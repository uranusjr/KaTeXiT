# KaTeXiT

Mimicking [LaTeXiT] with [KaTeX] and JavaScriptCore API. A proof of concept.

![KaTeXiT](http://d.pr/i/a2lk+)

## Building

A broswerified and minified script is bundled in the repository. If you want to update KaTeX, you’ll need to

1. Install [Browserify] and [UglifyJS] somewhere in `PATH` (preferrably `/usr/local/bin`).
2. Pull the KaTeX submodule.
3. Update KaTeX as you wish.
3. Hit build in Xcode. There’s a custom build script that’ll automatically recompile the bundled script (`bundle.js`) for you.


## License

[MIT] if you *really* want to use this.


[LaTeXiT]: http://www.chachatelier.fr/latexit/
[KaTeX]: http://khan.github.io/KaTeX/
[Browserify]: http://browserify.org
[UglifyJS]: https://github.com/mishoo/UglifyJS
[MIT]: http://opensource.org/licenses/MIT