--------------------------------------

-- __GLOBALS_VALUES__.lua

--------------------------------------
--------------------------------------

-- Filtrar el nombre del archivo
-- desde el cual se realizó la llamada
__FILE__ = getFile( __FILE__ )

-- Archivo validos
local Files = { }
table.insert( Files, "control" )
table.insert( Files, "data-final-fixes" )

-- Es necesario ejecutar este codigo??
if not table.getKey( Files, __FILE__ ) then
    return false
end if Items then return true end

--------------------------------------
--------------------------------------

-- Carga los valores de la configuración
for _, MOD in pairs( MODs ) do

    -- Crea la variable si aún no ha sido creada
    Setting[ MOD ] = Setting[ MOD ] or { }

    -- Carga la configuración de los mods
    local mod = Prefix .. string.gsub( MOD, "_", "-" )

    -- Exite una configuración para el MOD
    if settings.startup[ mod ] then
        Setting[ MOD ].value = settings.startup[ mod ].value
    end

end if not data then return end

--------------------------------------
--------------------------------------

-- Crear las variables
_G.Items      = { }
_G.Tiles      = { }
_G.Fluids     = { }
_G.Recipes    = { }
_G.Entitys    = { }
_G.Equipments = { }

-- Cargar las recetas
for _, recipe in pairs( data.raw.recipe ) do
    repeat

        -- Variable contenedora
        local _recipes = { recipe, recipe.expensive, recipe.normal }

        -- Validar si la receta esta oculta
        local Hidden = false
        for _, _recipe in pairs( _recipes ) do
            Hidden = _recipe.hidden
            if Hidden then break end
            Hidden = table.getKey( _recipe.flags, "hidden" )
            if Hidden then break end
        end if Hidden then break end

        -- Resultados de la recera
        local Results = { }
        for _, _recipe in pairs( _recipes ) do
            if _recipe.result then
                local result = { }
                table.insert( Results, result )
                table.insert( result, _recipe.result )
                table.insert( result, _recipe.result_count or 1 )
            end

            if _recipe.results then
                for _, result in pairs( _recipe.results ) do
                    table.insert( Results, result )
                end
            end
        end

        for _, Result in pairs( Results ) do

            -- { name = Nombre, amount = Contidad }
            -- { name = Nombre, amount = Contidad, type = "item" }
            -- { name = Nombre, amount = Contidad, type ="fluid", temperature = Temperatura }
            -- { name = Nombre, amount_min = Min, amount_max = Max, probability = [ Min: 0.01 - Max: 1 ] }
            if Result.name then

                -- Prepararse para guardar receta
                Recipes[ Result.name ] = Recipes[ Result.name ] or { }
                table.insert( Recipes[ Result.name ], recipe )

                -- Guardar referencia del resultado
                if Result.type ~= "fluid" then Items[ Result.name ]  = "" end
                if Result.type == "fluid" then Fluids[ Result.name ] = "" end
            end

            -- { Nombre, Contidad }
            if not Result.name then

                -- Prepararse para guardar receta
                Recipes[ Result[ 1 ] ] = Recipes[ Result[ 1 ] ] or { }
                table.insert( Recipes[ Result[ 1 ] ], recipe )

                -- Guardar referencia del resultado
                Items[ Result[ 1 ] ] = ""
            end
        end

        -- Ingredientes de la recera
        local Ingredients = { }
        for _, _recipe in pairs( _recipes ) do
            if _recipe.ingredients then
                for _, ingredient in pairs( _recipe.ingredients ) do
                    table.insert( Ingredients, ingredient )
                end
            end
        end

        for _, Ingredient in pairs( Ingredients ) do

            -- { name = Nombre, amount = Contidad }
            -- { name = Nombre, amount = Contidad, type = "item" }
            -- { name = Nombre, amount = Contidad, type ="fluid", temperature = Temperatura }
            if Ingredient.name then
                if Ingredient.type == "item"  then Items[ Ingredient.name ]  = "" end
                if Ingredient.type == "fluid" then Fluids[ Ingredient.name ] = "" end
            end

            -- { Nombre, Contidad }
            if not Ingredient.name then Items[ Ingredient[ 1 ] ] = "" end
        end

    until true
end

-- Cargar los suelos
for _, tile in pairs( data.raw.tile ) do
    repeat

        -- El suelo no se puede quitar
        if not tile.minable then break end
        if not tile.minable.result then break end

        -- El suelo no tiene receta
        if Items[ tile.minable.result ] then
            Items[ tile.minable.result ] = ""
        end

        -- Guardar el suelo
        Tiles[ tile.minable.result ] = Tiles[ tile.minable.result ] or { }
        table.insert( Tiles[ tile.minable.result ], tile )

    until true
end

-- Cargar los fluidos
for FluidName, _ in pairs( Fluids ) do
    local Fluid = data.raw.fluid[ FluidName ]
    if Fluid then Fluids[ FluidName ] = Fluid end
end

-- Evitar estos tipos
local AvoidTypes = { }
table.insert( AvoidTypes, "tile" )
table.insert( AvoidTypes, "fluid" )
table.insert( AvoidTypes, "recipe" )

-- Buscar el objeto
for ItemName, _ in pairs( Items ) do
    for _, subGrupo in pairs( data.raw ) do
        repeat

            -- Renombrar la variable
            local Item = subGrupo[ ItemName ]

            -- Objeto no encontrado
            if not Item then break end

            -- Objeto no apilable
            if not Item.stack_size then break end

            -- Tipos de objetos a evitar
            if table.getKey( AvoidTypes, Item.type ) then break end

            -- Objeto oculto
            local Hidden = Item.hidden
            Hidden = Hidden or table.getKey( Item.flags, "hidden" )
            if Hidden then Items[ ItemName ] = nil break end

            -- Guardar objeto
            Items[ ItemName ] = Item

            -- Guardar suelo
            if Item.place_as_tile then
                if not Tiles[ Item.name ] then
                    local tile = data.raw.tile
                    tile = tile[ Item.place_as_tile.result ]
                    Tiles[ Item.name ] = { tile }
                end
            end

            -- Guardar la entidad
            if Item.place_result then

                -- Entidad con nombre igual al objeto
                if Item.place_result == Item.name then
                    Entitys[ Item.name ] = ""
                end

                -- Entidad con nombre distinto al objeto
                if Item.place_result ~= Item.name then
                    Entitys[ Item.place_result ] = ""
                    Entitys[ Item.name ] = Item.place_result
                end
            end

            -- Guardar el equipable
            if Item.placed_as_equipment_result then
                Equipments[ Item.name ] = Item.name
            end

        until true
    end
end

-- Cargar las entidades
for EntityName, _ in pairs( Entitys ) do
    repeat

        if Entitys[ EntityName ] ~= "" then
            Entitys[ EntityName ] = Entitys[ Entitys[ EntityName ] ]
        end

        for _, subGroup in pairs( data.raw ) do
            repeat

                -- Objeto encontrado
                local Entity = subGroup[ EntityName ]
                if not Entity then break end
                if not Entity.minable then break end
                if table.getKey( AvoidTypes, Entity.type ) then break end
                if not( Entity.minable.result or Entity.minable.results ) then break end

                -- Guardar entidad
                Entitys[ EntityName ] = Entity

            until true
        end

    until true
end

-- Cargar los equipables
for ItemName, _ in pairs( Equipments ) do
    for _, subGrupo in pairs( data.raw ) do
        repeat

            -- Objeto encontrado
            local Equipment = subGrupo[ ItemName ]
            if not Equipment then break end
            if not Equipment.shape then break end
            if not Equipment.sprite then break end

            -- Guardar objeto
            Equipments[ ItemName ] = Equipment

        until true
    end
end

--------------------------------------
--------------------------------------

-- Variable contenedora
local Deleted   = { }
local String    = ""
local List      = { }
List.Items      = Items
List.Tiles      = Tiles
List.Fluids     = Fluids
List.Entitys    = Entitys
List.Recipes    = Recipes
List.Equipments = Equipments

-- Identificar valores vacios
for name, list in pairs( List ) do
    for key, value in pairs( list ) do
        if value == "" then

            String = String .. "\n"
            String = String .. string.sub( name, 1, #name - 1 )
            String = String .. " not found: " .. key

            table.insert( Deleted, key )
        end
    end
end

-- Eliminar valores vacios
for _, list in pairs( List ) do
    for _, value in pairs( Deleted ) do
        list[ value ] = nil
    end
end

-- Imprimir un informe de lo eliminados
if #String >= 1 then log( "\n>>>" .. String .. "\n<<<" ) end

--------------------------------------