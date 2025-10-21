#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    # export CUTLASS_PATH=$(pwd)
    # export CUDA_PATH="${PREFIX}/targets/${target_name}"
    export CUDA_HOME="${BUILD_PREFIX}/targets/x86_64-linux"
    # export CPATH="${PREFIX}/targets/x86_64-linux"
    # export CUDA_INSTALL_PATH=$(which nvcc | awk -F'/bin/nvcc' '{print $1}')
    export LIBMATHDX_HOME="${BUILD_PREFIX}"
    if [[ "$target_platform" == linux-* ]]; then
      # Add CUDA library paths for conda-forge packages
      export LIBRARY_PATH="${BUILD_PREFIX}/targets/x86_64-linux/lib:${LIBRARY_PATH}"
    #   export LIBRARY_PATH="${PREFIX}/targets/x86_64-linux/lib:${BUILD_PREFIX}/targets/x86_64-linux/lib:${BUILD_PREFIX}/lib:${LIBRARY_PATH}"
    #   export LD_EXTRA_FLAGS="$LD_EXTRA_FLAGS -L${PREFIX}/targets/x86_64-linux/lib -L${BUILD_PREFIX}/targets/x86_64-linux/lib -L${BUILD_PREFIX}/lib"
    fi
fi

# Force packman to use system python
export PM_PYTHON_EXT=${PYTHON}

${PYTHON} build_lib.py ${ARGS:-}
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
