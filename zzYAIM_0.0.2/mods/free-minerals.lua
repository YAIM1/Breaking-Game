---------------------------------------------------------------------------------------------------

---> free-minerals.lua <---

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
Private.Base = "assembling-machine-1"
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

    Private.LoadResorce( Data )

    Private.CreateSubGroup( )
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
    List.icon = data.raw.resource[ "uranium-ore" ].icon

    List.scale = 0.3
    List.icon_size = 64
    List.icon_mipmaps = 4
    List.shift = { -8, -8 }

    table.insert( Item.icons, List )
end

--- Cargar la información de la maquina
function Private.CreateCategory( )
    local Category = { }
    Category.name = ThisMOD.Prefix_MOD
    Category.type = "recipe-category"
    data:extend( { Category } )
end

--- Crear el espacio para las recetas
function Private.CreateSubGroup( )
    local subGroup = { }
    subGroup.group = "intermediate-products"
    subGroup.type  = "item-subgroup"
    subGroup.name  = ThisMOD.Prefix_MOD_
    subGroup.name  = subGroup.name .. Private.subGroup
    subGroup.order = subGroup.name
    data:extend( { subGroup } )
end

--- Buscar y cargar los recursos solidos
--- @param Data table
function Private.LoadResorce( Data )

    --- Inicializar la variable
    Data.Resources = { }

    --- Crar cada uno de los recursos
    for _, Resource in pairs( data.raw.resource ) do

        --- Validar los resutados
        local Results = { }
        Resource = Resource.minable
        if Resource.result then
            Results = { { name = Resource.result } }
        elseif Resource.results then
            Results = Resource.results
        end

        --- Crear una receta por cada recurso
        for _, Result in pairs( Results ) do

            --- El resultado es un fluido
            if Result.type and Result.type == "fluid" then break end

            --- Cargar el objeto
            local Item = GPrefix.Items[ Result.name ]
            if not Item then break end

            --- Guardar el recurso
            local Info = { }
            Info.item = Item
            Info.name = Result.name
            table.insert( Data.Resources, Info )
        end
    end
end

--- Crear una receta para cada recurso
--- @param Data table
function Private.CreateRecipes( Data )

    --- Validar que existan recursos
    if not Data.Resources then return end

    --- Inicializar la variable
    local Recipes = ThisMOD.NewRecipes[ "" ] or { }
    ThisMOD.NewRecipes[ "" ] = Recipes

    --- Recorrer los recursos enlistados
    for _, Resorce in pairs( Data.Resources ) do

        --- Recurso correspondiente
        local Result =  { }
        Result.type = "item"
        Result.name = Resorce.name
        Result.amount = ThisMOD.Value

        --- Receta del recurso
        local Recipe = { }
        Recipe.type = "recipe"
        Recipe.name = Resorce.item.name
        Recipe.icon = Resorce.item.icon
        Recipe.icons = GPrefix.DeepCopy( Resorce.item.icons )
        Recipe.order = ThisMOD.Prefix_MOD_ .. Resorce.item.name
        Recipe.icon_size = Resorce.item.icon_size
        Recipe.icon_mipmaps = Resorce.item.icon_mipmaps

        Recipe.enabled = true
        Recipe.category = ThisMOD.Prefix_MOD
        Recipe.energy_required = 10^-2

        Recipe.results     = { Result }
        Recipe.ingredients = { }

        if Resorce.item.localised_name then
            Recipe.localised_name = GPrefix.DeepCopy( Resorce.item.localised_name )
        else
            Recipe.localised_name = { "item-name." .. Resorce.item.name }
        end

        --- Guardar la nueva receta
        table.insert( Recipes, Recipe )
    end
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------