---------------------------------------------------------------------------------------------------

--> armor-with-immunity.lua <--

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

-- Cargar la información para crear las armaduras
function ThisMOD.LoadInformation(  )

    -- Información base
    ThisMOD.Base = { }
    ThisMOD.Base.Name = "light-armor"
    ThisMOD.Base.Ingredients = {
        { "wood"      , 500 },
        { "coal"      , 500 },
        { "stone"     , 500 },
        { "raw-fish"  ,  50 },
        { "iron-ore"  , 500 },
        { "copper-ore", 500 }
    }

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Establecer es el order
    local Order = string.char( 64 + GPrefix.getLength( data.raw[ "damage-type" ] ) + 1 )

    -- Crear la mejor armadura 
    local UltimateArmor = ThisMOD.CreateArmor( Items, "ultimate" )
    UltimateArmor.order = Order

    -- Crear la receta de la mejor armadura
    local UltimateRecipe = ThisMOD.CreateRecipe( Recipes, "ultimate" )
    UltimateRecipe.order = Order

    -- Crear las demás armaduras
    for Damage, _ in pairs( data.raw[ "damage-type" ] ) do

        -- Orden de la receta y el objeto
        Order = string.char( 64 + GPrefix.getLength( Items ) )

        -- Crear la armadura imune a un daño
        local DamageArmor = ThisMOD.CreateArmor( Items, Damage )
        DamageArmor.order = Order

        -- Agregar la inmunidad a las armaduras
        table.insert( DamageArmor.resistances, { type = Damage, decrease = 0, percent = 100 } )
        table.insert( UltimateArmor.resistances, { type = Damage, decrease = 0, percent = 100 } )

        -- Crear la receta para la armadura con inmunidad
        local DamageRecipe = ThisMOD.CreateRecipe( Recipes, Damage )
        DamageRecipe.order = Order

        -- Agregar los ingredientes a la receta
        DamageRecipe.ingredients = GPrefix.DeepCopy( ThisMOD.Base.Ingredients )
        table.insert( UltimateRecipe.ingredients, { ThisMOD.Prefix_MOD_ .. DamageArmor.name, 1 } )
    end
end

-- Crear una armadura sin resistencia
function ThisMOD.CreateArmor( Items, Name )

    -- Inicializar la nueva armadura
    local Item = GPrefix.Items[ ThisMOD.Base.Name ]
    Item = GPrefix.DeepCopy( Item )
    Items[ Name ] = Item

    -- Cambiar las propiedades
    Item.name = Name
    Item.resistances = { }
    Item.localised_name = { ThisMOD.Local .. "item-name", { ThisMOD.Local .. Name } }
    Item.localised_description = { ThisMOD.Local .. "item-description", { ThisMOD.Local .. Name } }

    -- Devolver los datos
    return Item
end

-- Crear una receta para la armadura
function ThisMOD.CreateRecipe( Recipes, Name )

    -- Inicializar la receta para la armadura
    local Recipe = GPrefix.Recipes[ ThisMOD.Base.Name ]
    Recipe = GPrefix.DeepCopy( Recipe[ 1 ] )
    Recipes[ "" ] = Recipes[ "" ] or { }
    table.insert( Recipes[ "" ], Recipe )

    -- Eliminar las propiedades inecesarios
    Recipe.normal = nil
    Recipe.results = nil
    Recipe.expensive = nil
    Recipe.ingredient = nil
    Recipe.Localised_description = nil

    -- Establece las propiedades basicas
    Recipe.name = Name
    Recipe.result = Name
    Recipe.ingredients = { }
    Recipe.localised_name = { ThisMOD.Local .. "item-name", { ThisMOD.Local .. Name } }

    -- Devolver los datos
    return Recipe
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------