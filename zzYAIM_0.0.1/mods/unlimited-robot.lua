--------------------------------------

-- unlimited-robot.lua

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

-- Variable contenedore
local Mod = { }
local Vanilla = { }

local Robots = { }
table.insert( Robots, "logistic-robot" )
table.insert( Robots, "construction-robot" )
local prefix = string.gsub( Prefix, "-", "%%-" )

-- Buscar los robots
for _, Entity in pairs( Entitys ) do

    -- Identificar los robots
    if Entity.energy_per_move then

        -- Robots de este mod
        if string.find( Entity.name, prefix ) then
            table.insert( Mod, Entity )
        end

        -- Robots de vanilla
        if table.getKey( Robots, Entity.name ) then
            table.insert( Vanilla, Entity )
        end
    end
end

-- Realizar el cambio
for _, Robot in pairs( #Mod > 0 and Mod or Vanilla ) do
    Robot.energy_per_tick = "0J"
    Robot.energy_per_move = "0J"
end

--------------------------------------