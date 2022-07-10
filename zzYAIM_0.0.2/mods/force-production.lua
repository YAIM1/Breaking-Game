---------------------------------------------------------------------------------------------------

--> force-production.lua <--

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

    local Items = Info.Items or { }
    Info.Items = Items

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Duplicar los modulos de producción
    for _, Item in pairs( GPrefix.Items ) do
        if Item.limitation then
            Items[ Item.name ] = GPrefix.DeepCopy( Item )
        end
    end

    -- Variable contenedora
    local limitation = { }

    -- Guardar el nombre de las recetas que afecta
    for _, Recipe in pairs( GPrefix.Recipes ) do
        for _, recipe in pairs( Recipe ) do
            if not GPrefix.getKey( limitation, recipe.name ) then
                table.insert( limitation, recipe.name )
            end
        end
    end

    -- Duplicar las recestas de los modulos
    for _, Module in pairs( Items ) do
        Recipes[ Module.name ] = GPrefix.Recipes[ Module.name ]
        Recipes[ Module.name ] = GPrefix.DeepCopy( Recipes[ Module.name ] )
        Module.limitation = limitation
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
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------