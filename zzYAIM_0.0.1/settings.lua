--------------------------------------

-- settings.lua

--------------------------------------
--------------------------------------

-- Identifica el archivo desde el cual se hace la llamada
__FILE__ = debug.getinfo( 1 ).short_src

-- Llama en archivo central del mod
require( "mods.__CONTROL__" )

--------------------------------------