@echo on

set "ARGS="

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set "NVCC_APPEND_FLAGS=%NVCC_APPEND_FLAGS% --use-local-env"
    set "CUDA_COMPILER_VERSION=%cuda_compiler_version%"
    set "CUTLASS_PATH=%CD%"
    )
    set "ARGS=--cuda_path=%CUDA_HOME%"
)

%PYTHON% build_lib.py %ARGS%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir

