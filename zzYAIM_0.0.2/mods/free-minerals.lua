---------------------------------------------------------------------------------------------------

--> free-minerals.lua <--

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

-- Configuración del MOD
local function Settings( )
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
    if true then return end
end

-- Cargar la configuración
Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Crear los subgrupos y las recetas de los fluidos
function ThisMOD.CreateMineralRecipe( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Crear el SubGrupo para los minerales
    local subGroup = { }
    subGroup.group = "intermediate-products"
    subGroup.type  = "item-subgroup"
    subGroup.name  = ThisMOD.Prefix_MOD_
    subGroup.name  = subGroup.name .. "create"
    subGroup.order = subGroup.name
    data:extend( { subGroup } )

    -- Crar cada uno de los recursos
    for _, Resources in pairs( data.raw[ "resource" ] ) do

        -- Validar los resutados
        local Results = { }
        Resources = Resources.minable
        if Resources.result then
            Results = { { name = Resources.result } }
        elseif Resources.results then
            Results = Resources.results
        end

        -- Crear una receta por cada recurso
        for _, Result in pairs( Results ) do

            -- Variable contenedor
            local Data = { }

            -- El resultado es un fluido
            if Result.type and Result.type == "fluid" then goto JumpResorce end

            -- Cargar el objeto
            Data.Item = GPrefix.Items[ Result.name ]
            if not Data.Item then goto JumpResorce end

            -- Fluido correspondiente
            Data.Result =  { }
            Data.Result.type = "item"
            Data.Result.name = Data.Item.name
            Data.Result.amount = 6 * 10^4

            -- Receta del fluido
            Data.Recipe = { }
            Data.Recipe.type = "recipe"
            Data.Recipe.name = Data.Item.name
            Data.Recipe.icon = Data.Item.icon
            Data.Recipe.icons = GPrefix.DeepCopy( Data.Item.icons )
            Data.Recipe.order = ThisMOD.Prefix_MOD_ .. Data.Item.name
            Data.Recipe.icon_size = Data.Item.icon_size
            Data.Recipe.icon_mipmaps = Data.Item.icon_mipmaps
            Data.Recipe.hide_from_player_crafting = true

            Data.Recipe.enabled = true
            Data.Recipe.category = ThisMOD.Prefix_MOD
            Data.Recipe.energy_required = 10^-2

            Data.Recipe.results     = { Data.Result }
            Data.Recipe.ingredients = { }

            if Data.Item.localised_name then
                Data.Recipe.localised_name = GPrefix.DeepCopy( Data.Item.localised_name )
            else
                Data.Recipe.localised_name = { "item-name." .. Data.Item.name }
            end

            -- Guardar la nueva receta
            GPrefix.addRecipe( Data.Recipe, ThisMOD )

            -- Recepción del salto
            :: JumpResorce ::
        end
    end
end

-- Cargar la información de la maquina
function ThisMOD.LoadMachine( )

    -- Inicializar las variables
    local Base = "assembling-machine-1"
    local Entity = GPrefix.Entities[ Base ]
    local Category = { type = "recipe-category", name = ThisMOD.Prefix_MOD }
    local Localised = "machine"

    -- Duplicar la información relacionada
    GPrefix.duplicateEntity( Entity, ThisMOD )

    -- Crear la nueva categoria
    data:extend( { Category } )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Entities = Info.Entities or { }
    Info.Entities = Entities

    -- Modificar la entidad
    Entity = Entities[ Entity.name ]
    Entity.energy_usage = "10W"
    Entity.next_upgrade = nil
    Entity.collision_mask = nil
    Entity.energy_source = { type = "void" }
    Entity.crafting_categories = { ThisMOD.Prefix_MOD }
    Entity.resource_categories = nil
    Entity.fast_replaceable_group = nil

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Actualizar el resultado de las recetas
    GPrefix.updateResults( ThisMOD )

    -- Inicializar y renombrar la variable
    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Eliminar los ingredientes
    local Recipe = Recipes[ Base ][ 1 ]
    for _, Table in ipairs( { Recipe, Recipe.normal, Recipe.expensive } ) do
        if Table.ingredients then
            Table.ingredients = { }
            Table.results = nil
        end
    end

    -- Eliminar las demas recetas
    while #Recipes[ Base ] > 1 do
        table.remove( Recipes[ Base ], 2 )
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Establecer el apodo
    local Item = Info.Items[ Base ]
    Item.localised_name = nil
    Item.localised_description = nil
    GPrefix.addLetter( Item, ThisMOD.Char )
    Item.localised_name[ 2 ] = { ThisMOD.Local .. Localised }
    Entity.localised_name = GPrefix.DeepCopy( Item.localised_name )
    Recipe.localised_name = GPrefix.DeepCopy( Item.localised_name )
    GPrefix.CreateIcons( Item )

    -- Agregar el referencia
    local List = { }

    List = { icon = "" }
    List.icon = data.raw.resource[ "uranium-ore" ].icon

    List.scale = 0.3
    List.icon_size = 64
    List.icon_mipmaps = 4
    List.shift = { -8, -8 }

    table.insert( Item.icons, List )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Habilitar la receta desde el inicia de la partida
    Recipes[ "" ] = Recipes[ Base ]
    Recipes[ Base ] = nil
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadMachine( )
    ThisMOD.CreateMineralRecipe( )
    GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------