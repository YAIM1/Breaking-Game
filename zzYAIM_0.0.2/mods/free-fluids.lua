---------------------------------------------------------------------------------------------------

--> free-fluids.lua <--

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

-- Cargar los fuidos de las recetas
function ThisMOD.FluidWithRecibe( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local Fluids = Info.Fluids or { }
    Info.Fluids = Fluids

    local Ranges = Info.Ranges or { }
    Info.Ranges = Ranges

    -- Cargar los fluidos de los ingredientes y resultados
    for _, recipes in pairs( GPrefix.Recipes ) do
        for _, recipe in pairs( recipes ) do

            -- Variable contenedora
            local _recipes = { recipe, recipe.expensive, recipe.normal }

            -- Resultados de la recera
            local Results = { }
            for _, _recipe in pairs( _recipes ) do
                if _recipe.result then
                    local result = { }
                    table.insert( Results, result )
                    table.insert( result, _recipe.result )
                    table.insert( result, _recipe.result_count or 1 )
                end

                if _recipe.results then
                    for _, result in pairs( _recipe.results ) do
                        table.insert( Results, result )
                    end
                end
            end

            for _, Result in pairs( Results ) do

                -- { name = Nombre, amount = Contidad }
                -- { name = Nombre, amount = Contidad, type = "item" }
                -- { name = Nombre, amount = Contidad, type ="fluid", temperature = Temperatura }
                -- { name = Nombre, amount_min = Min, amount_max = Max, probability = [ Min: 0.01 - Max: 1 ] }
                if Result.type == "fluid" then

                    -- Preparar el espacio
                    Fluids[ Result.name ] = Fluids[ Result.name ] or { }
                    local newFluids = Fluids[ Result.name ]

                    -- Guardar la temperatura
                    if not GPrefix.getKey( newFluids, Result.temperature ) then
                        table.insert( newFluids, Result.temperature )
                    end
                end
            end

            -- Ingredientes de la recera
            local Ingredients = { }
            for _, _recipe in pairs( _recipes ) do
                if _recipe.ingredients then
                    for _, ingredient in pairs( _recipe.ingredients ) do
                        table.insert( Ingredients, ingredient )
                    end
                end
            end

            for _, Ingredient in pairs( Ingredients ) do

                -- { name = Nombre, amount = Contidad }
                -- { name = Nombre, amount = Contidad, type = "item" }
                -- { name = Nombre, amount = Contidad, type ="fluid", temperature = Temperatura }
                if Ingredient.maximum_temperature then

                    -- Preparar el espacio
                    Ranges[ Ingredient.name ] = Ranges[ Ingredient.name ] or { }
                    local newFluids = Ranges[ Ingredient.name ]

                    -- Establecer la temperaturas limites
                    local Max = Ingredient.maximum_temperature
                    local Min = Ingredient.minimum_temperature

                    -- Temperatura minima no definida
                    if not Min then
                        local default = GPrefix.Fluids[ Ingredient.name ].default_temperature
                        local minimum = GPrefix.Fluids[ Ingredient.name ].min_temperature
                        local gas     = GPrefix.Fluids[ Ingredient.name ].gas_temperature

                        if not minimum and not gas then Min = default end
                        if not minimum and     gas then Min = math.min( default, gas ) end
                        if     minimum and not gas then Min = math.min( default, minimum ) end
                    end

                    -- Guardar el rango
                    table.insert( newFluids, { Min, Max } )
                end
            end

        end
    end
end

-- Cargar los fuidos sin recetas
function ThisMOD.FluidWithoutRecibe( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local Fluids = Info.Fluids or { }
    Info.Fluids = Fluids

    -- Fluidos que se crean sin recetas
    for _, Entity in pairs( GPrefix.Entities ) do
        repeat

            -- Validación
            if not Entity.output_fluid_box then break end
            if #Entity.output_fluid_box.pipe_connections < 1 then break end
            if not Entity.output_fluid_box.filter then break end
            if not Entity.target_temperature then break end

            -- Renombrar variable
            local Name = Entity.output_fluid_box.filter

            -- Preparar el espacio
            Fluids[ Name ] = Fluids[ Name ] or { }
            local newFluids = Fluids[ Name ]

            -- Guardar la temperatura
            if not GPrefix.getKey( newFluids, Entity.target_temperature ) then
                table.insert( newFluids, Entity.target_temperature )
            end

        until true
    end
end

-- Verificar los rangos de temperaturas
function ThisMOD.TemperatureRange( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local Fluids = Info.Fluids or { }
    Info.Fluids = Fluids

    local Ranges = Info.Ranges or { }
    Info.Ranges = Ranges

    -- Verificar los rangos
    for Name, Temperatures in pairs( Ranges ) do

        -- Preparar el espacio
        Fluids[ Name ] = Fluids[ Name ] or { }
        local NewFluids = Fluids[ Name ]

        -- Verificar cada rango
        for _, Range in pairs( Temperatures ) do

            -- Bandera
            local Add = true

            -- Renombrar la variable
            local Min = Range[ 1 ]
            local Max = Range[ 2 ]

            -- Verificar cada temperatura
            for _, Temperature in pairs( Fluids[ Name ] ) do
                if Temperature >= Min and Temperature <= Max then
                    Add = false break
                end
            end

            -- Añadir si no existe
            if Add then

                -- Añadir el valor por defecto
                local Default = GPrefix.Fluids[ Name ].default_temperature
                if Add and Default >= Min and Default <= Max then
                    table.insert( NewFluids, false )
                    Add = false
                end

                -- Añadir el valor medio
                local Middle = math.ceil( ( Min + Max ) / 2 )
                if Add and Default >= Min and Default <= Max then
                    table.insert( NewFluids, Middle )
                    Add = false
                end
            end
        end
    end
end

-- Cargar las temperaturas por defecto
function ThisMOD.TemperatureDefault( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local Fluids = Info.Fluids or { }
    Info.Fluids = Fluids

    -- Cargar las temperaturas por defecto
    for Name, Temperatures in pairs( Fluids ) do
        Fluids[ Name ] = #Temperatures > 0 and Temperatures or { true }
    end
end

-- Crear los subgrupos y las recetas de los fluidos
function ThisMOD.CreateFluidRecipe( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local Fluids = Info.Fluids or { }
    Info.Fluids = Fluids

    local Actions =  { "Create", "Delete" }

    -- Crear el SubGrupo para los fluidos
    -- con temperaturas unica
    for _, Action in pairs( Actions ) do
        local subGroup = { }
        subGroup.group = "fluids"
        subGroup.type  = "item-subgroup"
        subGroup.name  = ThisMOD.Prefix_MOD_
        subGroup.name  = subGroup.name .. Action .. "-"
        subGroup.name  = subGroup.name .. "0"
        subGroup.order = subGroup.name
        data:extend( { subGroup } )
    end

    -- Crar cada uno de los fluidos
    for Name, Temperatures in pairs( Fluids ) do

        -- Crear los SubGrupos para los fuidos
        -- con varias temperaturas
        if #Temperatures > 0 then
            for _, Action in pairs( Actions ) do
                local subGroup = { }
                subGroup.group = "fluids"
                subGroup.type  = "item-subgroup"
                subGroup.name  = ThisMOD.Prefix_MOD_
                subGroup.name  = subGroup.name .. Action .. "-"
                subGroup.name  = subGroup.name .. Name
                subGroup.order = subGroup.name
                data:extend( { subGroup } )
            end
        end

        for Number, temperature in pairs( Temperatures ) do
            for _, Action in pairs( Actions ) do

                -- Renombrar la variable
                local Fluid = GPrefix.Fluids[ Name ]

                -- Fluido correspondiente
                local fluid =  { }
                fluid.type = "fluid"
                fluid.name = Name
                fluid.amount = 10^6

                -- Establecer la temperatura
                if GPrefix.isNumber( temperature ) then
                    fluid.temperature = temperature
                end

                -- Receta del fluido
                local Recipe = { }
                Recipe.type = "recipe"
                Recipe.icon = Fluid.icon
                Recipe.icons = GPrefix.DeepCopy( Fluid.icons )
                Recipe.icon_size = Fluid.icon_size
                Recipe.icon_mipmaps = Fluid.icon_mipmaps
                Recipe.hide_from_player_crafting = true

                Recipe.enabled = true
                Recipe.category = ThisMOD.Prefix_MOD
                Recipe.energy_required = 10^-2

                Recipe.results     = { Action == "Create" and fluid or nil }
                Recipe.ingredients = { Action == "Delete" and fluid or nil }

                if Fluid.localised_name then
                    Recipe.localised_name = Fluid.localised_name
                else
                    Recipe.localised_name = { "fluid-name." .. Name }
                end

                -- Establecer el nombre de la receta
                Recipe.name = Action .. "-"

                -- Fluido con varias temperaturas
                if GPrefix.isNumber( temperature ) then
                    Recipe.name = Recipe.name .. Name
                    local Subgroup = ThisMOD.Prefix_MOD_
                    Recipe.subgroup = Subgroup .. Recipe.name
                    Recipe.name = Recipe.name .. "-" .. Number
                end

                -- Fluido con temperatura unica
                if not GPrefix.isNumber( temperature ) then
                    local Subgroup = ThisMOD.Prefix_MOD_
                    Recipe.subgroup = Subgroup .. Recipe.name .. "0"
                    Recipe.name = Recipe.name .. Name
                end

                -- Establecer el orden
                Recipe.order = Recipe.name

                -- Agregar la equis
                if Action == "Delete" then
                    GPrefix.CreateIcons( Recipe )

                    local List = { }
                    List.icon = "__core__/graphics/cancel.png"
                    List.icon_size = 64
                    List.icon_mipmaps = 1

                    List.scale = 0.3

                    table.insert( Recipe.icons, List )
                end

                -- Guardar el fluido
                GPrefix.addRecipe( Recipe, ThisMOD )
            end
        end
    end
end

-- Cargar la información de la maquina
function ThisMOD.LoadMachine( )

    -- Inicializar las variables
    local Base = "assembling-machine-2"
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
    Entity.energy_usage = "1W"
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
    List.icon = data.raw.fluid[ "crude-oil" ].icon

    List.scale = 0.3
    List.icon_size = 64
    List.icon_mipmaps = 4
    List.shift = { -10, -8 }

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

    ThisMOD.FluidWithRecibe( )   ThisMOD.FluidWithoutRecibe( )
    ThisMOD.TemperatureRange( )   ThisMOD.TemperatureDefault( )
    ThisMOD.CreateFluidRecipe( )

    ThisMOD.LoadMachine( )   GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------