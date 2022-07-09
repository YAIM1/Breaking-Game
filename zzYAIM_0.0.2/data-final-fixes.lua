---------------------------------------------------------------------------------------------------

--> data-final-fixes.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Crea la variable si aún no ha sido creada
GPrefix = GPrefix or { }

-- Identifica el archivo desde el cual se hace la llamada
GPrefix.File = debug.getinfo( 1 ).short_src

-- Llama en archivo central del mod
require( "mods/__LIBRARIES__/__CONTROL__" )

---------------------------------------------------------------------------------------------------