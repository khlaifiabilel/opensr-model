#!/usr/bin/env python3
"""
Script to download pre-trained models from Hugging Face.
"""

import os
import urllib.request
from pathlib import Path


def download_file(url: str, destination: str) -> None:
    """
    Download a file from a URL to a destination path.
    
    Args:
        url: URL of the file to download
        destination: Local path where the file should be saved
    """
    print(f"Downloading {os.path.basename(destination)}...")
    print(f"From: {url}")
    
    try:
        urllib.request.urlretrieve(url, destination)
        print(f"✓ Successfully downloaded to {destination}\n")
    except Exception as e:
        print(f"✗ Error downloading {url}: {e}\n")


def main():
    """Download all required models from Hugging Face."""
    # Set models directory to current directory (models/)
    models_dir = Path(__file__).parent
    models_dir.mkdir(exist_ok=True)
    
    # Define models to download
    models = [
        {
            "url": "https://huggingface.co/simon-donike/RS-SR-LTDF/resolve/main/opensr-ldsrs2_v1_0_0.ckpt",
            "filename": "opensr-ldsrs2_v1_0_0.ckpt"
        },
        {
            "url": "https://huggingface.co/simon-donike/RS-SR-LTDF/resolve/main/opensr_10m_v4_v6.ckpt",
            "filename": "opensr_10m_v4_v6.ckpt"
        }
    ]
    
    print("=" * 60)
    print("Downloading OpenSR models from Hugging Face")
    print("=" * 60 + "\n")
    
    # Download each model
    for model in models:
        destination = models_dir / model["filename"]
        
        # Skip if file already exists
        if destination.exists():
            print(f"⊘ {model['filename']} already exists, skipping...\n")
            continue
        
        download_file(model["url"], str(destination))
    
    print("=" * 60)
    print("Download process completed!")
    print("=" * 60)


if __name__ == "__main__":
    main()
