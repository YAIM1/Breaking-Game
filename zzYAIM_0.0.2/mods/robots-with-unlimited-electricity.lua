---------------------------------------------------------------------------------------------------

--> robots-with-unlimited-electricity.lua <--

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
    SettingOption.type  = "int-setting"
    SettingOption.order = ThisMOD.Index
    SettingOption.setting_type  = "startup"
    SettingOption.default_value = 1000
    SettingOption.minimum_value = 1
    SettingOption.maximum_value = 65000
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

-- Cargar las infomación de los robots de contrucción y
-- de los robots logisticos
function ThisMOD.LoadInformation( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Entities = Info.Entities or { }
    Info.Entities = Entities

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    local Items = Info.Items or { }
    Info.Items = Items

    -- Duplicar los robots
    for _, Entity in pairs( GPrefix.Entities ) do
        if Entity.energy_per_move then
            table.insert( Entities, Entity )
        end
    end

    -- Duplocar las recetas

end

-- Create los objetos
function ThisMOD.CreateItems( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Robot = Info.Entities or { }
    Info.Entities = Robot

    -- Crear los modulos
    for _, Module in pairs( Robot ) do
        GPrefix.addItem( Module, ThisMOD )
    end
end

-- Create los objetos
function ThisMOD.CreateRecipe( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Crear las recetas de los modulos
    for OldModuleName, Tables in pairs( Recipes ) do
        for _, Recipe in pairs( Tables ) do
            GPrefix.addRecipe( Recipe, ThisMOD )
            GPrefix.addTechnology( OldModuleName, Recipe.name )
        end
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )
    ThisMOD.CreateItems( )   ThisMOD.CreateRecipe( )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------




































--------------------------------------

-- robots-with-unlimited-electricity.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está usando
local MOD = GPrefix.getFile( debug.getinfo( 1 ).short_src )

-- Crear la vareble si no existe
GPrefix.MODs[ MOD ] = GPrefix.MODs[ MOD ] or { }

-- Guardar en el acceso rapido
GPrefix.MOD = GPrefix.MODs[ MOD ]

--------------------------------------
--------------------------------------

local Files = { }
table.insert( Files, "settings" )

-- Cargar la configuración

-- if GPrefix.getKey( Files, GPrefix.File ) then

--     -- Preparar la configuración de este mod
--     local SettingOption =  {
--         type           = "bool-setting",
--         setting_type   = "startup",
--         allowed_values = {"true", "false"},
--         default_value  = true
--     }

--     -- Construir valores
--     SettingOption.name  = GPrefix.MOD.Prefix_MOD
--     SettingOption.order = GPrefix.SettingOrder[ SettingOption.type ]
-- 	SettingOption.order = SettingOption.order .. "-" .. SettingOption.name

--     -- Cargar configuración del mod al juego
--     data:extend( { SettingOption } )
--     return
-- end

if GPrefix.getKey( Files, GPrefix.File ) then

    -- Preparar la configuración de este mod
    local SettingOption =  {
        type           = "bool-setting",
        setting_type   = "startup",
        allowed_values = { "true", "false" },
        default_value  = true
    }

    -- Construir valores
    local Local = GPrefix.MOD.Local
    SettingOption.name  = GPrefix.MOD.Prefix_MOD
    SettingOption.order = GPrefix.SettingOrder[ SettingOption.type ]
	SettingOption.order = SettingOption.order .. "-" .. SettingOption.name
    SettingOption.localised_name  = { GPrefix.MOD.Local .. "setting-name"}
    SettingOption.localised_description  = { GPrefix.MOD.Local .. "setting-description"}

    -- Cargar configuración del mod al juego
    data:extend( { SettingOption } )
    return
end

--------------------------------------
--------------------------------------

Files = { }
table.insert( Files, "data-final-fixes" )

-- Es necesario ejecutar este codigo??
if not GPrefix.getKey( Files, GPrefix.File ) then return end

-- MOD Inactivo
if not GPrefix.MOD.Active then return end

--------------------------------------
--------------------------------------

-- Parametro a buscar
local PrefixFind = string.gsub( GPrefix.Prefix, "-", "%%-" )

-- Buscar los robots
for _, Entity in pairs( GPrefix.Entities ) do
    repeat

        -- Identificar los robots
        if not Entity.energy_per_move then break end
        if not string.find( Entity.name, PrefixFind ) then break end

        -- Agregar el idicador de mejora
        GPrefix.addPlus( Entity )

        -- Realizar el cambio
        Entity.energy_per_tick = "0J"
        Entity.energy_per_move = "0J"
    until true
end

--------------------------------------