--------------------------------------

-- force-production.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está usando
local MOD = GPrefix.getFile( debug.getinfo( 1 ).short_src )

-- Crear la vareble si no existe
GPrefix.MODs[ MOD ] = GPrefix.MODs[ MOD ] or { }

-- Guardar en el acceso rapido
GPrefix.MOD = GPrefix.MODs[ MOD ]

--------------------------------------
--------------------------------------

local Files = { }
table.insert( Files, "settings" )

-- Cargar la configuración
if GPrefix.getKey( Files, GPrefix.File ) then

    -- Preparar la configuración de este mod
    local SettingOption =  {
        type           = "bool-setting",
        setting_type   = "startup",
        allowed_values = {"true", "false"},
        default_value  = true
    }

    -- Construir valores
    SettingOption.name  = GPrefix.MOD.Prefix_MOD
    SettingOption.order = GPrefix.SettingOrder[ SettingOption.type ]
	SettingOption.order = SettingOption.order .. "-" .. SettingOption.name
    SettingOption.localised_name  = { GPrefix.MOD.Local .. "setting-name"}
    SettingOption.localised_description  = { GPrefix.MOD.Local .. "setting-description"}

    -- Cargar configuración del mod al juego
    data:extend( { SettingOption } )
    return
end

--------------------------------------
--------------------------------------

Files = { }
table.insert( Files, "data-final-fixes" )

-- Es necesario ejecutar este codigo??
if not GPrefix.getKey( Files, GPrefix.File ) then return end

-- MOD Inactivo
if not GPrefix.MOD.Active then return end

--------------------------------------
--------------------------------------

-- Identificar el modelo
local Module = GPrefix.Items[ "productivity-module" ]

-- El modelo no existe
if not Module then return end

-- Variable contenedora
local recipes = Module.limitation

-- Guardar el nombre de las recetas que afecta
for _, Recipe in pairs( GPrefix.Recipes ) do
    for _, recipe in pairs( Recipe ) do
        if not GPrefix.getKey( recipes, recipe.name ) then
          table.insert( recipes, recipe.name )
        end
    end
end

-- Parametro a buscar
local PrefixFind = string.gsub( GPrefix.Prefix, "-", "%%-" )

-- Buscar los modulos de producción
for _, Item in pairs( GPrefix.Items ) do
    repeat
        if not string.find( Item.name, PrefixFind ) then break end
        if not Item.limitation then break end
        Item.limitation = recipes
    until true
end

--------------------------------------