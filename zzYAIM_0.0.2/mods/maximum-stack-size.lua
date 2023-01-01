---------------------------------------------------------------------------------------------------

---> maximum-stack-size.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "int" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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
    Private.addItems( )
    ThisMOD.DoEffect( ThisMOD )
    Private.removeItems( )
end

--- Agregar los iniciales
function Private.addItems( )
    for _, Item in pairs( GPrefix.Items ) do
        ThisMOD.NewItems[ Item.name ] = Item
    end
end

--- Retirar los objetos iniciales
function Private.removeItems( )

    --- Contenedor de los objetos a afectar
    local Keys = { }

    --- En listar los objetos a afectar
    for Key, _ in pairs( ThisMOD.NewItems ) do
        table.insert( Keys, Key )
    end

    --- Eliminar los objetos enlistados
    for _, Key in pairs( Keys ) do
        ThisMOD.NewItems[ Key ] = nil
    end
end

--- Aplicar el efecto del MOD por fuera del mismo
--- @param TheMOD ThisMOD
function Private.DoEffect( TheMOD )

    --- Contenedor de los objetos a afectar
    local Items = { }

    --- Enlistar los objetos a afectar
    for _, Item in pairs( TheMOD.NewItems ) do

        --- Evitar estos elementos
        local MODs = { ThisMOD, GPrefix.IC }
        for _, MOD in pairs( MODs ) do
            local isMOD = GPrefix.hasPrefixMOD( Item, MOD )
            if isMOD then goto JumpItem end
        end

        --- El objetos no es valido
        if not Private.ValidateItem( Item ) then goto JumpItem end

        --- Agregar el objeto a la lista
        table.insert( Items, Item )

        --- Recepción del salto
        :: JumpItem ::
    end

    --- Modificar los objetos enlistados
    for _, Item in pairs( Items ) do
        Private.doChange( Item, TheMOD )
    end
end

--- Validar si el objeto es el buacado
--- @param Item table
function Private.ValidateItem( Item )

    --- Validación básica
    if not Item.stack_size then return false end

    --- Objectos a evitar
    Private.AvoidItems = { }
    if mods and mods[ "space-exploration" ] then
        table.insert( Private.AvoidItems, "rocket-fuel" )
    end

    --- Evitar este tipo
    if GPrefix.getKey( Private.AvoidItems, Item.name ) then return false end

    --- Tipos a evitar
    Private.AvoidTypes = { }
    table.insert( Private.AvoidTypes, "armor" )
    table.insert( Private.AvoidTypes, "selection-tool" )
    table.insert( Private.AvoidTypes, "belt-immunity-equipment" )

    --- Evitar este tipo
    if GPrefix.getKey( Private.AvoidTypes, Item.type ) then return false end

    --- Patrones a evitar
    Private.AvoidPatterns = { }
    table.insert( Private.AvoidPatterns, "%-remote" )

    --- Evitar este patron
    for _, Pattern in pairs( Private.AvoidPatterns ) do
        if string.find( Item.name, Pattern ) then return false end
    end

    --- El cambio no le favorece
    if Item.stack_size >= ThisMOD.Value then return false end

    --- No es apilable
    if GPrefix.getKey( Item.flags, "not-stackable" ) then return false end

    --- No se puede crear
    if GPrefix.getKey( Item.flags, "spawnable" ) then return false end

    --- El objeto es valido
    return true
end

--- Aplicar el efecto del MOD
--- @param Item table
--- @param TheMOD ThisMOD
function Private.doChange( Item, TheMOD )

    --- Hacer el cambio
    Item.stack_size = ThisMOD.Value
    GPrefix.addLetter( Item, ThisMOD.Char )

    --- Actualizar la descripción de los compactados
    if GPrefix.CI then GPrefix.CI.UpdateDescription( Item, ThisMOD ) end

    --- Actualizar la entidad
    if Item.place_result then
        local Entity = GPrefix.Entities[ Item.place_result ]
        if Entity then GPrefix.addLetter( Entity, ThisMOD.Char ) end
    end

    --- Actualizar el equipamento
    if Item.placed_as_equipment_result then
        local Equipment = GPrefix.Equipaments[ Item.placed_as_equipment_result ]
        if Equipment then GPrefix.addLetter( Equipment, ThisMOD.Char ) end
    end

    --- Actualizar sus recestas
    for _, Recipe in pairs( GPrefix.Recipes[ Item.name ] or { } ) do
        GPrefix.addLetter( Recipe, ThisMOD.Char )
    end
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------