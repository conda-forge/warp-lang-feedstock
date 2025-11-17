#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    export CUDA_HOME="${BUILD_PREFIX}/targets/x86_64-linux"
    export LIBMATHDX_HOME="${BUILD_PREFIX}"
    export LIBRARY_PATH="${BUILD_PREFIX}/targets/x86_64-linux/lib:${LIBRARY_PATH}"
fi

env PM_PYTHON_EXT="${PYTHON}" \
    PM_PACKAGES_ROOT="${SRC_DIR}/_packman_cache" \
    ${PYTHON} build_lib.py ${ARGS:-} --quick -j${CPU_COUNT}

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
