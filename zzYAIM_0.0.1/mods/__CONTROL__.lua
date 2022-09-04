--------------------------------------

-- __CONTROL__.lua

--------------------------------------
--------------------------------------

-- Librerias
require( "mods.__CONSTANT__" )
require( "mods.__FUNCTION__" )
require( "mods.__GLOBALS_VALUES__" )

--------------------------------------
--------------------------------------

-- Cargador de los mods
for _, MOD in pairs( MODs ) do
    Setting[ MOD ] = Setting[ MOD ] or { }
    require( "mods." .. MOD )
end

--------------------------------------