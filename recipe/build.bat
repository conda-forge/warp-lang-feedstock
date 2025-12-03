@echo on

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set NVCC_APPEND_FLAGS=--use-local-env
    set LIBMATHDX_HOME=%BUILD_PREFIX%
    set "LIB=%CONDA_PREFIX%\Library\lib;%LIB%"
    set ARGS=--cuda_path=%CONDA_PREFIX%/Library
)

@REM Force packman to use system python
set PM_PYTHON_EXT=%PYTHON%

set

%PYTHON% build_lib.py %ARGS% --quick -j%CPU_COUNT% --llvm_path=%BUILD_PREFIX%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
