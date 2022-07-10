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

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

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
        if GPrefix.getKey( AvoidTypes, Item.type ) then goto JumpItem end

        -- Evitar este patron
        for _, Pattern in pairs( AvoidPatterns ) do
            if string.find( Item.name, Pattern ) then goto JumpItem end
        end

        -- El cambio no le favorece el cambio
        if Item.stack_size >= ThisMOD.Value then goto JumpItem end

        -- No es apilable
        if GPrefix.getKey( Item.flags, "not-stackable" ) then goto JumpItem end

        -- No se puede crear
        if GPrefix.getKey( Item.flags, "spawnable" ) then goto JumpItem end

        -- Hacer el cambio
        Item.stack_size = ThisMOD.Value
        GPrefix.addLetter( Item, ThisMOD.Char )

        for _, Recipe in pairs( GPrefix.Recipes[ Item.name ] or { } ) do
            GPrefix.addLetter( Recipe, ThisMOD.Char )
        end

        -- Recepción del salto
        :: JumpItem ::
    end
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------