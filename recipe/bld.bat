@echo on

set "ARGS="

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set NVCC_APPEND_FLAGS=--use-local-env
    if "%CUDA_COMPILER_VERSION:~0,3%" == "12." (
        set ARGS="--cuda_path=%CUDA_HOME%"
        set CUDA_PATH=%LIBRARY_PREFIX%
        set CUDA_BIN_PATH=%CUDA_PATH%\bin
    )
    set LINKER_EXTRA_FLAGS=%CONDA_PREFIX%/Library/lib
)

@REM Force packman to use system python
set PM_PYTHON_EXT=%PYTHON%

set

%PYTHON% build_lib.py %ARGS%
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
