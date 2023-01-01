---------------------------------------------------------------------------------------------------

---> armor-with-immunity.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "bool" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Valores de referencia
Private.Base = "light-armor"
Private.Ingredients = {
    { "wood"      , 500 },
    { "coal"      , 500 },
    { "stone"     , 500 },
    { "raw-fish"  ,  50 },
    { "iron-ore"  , 500 },
    { "copper-ore", 500 },
}

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

    --- Validación básica
    if not GPrefix.Items[ Private.Base ] then return end
    if not GPrefix.Recipes[ Private.Base ] then return end

    --- Inicializar las variables
    local Items = ThisMOD.NewItems
    local Recipes = ThisMOD.NewRecipes

    --- Establecer es el order
    local Count = GPrefix.getLength( data.raw[ "damage-type" ] )
    local Order = string.char( 64 + Count + 1 )

    --- Crear la mejor armadura 
    local UltimateArmor = Private.CreateArmor( Items, "ultimate" )
    GPrefix.AddIcon( UltimateArmor, ThisMOD )
    UltimateArmor.order = Order

    --- Crear la receta de la mejor armadura
    local UltimateRecipe = Private.CreateRecipe( Recipes, "ultimate" )
    UltimateRecipe.order = Order

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Crear las demás armaduras
    for Damage, _ in pairs( data.raw[ "damage-type" ] ) do

        --- Orden de la receta y el objeto
        Order = string.char( 64 + GPrefix.getLength( Items ) )

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

        --- Crear la armadura imune a un daño
        local DamageArmor = Private.CreateArmor( Items, Damage )
        GPrefix.AddIcon( DamageArmor, ThisMOD )
        DamageArmor.order = Order

        --- Agregar la inmunidad a las armaduras
        table.insert( DamageArmor.resistances, { type = Damage, decrease = 0, percent = 100 } )
        table.insert( UltimateArmor.resistances, { type = Damage, decrease = 0, percent = 100 } )

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

        --- Crear la receta para la armadura con inmunidad
        local DamageRecipe = Private.CreateRecipe( Recipes, Damage )
        DamageRecipe.order = Order

        --- Agregar los ingredientes a la receta
        DamageRecipe.ingredients = GPrefix.DeepCopy( Private.Ingredients )
        table.insert( UltimateRecipe.ingredients, { ThisMOD.Prefix_MOD_ .. DamageArmor.name, 1 } )
    end
end

--- Crear una armadura sin resistencia
--- @param Items table
--- @param Name string
function Private.CreateArmor( Items, Name )

    --- Inicializar la nueva armadura
    local Item = GPrefix.Items[ Private.Base ]
    Item = GPrefix.DeepCopy( Item )
    Items[ Name ] = Item

    --- Cambiar las propiedades
    Item.name = Name
    Item.resistances = { }
    Item.localised_name = { ThisMOD.Local .. "item-name", { ThisMOD.Local .. Name } }
    Item.localised_description = { ThisMOD.Local .. "item-description", { ThisMOD.Local .. Name } }

    --- Devolver los datos
    return Item
end

--- Crear una receta para la armadura
--- @param Recipes table
--- @param Name string
function Private.CreateRecipe( Recipes, Name )

    --- Inicializar la receta para la armadura
    local Recipe = GPrefix.Recipes[ Private.Base ]
    Recipe = GPrefix.DeepCopy( Recipe[ 1 ] )
    Recipes[ "" ] = Recipes[ "" ] or { }
    table.insert( Recipes[ "" ], Recipe )

    --- Eliminar las propiedades inecesarios
    Recipe.normal = nil
    Recipe.results = nil
    Recipe.expensive = nil

    --- Establece las propiedades basicas
    Recipe.name = Name
    Recipe.result = ThisMOD.Prefix_MOD_ .. Name
    Recipe.ingredients = { }
    Recipe.localised_name = { ThisMOD.Local .. "item-name", { ThisMOD.Local .. Name } }

    --- Devolver los datos
    return Recipe
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------