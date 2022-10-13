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
    SettingOption.order = ThisMOD.Char
    SettingOption.setting_type   = "startup"
    SettingOption.default_value  = true
    SettingOption.allowed_values = { "true", "false" }

    local Name = { }
    table.insert( Name, "" )
    table.insert( Name, { GPrefix.Local .. "setting-char", ThisMOD.Char } )
    table.insert( Name, { ThisMOD.Local .. "setting-name" } )
    if ThisMOD.Requires then
        Name = { GPrefix.Local .. "setting-require-name", Name, ThisMOD.Requires.Char }
    end SettingOption.localised_name = Name

    local Description = { ThisMOD.Local .. "setting-description" }
    if ThisMOD.Requires then
        Description = { GPrefix.Local .. "setting-require-description", { ThisMOD.Requires.Local .. "setting-name" }, Description }
    end SettingOption.localised_description = Description

    data:extend( { SettingOption } )
end

-- Cargar la configuración
ThisMOD.Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Cargar las entidades
function ThisMOD.LoadInformation( )

    -- Tipos a afectar
    local Types = { }
    table.insert( Types, "lab" )
    table.insert( Types, "furnace" )
    table.insert( Types, "mining-drill" )
    table.insert( Types, "assembling-machine" )

    -- Buscar las entidades a afectar
    for _, Entity in pairs( GPrefix.Entities ) do

        -- Renombrar la variable
        local Module = Entity.module_specification

        -- Validación básica
        if not GPrefix.getKey( Types, Entity.type ) then goto JumpEntity end
        if Module and Module.module_slots > 0 then goto JumpEntity end

        -- Validar elemento
        local Alias = nil
        if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
        if Alias and Alias( Entity.name ) then goto JumpEntity end

        -- Duplicar la información relacionada
        GPrefix.duplicateEntity( Entity, ThisMOD )

        -- Recepción del salto
        :: JumpEntity ::
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Entities = Info.Entities or { }
    Info.Entities = Entities

    -- Crear los efectos
    local Effects = { }
    table.insert( Effects, "speed" )
    table.insert( Effects, "pollution" )
    table.insert( Effects, "consumption" )
    table.insert( Effects, "productivity" )

    -- Hacer los cambios
    for _, Entity in pairs( Entities ) do

        -- Crear el slot
        local Module = { module_slots = 1 }
        Entity.module_specification = Module

        -- Hacer la entidad predispuesta a los efectos de los modulos
        Entity.allowed_effects = GPrefix.DeepCopy( Effects )
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Eliminar las demas recetas
    for _, Recipes in pairs( Info.Recipes ) do
        for i = 2, #Recipes, 1 do
            Recipes[ i ] = nil
        end
    end

    -- Actualizar el resultado de las recetas
    GPrefix.updateResults( ThisMOD )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Items = Info.Items or { }
    Info.Items = Items

    -- Asignar la marca del MOD
    for _, Item in pairs( Items ) do
        GPrefix.AddIcon( Item, ThisMOD )
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Item = Info.Item or { }
    Info.Item = Item
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------