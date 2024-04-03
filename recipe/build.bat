@echo on

setlocal EnableExtensions EnableDelayedExpansion

set "CUDA_COMPILER_VERSION=%cuda_compiler_version%"
if not "%CUDA_COMPILER_VERSION%" == "None" (
    set "CUTLASS_PATH=%CD%"
    if "!CUDA_COMPILER_VERSION:~0,2!" == "12" (
        set "CUDA_HOME=%BUILD_PREFIX%\targets\x86_64-linux"
        set "PATH=%PATH%;%BUILD_PREFIX%\nvvm\bin"
        set "CUDA_TOOLKIT_INCLUDE_DIR=%PREFIX%\targets\x86_64-linux"
        for /f "tokens=*" %%A in ('where nvcc') do set "CUDA_INSTALL_PATH=%%~dpA.."
    )
)

set "ARGS=--cuda_path=!CUDA_HOME!"

%PYTHON% build_lib.py %ARGS%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir

endlocal
