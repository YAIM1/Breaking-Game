---------------------------------------------------------------------------------------------------

---> sort-item.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "bool" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Inventarios a ordenar
Private.EntitysToSort = {
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

--- Sección para los prototipos
function Private.DataFinalFixes( )
    local FileValid = { "data-final-fixes" }
    local Active = GPrefix.isActive( ThisMOD, FileValid )
    if not Active then return end

    --- Aplicar el efecto del MOD por fuera del mismo
    --- @param TheMOD ThisMOD
    function ThisMOD.DoEffect( TheMOD )
        Private.DoEffect( TheMOD )
    end

    --- Procesar los prototipos del MOD
    Private.LoadPropotypes( )
    GPrefix.CreateNewElements( ThisMOD )

    --- Crear acceso directo al MOD
    GPrefix[ ThisMOD.MOD ] = ThisMOD
end

--- Procesar los prototipos cargados en el juego y
--- cargar los prototipos del MOD
function Private.LoadPropotypes( )
    ThisMOD.DoEffect( {
        NewEntities = GPrefix.Entities,
        NewRecipes = GPrefix.Recipes,
        NewItems = GPrefix.Items,
    } )
end

--- Aplicar el efecto del MOD por fuera del mismo
--- @param TheMOD ThisMOD
function Private.DoEffect( TheMOD )
    for _, Entity in pairs( TheMOD.NewEntities ) do
        Private.doChange( Entity, TheMOD )
    end
end

--- Aplicar el efecto del MOD
--- @param Entity table
--- @param TheMOD ThisMOD
function Private.doChange( Entity, TheMOD )

    --- Validación básica
    if not Entity then return end
    if not Entity.type then return end
    if not Entity.minable then return end
    if not Entity.minable.result then return end
    if not Private.EntitysToSort[ Entity.type ] then return end

    --- Cargar el objeto a modificar
    local ItemName = Entity.minable.result
    local Item = TheMOD.NewItems[ ItemName ]

    --- Agregar la letra
    GPrefix.addLetter( Entity, ThisMOD.Char )
    GPrefix.addLetter( Item, ThisMOD.Char )
    for _, Recipes in pairs( TheMOD.NewRecipes ) do
        for _, Recipe in pairs( Recipes ) do
            local Results = GPrefix.getResults( Recipe ) or { }
            if GPrefix.inTable( Results, Item ) then
                GPrefix.addLetter( Recipe, ThisMOD.Char )
            end
        end
    end

    --- Modificar las descripción del objeto
    if GPrefix.CI then GPrefix.CI.UpdateDescription( Item, ThisMOD ) end
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Sección para los eventos
function Private.Control( )
    local FileValid = { "control" }
    local Active = GPrefix.isActive( ThisMOD, FileValid )
    if not Active then return end

    Private.LoadEvents( )
end

--- Cargar los eventos del MOD
function Private.LoadEvents( )
    GPrefix.addEventOnControl( {
        ID = defines.events.on_gui_opened,
        Function = Private.InventorySort,
    } )
end

--- Aplicar el efecto del MOD
--- @param Event table
function Private.InventorySort( Event )

    -- Renombrar la variable
    local Entity = Event.entity

    -- Valinación básica
    if not Entity then return end

    -- Identificar el inventario
    local Inventory = Private.EntitysToSort[ Entity.type ]

    -- Inventario no encontrado
    if not Inventory then return end

    -- Validación de los datos
    local Inventorys = GPrefix.isTable( Inventory ) and Inventory or { Inventory }

    -- Ordenar inventario
    for _, inventory in ipairs( Inventorys ) do
        Entity.get_inventory( inventory ).sort_and_merge( )
    end
end

--- Sección para los eventos
Private.Control( )

---------------------------------------------------------------------------------------------------