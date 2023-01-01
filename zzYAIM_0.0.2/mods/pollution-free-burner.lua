---------------------------------------------------------------------------------------------------

---> pollution-free-burner.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "bool" )

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

        --- Validar la entidad
        if not Temporal.energy_source then goto JumpEntity end
        Temporal = Temporal.energy_source
        if not Temporal.type then goto JumpEntity end
        if Temporal.type ~= "burner" then goto JumpEntity end
        if not Temporal.emissions_per_minute then goto JumpEntity end

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
    local New = GPrefix.DuplicateItem( Name, ThisMOD )
    if not New then return end

    --- Aplciar el cambio
    local Array = New.Entity.energy_source
    if Array.emissions_per_minute > 0 then
        Array.emissions_per_minute = nil
    end

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

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------