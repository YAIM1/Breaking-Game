---------------------------------------------------------------------------------------------------

---> minimum-electrical-consumption.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "bool" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- propiedades a Cambiar
Private.Properties = { }
table.insert( Private.Properties, "energy_usage"                ) --- Para todas las entidades
table.insert( Private.Properties, "active_energy_usage"         ) --- Entidades logicas
table.insert( Private.Properties, "energy_per_nearby_scan"      ) --- Radar
table.insert( Private.Properties, "energy_per_sector"           ) --- Radar
table.insert( Private.Properties, "energy_per_movement"         ) --- Insertador
table.insert( Private.Properties, "energy_per_rotation"         ) --- Insertador
table.insert( Private.Properties, "energy_usage_per_tick"       ) --- Lamaparas y altavoz
table.insert( Private.Properties, "movement_energy_consumption" ) --- Spidertron

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

    --- Recorret las entidades disponibles
    for _, Entity in pairs( TheMOD.NewEntities ) do
        local Temporal = Entity

        --- Evitar estos elementos
        local MODs = { ThisMOD, GPrefix.IC }
        for _, MOD in pairs( MODs ) do
            local isMOD = GPrefix.hasPrefixMOD( Entity, MOD )
            if isMOD then goto JumpEntity end
        end

        --- Validación básica
        if not Entity.minable then goto JumpEntity end
        if not Entity.minable.result then goto JumpEntity end

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
--- @param Name string
--- @param TheMOD ThisMOD
function Private.doChange( Name, TheMOD )

    --- Duplicar el objeto
    local New = GPrefix.DuplicateItem( Name, TheMOD )
    if not New then return end

    --- Aplciar el cambio
    local Before = GPrefix.toString( New.Entity )
    Private.ApplyEffect( New.Entity )
    local After = GPrefix.toString( New.Entity )
    if Before == After then return end

    --- Incluir más información
    New.Name = Name
    New.TheMOD = TheMOD
    Private.SaveData( New )
end

--- Guardar la información
--- @param New table
function Private.SaveData( New )

    --- Renombrar las variables
    local Table = GPrefix.Recipes[ New.Name ] or New.TheMOD.NewRecipes[ New.Name ]
    local RecipeName = Table[ 1 ].name
    local NewRecipe = New.Recipes[ #New.Recipes ]

    local NewEntities = New.TheMOD.NewElements.NewEntities
    local NewItems = New.TheMOD.NewElements.NewItems
    local NewRecipes = New.TheMOD.NewElements.NewRecipes[ RecipeName ] or { }
    New.TheMOD.NewElements.NewRecipes[ RecipeName ] = NewRecipes

    --- Guardar los cambios
    NewEntities[ New.Entity.name ] = New.Entity
    NewItems[ New.Item.name ] = New.Item
    table.insert( NewRecipes, NewRecipe )

    --- Agregar la imagen de referencia
    GPrefix.AddIcon( New.Item, ThisMOD )

    --- Actualizar la receta
    local Recipes = { }
    table.insert( Recipes, NewRecipe )
    table.insert( Recipes, NewRecipe.normal )
    table.insert( Recipes, NewRecipe.expensive )
    for _, Recipe in ipairs( Recipes ) do
        for _, Result in ipairs( Recipe.results or { } ) do
            if Result.name == New.Name then
                Result.name = New.Item.name
            end
        end
    end
end

--- Establece el valor minimo
function Private.setEnergyValue( Unit )
    return tostring( 10 ^ 1 ) .. GPrefix.getUnit( Unit )
end

--- Cambiar las propiedades de la entidad
function Private.ApplyEffect( Entity )

    --- Validación básica
    if not Entity then return end

    repeat --- Todas las entidades
        if not Entity.energy_source then break end
        local Table = Entity.energy_source
        if not Table.type then return end
        if Table.type ~= "electric" then return end
        if not Table.drain then break end

        Entity.energy_source.drain = Private.setEnergyValue( Entity.energy_source.drain )
    until true

    --- Buscar y modificar las propiedades
    for _, Propiety in pairs( Private.Properties ) do
        if Entity[ Propiety ] then
            Entity[ Propiety ] = Private.setEnergyValue( Entity[ Propiety ] )
        end
    end

    repeat --- Arma de energía
        if not Entity.attack_parameters then break end
        local Table = Entity.attack_parameters
        if not Table.ammo_type then break end
        Table = Table.ammo_type
        if not Table.energy_consumption then break end

        Table = Entity.attack_parameters.ammo_type
        Table.energy_consumption = Private.setEnergyValue( Table.energy_consumption )
    until true
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------