@echo on

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set NVCC_APPEND_FLAGS=--use-local-env
    set "CUDA_VERSION_CHECK=0"
    if "%CUDA_COMPILER_VERSION:~0,3%" == "12." set "CUDA_VERSION_CHECK=1"
    if "%CUDA_COMPILER_VERSION:~0,3%" == "13." set "CUDA_VERSION_CHECK=1"
    if "%CUDA_VERSION_CHECK%" == "1" (
        set CUDA_HOME=%CONDA_PREFIX%/Library/
        set LIBMATHDX_HOME=%BUILD_PREFIX%
    )
    set "LIB=%CONDA_PREFIX%\Library\lib;%LIB%"
)

@REM Force packman to use system python
set PM_PYTHON_EXT=%PYTHON%

set

%PYTHON% build_lib.py %ARGS% --quick -j%CPU_COUNT%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
