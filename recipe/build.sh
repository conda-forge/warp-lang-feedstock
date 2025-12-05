#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    export LIBMATHDX_HOME="${BUILD_PREFIX}"
    export LIBRARY_PATH="${BUILD_PREFIX}/targets/x86_64-linux/lib:${LIBRARY_PATH}"
    export ARGS="--cuda_path ${BUILD_PREFIX}/targets/x86_64-linux"
    export NVCC_APPEND_FLAGS="-I${BUILD_PREFIX}/targets/x86_64-linux/include/cccl -I${BUILD_PREFIX}/targets/x86_64-linux/include"
fi

# Make sure nvvm tools are found by nvcc
export PATH="$PATH:$CONDA_PREFIX/nvvm/bin"

# PM_PYTHON_EXT tells Packman to use conda's Python instead of downloading its own
# Only needed on Linux where Packman's Python has missing dependencies like libcrypt.so.1
if [[ "${target_platform}" == linux-* ]]; then
    export PM_PYTHON_EXT="${PYTHON}"
fi

${PYTHON} build_lib.py ${ARGS:-} --quick -j${CPU_COUNT} --use_dynamic_cuda

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
