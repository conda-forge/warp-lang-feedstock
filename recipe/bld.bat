@echo on

set "ARGS="

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set "NVCC_APPEND_FLAGS=%NVCC_APPEND_FLAGS% --use-local-env"
    @REM set "CUDA_COMPILER_VERSION=%cuda_compiler_version%"
    @REM set "CUTLASS_PATH=%CD%"
    @REM set "CUDA_LIB_PATH=%CUDA_HOME%\lib\x64"
    @REM set "ARGS=--cuda_path=\"%CUDA_HOME%\""
    if "%CUDA_COMPILER_VERSION%" == "12.0" (
        set CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v%CUDA_COMPILER_VERSION%
        set CUDA_BIN_PATH=%CUDA_PATH%\bin
    )
)

set

%PYTHON% build_lib.py %ARGS%
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1