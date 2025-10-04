# Makefile for Spec Kit

.PHONY: help install build test clean check lint format publish reinstall

# Default target
help:
	@echo "Spec Kit Development Commands"
	@echo ""
	@echo "install     Install in development mode (editable)"
	@echo "build       Build the package"
	@echo "test        Run tests"
	@echo "check       Check code quality and formatting"
	@echo "lint        Run linting"
	@echo "format      Format code"
	@echo "clean       Clean build artifacts"
	@echo "reinstall   Reinstall the package"
	@echo "publish     Publish to PyPI (maintainers only)"

# Install in development mode
install:
	uv tool install --editable . --reinstall

# Build the package
build:
	uv build

# Run tests
test:
	uv run pytest

# Check code quality
check:
	uv run ruff check
	uv run ruff format --check

# Lint code
lint:
	uv run ruff check

# Format code
format:
	uv run ruff format

# Clean build artifacts
clean:
	rm -rf dist/
	rm -rf build/
	rm -rf *.egg-info/
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete

# Reinstall package
reinstall: clean install

# Run full build pipeline
all: clean install test build
	@echo "✅ Full build pipeline completed!"