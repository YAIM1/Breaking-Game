--------------------------------------

-- robots-with-unlimited-electricity.lua

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

-- if GPrefix.getKey( Files, GPrefix.File ) then

--     -- Preparar la configuración de este mod
--     local SettingOption =  {
--         type           = "bool-setting",
--         setting_type   = "startup",
--         allowed_values = {"true", "false"},
--         default_value  = true
--     }

--     -- Construir valores
--     SettingOption.name  = GPrefix.MOD.Prefix_MOD
--     SettingOption.order = GPrefix.SettingOrder[ SettingOption.type ]
-- 	SettingOption.order = SettingOption.order .. "-" .. SettingOption.name

--     -- Cargar configuración del mod al juego
--     data:extend( { SettingOption } )
--     return
-- end

if GPrefix.getKey( Files, GPrefix.File ) then

    -- Preparar la configuración de este mod
    local SettingOption =  {
        type           = "bool-setting",
        setting_type   = "startup",
        allowed_values = { "true", "false" },
        default_value  = true
    }

    -- Construir valores
    local Local = GPrefix.MOD.Local
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

-- Parametro a buscar
local PrefixFind = string.gsub( GPrefix.Prefix, "-", "%%-" )

-- Buscar los robots
for _, Entity in pairs( GPrefix.Entities ) do
    repeat

        -- Identificar los robots
        if not Entity.energy_per_move then break end
        if not string.find( Entity.name, PrefixFind ) then break end

        -- Agregar el idicador de mejora
        GPrefix.addPlus( Entity )

        -- Realizar el cambio
        Entity.energy_per_tick = "0J"
        Entity.energy_per_move = "0J"
    until true
end

--------------------------------------