---------------------------------------------------------------------------------------------------

--> sort-item.lua <--

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

-- Inventarios a ordenar
ThisMOD.EntitysToSort = {
    [ "car" ] = defines.inventory.car_trunk,
    [ "container" ] = defines.inventory.chest,
    [ "cargo-wagon" ] = defines.inventory.cargo_wagon,
    [ "spider-vehicle" ] = defines.inventory.spider_trunk,
    [ "logistic-container" ] = defines.inventory.chest,
    [ "roboport" ] = {
        defines.inventory.roboport_robot,
        defines.inventory.roboport_material
    }
}

-- Cargar las infomación
function ThisMOD.LoadInformation( )

    -- Contenedor
    local Table = { }

    -- Recorrer las entidades
    for _, Entity in pairs( GPrefix.Entities ) do

        -- Validación básica
        Table.flag = ThisMOD.EntitysToSort[ Entity.type ]
        if not Table.flag then goto JumpEntity end
        if not Entity.minable then goto JumpEntity end
        if not Entity.minable.result then goto JumpEntity end

        -- Cargar el objeto a modificar
        Table.ItemName = Entity.minable.result
        Table.Recipes = GPrefix.Recipes[ Table.ItemName ]
        Table.Item = GPrefix.Items[ Table.ItemName ]

        -- Agregar la letra
        GPrefix.addLetter( Entity, ThisMOD.Char )
        GPrefix.addLetter( Table.Item, ThisMOD.Char )
        for _, Recipe in pairs( Table.Recipes or { } ) do
            GPrefix.addLetter( Recipe, ThisMOD.Char )
        end

        if GPrefix.Compact then
            GPrefix.Compact.UpdateDescription( Table.Item, ThisMOD )
        end

        -- Recepción del salto
        :: JumpEntity ::
    end
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
---------------------------------------------------------------------------------------------------

function ThisMOD.InventorySort( Event )

    -- Renombrar la variable
    local Entity = Event.entity

    -- Valinación básica
    if not Entity then return end

    -- Identificar el inventario
    local Inventory = ThisMOD.EntitysToSort[ Entity.type ]

    -- Inventario no encontrado
    if not Inventory then return end

    -- Validación de los datos
    local Inventorys = GPrefix.isTable( Inventory ) and Inventory or { Inventory }

    -- Ordenar inventario
    for _, inventory in ipairs( Inventorys ) do
        Entity.get_inventory( inventory ).sort_and_merge( )
    end
end

function ThisMOD.Control( )
    if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    GPrefix.addEvent( {
        [ { "on_event", defines.events.on_gui_opened } ] = ThisMOD.InventorySort,
    } )
end

-- Cargar los eventos
ThisMOD.Control( )

---------------------------------------------------------------------------------------------------