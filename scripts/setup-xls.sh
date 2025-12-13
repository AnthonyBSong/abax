#!/usr/bin/env bash

# --- Variables ---
CONDA_DIR="/scratch/users/zrs29/xls/miniconda"
SELF=$(realpath "${BASH_SOURCE[0]}")

# --- Auto-setup ---
case "$1" in
  --enable-auto-setup)  grep -Fxq "source $SELF" ~/.bashrc \
	  || echo "source $SELF" >> ~/.bashrc ;;
  --disable-auto-setup) sed -i "\|source $SELF|d" ~/.bashrc ;;
esac

# --- Environment setup ---
export PATH="$PATH:/scratch/users/zrs29/xls/xls"

# --- Activate conda ---
. "/scratch/users/zrs29/xls/miniconda/etc/profile.d/conda.sh"

conda activate allo

# --- Setup LLVM compiler ---
source /work/shared/common/allo/setup-llvm19.sh >/dev/null

# --- Add paths to PATH ---
#export PATH=/scratch/users/zrs29/xls/miniconda/bin:$PATH

# --- Colors ---
MAGENTA="\[\e[1;35m\]"   # (xls)
GREEN="\[\e[1;32m\]"     # user@host
BLUE="\[\e[1;34m\]"      # path
RESET="\[\e[0m\]"        # reset

# --- Prompt ---
PS1="${MAGENTA}(xls) ${GREEN}\u@\h${RESET}:${BLUE}\w${RESET} \$ "
export PS1
