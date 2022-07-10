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

    local Array = { }

    -- Buscar las entidades a afectar
    for _, Entity in pairs( GPrefix.Entities ) do

        -- Identificar a los robots
        if not Entity.energy_per_move then goto JumpEntity end

        -- Posible afectados
        Entity = GPrefix.DeepCopy( Entity )
        Entities[ Entity.name ] = Entity

        -- Cambiar el objeto al minar
        Array.Minable = true
        Array.Minable = Array.Minable and Entity.minable
        Array.Minable = Array.Minable and Entity.minable.result
        if Array.Minable then
            Array.Name = Entity.minable.result

            Array.Item = GPrefix.Items[ Array.Name ]
            Array.Item = GPrefix.DeepCopy( Array.Item )
            Items[ Array.Name ] = Array.Item

            Array.Recipe = GPrefix.Recipes[ Array.Name ]
            Array.Recipe = GPrefix.DeepCopy( Array.Recipe )
            Recipes[ Array.Name ] = Array.Recipe
        end

        -- Recepción del salto
        :: JumpEntity ::
    end

    -- Hacer los cambios
    for _, Entity in pairs( Entities ) do
        Entity.energy_per_tick = "0J"
        Entity.energy_per_move = "0J"
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
    GPrefix.createEntity( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------