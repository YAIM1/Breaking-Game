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

-- Cargar las infomación
function ThisMOD.LoadInformation( )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Equipaments = Info.Equipaments or { }
    Info.Equipaments = Equipaments

    local Items = Info.Items or { }
    Info.Items = Items

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Redimencionar el tamñao del equipamento
    for _, Equipament in pairs( GPrefix.Equipaments ) do
        if Equipament.shape.width > 1 then
            Equipaments[ Equipament.name ] = Equipament
        elseif Equipament.shape.height > 1 then
            Equipaments[ Equipament.name ] = Equipament
        end
    end

    -- Hacer una copia de los equipos
    for Name, Equipament in pairs( Equipaments ) do
        Equipaments[ Name ] = GPrefix.DeepCopy( Equipament )
        Items[ Name ] = GPrefix.DeepCopy( GPrefix.Items[ Name ] )
        Recipes[ Name ] = GPrefix.DeepCopy( GPrefix.Recipes[ Name ] )
    end

    -- Hacer el cambio
    for _, Equipament in pairs( Equipaments ) do
        Equipament.shape.width = 1
        Equipament.shape.height = 1
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    -- Cargar las infomación
    ThisMOD.LoadInformation( )

    -- Crear los prototipos
    GPrefix.createItem( ThisMOD )
    GPrefix.createRecipe( ThisMOD )
    GPrefix.createEquipament( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------