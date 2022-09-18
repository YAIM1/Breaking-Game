--------------------------------------

-- equipament-1x1.lua

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
        type           = "bool-setting",
        setting_type   = "startup",
        allowed_values = {"true", "false"},
        default_value  = true
    }

    -- Construir valores
    _Setting.name  = Prefix .. modName
    _Setting.order = SettingOrder[ _Setting.type ]

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
    if not MOD.value then return false end
end

--------------------------------------
--------------------------------------

-- Redimencionar el tamñao del equipamento
for _, Equipment in pairs( Equipments ) do
    Equipment.shape.width = 1
    Equipment.shape.height = 1
end

--------------------------------------