---------------------------------------------------------------------------------------------------

--> minimum-electrical-consumption.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Contenedor de este MOD
local ThisMOD = { }

-- Cargar información de este MOD
if true then

    -- Identifica el mod que se está usando
    local NameMOD = GPrefix.getFile( debug.getinfo( 1 ).short_src )

    -- Crear la vareble si no existe
    GPrefix.MODs[ NameMOD ] = GPrefix.MODs[ NameMOD ] or { }

    -- Guardar en el acceso rapido
    ThisMOD = GPrefix.MODs[ NameMOD ]
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Configuración del MOD
function ThisMOD.Settings( )
    if not GPrefix.getKey( { "settings" }, GPrefix.File ) then return end

    local SettingOption =  { }
    SettingOption.name  = ThisMOD.Prefix_MOD
    SettingOption.type  = "bool-setting"
    SettingOption.order = ThisMOD.Char
    SettingOption.setting_type   = "startup"
    SettingOption.default_value  = true
    SettingOption.allowed_values = { "true", "false" }

	local Name = { }
    table.insert( Name, "" )
    table.insert( Name, { GPrefix.Local .. "setting-char", ThisMOD.Char } )
    table.insert( Name, { ThisMOD.Local .. "setting-name" } )
	if ThisMOD.Requires then
		Name = { GPrefix.Local .. "setting-require-name", Name, ThisMOD.Requires.Char }
	end SettingOption.localised_name = Name

	local Description = { ThisMOD.Local .. "setting-description" }
	if ThisMOD.Requires then
		Description = { GPrefix.Local .. "setting-require-description", { ThisMOD.Requires.Local .. "setting-name" }, Description }
	end SettingOption.localised_description = Description

    data:extend( { SettingOption } )
end

-- Cargar la configuración
ThisMOD.Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Cargar la infomación
function ThisMOD.LoadInformation( )

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Entities = Info.Entities or { }
    Info.Entities = Entities

    local Table = { }
    local String = ""

    -- Establecer electricidad minima
    local function Min( OldValue )
       return tostring( 10 ^ 1 ) .. GPrefix.getUnit( OldValue )
    end

    -- Agregar a los prototipos del juego
    local function add( Entity )
        if not Entities[ Entity.name ] then
            GPrefix.duplicateEntity( Entity, ThisMOD )
        end return Entities[ Entity.name ]
    end

    -- Buscar las entidades a afectar
    for _, Entity in pairs( GPrefix.Entities ) do

        -- Validar elemento
        local Alias = nil
        if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
        if Alias and Alias( Entity.name ) then goto JumpEntity end

        -- Todos
        repeat
            if not Entity.energy_source then break end
            Table = Entity.energy_source
            if not Table.type then goto JumpEntity end
            if Table.type ~= "electric" then goto JumpEntity end
            if not Table.drain then break end

            Entity = add( Entity )
            Entity.energy_source.drain = nil
        until true

        if Entity.energy_usage then
            Entity = add( Entity )
            Entity.energy_usage = Min( Entity.energy_usage )
        end

        -- Entidades logicas
        if Entity.active_energy_usage then
            Entity = add( Entity )
            Entity.active_energy_usage = Min( Entity.active_energy_usage )
        end

        -- Radar
        if Entity.energy_per_nearby_scan then
            Entity = add( Entity )
            Entity.energy_per_nearby_scan = Min( Entity.energy_per_nearby_scan )
        end

        if Entity.energy_per_sector then
            Entity = add( Entity )
            Entity.energy_per_sector = Min( Entity.energy_per_sector )
        end

        -- Insertador
        if Entity.energy_per_movement then
            Entity = add( Entity )
            Entity.energy_per_movement = Min( Entity.energy_per_movement )
        end

        if Entity.energy_per_rotation then
            Entity = add( Entity )
            Entity.energy_per_rotation = Min( Entity.energy_per_rotation )
        end

        -- Lamaparas y altavoz
        if Entity.energy_usage_per_tick then
            Entity = add( Entity )
            Entity.energy_usage_per_tick = Min( Entity.energy_usage_per_tick )
        end

        -- Spidertron
        if Entity.movement_energy_consumption then
            Entity = add( Entity )
            Entity.movement_energy_consumption = Min( Entity.movement_energy_consumption )
        end

        -- Arma de energía
        repeat
            if not Entity.attack_parameters then break end
            Table = Entity.attack_parameters
            if not Table.ammo_type then break end
            Table = Table.ammo_type
            if not Table.energy_consumption then break end

            Entity = add( Entity )
            Table = Entity.attack_parameters.ammo_type
            Table.energy_consumption = Min( Table.energy_consumption )
        until true

        -- Recepción del salto
        :: JumpEntity ::
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------