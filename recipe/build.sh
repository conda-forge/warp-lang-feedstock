#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    export CUDA_HOME="${BUILD_PREFIX}/targets/x86_64-linux"
    export LIBMATHDX_HOME="${BUILD_PREFIX}"
    export LIBRARY_PATH="${BUILD_PREFIX}/targets/x86_64-linux/lib:${LIBRARY_PATH}"
fi

# PM_PYTHON_EXT tells Packman to use conda's Python instead of downloading its own
# Only needed on Linux where Packman's Python has missing dependencies like libcrypt.so.1
if [[ "${target_platform}" == linux-* ]]; then
    export PM_PYTHON_EXT="${PYTHON}"
fi

${PYTHON} build_lib.py ${ARGS:-} --quick

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
