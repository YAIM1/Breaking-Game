--------------------------------------

-- stack-size.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está llamando
local modName = getFile( debug.getinfo( 1 ).short_src )

--------------------------------------
--------------------------------------

local Files = { "settings" }
if table.getKey( Files, __FILE__ ) then

	-- Preparar la configuración de este mod
    local _Setting =  {
        type          = "int-setting",
        setting_type  = "startup",
        default_value = 1000,
        minimum_value = 1,
        maximum_value = 65000
    }

    -- Construir valores
    local Description = "mod-setting-description."
    Description = Description .. "zzYAIM-short-setting"
    _Setting.name  = Prefix .. modName
    _Setting.order = SettingOrder[ _Setting.type ]
    _Setting.localised_description = { Description }

    -- Cargar configuración del mod al juego
    data:extend( { _Setting } )
end

--------------------------------------
--------------------------------------

Files = { "data-final-fixes" }

-- Es necesario ejecutar este codigo??
if not table.getKey( Files, __FILE__ ) then
    return false
end

-- MOD Activado
if not Active then
    local MOD = Setting[ modName ]
    if not MOD then return false end
    if MOD.value == 1 then return false end
end

--------------------------------------
--------------------------------------

-- Renombrar la variable
local _setting = Setting[ modName ]

-- Tipos a evitar
local AvoidTypes = { }
table.insert( AvoidTypes, "armor" )
table.insert( AvoidTypes, "selection-tool" )
table.insert( AvoidTypes, "belt-immunity-equipment" )

-- Patrones a evitar
local AvoidPatterns = { }
table.insert( AvoidPatterns, "%-remote" )

-- Hacer el camnbio en los items del juego, si le favorece
for _, item in pairs( Items ) do
    local Valid = not table.getKey( AvoidTypes, item.type )
    for _, Pattern in pairs( AvoidPatterns ) do
        Valid = Valid and not string.find( item.name, Pattern )
    end Valid = Valid and item.stack_size < _setting.value
    Valid = Valid and not table.getKey( item.flags, "not-stackable" )
    if Valid then item.stack_size = _setting.value end
end

--------------------------------------