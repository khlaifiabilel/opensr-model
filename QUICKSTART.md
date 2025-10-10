# OpenSR Model - Quick Setup Reference

## 🚀 One-Line Setup

```bash
# CPU only
./setup_environment.sh cpu

# GPU (CUDA)
./setup_environment.sh gpu

# Interactive
./setup_environment.sh
```

## 📋 Prerequisites Checklist

- [ ] Conda installed (`conda --version`)
- [ ] ~10GB free disk space
- [ ] NVIDIA GPU with CUDA 11.7+ (for GPU mode)
- [ ] Git installed (optional)

## ⚡ Quick Commands

```bash
# Activate environment
conda activate opensr-model

# Test installation
python -c "import opensr_model; print('Success!')"

# Run demo
python demo.py

# Download models
python download_models.py

# Deactivate
conda deactivate
```

## 🔧 What Gets Installed

- **Python:** 3.10
- **PyTorch:** 1.13.1 (CPU or CUDA 11.7)
- **PyTorch Lightning:** 1.9.0
- **Geospatial:** rasterio, geopandas, pyproj, shapely
- **CV:** opencv, scikit-image, albumentations, kornia
- **Diffusion:** diffusers, transformers, taming-transformers
- **Utils:** numpy, tqdm, wandb, einops

## 📦 Environment Size

- **Conda env:** ~5GB
- **Pre-trained models:** ~3.1GB
- **Total:** ~8.1GB

## ⏱️ Setup Time

- **CPU mode:** ~10-15 minutes
- **GPU mode:** ~15-20 minutes
- **Model download:** ~5-10 minutes (depends on connection)

## 🐛 Common Issues

### Conda not found
```bash
export PATH="/path/to/miniconda3/bin:$PATH"
conda init bash && source ~/.bashrc
```

### CUDA out of memory
- Use CPU mode
- Reduce batch size
- Close other GPU applications

### Package conflicts
```bash
conda env remove -n opensr-model
./setup_environment.sh gpu  # Recreate
```

## 📊 Verify Installation

```python
import torch
import opensr_model

device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Device: {device}")

model = opensr_model.SRLatentDiffusion(bands="10m", device=device)
print("✓ Model loaded successfully!")
```

## 🎯 Next Steps

1. Activate environment: `conda activate opensr-model`
2. Download models: `python download_models.py`
3. Run demo: `python demo.py`
4. Read: `SETUP_GUIDE.md` for detailed docs
5. Check: `models/README.md` for model info

## 📚 Documentation

- **SETUP_GUIDE.md** - Comprehensive setup documentation
- **README.md** - Project overview and usage
- **models/README.md** - Pre-trained models info

## 🔗 Links

- Repository: https://github.com/ESAopenSR/opensr-model
- Models: https://huggingface.co/simon-donike/RS-SR-LTDF
- Paper: https://ieeexplore.ieee.org/abstract/document/10887321

---

Need help? Check `SETUP_GUIDE.md` for detailed troubleshooting!
