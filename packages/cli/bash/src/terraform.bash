#!/bin/bash

# Terraform Shortcuts (Compact)

alias tf='terraform'

tf-init()      { terraform init "$@"; }
tf-plan()      { terraform plan "$@"; }
tf-apply()     { terraform apply "$@"; }
tf-apply-auto(){ terraform apply -auto-approve "$@"; }
tf-destroy()   { terraform destroy "$@"; }
tf-destroy-auto(){ terraform destroy -auto-approve "$@"; }
tf-fmt()       { terraform fmt "$@"; }
tf-validate()  { terraform validate "$@"; }
tf-show()      { terraform show "$@"; }
tf-state()     { terraform state "$@"; }
tf-output()    { terraform output "$@"; }
