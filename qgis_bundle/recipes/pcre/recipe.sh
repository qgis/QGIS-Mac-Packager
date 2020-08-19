#!/bin/bash

function check_pcre() {
  env_var_exists VERSION_pcre
  env_var_exists LINK_pcre
}

function bundle_pcre() {
    try cp -av $DEPS_LIB_DIR/libpcre.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_pcre() {
    install_name_id  @rpath/$LINK_pcre $BUNDLE_LIB_DIR/$LINK_pcre
}

function fix_binaries_pcre_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_pcre
}

function fix_paths_pcre() {
  :
}

function fix_paths_pcre_check() {
  :
}