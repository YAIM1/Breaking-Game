--------------------------------------

-- pollution-free-electricity.lua

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

-- Variable contenedora
local Count = 0

-- Parametro a buscar
local PrefixFind = string.gsub( GPrefix.Prefix, "-", "%%-" )

-- Buscar entidades que emiten contaminación
-- y funcinan con electricidad
for _, Entity in pairs( GPrefix.Entities ) do
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
            if string.find( Entity.name, PrefixFind ) then

                -- Agregar el idicador de mejora
                GPrefix.addPlus( Entity )

                Flag.emissions_per_minute = nil
            end Count = Count + 1
        end

    until true
end

-- Buscar entidades que
-- Queman conbustibles para generar enegia
-- Queman conbustibles para funcionar
for _, Entity in pairs( GPrefix.Entities ) do
    if string.find( Entity.name, PrefixFind ) then
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
end

--------------------------------------