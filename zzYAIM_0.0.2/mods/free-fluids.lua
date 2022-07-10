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
    SettingOption.localised_description = { ThisMOD.Local .. "setting-description" }

    local List = { }
    table.insert( List, "" )
    table.insert( List, "[font=default-bold][ " .. ThisMOD.Char .. " ][/font] " )
    table.insert( List, { ThisMOD.Local .. "setting-name" } )
    SettingOption.localised_name = List

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
                Recipe.icons = Fluid.icons
                Recipe.icon_size = Fluid.icon_size
                Recipe.icon_mipmaps = Fluid.icon_mipmaps
                Recipe.hide_from_player_crafting = true

                Recipe.enabled = true
                Recipe.category = ThisMOD.Prefix_MOD
                Recipe.energy_required = 10^-2

                Recipe.results     = { Action == "Create" and fluid or nil }
                Recipe.ingredients = { Action == "Delete" and fluid or nil }

                Recipe.localised_name = { "fluid-name." .. Name }

                -- Establecer el nombre de la receta
                Recipe.name = ThisMOD.Prefix_MOD_
                Recipe.name = Recipe.name .. Action .. "-"

                -- Fluido con varias temperaturas
                if GPrefix.isNumber( temperature ) then
                    Recipe.name = Recipe.name .. Name
                    Recipe.subgroup = Recipe.name
                    Recipe.name = Recipe.name .. "-" .. Number
                end

                -- Fluido con temperatura unica
                if not GPrefix.isNumber( temperature ) then
                    Recipe.subgroup = Recipe.name .. "0"
                    Recipe.name = Recipe.name .. Name
                end

                -- Establecer el orden
                Recipe.order = Recipe.name

                -- Agregar la equis
                if Action == "Delete" then
                    local List = { }

                    List.icon = "__core__/graphics/cancel.png"
                    List.icon_size = 64
                    List.icon_mipmaps = 1

                    List.scale = 0.3

                    GPrefix.addIcon( Fluid, Recipe, List )
                end

                -- Guardar el fluido
                GPrefix.addRecipe( Recipe, ThisMOD )
            end
        end
    end
end

-- Cargar la información de la maquina
function ThisMOD.LoadMachine( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationMachine or { }
    ThisMOD.InformationMachine = Info

    local Machine = Info.Machine or { }
    Info.Machine = Machine

    -- Inicializar las variables
    local Base = "assembling-machine-2"
    Machine.Item = GPrefix.DeepCopy( GPrefix.Items[ Base ] )
    Machine.Entity = GPrefix.DeepCopy( GPrefix.Entities[ Base ] )
    Machine.Recipe = GPrefix.DeepCopy( GPrefix.Recipes[ Base ][ 1 ] )
    Machine.Category = { type = "recipe-category", name = ThisMOD.Prefix_MOD }
    Machine.Recipes = { Machine.Recipe, Machine.Recipe.normal, Machine.Recipe.expensive }

    -- Modificar la entidad
    Machine.Entity.energy_usage = "1W"
    Machine.Entity.next_upgrade = nil
    Machine.Entity.energy_source = { type = "void" }
    Machine.Entity.crafting_categories = { ThisMOD.Prefix_MOD }
    Machine.Entity.resource_categories = nil
    Machine.Entity.fast_replaceable_group = nil

    -- Establecer el apodo
    local Localised = "machine"
    Machine.Item.localised_name = { ThisMOD.Local .. Localised }
    Machine.Entity.localised_name = { ThisMOD.Local .. Localised }
    Machine.Recipe.localised_name = { ThisMOD.Local .. Localised }
end

-- Crear el objeto, la receta y la entidad
function ThisMOD.CreateMachine( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationMachine or { }
    ThisMOD.InformationMachine = Info

    local Machine = Info.Machine or { }
    Info.Machine = Machine

    -- Crear la nueva categoria
    data:extend( { Machine.Category } )

    -- Eliminar los ingredientes
    for _, Recipe in pairs( Machine.Recipes ) do
        if Recipe.ingredient or Recipe.ingredients then
            Recipe.ingredient = nil   Recipe.ingredients = { }
        end
    end

    -- Preparar los datos
    GPrefix.addItem( Machine.Item, ThisMOD )
    GPrefix.addEntity( Machine.Entity, ThisMOD )
    GPrefix.addRecipe( Machine.Recipe, ThisMOD )
    GPrefix.addTechnology( nil, Machine.Recipe.name )
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.FluidWithRecibe( )   ThisMOD.FluidWithoutRecibe( )
    ThisMOD.TemperatureRange( )   ThisMOD.TemperatureDefault( )
    ThisMOD.CreateFluidRecipe( )

    ThisMOD.LoadMachine( )   ThisMOD.CreateMachine( )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------