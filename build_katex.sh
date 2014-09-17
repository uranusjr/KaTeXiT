#!/usr/bash

PATH=/usr/local/bin:$PATH
ROOT=$PWD/KaTeXiT
RESOURCES=$ROOT/Resources
KATEX=$PWD/Dependency/KaTeX/static

if [ -d "$KATEX" ]; then
    if hash browserify 2>/dev/null; then
        browserify $ROOT/main.js --standalone katexit > $RESOURCES/bundle.js

        if hash uglifyjs 2>/dev/null; then
            uglifyjs $RESOURCES/bundle.js > $RESOURCES/_bundle.js
            mv $RESOURCES/_bundle.js $RESOURCES/bundle.js
        fi
    fi
    if hash lessc 2>/dev/null; then
        lessc /katex.less > $RESOURCES/katex/katex.less.css
        cat $RESOURCES/katex/katex.less.css $KATEX/fonts.css > $RESOURCES/katex/katex.css
        if hash cleancss 2>/dev/null; then
            cleancss -o $RESOURCES/katex/katex.min.css $RESOURCES/katex/katex.css
        else
            cp $RESOURCES/katex/katex.css $RESOURCES/katex/katex.min.css
        fi
        rm $RESOURCES/katex/katex.less.css $RESOURCES/katex/katex.css
    fi
    cp -r $KATEX/fonts $RESOURCES/katex
fi
