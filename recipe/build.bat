@echo on

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set NVCC_APPEND_FLAGS=--use-local-env
    set "CUDA_VERSION_CHECK=0"
    if "%CUDA_COMPILER_VERSION:~0,3%" == "12." set "CUDA_VERSION_CHECK=1"
    if "%CUDA_COMPILER_VERSION:~0,3%" == "13." set "CUDA_VERSION_CHECK=1"
    if "%CUDA_VERSION_CHECK%" == "1" (
        set CUDA_HOME=%CONDA_PREFIX%/Library/
    )
    set LINKER_EXTRA_FLAGS=%CONDA_PREFIX%/Library/lib
)

@REM Force packman to use system python
set PM_PYTHON_EXT=%PYTHON%

set

%PYTHON% build_lib.py %ARGS%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
