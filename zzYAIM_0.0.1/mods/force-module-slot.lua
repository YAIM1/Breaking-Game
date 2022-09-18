--------------------------------------

-- force-module-slot.lua

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

-- Tipos a afectar
local Types = { }
table.insert( Types, "lab" )
table.insert( Types, "furnace" )
table.insert( Types, "mining-drill" )
table.insert( Types, "assembling-machine" )

-- Buscar las entidades a afectar
for _, Entity in pairs( Entitys ) do
    repeat

        -- Renombrar la variable
        local Module = Entity.module_specification

        -- Validación básica
        if not table.getKey( Types, Entity.type ) then break end
        if Module and Module.module_slots > 0 then break end

        -- Crear el slot
        Module = { }
        Module.module_slots = 1
        Entity.module_specification = Module

        -- Hacer la entidad predispuesta
        -- a los efectos de los modulos
        Entity.allowed_effects = { }
        table.insert( Entity.allowed_effects, "speed" )
        table.insert( Entity.allowed_effects, "pollution" )
        table.insert( Entity.allowed_effects, "consumption" )
        table.insert( Entity.allowed_effects, "productivity" )

    until true
end

--------------------------------------