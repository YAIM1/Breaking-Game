---------------------------------------------------------------------------------------------------

--> robots-with-unlimited-electricity.lua <--

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

-- Cargar los prototipos de los robots logistico
function ThisMOD.LoadInformation( )

    -- Buscar las entidades a afectar
    for _, Entity in pairs( GPrefix.Entities ) do

        -- Identificar a los robots
        if not Entity.energy_per_move then goto JumpEntity end

        -- Validar elemento
        local Alias = nil
        if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
        if Alias and Alias( Entity.name ) then goto JumpEntity end

        -- Duplicar la información relacionada
        GPrefix.duplicateEntity( Entity, ThisMOD )

        -- Recepción del salto
        :: JumpEntity ::
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Entities = Info.Entities or { }
    Info.Entities = Entities

    -- Hacer los cambios
    for _, Entity in pairs( Entities ) do
        Entity.energy_per_tick = "0J"
        Entity.energy_per_move = "0J"
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Eliminar los ingredientes
    for _, Recipe in pairs( Recipes ) do Recipe = Recipe[ 1 ]
        for _, Table in ipairs( { Recipe, Recipe.normal, Recipe.expensive } ) do
            if Table.ingredients then

                -- Nombre del objeto
                local name = GPrefix.Prefix_
                name = string.gsub( name, "-", "%%-" )
                name = string.gsub( Recipe.name, name, "" )

                -- Establecer el resultado
                Table.result = ThisMOD.Prefix_MOD_ .. name
                Table.results = nil
            end
        end
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Items = Info.Items or { }
    Info.Items = Items

    -- Asignar la marca del MOD
    for _, Item in pairs( Items ) do
        GPrefix.AddIcon( Item, ThisMOD )
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