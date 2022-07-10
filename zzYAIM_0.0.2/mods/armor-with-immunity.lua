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

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Damages = Info.Damages or { }
    Info.Damages = Damages

    local SubGroup = Info.SubGroup or { }
    Info.SubGroup = SubGroup

    -- Ingrediente opcional
    local Fish = GPrefix.Items[ "raw-fish" ].name

    -- Armadura modelo
    Info.Base = "light-armor"

    -- Ingredientes por defecto
    Info.Ingredients = {
        { "wood"      , 500 },
        { "coal"      , 500 },
        { "stone"     , 500 },
        { "iron-ore"  , 500 },
        { "copper-ore", 500 }
    }

    -- Cargar todos los tipos de daños
    for Damage, _ in pairs( data.raw[ "damage-type" ] ) do
        table.insert( Damages, Damage )
    end

    -- Crear el espacio para las armaduras
    Info.Armors = { }

    -- Inicializar la infaormación de la mejor armadura
    local Ultimate = { }
    Ultimate.Name = "ultimate"
    Ultimate.Ingredients = { }
    Ultimate.Immunities = GPrefix.DeepCopy( Damages )
    Ultimate.Order = string.char( 64 + 1 + #Damages )
    Ultimate.Localised_name = { ThisMOD.Local .. "item-name", { ThisMOD.Local .. "ultimate" } }
    Ultimate.Localised_description = { ThisMOD.Local .. "item-description", { ThisMOD.Local .. "ultimate" } }

    -- Cargar los ingredientes de cada armadura
    for Index, Damage in pairs( Damages ) do
        local Armor = { }   table.insert( Info.Armors, Armor )
        Armor.Order = string.char( 64 + Index )
        Armor.Name = Damage   Armor.Immunities = { Damage }
        Armor.Ingredients = GPrefix.DeepCopy( Info.Ingredients )
        table.insert( Armor.Ingredients, { Fish, 50 } )
        Armor.Localised_name = { ThisMOD.Local .. "item-name", { ThisMOD.Local .. Damage } }
        Armor.Localised_description = { ThisMOD.Local .. "item-description", { ThisMOD.Local .. Damage } }
    end

    -- Agregar la armadura
    table.insert( Info.Armors, Ultimate )
end

-- Crear las armaduras
function ThisMOD.CreateArmors( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    -- Recorrer la información
    for _, Armor in pairs( Info.Armors ) do

        -- Copiar la armadura de muestra
        local OldItem = GPrefix.Items[ Info.Base ]
        local NewItem = GPrefix.DeepCopy( OldItem )
        NewItem.order = Armor.Order
        NewItem.name = Armor.Name
        NewItem.localised_name = Armor.Localised_name
        NewItem.localised_description = Armor.Localised_description
        NewItem.resistances = { }

        -- Establecer la resistencia de la armadura
        for _, Damage in pairs( Armor.Immunities ) do
            table.insert( NewItem.resistances,
                { type = Damage, decrease = 0, percent = 100 }
            )
        end

        -- Cargar los datos al juego
        GPrefix.addItem( NewItem, ThisMOD )

        -- Agregar la armadura a los ingredientes de la ultima armadura
        local Ultimate = Info.Armors[ #Info.Armors ]
        if Ultimate ~= Armor then
            table.insert( Ultimate.Ingredients, { NewItem.name, 1 } )
        end
    end
end

-- Crear las recetas de las armaduras
function ThisMOD.CreateRecipe( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    -- Recorrer la información
    for _, Armor in pairs( Info.Armors ) do

        -- Copiar la receta de la armadura de muestra
        local OldRecipe = GPrefix.Recipes[ Info.Base ][ 1 ]
        local NewRecipe = GPrefix.DeepCopy( OldRecipe )
        NewRecipe.localised_name = Armor.Localised_name
        NewRecipe.enabled = true
        NewRecipe.order = Armor.Order
        NewRecipe.name = Armor.Name

        -- Asignar los ingredientes a la receta
        NewRecipe.ingredients = { }
        local ingredients = NewRecipe.ingredients
        for _, Ingredient in pairs( Armor.Ingredients ) do
            local ingredient  = { }
            ingredient.type   = "item"
            ingredient.name   = Ingredient[ 1 ]
            ingredient.amount = Ingredient[ 2 ]
            table.insert( ingredients, ingredient )
        end

        -- Cargar los datos al juego
        GPrefix.addRecipe( NewRecipe, ThisMOD )
        GPrefix.addTechnology( Info.Base, NewRecipe.name )
    end
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