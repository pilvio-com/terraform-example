variable "pilvioprops" {
  description = "See muutuja hoiab pilvio api võti ja billingkonto number"
  type = object({
    apikey           = string
    billingAccountId = string
  })
}

variable "projectname" {
  description = "See muutuja kirjeldab projekti nime, mida kasutatakse näiteks ressursi nimede genereerimisel"
  type        = string
}

variable "server" {
  description = "See muutuja hoiab loodava virtuaalserveri parameetreid"
  type = object({
    os_name    = string
    os_version = string
    username   = string
    vcpu       = number
    memory     = number
    disk       = number
  })
}

variable "extradisksize" {
  description = "See muutuja kirjeldab lisaketta parameetrid"
  default     = 20
}
