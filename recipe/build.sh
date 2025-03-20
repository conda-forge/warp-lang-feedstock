#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    ARGS="--cuda_path=${CUDA_HOME}"
    export CUTLASS_PATH=$(pwd)
    if [[ ${cuda_compiler_version} == 12* ]]; then
      export CUDA_HOME="${BUILD_PREFIX}/targets/x86_64-linux"
      export CUDA_TOOLKIT_INCLUDE_DIR="${PREFIX}/targets/x86_64-linux"
      export CUDA_INSTALL_PATH=$(which nvcc | awk -F'/bin/nvcc' '{print $1}')
    fi
fi

${PYTHON} build_lib.py ${ARGS:-}
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
