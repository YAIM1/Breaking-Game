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
    SettingOption.order = ThisMOD.Char
    SettingOption.setting_type  = "startup"
    SettingOption.default_value = 1000
    SettingOption.minimum_value = 1
    SettingOption.maximum_value = 65000

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

-- Objectos a evitar
ThisMOD.AvoidItems = { }
if mods and mods[ "space-exploration" ] then
    table.insert( ThisMOD.AvoidItems, "rocket-fuel" )
end

-- Tipos a evitar
ThisMOD.AvoidTypes = { }
table.insert( ThisMOD.AvoidTypes, "armor" )
table.insert( ThisMOD.AvoidTypes, "selection-tool" )
table.insert( ThisMOD.AvoidTypes, "belt-immunity-equipment" )

-- Patrones a evitar
ThisMOD.AvoidPatterns = { }
table.insert( ThisMOD.AvoidPatterns, "%-remote" )

-- Cargar las infomación
function ThisMOD.ModifyItem( Item )

    -- Validación básica
    if not Item.stack_size then return end

    -- Evitar este tipo
    if GPrefix.getKey( ThisMOD.AvoidItems, Item.name ) then return end

    -- Evitar este tipo
    if GPrefix.getKey( ThisMOD.AvoidTypes, Item.type ) then return end

    -- Evitar este patron
    for _, Pattern in pairs( ThisMOD.AvoidPatterns ) do
        if string.find( Item.name, Pattern ) then return end
    end

    -- El cambio no le favorece el cambio
    if Item.stack_size >= ThisMOD.Value then return end

    -- No es apilable
    if GPrefix.getKey( Item.flags, "not-stackable" ) then return end

    -- No se puede crear
    if GPrefix.getKey( Item.flags, "spawnable" ) then return end

    -- Hacer el cambio
    Item.stack_size = ThisMOD.Value
    GPrefix.addLetter( Item, ThisMOD.Char )

    -- Actualizar la descripción de los compactados
    if GPrefix.Compact then
        GPrefix.Compact.UpdateDescription( Item, ThisMOD )
    end

    -- Actualizar la entidad
    if Item.place_result then
        local Entity = GPrefix.Entities[ Item.place_result ]
        if Entity then GPrefix.addLetter( Entity, ThisMOD.Char ) end
    end

    -- Actualizar el equipamento
    if Item.placed_as_equipment_result then
        local Equipment = GPrefix.Equipaments[ Item.placed_as_equipment_result ]
        if Equipment then GPrefix.addLetter( Equipment, ThisMOD.Char ) end
    end

    -- Actualizar sus recestas
    for _, Recipe in pairs( GPrefix.Recipes[ Item.name ] or { } ) do
        GPrefix.addLetter( Recipe, ThisMOD.Char )
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    --Recorrer los objetos
    for _, Item in pairs( GPrefix.Items ) do
        ThisMOD.ModifyItem( Item )
    end GPrefix.StackSize = ThisMOD
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------