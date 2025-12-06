# ----------------------------------------
# Makefile for Python + Ruff + Docsify
# ----------------------------------------

# Phony targets (always run)
.PHONY: build lint format run docsify init-docs help

# Colors
BLUE  := \033[0;34m
GREEN := \033[0;32m
RESET := \033[0m

# ----------------------------------------
# Code Quality
# ----------------------------------------

lint:
	@echo -e "$(BLUE)==> Running Ruff lint...$(RESET)"
	uvx ruff check

format:
	@echo -e "$(BLUE)==> Running Ruff format...$(RESET)"
	uvx ruff format

# ----------------------------------------
# Main build target
# ----------------------------------------

build: lint format run
	@echo -e "$(GREEN)✔ Build complete.$(RESET)"

run:
	@echo -e "$(BLUE)==> Running Python main module...$(RESET)"
	python3 -m main

# ----------------------------------------
# Docsify
# ----------------------------------------

docsify:
	@echo -e "$(BLUE)==> Initializing Docsify folder...$(RESET)"
	pnpx docsify-cli init ./docs

serve-docs:
	@echo -e "$(BLUE)==> Starting Docsify dev server...$(RESET)"
	pnpx docsify-cli serve ./docs

# ----------------------------------------
# Help
# ----------------------------------------

help:
	@echo "Available commands:"
	@echo "  make lint        - Run Ruff lint checks"
	@echo "  make format      - Auto-format code using Ruff"
	@echo "  make run         - Run main module"
	@echo "  make build       - Lint + format + run"
	@echo "  make docsify     - Start Docsify server"
	@echo "  make init-docs   - Create Docsify docs folder"
