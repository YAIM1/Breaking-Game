--------------------------------------

-- pollution-free-electricity.lua

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

-- Variable contenedora
local Count = 0

-- Buscar entidades que emiten contaminación
-- y funcinan con electricidad
for _, Entity in pairs( Entitys ) do
    repeat

        -- Validación básica
        local Flag = Entity
        if not Flag.energy_source then break end
        Flag = Flag.energy_source
        if not Flag.type then break end
        if Flag.type ~= "electric" then break end
        if not Flag.emissions_per_minute then break end

        -- Incrementar conteo y eliminar contaminación
        if Flag.emissions_per_minute > 0 then
            Flag.emissions_per_minute = nil
            Count = Count + 1
        end

    until true
end

-- Buscar entidades que
-- Queman conbustibles para generar enegia
-- Queman conbustibles para funcionar
for _, Entity in pairs( Entitys ) do
    repeat

        -- Validación básica
        local Flag = Entity
        if not Flag.burner then break end
        Flag = Entity.burner
        if not Flag.emissions_per_minute then break end

        -- Potenciar valor
        Flag.emissions_per_minute = Flag.emissions_per_minute * Count

    until true
    repeat

        -- Validación básica
        local Flag = Entity
        if not Flag.energy_source then break end
        Flag = Flag.energy_source
        if not Flag.type then break end
        if Flag.type ~= "burner" then break end
        if not Flag.emissions_per_minute then break end

        -- Potenciar valor
        Flag.emissions_per_minute = Flag.emissions_per_minute * Count

    until true
end

--------------------------------------