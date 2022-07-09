--------------------------------------

-- maximum-stack-size.lua

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
        type          = "int-setting",
        setting_type  = "startup",
        default_value = 1000,
        minimum_value = 1,
        maximum_value = 65000
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

-- Tipos a evitar
local AvoidTypes = { }
table.insert( AvoidTypes, "armor" )
table.insert( AvoidTypes, "selection-tool" )
table.insert( AvoidTypes, "belt-immunity-equipment" )

-- Patrones a evitar
local AvoidPatterns = { }
table.insert( AvoidPatterns, "%-remote" )

-- Hacer el camnbio en los items del juego, si le favorece
for _, item in pairs( GPrefix.Items ) do

    -- Evitar este tipo
    local Valid = not GPrefix.getKey( AvoidTypes, item.type )

    -- Evitar este patron
    for _, Pattern in pairs( AvoidPatterns ) do
        Valid = Valid and not string.find( item.name, Pattern )
    end

    -- El cambio le favorece el cambio
    Valid = Valid and item.stack_size < GPrefix.MOD.Value

    -- No es apilable
    Valid = Valid and not GPrefix.getKey( item.flags, "not-stackable" )

    -- No se puede crear
    Valid = Valid and not GPrefix.getKey( item.flags, "spawnable" )

    -- Hacer el cambio
    if Valid then item.stack_size = GPrefix.MOD.Value end
end

--------------------------------------