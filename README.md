## plec - Command-line Commands

- `plec` : Starts the plec
- `plec (file)` : Starts the repl with the specified script(.plec)
- `plec -lstd` : Starts the repl with the specified preloaded lib(require), in this case _lib.std_
- `plec -l lib/std.lua` : Starts the repl with the specified not-preloaded lib(import), in this case _./lib/std.lua_
- `plec -gl43` : Sets openGL version to specified version, in this example 4.3. Avaliable: 11, 21, 33, 43 and es2 (default is OpenGL2.1)

## plec - Built-In Commands

- `require modname` : require a preloaded lib named _modname_
- `import filepath` : load via _dofile_ pointed by _filepath_

## plec - Built-In Libraries

- `lib.core` : core are the essential to get a working console session, it is automatically loaded into plec from main.lua, only need to worry about loading it if running a custom/modified plec
- `lib.std` : standard is a extension of core, mostly composed by utils
- `lib.time` : creates session.data.time and automaticly set a timepass worker on top of others
- `lib.worker` : allow workers to be modified from inside a plec script or repl
- `lib.raylib` : includes raylib, an awesome game-development lib

## plec - Session Temp values

- `session.temp.exit` : responsible for exiting repl or keep in loop
- `session.temp.keep` : prevent the session.temp begin cleared, auto-disable
- `session.temp.break`: cancel current list processing
- `session.temp.skip` : prevent next command from running

## plec - Session Data values

- `session.data.preload` : prevent the preload from automaticaly run
- `session.data.setup` : prevent the setup from automaticaly run

## plec - Core Library commands(lib.core)

- `run scriptname` : run the _filename_ script
- `set name anything` : set a variable inside plec's session, you can also use this to set references
- `unset var-name` : unset a variable
- `def lua-code-here` : create a command from inside plec
- `undef cmd-name` : delete a cmd from data
- `autodef lua-code-here` : create a command from inside plec and automaticly load it
- `load` : load a existing cmd to session.
- `unload` : unload a loaded cmd from session.
- `> lua-code` : solve a lua code

## plec - Core Library workers(lib.core)

- `=` : turn _varname_ = _any1_ into set _varname_ _any1_
- `=>` : turn _functioname_ => _any1_ into def _functioname_ _any1_
- `unref` : turn _@any_ into its setted value, or replace by '' if no value set
- `unwrapcmd` : turn _([any])_ into session:run('any') result
- `spacendclean` : remove all spaces on start and end of command
- `timepass` : increments session.time
- `sigfault` : verify if the asked command is avaliable

## plec - Standard Library(lib.std)

- `help` : list all existing commands
- `lhelp` : list all loaded commands
- `clear` : clear terminal
- `pause` : send the user to api.run()
- `echo string` : print text and return it
- `--- string` : return comment
- `$ cmd` : direct access to OS terminal
- `exit` : quit, but complete the current loop
- `terminate` : force quit, terminate the process

## plec - worker Library(lib.worker)

- `worker.add id position newid` : workeradd a loaded worker, only _id_ is obligatory
- `worker.rm index/id` : remove worker at _index_ or by its _id_
- `worker.help` : list all workeradded workers
- `worker.lhelp` : list all loaded workers

## plec - compiler Library(lib.compile)

- `compile luajitpath Ccompiler -V -Cgcc -I/include/folder/ -L/library/folder` : compile command, it runs automaticaly if you do not disable setup, -V activate vitrine
- `cpreload` : manual preload in case you want more control over the compilation
- `csetup` : manual setup in case you want more control over the compilation
- `session.data.compile.vitrine` : demonstration mode, this copy the examples in the compilation
- `session.data.compile.ccompiler` : allow you to set a C compiler
- `session.data.compile.lib` : allow you to set a the lib path to your libraries
- `session.data.compile.include` : allow you to set a the include path to your headers

## plec - raylib Library(lib.raylib)

- `new.window width length` : create a new windows on size _width_:_length_
- `close` : terminate current window
- `new.scene type` : create a new scene, _type_ can be 2d or 3d
- `new.cube px py pz sx sy sz color` : create a new cube of size {x=sx,y=sy,z=sz} in position {x=px,y=py,z=pz} in _color_ color
- `new.text` : creates a new text in current scene
- `color.text` : sets default text color
- `color.background` : sets default background color
- `fontsize` : sets default font size
- `consolemode` : enters console mode
- `set.flag flag` : sets a renderer flag _flag_, must be used only before creating window. Avaliable: FLAG_VSYNC_HINT, FLAG_FULLSCREEN_MODE, FLAG_WINDOW_RESIZABLE, FLAG_WINDOW_UNDECORATED, FLAG_WINDOW_HIDDEN, FLAG_WINDOW_MINIMIZED, FLAG_WINDOW_MAXIMIZED, FLAG_WINDOW_UNFOCUSED, FLAG_WINDOW_TOPMOST, FLAG_WINDOW_ALWAYS_RUN, FLAG_WINDOW_TRANSPARENT, FLAG_WINDOW_HIGHDPI, FLAG_WINDOW_MOUSE_PASSTHROUGH, FLAG_BORDERLESS_WINDOWED_MODE, FLAG_MSAA_4X_HINT, FLAG_INTERLACED_HINT
- `set.scene x` : set main scene to scene of index _x_

## plec - raylib Library Workers(lib.raylib)

- `startdraw`: Begins drawing the frame. Call this before any drawing operation.
- `start3d`: Begins 3D mode with the camera associated with the current scene.
- `clearbg`: Clears the background with the color defined in the current scene.
- `end3d`: Ends 3D mode and returns to 2D mode.
- `drawtxt`: Draws all the texts defined in the current scene using the properties specified for each text.
- `drawcube`: Draws all the cubes defined in the current scene using the properties specified for each cube.
- `enddraw`: Ends drawing and swaps buffers, displaying the rendered frame on the screen.

## plec - Syntax

- `@variable` : is replaced by the _variable_ value
- `wl!wl2!wl3` : this set the current command to run on _wl_ _wl2_ _wl3_ pipelines
- `([command])` : run _command_ on plec layer
- `;` : separate commands, finish the command and start a new one

## NOTES

- remember that plec will ALWAYS start from its folder, no matter what you do, no matter where you are it will always start in the plec executable folder