--------------------------------------

-- inventory-sort.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está llamando
local modName = getFile( debug.getinfo( 1 ).short_src )

--------------------------------------
--------------------------------------

local Files = { "settings" }
if table.getKey( Files, __FILE__ ) then

    -- Preparar la configuración de este mod
    local _Setting =  {
        type           = "bool-setting",
        setting_type   = "startup",
        allowed_values = {"true", "false"},
        default_value  = true
    }

    -- Construir valores
    _Setting.name  = Prefix .. modName
    _Setting.order = SettingOrder[ _Setting.type ]

    -- Cargar configuración del mod al juego
    data:extend( { _Setting } )
end

--------------------------------------
--------------------------------------

Files = { "control" }

-- Es necesario ejecutar este codigo??
if not table.getKey( Files, __FILE__ ) then
    return false
end

-- MOD Activado
if not Active then
    local MOD = Setting[ modName ]
    if not MOD then return false end
    if not MOD.value then return false end
end

--------------------------------------
--------------------------------------

-- Renombrar la variable
local Event = defines.events.on_gui_opened

-- Inventarios a ordenar
local EntitysToSort = {
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

local function InventorySort( event )

    -- Renombrar la variable
    local Entity = event.entity

    -- Valinación básica
    if not Entity then return end

    -- Identificar el inventario
    local Inventory = EntitysToSort[ Entity.type ]

    -- Inventario no encontrado
    if not Inventory then return end

    -- Validación de los datos
    local Inventorys = isTable( Inventory ) and Inventory or { Inventory }

    -- Ordenar inventario
    for _, inventory in ipairs( Inventorys ) do
        Entity.get_inventory( inventory ).sort_and_merge( )
    end

end

-- Aplicar el efecto en el evento
script.on_event( Event, InventorySort )

--------------------------------------