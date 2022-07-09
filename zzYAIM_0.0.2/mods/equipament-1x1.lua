---------------------------------------------------------------------------------------------------

--> equipament-1x1.lua <--

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

-- Seleccionar el equipamento a duplicar
function ThisMOD.LoadInformation( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local NewEquipaments = Info.Equipaments or { }
    Info.Equipaments = NewEquipaments

    local NewItems = Info.Items or { }
    Info.Items = NewItems

    local NewRecipes = Info.Recipes or { }
    Info.Recipes = NewRecipes

    -- Redimencionar el tamñao del equipamento
    for _, Equipament in pairs( GPrefix.Equipments ) do
        if Equipament.shape.width > 1 then
            NewEquipaments[ Equipament.name ] = Equipament
        elseif Equipament.shape.height > 1 then
            NewEquipaments[ Equipament.name ] = Equipament
        end
    end

    -- Hacer una copia de los equipos
    for Name, Equipament in pairs( NewEquipaments ) do
        NewEquipaments[ Name ] = GPrefix.DeepCopy( Equipament )
        NewItems[ Name ] = GPrefix.DeepCopy( GPrefix.Items[ Name ] )
        NewRecipes[ Name ] = GPrefix.DeepCopy( GPrefix.Recipes[ Name ] )
    end
end

-- Hacer en los objetos del equipamento
function ThisMOD.CreateItem( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local NewItems = Info.Items or { }
    Info.Items = NewItems

    -- Hacer el cambio en los objetos y crearlos
    for _, Item in pairs( NewItems ) do
        GPrefix.addItem( Item, ThisMOD )
    end
end

-- Hacer el cambio en el equipamento
function ThisMOD.CreateRecipe( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local NewRecipes = Info.Recipes or { }
    Info.Recipes = NewRecipes

    -- Hacer una copia de los equipos
    for OldItemName, Recipes in pairs( NewRecipes ) do
        for _, Recipe in ipairs( Recipes ) do
            GPrefix.addRecipe( Recipe, ThisMOD )
            GPrefix.addTechnology( OldItemName, Recipe.name )
        end
    end
end

-- Hacer el cambio en el equipamento
function ThisMOD.CreateEquipament( )

    -- Renombrar la variable
    local Info = ThisMOD.InformationFluid or { }
    ThisMOD.InformationFluid = Info

    local NewEquipaments = Info.Equipaments or { }
    Info.Equipaments = NewEquipaments

    -- Hacer una copia de los equipos
    for Name, Equipament in pairs( NewEquipaments ) do
        Equipament.shape.width = 1
        Equipament.shape.height = 1
        GPrefix.addEquipament( Equipament, ThisMOD )
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )
    ThisMOD.CreateItem( )   ThisMOD.CreateEquipament( )   ThisMOD.CreateRecipe( )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------















-- --------------------------------------

-- -- equipament-1x1.lua

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

-- -- Redimencionar el tamñao del equipamento
-- for _, Equipment in pairs( GPrefix.Equipments ) do
--     Equipment.shape.width = 1
--     Equipment.shape.height = 1
-- end

-- --------------------------------------