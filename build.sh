#!/usr/bin/env bash
# Build script for Spec Kit

set -e

echo "🔨 Building Spec Kit..."

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Please install uv first."
    echo "Visit: https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
fi

# Install in development mode
echo "📦 Installing in development mode..."
uv tool install --editable . --reinstall

# Run tests if they exist
if [ -d "tests" ] && [ "$(ls -A tests)" ]; then
    echo "🧪 Running tests..."
    uv run pytest
else
    echo "ℹ️  No tests found, skipping test run"
fi

# Check that the installation works
echo "✅ Verifying installation..."
if command -v specify &> /dev/null; then
    echo "✅ specify command is available"
    specify --version 2>/dev/null || echo "ℹ️  Version not available"
else
    echo "❌ specify command not found after installation"
    exit 1
fi

# Build the package
echo "📦 Building package..."
uv build

echo "✅ Build completed successfully!"
echo ""
echo "🚀 You can now use 'specify' command"
echo "📦 Built packages are in the 'dist/' directory"