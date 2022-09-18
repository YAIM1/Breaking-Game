--------------------------------------

-- free-fluids.lua

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

-- Renombrar la variable
local _Prefix = Prefix .. modName .. "-"

-- Agregar el subgrupo en los objetos
local subGroup = { }
subGroup.group = "fluids"
subGroup.type  = "item-subgroup"
subGroup.order = _Prefix .. "a0"
subGroup.name  = _Prefix .. "fluid"
data:extend( { subGroup } )

-- Crar cada uno de los fluidos
for _, Fluid in pairs( Fluids ) do

    -- Fluido resultante
    local Result =  { }
    Result.type = "fluid"
    Result.name = Fluid.name
    Result.amount = 10^5

    -- Temperatura
    if Fluid.name == "steam" then
        Result.temperature = Fluid.max_temperature
    end

    -- Receta del fluido
    local Recipe = { }
    Recipe.type = "recipe"
    Recipe.name = "free-" .. Fluid.name
    Recipe.icons = Fluid.icons
    Recipe.order = Fluid.order
    Recipe.subgroup = _Prefix .. "fluid"
    Recipe.icon_size = Fluid.icon_size
    Recipe.icon_mipmaps = Fluid.icon_mipmaps

    Recipe.enabled = true
    Recipe.results = { Result }
    Recipe.category = "crafting-with-fluid"
    Recipe.ingredients = { }
    Recipe.energy_required = 0.01

    -- Sobre escribir los nombres
    if not Fluid.localised_name then
        Recipe.localised_name = { "fluid-name." .. Fluid.name }
    end Recipe.localised_name = { "", Recipe.localised_name }

    -- Agregar el Pez
    addIcon( Fluid, Recipe )

    -- Guardar el fluido
    data:extend( { Recipe } )
end

--------------------------------------