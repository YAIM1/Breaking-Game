--------------------------------------

-- minimum-consumption.lua

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

-- Parametro a buscar
local PrefixFind = string.gsub( GPrefix.Prefix, "-", "%%-" )

-- Buscar entidades que funcinan con electricidad
for _, Entity in pairs( GPrefix.Entities ) do
    repeat

        -- Evitar un bucle
        if not string.find( Entity.name, PrefixFind ) then break end

        local Value = 0

        -- Todos
        if Entity.energy_usage then
            Value = Entity.energy_usage
            Entity.energy_usage = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        repeat
            if not Entity.energy_source then break end
            Value = Entity.energy_source
            if not Value.drain then break end
            Value.drain = nil
            GPrefix.addPlus( Entity )
        until true

        -- Entidades logicas
        if Entity.active_energy_usage then
            Value = Entity.active_energy_usage
            Entity.active_energy_usage = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        -- Radar
        if Entity.energy_per_nearby_scan then
            Value = Entity.energy_per_nearby_scan
            Entity.energy_per_nearby_scan = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        if Entity.energy_per_sector then
            Value = Entity.energy_per_sector
            Entity.energy_per_sector = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        -- Insertador
        if Entity.energy_per_movement then
            Value = Entity.energy_per_movement
            Entity.energy_per_movement = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        if Entity.energy_per_rotation then
            Value = Entity.energy_per_rotation
            Entity.energy_per_rotation = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        -- Lamaparasy altavoz
        if Entity.energy_usage_per_tick then
            Value = Entity.energy_usage_per_tick
            Entity.energy_usage_per_tick = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        -- Spidertron
        if Entity.movement_energy_consumption then
            Value = Entity.movement_energy_consumption
            Entity.movement_energy_consumption = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        if Entity.braking_power then
            Value = Entity.braking_power
            Entity.braking_power = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value )
            GPrefix.addPlus( Entity )
        end

        -- Arma de energía
        repeat
            if not Entity.attack_parameters then break end
            Value = Entity.attack_parameters
            if not Value.ammo_type then break end
            Value = Value.ammo_type
            if not Value.energy_consumption then break end
            Value.energy_consumption = tostring( 10 ^ -2 ) .. GPrefix.getUnit( Value.energy_consumption )
            GPrefix.addPlus( Entity )
        until true
    until true
end

--------------------------------------