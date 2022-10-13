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
        ThisMOD.duplicateItem( Item )
    end

    -- Variable contenedora
    local limitation = { }

    -- Guardar el nombre de las recetas que afectará
    for _, Recipe in pairs( data.raw.recipe ) do
        if not GPrefix.getKey( limitation, Recipe.name ) then
            table.insert( limitation, Recipe.name )
        end
    end

    -- Duplicar las recestas de los modulos
    for _, Item in pairs( Items ) do

        -- Duplicar las recetas
        Recipes[ Item.name ] = GPrefix.Recipes[ Item.name ]
        Recipes[ Item.name ] = GPrefix.DeepCopy( Recipes[ Item.name ] )

        -- Hacer el cambio
        GPrefix.AddIcon( Item, ThisMOD )
        Item.limitation = limitation

        -- Eliminar las demas recetas
        while #Recipes[ Item.name ] > 1 do
            table.remove( Recipes[ Item.name ], 2 )
        end
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Actualizar el resultado de las recetas
    GPrefix.updateResults( ThisMOD )
end

-- Duplicar el objeto si es un modulo
function ThisMOD.duplicateItem( Item )

    -- Es un modulo??
    if not Item.limitation then return end

    -- Validar elemento
    local Alias = nil
    if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
    if Alias and Alias( Item.name ) then return end

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Duplicar el objeto
    Items[ Item.name ] = GPrefix.DeepCopy( Item )
end

-- Agregar una receta a los modulos
function ThisMOD.addRecipe( RecipeName )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Agregar la receta a cada modulo
    for _, Item in pairs( Items ) do
        table.insert( Item.limitation, RecipeName )
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.createInformation( ThisMOD )
    GPrefix.ForceProduction = ThisMOD
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------