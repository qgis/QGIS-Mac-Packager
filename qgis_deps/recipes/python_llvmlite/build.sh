function build_python_llvmlite() {
  # build llvm
  try mkdir -p ${DEPS_BUILD_PATH}/python_llvmlite/build-$ARCH-llvm/
  try cd ${DEPS_BUILD_PATH}/python_llvmlite/build-$ARCH-llvm/

  push_env
  # chmod +x $BUILD_python_llvmlite/conda-recipes/llvmdev/build.sh
  # try $BUILD_python_llvmlite/conda-recipes/llvmdev/build.sh

  try ${CMAKE} \
    -DLLVM_ENABLE_ASSERTIONS:BOOL=ON \
    -DLINK_POLLY_INTO_TOOLS:BOOL=ON \
    -DLLVM_ENABLE_LIBXML2:BOOL=OFF \
    -DHAVE_TERMINFO_CURSES=OFF \
    -DHAVE_TERMINFO_NCURSES=OFF \
    -DHAVE_TERMINFO_NCURSESW=OFF \
    -DHAVE_TERMINFO_TERMINFO=OFF \
    -DHAVE_TERMINFO_TINFO=OFF \
    -DHAVE_TERMIOS_H=OFF \
    -DCLANG_ENABLE_LIBXML=OFF \
    -DLIBOMP_INSTALL_ALIASES=OFF \
    -DLLVM_ENABLE_RTTI=OFF \
    -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;NVPTX" \
    -DLLVM_INCLUDE_UTILS=ON \
    -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    $BUILD_llvm

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env

  # build python
  try cd ${DEPS_BUILD_PATH}/python_llvmlite/build-$ARCH

  push_env

  export LLVM_CONFIG=$STAGE_PATH/bin/llvm-config
  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install
  unset LLVM_CONFIG

  pop_env
}
