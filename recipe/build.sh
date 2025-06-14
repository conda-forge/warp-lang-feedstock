#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    ARGS="--cuda_path=${CUDA_HOME}"
    export CUTLASS_PATH=$(pwd)
    if [[ ${cuda_compiler_version} == 12* ]]; then
      export CUDA_HOME="${BUILD_PREFIX}/targets/x86_64-linux"
      export CUDA_TOOLKIT_INCLUDE_DIR="${PREFIX}/targets/x86_64-linux"
      export CUDA_INSTALL_PATH=$(which nvcc | awk -F'/bin/nvcc' '{print $1}')
      export LIBMATHDX_HOME="${BUILD_PREFIX}"
    fi
    if [[ "$target_platform" == linux-* ]]; then
      export LD_EXTRA_FLAGS="$LD_EXTRA_FLAGS -L$CONDA_PREFIX/targets/x86_64-linux/lib"
    fi
fi

# Force packman to use system python
export PM_PYTHON_EXT=${PYTHON}

${PYTHON} build_lib.py ${ARGS:-}
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
