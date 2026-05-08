#!/bin/bash

set -exo pipefail

if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
    if [[ "${target_platform}" == "linux-aarch64" ]]; then
        cuda_target_dir="sbsa-linux"
    else
        cuda_target_dir="x86_64-linux"
    fi

    cuda_target_prefix="${PREFIX}/targets/${cuda_target_dir}"
    cuda_target_include="${cuda_target_prefix}/include"

    # Include crt/ from BUILD_PREFIX
    export CPATH="${BUILD_PREFIX}/targets/${cuda_target_dir}/include${CPATH:+:${CPATH}}"

    # CUDA target files live under PREFIX/targets, while MathDx installs its
    # headers and libraries at the top level of the selected prefix.
    export WARP_CUDA_PATH="${cuda_target_prefix}"
    export LIBMATHDX_HOME="${PREFIX}"
    export LIBRARY_PATH="${PREFIX}/lib:${cuda_target_prefix}/lib${LIBRARY_PATH:+:${LIBRARY_PATH}}"
    export NVCC_APPEND_FLAGS="${NVCC_APPEND_FLAGS:-} -I${cuda_target_include}/cccl -I${cuda_target_include}"
fi

# Make sure nvvm tools are found by nvcc
export PATH="$PATH:$CONDA_PREFIX/nvvm/bin"

# build_llvm.py overrides PM_PYTHON_EXT with sys.executable in the packman
# subprocess env. During cross-compilation, sys.executable is the crossenv
# wrapper that cannot import native modules like binascii. After patch 02
# we only need to override it for cross-builds.
if [[ "${build_platform:-}" != "${target_platform:-}" ]]; then
    export PM_PYTHON_EXT="${BUILD_PREFIX}/bin/python${PY_VER}"
fi

# Warp invokes `strip` directly when producing warp.so. During cross-compilation that resolves
# to the build-machine strip, which cannot process target binaries (e.g. aarch64 on x86_64).
# Provide a shim so plain `strip` uses conda-build's target strip (`$STRIP`) instead.
if [[ "${build_platform:-}" != "${target_platform:-}" && -n "${STRIP:-}" ]]; then
    mkdir -p .warp-build-tools
    cat > .warp-build-tools/strip <<EOF
#!/bin/sh
exec "${STRIP}" "\$@"
EOF
    chmod +x .warp-build-tools/strip
    export PATH="${PWD}/.warp-build-tools:${PATH}"
fi

${PYTHON} build_lib.py -j${CPU_COUNT} --use-dynamic-cuda

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
