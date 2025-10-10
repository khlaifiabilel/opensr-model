#!/bin/bash

################################################################################
# OpenSR Model - Environment Setup Script
################################################################################
# This script creates a dedicated conda environment for the OpenSR model
# with support for both CPU and GPU (CUDA) configurations.
#
# Usage:
#   ./setup_environment.sh [cpu|gpu]
#
# Examples:
#   ./setup_environment.sh cpu    # Create CPU-only environment
#   ./setup_environment.sh gpu    # Create GPU environment with CUDA support
#   ./setup_environment.sh        # Interactive mode (prompts for choice)
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENV_NAME="opensr-model"
PYTHON_VERSION="3.10"
PYTORCH_VERSION="1.13.1"
TORCHVISION_VERSION="0.14.1"
TORCHAUDIO_VERSION="0.13.1"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BLUE}"
    echo "================================================================================"
    echo "$1"
    echo "================================================================================"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_conda() {
    if ! command -v conda &> /dev/null; then
        print_error "Conda is not installed or not in PATH"
        echo "Please install Miniconda or Anaconda first:"
        echo "  https://docs.conda.io/en/latest/miniconda.html"
        exit 1
    fi
    print_success "Conda found: $(conda --version)"
}

################################################################################
# Main Setup Logic
################################################################################

main() {
    print_header "OpenSR Model - Environment Setup"
    
    # Check if conda is available
    check_conda
    
    # Determine device type (CPU or GPU)
    DEVICE_TYPE=""
    if [ $# -eq 0 ]; then
        # Interactive mode
        echo "Select device type:"
        echo "  1) CPU only"
        echo "  2) GPU (CUDA)"
        read -p "Enter choice [1-2]: " choice
        case $choice in
            1) DEVICE_TYPE="cpu";;
            2) DEVICE_TYPE="gpu";;
            *) 
                print_error "Invalid choice"
                exit 1
                ;;
        esac
    else
        DEVICE_TYPE="$1"
    fi
    
    # Validate device type
    if [[ "$DEVICE_TYPE" != "cpu" && "$DEVICE_TYPE" != "gpu" ]]; then
        print_error "Invalid device type: $DEVICE_TYPE"
        echo "Usage: $0 [cpu|gpu]"
        exit 1
    fi
    
    print_info "Device type: $DEVICE_TYPE"
    echo
    
    # Check if environment already exists
    if conda env list | grep -q "^${ENV_NAME} "; then
        print_warning "Environment '$ENV_NAME' already exists"
        read -p "Do you want to remove and recreate it? [y/N]: " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            print_info "Removing existing environment..."
            conda env remove -n "$ENV_NAME" -y
            print_success "Environment removed"
        else
            print_info "Updating existing environment..."
        fi
    fi
    
    # Create conda environment
    print_header "Step 1: Creating Conda Environment"
    print_info "Environment name: $ENV_NAME"
    print_info "Python version: $PYTHON_VERSION"
    
    if ! conda env list | grep -q "^${ENV_NAME} "; then
        conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y
        print_success "Environment created successfully"
    else
        print_success "Using existing environment"
    fi
    echo
    
    # Initialize conda for bash
    eval "$(conda shell.bash hook)"
    
    # Activate environment
    print_info "Activating environment..."
    conda activate "$ENV_NAME"
    print_success "Environment activated"
    echo
    
    # Install PyTorch based on device type
    print_header "Step 2: Installing PyTorch and Related Packages"
    
    if [ "$DEVICE_TYPE" == "gpu" ]; then
        print_info "Installing PyTorch with CUDA 11.7 support..."
        conda install pytorch=$PYTORCH_VERSION torchvision=$TORCHVISION_VERSION torchaudio=$TORCHAUDIO_VERSION \
            pytorch-cuda=11.7 -c pytorch -c nvidia -y
        print_success "PyTorch (GPU) installed"
    else
        print_info "Installing PyTorch (CPU-only)..."
        conda install pytorch=$PYTORCH_VERSION torchvision=$TORCHVISION_VERSION torchaudio=$TORCHAUDIO_VERSION \
            cpuonly -c pytorch -y
        print_success "PyTorch (CPU) installed"
    fi
    echo
    
    # Install core dependencies via conda (faster and more reliable)
    print_header "Step 3: Installing Core Dependencies via Conda"
    print_info "Installing numpy, scipy, scikit-learn, scikit-image..."
    conda install -y \
        numpy=1.23.5 \
        scikit-learn=1.3.0 \
        scikit-image=0.19.3 \
        pillow=9.4.0 \
        tqdm \
        requests \
        -c conda-forge
    print_success "Core dependencies installed"
    echo
    
    # Install geospatial dependencies via conda
    print_header "Step 4: Installing Geospatial Dependencies"
    print_info "Installing rasterio, geopandas, pyproj, shapely..."
    conda install -y \
        rasterio=1.3.6 \
        geopandas=0.12.2 \
        pyproj=3.4.1 \
        shapely=2.0.1 \
        affine=2.4.0 \
        -c conda-forge
    print_success "Geospatial dependencies installed"
    echo
    
    # Upgrade pip
    print_header "Step 5: Upgrading pip and setuptools"
    python -m pip install --upgrade pip setuptools wheel
    print_success "pip upgraded"
    echo
    
    # Install PyTorch Lightning and related packages
    print_header "Step 6: Installing PyTorch Lightning and Transformers"
    pip install pytorch-lightning==1.9.0 \
        transformers==4.26.1 \
        torchmetrics==0.11.1 \
        omegaconf==2.3.0
    print_success "PyTorch Lightning ecosystem installed"
    echo
    
    # Install computer vision packages
    print_header "Step 7: Installing Computer Vision Packages"
    pip install albumentations==1.3.1 \
        opencv-python==4.7.0.68 \
        lpips==0.1.4 \
        kornia==0.6.9 \
        imageio==2.25.0 \
        einops==0.6.0
    print_success "Computer vision packages installed"
    echo
    
    # Install diffusion and generative model packages
    print_header "Step 8: Installing Diffusion Model Dependencies"
    pip install diffusers==0.12.1 \
        huggingface-hub==0.12.0 \
        safetensors
    
    # Try to install taming-transformers (may require git)
    print_info "Installing taming-transformers..."
    if pip install taming-transformers==0.0.1 2>/dev/null; then
        print_success "taming-transformers installed"
    else
        print_warning "Failed to install taming-transformers via pip"
        print_info "Attempting to install from GitHub..."
        if pip install git+https://github.com/CompVis/taming-transformers.git@master 2>/dev/null; then
            print_success "taming-transformers installed from GitHub"
        else
            print_warning "Could not install taming-transformers - may need manual installation"
        fi
    fi
    echo
    
    # Install experiment tracking and utilities
    print_header "Step 9: Installing Utilities and Experiment Tracking"
    pip install wandb==0.13.9 \
        oauthlib==3.2.2 \
        pathtools==0.1.2 \
        typing-extensions==4.7.1
    print_success "Utilities installed"
    echo
    
    # Install the opensr-model package itself
    print_header "Step 10: Installing OpenSR Model Package"
    print_info "Installing in development mode..."
    
    # Get the script directory (project root)
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    cd "$SCRIPT_DIR"
    
    pip install -e .
    print_success "OpenSR Model package installed in development mode"
    echo
    
    # Download pre-trained models
    print_header "Step 11: Downloading Pre-trained Models"
    read -p "Do you want to download pre-trained models (~3.1GB)? [y/N]: " download_models
    
    if [[ $download_models == [yY] || $download_models == [yY][eE][sS] ]]; then
        print_info "Downloading models from Hugging Face..."
        python download_models.py
        print_success "Models downloaded to ./models/"
    else
        print_info "Skipping model download. You can run 'python download_models.py' later."
    fi
    echo
    
    # Verify installation
    print_header "Step 12: Verifying Installation"
    print_info "Testing PyTorch installation..."
    python -c "import torch; print(f'PyTorch version: {torch.__version__}')"
    python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
    if [ "$DEVICE_TYPE" == "gpu" ]; then
        python -c "import torch; print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')" || true
    fi
    
    print_info "Testing OpenSR Model import..."
    python -c "import opensr_model; print(f'OpenSR Model imported successfully')"
    
    print_info "Testing key dependencies..."
    python -c "import pytorch_lightning, transformers, rasterio, geopandas; print('All key dependencies available')"
    
    print_success "Installation verified!"
    echo
    
    # Print summary
    print_header "Installation Complete!"
    echo
    echo "Environment Details:"
    echo "  Name: $ENV_NAME"
    echo "  Python: $(python --version 2>&1)"
    echo "  Device: $DEVICE_TYPE"
    echo "  Location: $(conda env list | grep "$ENV_NAME" | awk '{print $2}')"
    echo
    echo "To activate this environment, run:"
    echo -e "${GREEN}  conda activate $ENV_NAME${NC}"
    echo
    echo "To test the installation, run:"
    echo -e "${GREEN}  python demo.py${NC}"
    echo
    echo "To deactivate the environment, run:"
    echo -e "${YELLOW}  conda deactivate${NC}"
    echo
    print_success "Setup completed successfully! 🎉"
}

################################################################################
# Script Entry Point
################################################################################

# Run main function
main "$@"
