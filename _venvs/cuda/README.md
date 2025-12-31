# CUDA Environment Setup

Python environment configured for CUDA 13.0 with PyTorch and vLLM on ARM64 (aarch64).

## Contents

- **Python**: 3.13.x
- **PyTorch**: 2.9.1 with CUDA 13.0 support
- **vLLM**: 0.14.0rc1 (built from source for CUDA 13.0)
- **Platform**: Linux ARM64 (aarch64)

## Prerequisites

- CUDA 13.0 installed at `/usr/local/cuda`
- NVIDIA GPU with compute capability 12.0+ (e.g., GB10 with 12.1)
- uv package manager

## Installation

### Initial Setup

```bash
# Clone/navigate to this directory
cd /path/to/cuda

# Sync the environment
CUDA_HOME=/usr/local/cuda VLLM_TARGET_DEVICE=cuda TORCH_CUDA_ARCH_LIST="12.0" MAX_JOBS=16 \
  uv sync --no-build-isolation
```

**First sync takes 20-40 minutes** as it builds vLLM from source. Subsequent syncs reuse the cached build and take only seconds.

### Verify Installation

```bash
source .venv/bin/activate

# Check versions
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
vllm --version
```

Expected output:
```
PyTorch: 2.9.1+cu130
CUDA available: True
0.14.0rc1.dev195+g357d435c5.cu130
```

## Important: Using `uv sync`

**⚠️ CRITICAL:** Always run `uv sync` with the required environment variables and flags:

```bash
CUDA_HOME=/usr/local/cuda VLLM_TARGET_DEVICE=cuda TORCH_CUDA_ARCH_LIST="12.0" MAX_JOBS=16 \
  uv sync --no-build-isolation
```

### Why These Flags Matter

- **`CUDA_HOME=/usr/local/cuda`**: Tells the build where to find CUDA
- **`VLLM_TARGET_DEVICE=cuda`**: Builds vLLM with CUDA support (not CPU-only)
- **`TORCH_CUDA_ARCH_LIST="12.0"`**: Specifies GPU compute capability to compile for
- **`MAX_JOBS=16`**: Limits parallel compilation jobs to avoid OOM
- **`--no-build-isolation`**: Allows build to see environment variables

### Create an Alias (Recommended)

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
alias uv-sync-cuda='CUDA_HOME=/usr/local/cuda VLLM_TARGET_DEVICE=cuda TORCH_CUDA_ARCH_LIST="12.0" MAX_JOBS=16 uv sync --no-build-isolation'
```

Then simply run:
```bash
uv-sync-cuda
```

## Configuration Details

### vLLM Git Pinning

vLLM is pinned to commit `357d435c5` in `pyproject.toml` to prevent automatic rebuilds:

```toml
vllm = { git = "https://github.com/vllm-project/vllm.git", rev = "357d435c5" }
```

### Platform-Specific Resolution

The environment is configured for ARM64 only to avoid dependency conflicts:

```toml
[tool.uv]
environments = [
    "sys_platform == 'linux' and platform_machine == 'aarch64'",
]
```

### Manual Dependencies

Key vLLM dependencies are manually declared to prevent removal during sync:
- `ray>=2.48`
- `xgrammar>=0.1`
- `flashinfer-python`
- `outlines-core`

## Updating vLLM

To update vLLM to a newer commit:

1. **Find the latest commit:**
   ```bash
   cd ~/.cache/uv/git-v0/checkouts/ee05fe20759ffa58/357d435c5
   git fetch origin
   git log origin/main --oneline -5
   ```

2. **Update `pyproject.toml`:**
   ```toml
   vllm = { git = "https://github.com/vllm-project/vllm.git", rev = "<new-commit-hash>" }
   ```

3. **Rebuild:**
   ```bash
   rm uv.lock
   CUDA_HOME=/usr/local/cuda VLLM_TARGET_DEVICE=cuda TORCH_CUDA_ARCH_LIST="12.0" MAX_JOBS=16 \
     uv sync --no-build-isolation
   ```

## Troubleshooting

### Issue: Missing vLLM Dependencies After Sync

**Symptom:** Running plain `uv sync` removes ray, xgrammar, etc.

**Solution:** Always use the full command with environment variables and `--no-build-isolation` flag.

### Issue: `libcudart.so.12: cannot open shared object file`

**Symptom:** vLLM fails to import with missing CUDA library error.

**Cause:** Pre-built vLLM wheels are for CUDA 12, not CUDA 13.

**Solution:** This environment builds vLLM from source for CUDA 13, which avoids this issue.

### Issue: PyTorch Shows CPU-Only Version

**Symptom:** `torch.cuda.is_available()` returns `False`.

**Solution:** Run `uv sync` with proper flags to restore CUDA-enabled PyTorch from the PyTorch index.

### Issue: Build Fails with `compute_1.` Error

**Symptom:** nvcc error about unsupported gpu architecture.

**Solution:** `TORCH_CUDA_ARCH_LIST` is set to fix this. Ensure it's specified when building.

## GPU Compatibility Note

Your NVIDIA GB10 GPU has compute capability **12.1**, but PyTorch 2.9.1 officially supports up to **12.0**. The build uses 12.0 which works fine due to NVIDIA's forward compatibility. You may see a warning on first import - this is expected and harmless.

## Cache Location

- **Git repository**: `~/.cache/uv/git-v0/db/`
- **Checked out source**: `~/.cache/uv/git-v0/checkouts/ee05fe20759ffa58/357d435c5/`
- **Built wheels**: `~/.cache/uv/builds-v0/` and `~/.cache/uv/wheels-v*/`

## Environment Variables Reference

```bash
# CUDA installation path
export CUDA_HOME=/usr/local/cuda

# Target device for vLLM (cuda or cpu)
export VLLM_TARGET_DEVICE=cuda

# GPU architectures to compile for
# 8.0 = Ampere (A100, RTX 3090/4090)
# 9.0 = Hopper (H100)
# 12.0 = Blackwell (GB10, GB200)
export TORCH_CUDA_ARCH_LIST="12.0"

# Limit parallel compilation jobs
export MAX_JOBS=16
```

## References

- [PyTorch with CUDA](https://download.pytorch.org/whl/cu130)
- [vLLM GitHub](https://github.com/vllm-project/vllm)
- [uv Documentation](https://docs.astral.sh/uv/)
