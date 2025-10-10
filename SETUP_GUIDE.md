# Environment Setup Guide

This guide provides detailed instructions for setting up the OpenSR Model development environment using the automated setup script.

## Quick Start

### Prerequisites

- **Conda** (Miniconda or Anaconda) installed
- **Git** (for cloning the repository)
- **~10GB** disk space (5GB for environment + 3.1GB for models + 2GB buffer)
- **NVIDIA GPU** with CUDA support (optional, for GPU acceleration)

### Basic Usage

```bash
# Make the script executable (if not already)
chmod +x setup_environment.sh

# Interactive mode - prompts for CPU/GPU choice
./setup_environment.sh

# Direct CPU setup
./setup_environment.sh cpu

# Direct GPU setup
./setup_environment.sh gpu
```

## Detailed Setup Steps

### 1. CPU-Only Environment

For systems without NVIDIA GPU or for testing purposes:

```bash
./setup_environment.sh cpu
```

This will:
- Create a conda environment named `opensr-model`
- Install Python 3.10
- Install PyTorch 1.13.1 (CPU version)
- Install all required dependencies
- Install the opensr-model package in development mode
- Optionally download pre-trained models

**Total setup time:** ~10-15 minutes (depending on internet speed)

### 2. GPU Environment (CUDA)

For systems with NVIDIA GPU and CUDA support:

```bash
./setup_environment.sh gpu
```

This will:
- Create a conda environment named `opensr-model`
- Install Python 3.10
- Install PyTorch 1.13.1 with CUDA 11.7 support
- Install all required dependencies with GPU acceleration
- Install the opensr-model package in development mode
- Optionally download pre-trained models

**Total setup time:** ~15-20 minutes (depending on internet speed)

**CUDA Requirements:**
- NVIDIA GPU with compute capability 3.5 or higher
- NVIDIA drivers supporting CUDA 11.7
- At least 8GB GPU memory recommended for inference

## What Gets Installed

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| Python | 3.10 | Base interpreter |
| PyTorch | 1.13.1 | Deep learning framework |
| PyTorch Lightning | 1.9.0 | Training framework |
| Transformers | 4.26.1 | Transformer models |

### Geospatial Libraries

| Package | Version | Purpose |
|---------|---------|---------|
| Rasterio | 1.3.6 | Raster data I/O |
| GeoPandas | 0.12.2 | Geospatial data manipulation |
| PyProj | 3.4.1 | Cartographic projections |
| Shapely | 2.0.1 | Geometric operations |
| Affine | 2.4.0 | Affine transformations |

### Computer Vision

| Package | Version | Purpose |
|---------|---------|---------|
| OpenCV | 4.7.0.68 | Image processing |
| scikit-image | 0.19.3 | Image analysis |
| Albumentations | 1.3.1 | Data augmentation |
| Kornia | 0.6.9 | Differentiable CV |
| LPIPS | 0.1.4 | Perceptual similarity |
| Einops | 0.6.0 | Tensor operations |

### Diffusion Models

| Package | Version | Purpose |
|---------|---------|---------|
| Diffusers | 0.12.1 | Diffusion models |
| Hugging Face Hub | 0.12.0 | Model downloading |
| Taming Transformers | 0.0.1 | VQGAN/VQVAE |
| Safetensors | latest | Safe model loading |

### Utilities

| Package | Version | Purpose |
|---------|---------|---------|
| NumPy | 1.23.5 | Numerical operations |
| scikit-learn | 1.3.0 | Machine learning utilities |
| tqdm | latest | Progress bars |
| wandb | 0.13.9 | Experiment tracking |
| OmegaConf | 2.3.0 | Configuration management |

## Environment Management

### Activating the Environment

```bash
conda activate opensr-model
```

### Deactivating the Environment

```bash
conda deactivate
```

### Updating the Environment

If you need to update packages:

```bash
conda activate opensr-model
pip install --upgrade package-name
```

### Removing the Environment

```bash
conda env remove -n opensr-model
```

### Recreating the Environment

Simply run the setup script again - it will detect the existing environment and offer to recreate it:

```bash
./setup_environment.sh gpu
# Choose 'y' when prompted to remove and recreate
```

## Troubleshooting

### Issue: Conda command not found

**Solution:**
```bash
# Add conda to PATH (adjust path to your installation)
export PATH="/home/username/miniconda3/bin:$PATH"

# Or initialize conda for your shell
conda init bash
source ~/.bashrc
```

### Issue: CUDA out of memory

**Solution:**
- Reduce batch size in your code
- Use CPU mode instead: `./setup_environment.sh cpu`
- Close other GPU-consuming applications

### Issue: taming-transformers installation fails

**Solution:**
```bash
# Install manually from GitHub
conda activate opensr-model
pip install git+https://github.com/CompVis/taming-transformers.git@master
```

### Issue: Rasterio/GDAL conflicts

**Solution:**
```bash
# Reinstall via conda-forge
conda activate opensr-model
conda install -c conda-forge rasterio=1.3.6 --force-reinstall
```

### Issue: Model download fails

**Solution:**
```bash
# Download models manually
conda activate opensr-model
python download_models.py

# Or use curl/wget
cd models/
wget https://huggingface.co/simon-donike/RS-SR-LTDF/resolve/main/opensr-ldsrs2_v1_0_0.ckpt
wget https://huggingface.co/simon-donike/RS-SR-LTDF/resolve/main/opensr_10m_v4_v6.ckpt
```

## Testing Your Installation

### Basic Import Test

```python
import torch
import opensr_model

print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print("OpenSR Model imported successfully!")
```

### Run Demo Script

```bash
conda activate opensr-model
python demo.py
```

This will:
1. Load the pre-trained model
2. Download a test image
3. Perform super-resolution
4. Save the result as `example_128.png`

### Quick Model Test

```python
import torch
import opensr_model

device = "cuda" if torch.cuda.is_available() else "cpu"
model = opensr_model.SRLatentDiffusion(bands="10m", device=device)

# Test with random input
X = torch.rand(1, 4, 128, 128).to(device)
sr = model(X)

print(f"Input shape: {X.shape}")
print(f"Output shape: {sr.shape}")
print("Model works correctly!")
```

## Performance Optimization

### For CPU Users

1. **Set threading:**
```bash
export OMP_NUM_THREADS=8
export MKL_NUM_THREADS=8
```

2. **Use smaller batch sizes**
3. **Reduce inference steps** (custom_steps parameter)

### For GPU Users

1. **Enable TensorFloat-32:**
```python
torch.backends.cuda.matmul.allow_tf32 = True
```

2. **Use mixed precision:**
```python
with torch.cuda.amp.autocast():
    sr = model(X)
```

3. **Clear cache between runs:**
```python
torch.cuda.empty_cache()
```

## Next Steps

After successful installation:

1. **Read the main README.md** for model usage examples
2. **Check models/README.md** for pre-trained model details
3. **Run demo.py** to test super-resolution
4. **Explore the example scripts:**
   - `demo.py` - Basic super-resolution
   - `uncertainty.py` - Uncertainty estimation
   - `sr_of_s2_tile.py` - Process Sentinel-2 tiles

## Additional Resources

- **Project Repository:** https://github.com/ESAopenSR/opensr-model
- **Model Weights:** https://huggingface.co/simon-donike/RS-SR-LTDF
- **Paper:** [Trustworthy Super-Resolution of Multispectral Sentinel-2 Imagery](https://ieeexplore.ieee.org/abstract/document/10887321)
- **PyTorch Documentation:** https://pytorch.org/docs/stable/index.html
- **Conda Documentation:** https://docs.conda.io/

## Support

If you encounter issues not covered in this guide:

1. Check the GitHub Issues page
2. Verify your conda and CUDA versions
3. Ensure all prerequisites are met
4. Try recreating the environment from scratch

---

**Last Updated:** October 2025  
**Script Version:** 1.0.0  
**Minimum Requirements:** Python 3.10, Conda 4.10+, ~10GB disk space
