---------------------------------------------------------------------------------------------------

---> slots-with-filters.lua <---

---------------------------------------------------------------------------------------------------
--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "bool" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Tipo de entidades a las que afectar
Private.Affected = { }
table.insert( Private.Affected, "container" )
table.insert( Private.Affected, "logistic-container" )

--- Nuevos typo del contenedor
Private.Type = "with_filters_and_bar"

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

    --- Duplicar los accesos
    --- @type ThisMOD
    local TheMOD = { }
    for Key, Value in pairs( ThisMOD ) do
        TheMOD[ Key ] = Value
    end

    --- Remplazar los prototipos
    TheMOD.NewEntities = GPrefix.Entities
    TheMOD.NewRecipes = GPrefix.Recipes
    TheMOD.NewItems = GPrefix.Items

    --- Aplicar los efectos
    ThisMOD.DoEffect( TheMOD )
end

--- Aplicar el efecto del MOD por fuera del mismo
--- @param TheMOD ThisMOD
function Private.DoEffect( TheMOD )

    --- Contenedor de los objetos a afectar
    local Names = { }

    --- Recorrer las entidades disponibles
    for _, Entity in pairs( TheMOD.NewEntities ) do

        --- Evitar estos elementos
        local MODs = { ThisMOD }
        for _, MOD in pairs( MODs ) do
            local isMOD = GPrefix.hasPrefixMOD( Entity, MOD )
            if isMOD then goto JumpEntity end
        end

        --- Validación básica
        if not Entity.minable then goto JumpEntity end
        if not Entity.minable.result then goto JumpEntity end

        --- Validar la entidad
        if not GPrefix.getKey( Private.Affected, Entity.type ) then goto JumpEntity end

        --- Agregar el objeto a la lista
        table.insert( Names, Entity.minable.result )

        --- Recepción del salto
        :: JumpEntity ::
    end

    --- Modificar los objetos enlistados
    for _, Name in pairs( Names ) do
        Private.doChange( Name, TheMOD )
    end
end

--- Aplicar el efecto del MOD
--- @param Name table
--- @param TheMOD ThisMOD
function Private.doChange( Name, TheMOD )

    --- Cargar el objeto a modificar
    local Item = GPrefix.Items[ Name ] or TheMOD.NewItems[ Name ]
    if not Item then return end
    if not Item.place_result then return end

    --- Actualizar la entidad
    local Entity = GPrefix.Entities[ Item.place_result ] or TheMOD.NewEntities[ Item.place_result ]
    if not Entity then return end
    Entity.inventory_type = Private.Type

    --- Agregar la letra
    GPrefix.addLetter( Item, ThisMOD.Char )
    GPrefix.addLetter( Entity, ThisMOD.Char )
    for _, Recipe in pairs( GPrefix.Recipes[ Item.name ] or { } ) do
        GPrefix.addLetter( Recipe, ThisMOD.Char )
    end
    for _, Recipes in pairs( TheMOD.NewRecipes ) do
        for _, Recipe in pairs( Recipes ) do
            local Results = GPrefix.getResults( Recipe ) or { }
            if GPrefix.inTable( Results, Item ) then
                GPrefix.addLetter( Recipe, ThisMOD.Char )
            end
        end
    end 

    --- Actualizar la descripción de los compactados
    if GPrefix.CI then GPrefix.CI.UpdateDescription( Item, ThisMOD ) end
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------