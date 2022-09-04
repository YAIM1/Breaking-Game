--------------------------------------

-- __CONSTANT__.lua

--------------------------------------
--------------------------------------

if Prefix then return true end

--------------------------------------
--------------------------------------

-- Globales
_G.Setting  = { }
_G.Prefix   = "zzYAIM-"
_G.Files    = { }

--------------------------------------
--------------------------------------

-- Unidades de energia
_G.Unit = { }
Unit.K =  3
Unit.M =  6
Unit.G =  9
Unit.T = 12
Unit.P = 15
Unit.E = 18
Unit.Z = 21
Unit.Y = 24
Unit[ 0 ] = ""

-- Invertir valores
for key, value in pairs( Unit ) do
    Unit[ value ] = key
end

--------------------------------------
--------------------------------------

-- Order en la configuración
_G.SettingOrder = { }
SettingOrder[ "bool-setting" ]   = "A"
SettingOrder[ "string-setting" ] = "B"
SettingOrder[ "double-setting" ] = "C"
SettingOrder[ "int-setting" ]    = "D"

--------------------------------------
--------------------------------------

-- Cargar los MODs
_G.MODs = { }
table.insert( MODs, "compact" )
table.insert( MODs, "free-fluids" )
table.insert( MODs, "immune-armors" )
table.insert( MODs, "equipament-1x1" )
table.insert( MODs, "inventory-sort" )
table.insert( MODs, "unlimited-robot" )
table.insert( MODs, "force-production" )
table.insert( MODs, "force-module-slot" )
table.insert( MODs, "pollution-free-electricity" )
-- table.insert( MODs, "pruebas" )
table.insert( MODs, "stack-size" )

--------------------------------------