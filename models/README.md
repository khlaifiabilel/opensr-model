# Pre-trained Models

This directory contains pre-trained models for OpenSR (Open Super-Resolution) framework, designed for super-resolution of remote sensing imagery, particularly Sentinel-2 satellite data.

## Models Overview

### 1. opensr-ldsrs2_v1_0_0.ckpt

**Model Type**: Latent Diffusion Super-Resolution for Sentinel-2 (LDSRS2)

**Description**: 
This is a latent diffusion-based super-resolution model specifically trained for enhancing Sentinel-2 satellite imagery. The model uses a latent diffusion approach to generate high-resolution outputs from lower-resolution Sentinel-2 inputs.

**Key Features**:
- Version: 1.0.0
- Architecture: Latent Diffusion Model
- Primary Use: Super-resolution of Sentinel-2 imagery
- Trained on remote sensing data with focus on preserving spectral characteristics

**Typical Use Case**:
Super-resolving Sentinel-2 satellite images to higher spatial resolution while maintaining spectral integrity, useful for detailed land cover analysis, agricultural monitoring, and environmental studies.

---

### 2. opensr_10m_v4_v6.ckpt

**Model Type**: 10m Resolution Super-Resolution Model

**Description**:
This model is designed to enhance Sentinel-2 imagery to 10-meter resolution. It represents an advanced version (v4_v6) of the OpenSR model family, optimized for producing high-quality 10m resolution outputs.

**Key Features**:
- Version: v4_v6 (indicating iterative improvements)
- Target Resolution: 10 meters
- Optimized for Sentinel-2 band super-resolution
- Enhanced accuracy and detail preservation

**Typical Use Case**:
Upscaling lower-resolution Sentinel-2 bands (20m or 60m) to 10m resolution, enabling consistent multi-spectral analysis at uniform spatial resolution. Particularly useful for applications requiring detailed spatial information across all spectral bands.

---

## Model Source

Both models are hosted on Hugging Face and developed by the RS-SR-LTDF (Remote Sensing Super-Resolution Latent Diffusion) project:

- **Repository**: [simon-donike/RS-SR-LTDF](https://huggingface.co/simon-donike/RS-SR-LTDF)
- **Direct Links**:
  - [opensr-ldsrs2_v1_0_0.ckpt](https://huggingface.co/simon-donike/RS-SR-LTDF/resolve/main/opensr-ldsrs2_v1_0_0.ckpt)
  - [opensr_10m_v4_v6.ckpt](https://huggingface.co/simon-donike/RS-SR-LTDF/resolve/main/opensr_10m_v4_v6.ckpt)

## Usage

To use these models in your code, load them using PyTorch Lightning or the appropriate framework:

```python
from opensr_model import SRModel

# Load the latent diffusion model
model_ldsrs2 = SRModel.from_pretrained("models/opensr-ldsrs2_v1_0_0.ckpt")

# Or load the 10m resolution model
model_10m = SRModel.from_pretrained("models/opensr_10m_v4_v6.ckpt")
```

## Re-downloading Models

If you need to re-download these models, run the download script from the project root:

```bash
python download_models.py
```

The script will automatically skip files that already exist to avoid unnecessary downloads.

## Model Files

| Filename | Size | Purpose |
|----------|------|---------|
| `opensr-ldsrs2_v1_0_0.ckpt` | ~XXX MB | Latent Diffusion SR for Sentinel-2 |
| `opensr_10m_v4_v6.ckpt` | ~XXX MB | 10m Resolution Enhancement |

---

**Note**: These models are designed for research and development purposes in remote sensing applications. Please refer to the original model repository for licensing information and citation requirements.
