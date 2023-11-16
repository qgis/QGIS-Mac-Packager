#!/bin/bash

DESC_python_pyqt5="PyQt5 package for python"

# version of your package
VERSION_python_pyqt5=5.15.9

# dependencies of this recipe
DEPS_python_pyqt5=(python python_sip qtwebkit qscintilla python_pyqt_builder)

# url of the package
URL_python_pyqt5=https://files.pythonhosted.org/packages/5c/46/b4b6eae1e24d9432905ef1d4e7c28b6610e28252527cdc38f2a75997d8b5/PyQt5-${VERSION_python_pyqt5}.tar.gz

# md5 of the package
MD5_python_pyqt5=9d97fc06b7ae75e654e946c49e07ff12

# default build path
BUILD_python_pyqt5=$BUILD_PATH/python_pyqt5/$(get_directory $URL_python_pyqt5)

# default recipe path
RECIPE_python_pyqt5=$RECIPES_PATH/python_pyqt5

function fix_python_pyqt5_paths() {
  # these are sh scripts that calls plain python{VERSION_major_python}
  # so when on path there is homebrew python or other
  # it fails
  targets=(
    bin/pylupdate5
    bin/pyrcc5
    bin/pyuic5
  )

  for i in ${targets[*]}
  do
    try ${SED} "s;exec ./python${VERSION_major_python}.${VERSION_minor_python};exec $STAGE_PATH/bin/python${VERSION_major_python}.${VERSION_minor_python};g" $STAGE_PATH/$i
    try ${SED} "s;exec python${VERSION_major_python}.${VERSION_minor_python};exec $STAGE_PATH/bin/python${VERSION_major_python}.${VERSION_minor_python};g" $STAGE_PATH/$i

    try ${SED} "s;exec ./python${VERSION_major_python};exec $STAGE_PATH/bin/python${VERSION_major_python};g" $STAGE_PATH/$i
    try ${SED} "s;exec python${VERSION_major_python};exec $STAGE_PATH/bin/python${VERSION_major_python};g" $STAGE_PATH/$i
    rm -f $STAGE_PATH/$i.orig
  done

  echo ${REPL}
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyqt5() {
  try mkdir -p $BUILD_python_pyqt5
  cd $BUILD_python_pyqt5

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_pyqt5() {
  if python_package_installed PyQt5.QtCore; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_pyqt5() {
  try rsync -a $BUILD_python_pyqt5/ $BUILD_PATH/python_pyqt5/build-$ARCH/
  try cd $BUILD_PATH/python_pyqt5/build-$ARCH

  push_env

  try $STAGE_PATH/bin/sip-install \
    --confirm-license \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --scripts-dir ${STAGE_PATH}/bin \
    --disable QAxContainer \
    --disable QtX11Extras \
    --disable QtWinExtras \
    --disable Enginio \
    --jobs $CORES \
    --verbose \
    --qmake-setting 'QT.webkit.VERSION = 5.212.0' \
    --qmake-setting 'QT.webkit.MAJOR_VERSION = 5' \
    --qmake-setting 'QT.webkit.MINOR_VERSION = 212' \
    --qmake-setting 'QT.webkit.PATCH_VERSION = 0' \
    --qmake-setting 'QT.webkit.name = QtWebKit' \
    --qmake-setting 'QT.webkit.module = QtWebKit' \
    --qmake-setting 'QT.webkit.DEFINES = QT_WEBKIT_LIB' \
    --qmake-setting "QT.webkit.includes = \"${STAGE_PATH}/lib/QtWebKit.framework/Headers\" \"${STAGE_PATH}/\"" \
    --qmake-setting 'QT.webkit.private_includes =' \
    --qmake-setting "QT.webkit.libs = \"${STAGE_PATH}/lib\"" \
    --qmake-setting "QT.webkit.rpath = \"${STAGE_PATH}/lib\"" \
    --qmake-setting 'QT.webkit.depends = core gui network' \
    --qmake-setting 'QT.webkit.run_depends = multimedia sensors positioning qml quick core_private gui_private' \
    --qmake-setting "QT.webkit.bins = ${STAGE_PATH}/bin" \
    --qmake-setting 'QT.webkit.libexec =' \
    --qmake-setting 'QT.webkit.plugins =' \
    --qmake-setting 'QT.webkit.imports =' \
    --qmake-setting 'QT.webkit.qml =' \
    --qmake-setting "QT.webkit.frameworks = ${STAGE_PATH}/lib" \
    --qmake-setting 'QT.webkit.module_config = v2 lib_bundle' \
    --qmake-setting 'QT_MODULES += webkit' \
    --qmake-setting 'QMAKE_LIBS_PRIVATE += ' \
    --qmake-setting "QMAKE_RPATHDIR += ${STAGE_PATH}/lib" \
    --qmake-setting 'QT.webkitwidgets.VERSION = 5.212.0' \
    --qmake-setting 'QT.webkitwidgets.MAJOR_VERSION = 5' \
    --qmake-setting 'QT.webkitwidgets.MINOR_VERSION = 212' \
    --qmake-setting 'QT.webkitwidgets.PATCH_VERSION = 0' \
    --qmake-setting 'QT.webkitwidgets.name = QtWebKitWidgets' \
    --qmake-setting 'QT.webkitwidgets.module = QtWebKitWidgets' \
    --qmake-setting 'QT.webkitwidgets.DEFINES = QT_WEBKITWIDGETS_LIB' \
    --qmake-setting "QT.webkitwidgets.includes = \"${STAGE_PATH}/lib/QtWebKitWidgets.framework/Headers\" \"${STAGE_PATH}/\"" \
    --qmake-setting 'QT.webkitwidgets.private_includes =' \
    --qmake-setting "QT.webkitwidgets.libs = \"${STAGE_PATH}/lib\"" \
    --qmake-setting "QT.webkitwidgets.rpath = \"${STAGE_PATH}/lib\"" \
    --qmake-setting 'QT.webkitwidgets.depends = core gui network widgets webkit' \
    --qmake-setting 'QT.webkitwidgets.run_depends = multimedia sensors positioning qml quick core_private gui_private widgets_private opengl printsupport multimediawidgets' \
    --qmake-setting "QT.webkitwidgets.bins = ${STAGE_PATH}/bin" \
    --qmake-setting 'QT.webkitwidgets.libexec =' \
    --qmake-setting 'QT.webkitwidgets.plugins =' \
    --qmake-setting 'QT.webkitwidgets.imports =' \
    --qmake-setting 'QT.webkitwidgets.qml =' \
    --qmake-setting "QT.webkitwidgets.frameworks = ${STAGE_PATH}/lib" \
    --qmake-setting 'QT.webkitwidgets.module_config = v2 lib_bundle' \
    --qmake-setting 'QT_MODULES += webkitwidgets' \
    --qmake-setting 'QMAKE_LIBS_PRIVATE += ' \
    --qmake-setting "QMAKE_RPATHDIR += ${STAGE_PATH}/lib"

  # added depencencies
  # ref: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/pyqt@5.rb
  try curl -o PyQt5_sip-12.11.0.tar.gz https://files.pythonhosted.org/packages/39/5f/fd9384fdcb9cd0388088899c110838007f49f5da1dd1ef6749bfb728a5da/PyQt5_sip-12.11.0.tar.gz
  try tar zxf PyQt5_sip-12.11.0.tar.gz
  try cd PyQt5_sip-12.11.0
  try $PYTHON setup.py install
  try cd ..
  
  try curl -o PyQt3D-5.15.5.tar.gz https://files.pythonhosted.org/packages/44/af/58684ce08013c0e16839662844b29cd73259a909982c4d6517ce5ffda05f/PyQt3D-5.15.5.tar.gz
  try tar zxf PyQt3D-5.15.5.tar.gz
  try cd PyQt3D-5.15.5
  try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt5/bindings\"\]|g" pyproject.toml
  try $STAGE_PATH/bin/sip-install \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --verbose
  try cd ..

  try curl -o PyQtChart-5.15.6.tar.gz https://files.pythonhosted.org/packages/eb/17/1d9bb859b3e09a06633264ad91249ede0abd68c1e3f2f948ae7df94702d3/PyQtChart-5.15.6.tar.gz
  try tar zxf PyQtChart-5.15.6.tar.gz
  try cd PyQtChart-5.15.6
  try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt5/bindings\"\]|g" pyproject.toml
  try $STAGE_PATH/bin/sip-install \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --verbose
  try cd ..

  try curl -o PyQtDataVisualization-5.15.5.tar.gz https://files.pythonhosted.org/packages/9c/ff/6ba767b4e1dbc32c7ffb93cd5d657048f6a4edf318c5b8810c8931a1733b/PyQtDataVisualization-5.15.5.tar.gz
  try tar zxf PyQtDataVisualization-5.15.5.tar.gz
  try cd PyQtDataVisualization-5.15.5
  try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt5/bindings\"\]|g" pyproject.toml
  try $STAGE_PATH/bin/sip-install \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --verbose
  try cd ..

  try curl -o PyQtNetworkAuth-5.15.5.tar.gz https://files.pythonhosted.org/packages/85/b6/6b8f30ebd7c15ded3d91ed8d6082dee8aebaf79c4e8d5af77b1172c805c2/PyQtNetworkAuth-5.15.5.tar.gz
  try tar xzf PyQtNetworkAuth-5.15.5.tar.gz
  try cd PyQtNetworkAuth-5.15.5
  try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt5/bindings\"\]|g" pyproject.toml
  try $STAGE_PATH/bin/sip-install \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --verbose
  try cd ..

  try curl -o PyQtWebEngine-5.15.6.tar.gz https://files.pythonhosted.org/packages/cf/4b/ca01d875eff114ba5221ce9311912fbbc142b7bb4cbc4435e04f4f1f73cb/PyQtWebEngine-5.15.6.tar.gz
  try tar zxf PyQtWebEngine-5.15.6.tar.gz
  try cd PyQtWebEngine-5.15.6
  try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt5/bindings\"\]|g" pyproject.toml
  try $STAGE_PATH/bin/sip-install \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --verbose
  try cd ..

  try curl -o PyQtPurchasing-5.15.5.tar.gz https://files.pythonhosted.org/packages/41/2a/354f0ae3fa02708719e2ed6a8c310da4283bf9a589e2a7fcf7dadb9638af/PyQtPurchasing-5.15.5.tar.gz
  try tar zxf PyQtPurchasing-5.15.5.tar.gz
  try cd PyQtPurchasing-5.15.5
  try sed -i '' -e "s|\[tool.sip.project\]|\[tool.sip.project\]\nsip-include-dirs = \[\"${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages/PyQt5/bindings\"\]|g" pyproject.toml
  try $STAGE_PATH/bin/sip-install \
    --target-dir ${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages \
    --verbose
  try cd ..

  fix_python_pyqt5_paths

  pop_env
}

function postbuild_python_pyqt5() {
   if ! python_package_installed_verbose PyQt5.QtCore; then
      error "Missing python package PyQt5.QtCore"
   fi

   if ! python_package_installed_verbose PyQt5.QtWebKit; then
      error "Missing python package PyQt5.QtWebKit"
   fi

   if ! python_package_installed_verbose PyQt5.QtWebKitWidgets; then
      error "Missing python package PyQt5.QtWebKitWidgets"
   fi
}

# function to append information to config file
function add_config_info_python_pyqt5() {
  append_to_config_file "# python_pyqt5-${VERSION_python_pyqt5}: ${DESC_python_pyqt5}"
  append_to_config_file "export VERSION_python_pyqt5=${VERSION_python_pyqt5}"
}