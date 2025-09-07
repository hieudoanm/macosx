#!/bin/bash

# -------------------------------------
# 🌍🧱 Terraform Shortcuts (Compact)
# -------------------------------------

alias tf='terraform'   # 🧱 Core Terraform CLI

# 🚀 Initialization
tf-init() {
  echo "🚀📦 Initializing Terraform..."
  terraform init "$@"
}

# 🧠 Planning
tf-plan() {
  echo "🧠📐 Generating execution plan..."
  terraform plan "$@"
}

# 🛠️ Apply (manual approve)
tf-apply() {
  echo "🛠️🚦 Applying Terraform changes (manual approval)..."
  terraform apply "$@"
}

# ⚡ Apply (auto approve)
tf-apply-auto() {
  echo "⚡🚀 Applying Terraform changes (auto-approve)..."
  terraform apply -auto-approve "$@"
}

# 💣 Destroy (manual approve)
tf-destroy() {
  echo "💣⚠️ Destroying infrastructure (manual approval)..."
  terraform destroy "$@"
}

# ☢️ Destroy (auto approve)
tf-destroy-auto() {
  echo "☢️🔥 Destroying infrastructure (auto-approve)..."
  terraform destroy -auto-approve "$@"
}

# 🧹 Format
tf-fmt() {
  echo "🧹✨ Formatting Terraform files..."
  terraform fmt "$@"
}

# ✅ Validate
tf-validate() {
  echo "✅🔍 Validating Terraform configuration..."
  terraform validate "$@"
}

# 👀 Show
tf-show() {
  echo "👀📄 Showing Terraform state / plan..."
  terraform show "$@"
}

# 🗺️ State
tf-state() {
  echo "🗺️📦 Managing Terraform state..."
  terraform state "$@"
}

# 📤 Outputs
tf-output() {
  echo "📤🔑 Fetching Terraform outputs..."
  terraform output "$@"
}
