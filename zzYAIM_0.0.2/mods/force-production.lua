---------------------------------------------------------------------------------------------------

---> force-production.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "bool" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Listado de las recestas a fectar
Private.limitation = { }

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
    for _, Item in pairs( TheMOD.NewItems ) do

        --- Evitar estos elementos
        local MODs = { ThisMOD, GPrefix.IC }
        for _, MOD in pairs( MODs ) do
            local isMOD = GPrefix.hasPrefixMOD( Item, MOD )
            if isMOD then goto JumpEntity end
        end

        --- No es un modulo
        if not Item.limitation then goto JumpEntity end

        --- Agregar el objeto a la lista
        table.insert( Names, Item.name )

        --- Recepción del salto
        :: JumpEntity ::
    end

    --- Agregar las recestas 
    Private.limitation = { }
    for _, Recipe in ipairs( data.raw.recipe ) do
        table.insert( Private.limitation, Recipe.name )
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
    New.Item.limitation = Private.limitation

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

    local NewItems = New.TheMOD.NewElements.NewItems
    local NewRecipes = New.TheMOD.NewElements.NewRecipes[ RecipeName ] or { }
    New.TheMOD.NewElements.NewRecipes[ RecipeName ] = NewRecipes

    --- Guardar los cambios
    NewItems[ New.Item.name ] = New.Item
    table.insert( NewRecipes, NewRecipe )
    table.insert( Private.limitation, NewRecipe.name )

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