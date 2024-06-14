#### Create ssh keys
resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  filename        = "${path.module}/sshkeys/id_rsa"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/sshkeys/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

resource "pilvio_vpc" "subnet" {
  name = "${var.projectname}-subnet"
}

#### Create passwords
resource "random_string" "server_pw" {
  length      = 16
  special     = true
  min_lower   = 4
  min_numeric = 1
  min_special = 1
  min_upper   = 1
  numeric     = true
  upper       = true
}

resource "pilvio_floatingip" "server" {
  name               = "${var.projectname}-ip"
  billing_account_id = var.pilvioprops.billingAccountId
}

resource "pilvio_vm" "server" {
  name         = var.projectname
  os_name      = var.server.os_name
  os_version   = var.server.os_version
  memory       = var.server.memory
  vcpu         = var.server.vcpu
  disks        = var.server.disk
  username     = var.server.username
  password     = random_string.server_pw.result
  network_uuid = pilvio_vpc.subnet.uuid
  public_key   = local_file.ssh_public_key_openssh.content
  cloud_init = jsonencode({
    "packages" = [
      "docker.io",
      "docker-compose"
    ],
    "runcmd" = [
      "sudo usermod -aG docker ${var.server.username}"
    ]
  })
}

resource "pilvio_floatingip_assignment" "server" {
  depends_on  = [pilvio_vm.server]
  assigned_to = pilvio_vm.server.uuid
  address     = pilvio_floatingip.server.address
}

resource "pilvio_disk" "server" {
  size_gb            = var.extradisksize
  billing_account_id = var.pilvioprops.billingAccountId
}

resource "pilvio_disk_attachment" "server" {
  uuid    = pilvio_disk.server.uuid
  vm_uuid = pilvio_vm.server.uuid
}

output "result" {
  value = [
    "Server Name:   ${pilvio_vm.server.name}",
    "Server UUID:   ${pilvio_vm.server.uuid}",
    "IP Address:    ${pilvio_floatingip.server.address}",
    "Private IP:    ${pilvio_vm.server.private_ipv4}",
    "Subnet Name:   ${pilvio_vpc.subnet.name}"
  ]
}
