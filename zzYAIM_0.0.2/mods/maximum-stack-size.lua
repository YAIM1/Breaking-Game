---------------------------------------------------------------------------------------------------

--> maximum-stack-size.lua <--

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

-- Cargar los objetos a modificar
function ThisMOD.LoadItems(  )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Tipos a evitar
    local AvoidTypes = { }
    table.insert( AvoidTypes, "armor" )
    table.insert( AvoidTypes, "selection-tool" )
    table.insert( AvoidTypes, "belt-immunity-equipment" )

    -- Patrones a evitar
    local AvoidPatterns = { }
    table.insert( AvoidPatterns, "%-remote" )

    -- Hacer el camnbio en los items del juego, si le favorece
    for _, Item in pairs( GPrefix.Items ) do

        -- Evitar este tipo
        local Valid = not GPrefix.getKey( AvoidTypes, Item.type )

        -- Evitar este patron
        for _, Pattern in pairs( AvoidPatterns ) do
            Valid = Valid and not string.find( Item.name, Pattern )
        end

        -- El cambio le favorece el cambio
        Valid = Valid and Item.stack_size < ThisMOD.Value

        -- No es apilable
        Valid = Valid and not GPrefix.getKey( Item.flags, "not-stackable" )

        -- No se puede crear
        Valid = Valid and not GPrefix.getKey( Item.flags, "spawnable" )

        -- Hacer el cambio
        if Valid then table.insert( Items, Item ) end
    end
end

-- Crear las recetas de las armaduras
function ThisMOD.doChanger( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Recorrer la información
    for _, Item in pairs( Items ) do
        GPrefix.addLetter( Item, ThisMOD.Char )
        Item.stack_size = ThisMOD.Value
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadItems( )   ThisMOD.doChanger( )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------




































-- --------------------------------------

-- -- maximum-stack-size.lua

-- --------------------------------------
-- --------------------------------------

-- -- Identifica el mod que se está usando
-- local MOD = GPrefix.getFile( debug.getinfo( 1 ).short_src )

-- -- Crear la vareble si no existe
-- GPrefix.MODs[ MOD ] = GPrefix.MODs[ MOD ] or { }

-- -- Guardar en el acceso rapido
-- GPrefix.MOD = GPrefix.MODs[ MOD ]

-- --------------------------------------
-- --------------------------------------

-- local Files = { }
-- table.insert( Files, "settings" )

-- -- Cargar la configuración
-- if GPrefix.getKey( Files, GPrefix.File ) then

-- 	-- Preparar la configuración de este mod
--     local SettingOption =  {
--         type          = "int-setting",
--         setting_type  = "startup",
--         default_value = 1000,
--         minimum_value = 1,
--         maximum_value = 65000
--     }

--     -- Construir valores
--     SettingOption.name  = GPrefix.MOD.Prefix_MOD
--     SettingOption.order = GPrefix.SettingOrder[ SettingOption.type ]
-- 	SettingOption.order = SettingOption.order .. "-" .. SettingOption.name
--     SettingOption.localised_name  = { GPrefix.MOD.Local .. "setting-name"}
--     SettingOption.localised_description  = { GPrefix.MOD.Local .. "setting-description"}

--     -- Cargar configuración del mod al juego
--     data:extend( { SettingOption } )
--     return
-- end

-- --------------------------------------
-- --------------------------------------

-- Files = { }
-- table.insert( Files, "data-final-fixes" )

-- -- Es necesario ejecutar este codigo??
-- if not GPrefix.getKey( Files, GPrefix.File ) then return end

-- -- MOD Inactivo
-- if not GPrefix.MOD.Active then return end

-- --------------------------------------
-- --------------------------------------

-- -- Tipos a evitar
-- local AvoidTypes = { }
-- table.insert( AvoidTypes, "armor" )
-- table.insert( AvoidTypes, "selection-tool" )
-- table.insert( AvoidTypes, "belt-immunity-equipment" )

-- -- Patrones a evitar
-- local AvoidPatterns = { }
-- table.insert( AvoidPatterns, "%-remote" )

-- -- Hacer el camnbio en los items del juego, si le favorece
-- for _, item in pairs( GPrefix.Items ) do

--     -- Evitar este tipo
--     local Valid = not GPrefix.getKey( AvoidTypes, item.type )

--     -- Evitar este patron
--     for _, Pattern in pairs( AvoidPatterns ) do
--         Valid = Valid and not string.find( item.name, Pattern )
--     end

--     -- El cambio le favorece el cambio
--     Valid = Valid and item.stack_size < GPrefix.MOD.Value

--     -- No es apilable
--     Valid = Valid and not GPrefix.getKey( item.flags, "not-stackable" )

--     -- No se puede crear
--     Valid = Valid and not GPrefix.getKey( item.flags, "spawnable" )

--     -- Hacer el cambio
--     if Valid then item.stack_size = GPrefix.MOD.Value end
-- end

-- --------------------------------------