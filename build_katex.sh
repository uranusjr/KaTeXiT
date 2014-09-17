#!/usr/bash

PATH=/usr/local/bin:$PATH
ROOT=$PWD/KaTeXiT
RESOURCES=$ROOT/Resources

if hash browserify 2>/dev/null; then
    browserify $ROOT/main.js --standalone katexit > $RESOURCES/bundle.js

    if hash uglifyjs 2>/dev/null; then
        uglifyjs $RESOURCES/bundle.js > $RESOURCES/_bundle.js
        mv $RESOURCES/_bundle.js $RESOURCES/bundle.js
    fi
fi
