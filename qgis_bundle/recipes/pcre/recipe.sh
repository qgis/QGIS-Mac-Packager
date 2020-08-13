#!/bin/bash

function check_pcre() {
  env_var_exists VERSION_pcre
  env_var_exists LINK_pcre
}

function bundle_pcre() {
    try cp -av $DEPS_LIB_DIR/libpcre.*dylib $BUNDLE_LIB_DIR
}

function postbundle_pcre() {
    install_name_id  @rpath/$LINK_pcre $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_pcre
}
