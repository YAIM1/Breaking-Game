---------------------------------------------------------------------------------------------------

---> free-fluids.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "int" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Valores de referencia
Private.Base = "assembling-machine-2"
Private.Localised = "machine"
Private.subGroup = "create"

--- Sección para los prototipos
function Private.DataFinalFixes( )
    local FileValid = { "data-final-fixes" }
    local Active = GPrefix.isActive( ThisMOD, FileValid )
    if not Active then return end

    --- Procesar los prototipos del MOD
    Private.LoadPropotypes( )
    GPrefix.CreateNewElements( ThisMOD )

    --- Crear acceso directo al MOD
    GPrefix[ ThisMOD.MOD ] = ThisMOD
end

--- Procesar los prototipos cargados en el juego y
--- cargar los prototipos del MOD
function Private.LoadPropotypes( )
    local Data = { }
    Private.CreateMachine( Data )
    if not Data.New then return end
    Private.CreateCategory( )

    --- Cargar los fluidos
    Private.LoadFluidFromRecipeResults( Data )
    Private.LoadFluidFromRecipeIngredients( Data )
    Private.LoadFluidFromEntites( Data )

    --- Cargar los volres
    Private.ConvertRange( Data )
    Private.LoadDefaultTemperature( Data )

    Private.CreateRecipes( Data )
end

--- Cargar la información de la maquina
--- @param Data table
function Private.CreateMachine( Data )

    --- Duplicar la entidad base
    local New = GPrefix.DuplicateItem( Private.Base, ThisMOD )
    if not New then return end
    Data.New = New

    --- Inicializar y renombrar la variable
    local Entity = New.Entity

    --- Modificar la entidad
    Entity.energy_usage = "10W"
    Entity.next_upgrade = nil
    Entity.collision_mask = nil
    Entity.energy_source = { type = "void" }
    Entity.crafting_categories = { ThisMOD.Prefix_MOD }
    Entity.resource_categories = nil

    --- Eliminar los ingredientes
    local Recipe = New.Recipes[ 1 ]
    local Array = { Recipe, Recipe.normal, Recipe.expensive }
    for _, Table in ipairs( Array ) do
        if Table.ingredients then
            Table.ingredients = { }
        end
    end

    --- Establecer el resultado
    local Results = { ThisMOD.Prefix_MOD_ .. Private.Base, 1 }
    GPrefix.setResults( Recipe, { Results } )

    --- Establecer el apodo
    --- @type table
    local Item = New.Item
    Item.localised_description = nil
    Item.localised_name[ 2 ] = { ThisMOD.Local .. Private.Localised }
    Entity.localised_name = GPrefix.DeepCopy( Item.localised_name )
    Recipe.localised_name = GPrefix.DeepCopy( Item.localised_name )

    --- Eliminar la investigación
    ThisMOD.NewRecipes[ Private.Base ] = nil
    local Recipes = ThisMOD.NewRecipes[ "" ] or { }
    ThisMOD.NewRecipes[ "" ] = Recipes
    table.insert( Recipes, Recipe )

    --- Agregar el referencia
    local List = { }

    List = { icon = "" }
    List.icon = data.raw.fluid[ "crude-oil" ].icons[ 1 ].icon

    List.scale = 0.3
    List.icon_size = 64
    List.icon_mipmaps = 4
    List.shift = { -10, -8 }

    table.insert( Item.icons, List )
end

--- Cargar la información de la maquina
function Private.CreateCategory( )
    local Category = { }
    Category.name = ThisMOD.Prefix_MOD
    Category.type = "recipe-category"
    data:extend( { Category } )
end

--- Cargar los fluidos desde los resultados de las recestas
--- @param Data table
function Private.LoadFluidFromRecipeResults( Data )

    --- Inicializar la variable
    local Fluids = Data.Fluids or { }
    Data.Fluids = Fluids

    --- Recorrer las recetas
    for _, Recipes in pairs( GPrefix.Recipes ) do
        for _, Recipe in pairs( Recipes ) do

            --- Variable contenedora
            local recipes = { Recipe, Recipe.expensive, Recipe.normal }

            --- Concentrar los resultados en una variable
            local Results = { }
            for _, recipe in pairs( recipes ) do
                if recipe.results then
                    for _, result in pairs( recipe.results ) do
                        table.insert( Results, result )
                    end
                end
            end

            --- Buscar en los resultados encontrados
            for _, Result in pairs( Results ) do

                --- { name = Nombre, amount = Contidad }
                --- { name = Nombre, amount = Contidad, type = "item" }
                --- { name = Nombre, amount = Contidad, type ="fluid", temperature = Temperatura }
                --- { name = Nombre, amount_min = Min, amount_max = Max, probability = [ Min: 0.01 - Max: 1 ] }
                if Result.type == "fluid" then

                    --- Preparar el espacio
                    Fluids[ Result.name ] = Fluids[ Result.name ] or { }
                    local newFluids = Fluids[ Result.name ]

                    --- Guardar la temperatura
                    if not GPrefix.getKey( newFluids, Result.temperature ) then
                        table.insert( newFluids, Result.temperature )
                    end
                end
            end
        end
    end
end

--- Cargar los fluidos desde los ingredientes de las recestas
--- @param Data table
function Private.LoadFluidFromRecipeIngredients( Data )

    --- Inicializar la variable
    local Ranges = Data.Ranges or { }
    Data.Ranges = Ranges

    --- Recorrer las recetas
    for _, Recipes in pairs( GPrefix.Recipes ) do
        for _, Recipe in pairs( Recipes ) do

            --- Variable contenedora
            local recipes = { Recipe, Recipe.expensive, Recipe.normal }

            --- Ingredientes de la recera
            local Ingredients = { }
            for _, recipe in pairs( recipes ) do
                if recipe.ingredients then
                    for _, ingredient in pairs( recipe.ingredients ) do
                        table.insert( Ingredients, ingredient )
                    end
                end
            end

            for _, Ingredient in pairs( Ingredients ) do

                --- { name = Nombre, amount = Contidad }
                --- { name = Nombre, amount = Contidad, type = "item" }
                --- { name = Nombre, amount = Contidad, type ="fluid", temperature = Temperatura }
                if Ingredient.maximum_temperature then

                    --- Preparar el espacio
                    Ranges[ Ingredient.name ] = Ranges[ Ingredient.name ] or { }
                    local newFluids = Ranges[ Ingredient.name ]

                    --- Establecer la temperaturas limites
                    local Max = Ingredient.maximum_temperature
                    local Min = Ingredient.minimum_temperature

                    --- Temperatura minima no definida
                    if not Min then
                        local default = GPrefix.Fluids[ Ingredient.name ].default_temperature
                        local minimum = GPrefix.Fluids[ Ingredient.name ].min_temperature
                        local gas     = GPrefix.Fluids[ Ingredient.name ].gas_temperature

                        if not minimum and not gas then Min = default end
                        if not minimum and     gas then Min = math.min( default, gas ) end
                        if     minimum and not gas then Min = math.min( default, minimum ) end
                    end

                    --- Guardar el rango
                    table.insert( newFluids, { Min, Max } )
                end
            end
        end
    end
end

--- Cargar los fluidos desde las entidades
--- @param Data table
function Private.LoadFluidFromEntites( Data )

    --- Inicializar la variable
    local Fluids = Data.Fluids or { }
    Data.Fluids = Fluids

    --- Fluidos que se crean sin recetas
    for _, Entity in pairs( GPrefix.Entities ) do
        repeat

            --- Validación
            if not Entity.output_fluid_box then break end
            if #Entity.output_fluid_box.pipe_connections < 1 then break end
            if not Entity.output_fluid_box.filter then break end
            if not Entity.target_temperature then break end

            --- Renombrar variable
            local Name = Entity.output_fluid_box.filter

            --- Preparar el espacio
            Fluids[ Name ] = Fluids[ Name ] or { }
            local newFluids = Fluids[ Name ]

            --- Guardar la temperatura
            if not GPrefix.getKey( newFluids, Entity.target_temperature ) then
                table.insert( newFluids, Entity.target_temperature )
            end

        until true
    end
end

--- Convierte los rangos de las temperaturas una unica
--- @param Data table
function Private.ConvertRange( Data )

    --- Inicializar la variable
    local Fluids = Data.Fluids or { }
    Data.Fluids = Fluids

    --- Inicializar la variable
    local Ranges = Data.Ranges or { }
    Data.Ranges = Ranges

    --- Verificar los rangos
    for Name, Temperatures in pairs( Ranges ) do

        --- Preparar el espacio
        Fluids[ Name ] = Fluids[ Name ] or { }
        local NewFluids = Fluids[ Name ]

        --- Verificar cada rango
        for _, Range in pairs( Temperatures ) do

            --- Bandera
            local Add = true

            --- Renombrar la variable
            local Min = Range[ 1 ]
            local Max = Range[ 2 ]

            --- Verificar cada temperatura
            for _, Temperature in pairs( Fluids[ Name ] ) do
                if Temperature >= Min and Temperature <= Max then
                    Add = false break
                end
            end

            --- Añadir si no existe
            if Add then

                --- Añadir el valor por defecto
                local Default = GPrefix.Fluids[ Name ].default_temperature
                if Add and Default >= Min and Default <= Max then
                    table.insert( NewFluids, false )
                end

                --- Añadir el valor medio
                local Middle = math.ceil( ( Min + Max ) / 2 )
                if Add and Default >= Min and Default <= Max then
                    table.insert( NewFluids, Middle )
                end
            end
        end
    end
end

--- Cargar las temperaturas
--- @param Data table
function Private.LoadDefaultTemperature( Data )

    --- Inicializar la variable
    local Fluids = Data.Fluids or { }
    Data.Fluids = Fluids

    --- Cargar las temperaturas por defecto
    for Name, Temperatures in pairs( Fluids ) do
        Fluids[ Name ] = #Temperatures > 0 and Temperatures or { true }
    end
end

--- Crear una receta para cada fluido
--- @param Data table
function Private.CreateRecipes( Data )

    --- Inicializar la variable
    local Fluids = Data.Fluids or { }
    Data.Fluids = Fluids

    local Actions =  { "Create", "Delete" }

    --- Crear el SubGrupo para los fluidos
    --- con temperaturas unica
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

    --- Crar cada uno de los fluidos
    for Name, Temperatures in pairs( Fluids ) do

        --- Crear los SubGrupos para los fuidos
        --- con varias temperaturas
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

                --- Renombrar la variable
                local Fluid = GPrefix.Fluids[ Name ]

                --- Fluido correspondiente
                local fluid =  { }
                fluid.type = "fluid"
                fluid.name = Name
                fluid.amount = ThisMOD.Value

                --- Establecer la temperatura
                if GPrefix.isNumber( temperature ) then
                    fluid.temperature = temperature
                end

                --- Receta del fluido
                local Recipe = { }
                Recipe.type = "recipe"
                Recipe.icon = Fluid.icon
                Recipe.icons = GPrefix.DeepCopy( Fluid.icons )
                Recipe.icon_size = Fluid.icon_size
                Recipe.icon_mipmaps = Fluid.icon_mipmaps

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

                --- Establecer el nombre de la receta
                Recipe.name = Action .. "-"

                --- Fluido con varias temperaturas
                if GPrefix.isNumber( temperature ) then
                    Recipe.name = Recipe.name .. Name
                    local Subgroup = ThisMOD.Prefix_MOD_
                    Recipe.subgroup = Subgroup .. Recipe.name
                    Recipe.name = Recipe.name .. "-" .. Number
                end

                --- Fluido con temperatura unica
                if not GPrefix.isNumber( temperature ) then
                    local Subgroup = ThisMOD.Prefix_MOD_
                    Recipe.subgroup = Subgroup .. Recipe.name .. "0"
                    Recipe.name = Recipe.name .. Name
                end

                --- Establecer el orden
                Recipe.order = Recipe.name

                --- Agregar la equis
                if Action == "Delete" then
                    local List = { }
                    List.icon = "__core__/graphics/cancel.png"
                    List.icon_size = 64
                    List.icon_mipmaps = 1

                    List.scale = 0.3

                    table.insert( Recipe.icons, List )
                end

                --- Guardar el fluido
                GPrefix.addRecipe( Recipe, ThisMOD )
            end
        end
    end
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------