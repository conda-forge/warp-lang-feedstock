@echo on

set "ARGS="

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set "NVCC_APPEND_FLAGS=%NVCC_APPEND_FLAGS% --use-local-env"
    set ARGS=--cuda_path="%CUDA_HOME%"
    if "%CUDA_COMPILER_VERSION%" == "12.0" (
        set CUDA_PATH=%LIBRARY_PREFIX%
        set CUDA_BIN_PATH=%CUDA_PATH%\bin
    )
)

set

%PYTHON% build_lib.py %ARGS% --mode=release
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
