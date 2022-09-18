--------------------------------------

-- force-production.lua

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

-- Variable contenedora
local recipes = { }

-- Guardar en nombre de las recetas
for _, Recipe in pairs( Recipes ) do
    for _, recipe in pairs( Recipe ) do
        table.insert( recipes, recipe.name )
    end
end

-- Variable contenedore
local Mod = { }
local Vanilla = { }

local Modules = { }
table.insert( Modules, "productivity-module" )
table.insert( Modules, "productivity-module-2" )
table.insert( Modules, "productivity-module-3" )
local prefix = string.gsub( Prefix, "-", "%%-" )

-- Buscar los modulos de producción
for _, Item in pairs( Items ) do

    -- Identificar los modulos
    if Item.limitation then

        -- Modulos de este mod
        if string.find( Item.name, prefix ) then
            table.insert( Mod, Item )
        end

        -- Modulos de vanilla
        if table.getKey( Modules, Item.name ) then
            table.insert( Vanilla, Item )
        end
    end
end

-- Realizar el cambio
for _, Item in pairs( #Mod > 0 and Mod or Vanilla ) do
    Item.limitation = recipes
end

--------------------------------------