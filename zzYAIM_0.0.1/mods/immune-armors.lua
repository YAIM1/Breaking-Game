--------------------------------------

-- armors.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está llamando
local modName = getFile( debug.getinfo( 1 ).short_src )

--------------------------------------
--------------------------------------

local Files = { "settings" }
if table.getKey( Files, __FILE__ ) then

    -- Preparar la configuración de este mod
    local _Setting =  {
        type           = "bool-setting",
        setting_type   = "startup",
        allowed_values = {"true", "false"},
        default_value  = true
    }

    -- Construir valores
    _Setting.name  = Prefix .. modName
    _Setting.order = SettingOrder[ _Setting.type ]

    -- Cargar configuración del mod al juego
    data:extend( { _Setting } )
end

--------------------------------------
--------------------------------------

Files = { "data-final-fixes" }

-- Es necesario ejecutar este codigo??
if not table.getKey( Files, __FILE__ ) then
    return false
end

-- MOD Activado
if not Active then
    local MOD = Setting[ modName ]
    if not MOD then return false end
    if not MOD.value then return false end
end

--------------------------------------
--------------------------------------

-- Crea la variable
Setting[ modName ] = { }

-- Variable contenedora
local _Prefix = Prefix .. modName .. "-"

-- Renombrar la variable
local _Setting = Setting[ modName ]
local Damage = data.raw[ "damage-type" ]

-- Armadura modelo
_Setting.base = "light-armor"

-- Ingredientes por defecto
_Setting.ingredients = {
    { "wood"      , 500 },
    { "coal"      , 500 },
    { "stone"     , 500 },
    { "iron-ore"  , 500 },
    { "copper-ore", 500 }
}

-- Tipos de daños
_Setting.damage = { }
_Setting.damage.ultimate = { }
for damage, _ in pairs( Damage ) do
    _Setting.damage[ damage ] = false
    table.insert( _Setting.damage.ultimate,
        { _Prefix .. damage .. "-armor", 1 }
    )
end

--------------------------------------
--------------------------------------

-- No hay receta para la armadura
if not Recipes[ _Setting.base ] then return false end

-- La armadura no existe
if not Items[ _Setting.base ] then return false end

-- Agregar los subgroups
addSubGroup( modName, { armor = "" } )

-- Agregar las armaduras y su recetas
for name, armors in pairs( _Setting.damage ) do

    -- Establecer el nombre de la armadura
    local Name = _Prefix .. name .. "-armor"

    ---> <---     ---> <---     ---> <---

    -- Copiar la armadura de muestra
    local ItemOld       = Items[ _Setting.base ]
    local ItemNew       = table.deepcopy( ItemOld )
    ItemNew.subgroup    = _Prefix .. ItemOld.subgroup
    ItemNew.name        = Name
    ItemNew.resistances = { }

    -- Establecer la resistencia de la armadura
    local damages = Damage[ name ] and { [ name ] = "" } or Damage
    for damage, _ in pairs( damages ) do
        table.insert( ItemNew.resistances,
            { type = damage, decrease = 0, percent = 100 }
        )
    end

    -- Establecer el pez en la imagen
    addIcon( ItemOld, ItemNew )

    ---> <---     ---> <---     ---> <---

    -- Copiar la receta de la armadura de muestra
    local RecipeOld = Recipes[ _Setting.base ][ 1 ]
    local RecipeNew = table.deepcopy( RecipeOld )
    RecipeNew.enabled = true
    RecipeNew.result  = Name
    RecipeNew.name    = Name

    -- Establecer el pez en la imagen
    addIcon( ItemOld, RecipeNew )

    -- Establce los ingredientes a usar
    local Ingredients = armors or _Setting.ingredients

    -- Asignar los ingredientes a la receta
    RecipeNew.ingredients = { }
    local ingredients = RecipeNew.ingredients
    for _, Ingredient in pairs( Ingredients ) do
        local ingredient  = { }
        ingredient.type   = "item"
        ingredient.name   = Ingredient[ 1 ]
        ingredient.amount = Ingredient[ 2 ]
        table.insert( ingredients, ingredient )
    end

    ---> <---     ---> <---     ---> <---

    -- Cargar los datos al juego
    Recipes[ RecipeNew.name ] = Recipes[ RecipeNew.name ] or { }
    table.insert( Recipes[ RecipeNew.name ], RecipeNew )
    data:extend( { ItemNew, RecipeNew } )
    Items[ ItemNew.name ] = ItemNew
end

--------------------------------------