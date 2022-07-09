---------------------------------------------------------------------------------------------------

--> force-a-slot-module.lua <--

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
    SettingOption.order = ThisMOD.Index
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

-- Cargar las entidades
function ThisMOD.LoadInformation( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Types = Info.Types or { }
    Info.Types = Types

    local Entities = Info.Entities or { }
    Info.Entities = Entities

    local Items = Info.Items or { }
    Info.Items = Items

    -- Tipos a afectar
    table.insert( Types, "lab" )
    table.insert( Types, "furnace" )
    table.insert( Types, "mining-drill" )
    table.insert( Types, "assembling-machine" )

    -- Buscar las entidades a afectar
    for _, Entity in pairs( GPrefix.Entities ) do
        repeat

            -- Renombrar la variable
            local Module = Entity.module_specification

            -- Validación básica
            if not GPrefix.getKey( Types, Entity.type ) then break end
            if Module and Module.module_slots > 0 then break end

            -- Posible afectados
            Entity = GPrefix.DeepCopy( Entity )
            Entities[ Entity.name ] = Entity

            -- Cambiar el objeto al minar
            local Flag = Entity
            Flag = Flag and Entity.minable
            Flag = Flag and Entity.minable.result
            if Flag then
                Flag = Entity.minable.result
                Flag = GPrefix.Items[ Flag ]
                Flag = GPrefix.DeepCopy( Flag )
                Items[ Flag.name ] = Flag
            end

        until true
    end
end

-- Create los objetos
function ThisMOD.CreateItems( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Cambiar los objetos
    for _, Item in pairs( Items ) do
        GPrefix.addItem( Item, ThisMOD )
    end
end

-- Create las entidades
function ThisMOD.CreateEntities( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Entities = Info.Entities or { }
    Info.Entities = Entities

    -- Cambiar las entidades
    for _, Entity in pairs( Entities ) do

        -- Crear el slot
        local Module = { }
        Module.module_slots = 1
        Entity.module_specification = Module

        -- Hacer la entidad predispuesta
        -- a los efectos de los modulos
        Entity.allowed_effects = { }
        table.insert( Entity.allowed_effects, "speed" )
        table.insert( Entity.allowed_effects, "pollution" )
        table.insert( Entity.allowed_effects, "consumption" )
        table.insert( Entity.allowed_effects, "productivity" )

        -- Cargar los datos al juego
        GPrefix.addEntity( Entity, ThisMOD )
    end
end

-- Create las recetas de las entidades
function ThisMOD.CreateRecipe( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Cambiar los objetos
    for ItemName, _ in pairs( Items ) do

        -- Identificar y duplicar las recetas
        local Recipes = GPrefix.Recipes
        Recipes = Recipes[ ItemName ]
        Recipes = GPrefix.DeepCopy( Recipes )

        -- Remplazar el objeto
        for _, Recipe in pairs( Recipes ) do
            GPrefix.addRecipe( Recipe, ThisMOD )
            GPrefix.addTechnology( nil, Recipe.name )
        end
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )
    ThisMOD.CreateItems( )   ThisMOD.CreateEntities( )    ThisMOD.CreateRecipe( )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------