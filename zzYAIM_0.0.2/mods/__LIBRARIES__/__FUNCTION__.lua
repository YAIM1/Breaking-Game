---------------------------------------------------------------------------------------------------

--> __FUNCTION__.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

if GPrefix.isNil then return end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

function GPrefix.isNil( Value )      return type( Value ) == "nil"      end
function GPrefix.isTable( Value )    return type( Value ) == "table"    end
function GPrefix.isString( Value )   return type( Value ) == "string"   end
function GPrefix.isNumber( Value )   return type( Value ) == "number"   end
function GPrefix.isBoolean( Value )  return type( Value ) == "boolean"  end
function GPrefix.isFunction( Value ) return type( Value ) == "function" end
function GPrefix.isUserData( Value ) return type( Value ) == "userdata" end


-- Call example. string.trim( string )

function string.trim( String )

    -- Eliminar los espacios internos
    String = string.gsub( String, "%s+", " " )

    -- Buscar los espacios de las puntas
    local End = string.len( String )
    local Start = string.find( String, "%s+" )
    local Reverse = string.reverse( String )
    local Result = string.find( Reverse, "%s+" )

    -- Hacer los correciones
    Start = Start == 1 and 2 or 1
    End = Result == 1 and End - 1 or End

    -- Eliminar los espacios de las puntas
    return string.sub( String, Start, End )
end

-- Call example. GPrefix.getLength( table )

function GPrefix.getLength( Table )

    -- Valdación básica
    if not GPrefix.isTable( Table ) then return nil end

    -- Variable de salida
    local Output = 0

    -- Contar campos
    for _ in pairs( Table ) do
        Output = Output + 1
    end

    -- Devolver el resultado
    return Output
end

-- Call example. DeepCopy( table )

function GPrefix.DeepCopy( Any )

    -- Valdación básica
    if not GPrefix.isTable( Any ) then return Any end

    -- Variable de salida
    local Output = { }

    -- Duplicar tabla
    for Key, Value in pairs( Any ) do
        Output[ Key ] = GPrefix.DeepCopy( Value )
    end

    -- Devolver el resultado
    return Output
end

-- Call example 1. GPrefix.getKey( table, Value )
-- Call example 2. GPrefix.getKey( table, Value1, ... , ValueN )

function GPrefix.getKey( Table, ... )

    -- Variable contenedora
    local Values = { ... }

    -- Valdación básica
    if not GPrefix.isTable( Table ) then return nil end
    if GPrefix.isNil( Values ) then return nil end

    -- Variable de salida
    local Output = { }

    -- Buscar el valor
    for _, Value in pairs( Values ) do
        for key, value in pairs( Table ) do
            if Value == value then
                table.insert( Output, key )
            end
        end
    end

    -- Example all
    if #Output == 0 then return nil         end
    if #Output == 1 then return Output[ 1 ] end
    if #Output >= 2 then return Output      end
end

-- Call example. GPrefix.toString( AnyVariable )

function GPrefix.toString( Value )
    local function SubFunction( Variable, Cache )
        -- Variables
        local Types  = { }
        Cache = Cache or { }
        local varType = type( Variable )

        -- La variable es simple
        Types = { "function", "thread" }
        if GPrefix.getKey( Types, varType ) then
            return varType .. "( )"
        end

        Types = { "userdata" }
        if GPrefix.getKey( Types, varType ) then
            return varType
        end

        Types = { "string" }
        if GPrefix.getKey( Types, varType ) then
            return "'" .. Variable .. "'"
        end

        Types = { "number" }
        if GPrefix.getKey( Types, varType ) then
            return Variable
        end

        Types = { "boolean", "nil" }
        if GPrefix.getKey( Types, varType ) then
            return tostring( Variable )
        end

        -- La vabriable es compleja
        Types = { "table" }
        if GPrefix.getKey( Types, varType ) then
            local Loop   = GPrefix.getKey( Cache, Variable )
            local output = ""

            -- La variable no ha sido revisada
            if not Loop then
                output = "{"
                table.insert( Cache, Variable )
                for key, value in pairs( Variable ) do

                    if GPrefix.isNil( GPrefix.getKey( Types, type( key ) ) ) then
                        output = output .. "\n\t[ " .. SubFunction( key, Cache ) .. " ] = "
                    end

                    if GPrefix.getKey( Types, type( key ) ) then
                        output = output .. "\n\t[ '" .. type( key ) .. "' ] = "
                    end

                    local String = SubFunction( value, Cache )
                    output = output .. string.gsub( String, "\n", "\n\t" ) .. ","
                end

                table.remove( Cache )
            end

            -- Revisar la variable puede generar un ciclo infinito
            if Loop then

                -- El objeto es este mismo
                if Loop == 1 then
                    output = output .. varType .. " --> Is this object"
                end

                -- El objeto está varias posiciones arriba
                if Loop >= 2 then
                    local Up = 1 + #Cache - Loop
                    output = output .. varType .. " --> This object is " .. Up .. " hierarchical positions up"
                end
            end

            -- Agrega el cierre cuando sea necesario
            if string.sub( output, 1, 1 ) == "{" then
                if #output >= 2 then output = output .. "\n}" end
                if #output <= 1 then output = output .. " }" end
            end

            return output
        end

        -- La variable es desconocido
        return "Unknown variable"
    end

    -- Devolver el resultado
    return SubFunction( Value )
end

-- Call example. GPrefix.Log( Variable1, ... , VariableN )

function GPrefix.Log( ... )

    -- Variable contenedora
    local Values = { ... }

    -- Validación básica
    if #Values == 0 then return false end

    -- Variable de salida
    local Output = ""

    -- Convertir las variables
    for Index, Value in pairs( Values ) do
        local String = ""
        if GPrefix.isTable( Value ) and Value.name then String = Value.name end
        if String == "" then String = Index end
        String = "[ " .. GPrefix.toString( String ) .. " ]"

        Output = Output .. "\n" .. String
        Output = Output .. " = " .. GPrefix.toString( Value )
    end

    -- Mostrar el resultado
    log( "\n>>>" .. Output .. "\n<<<" )
end

-- Call example. GPrefix.getFile( String )

function GPrefix.getFile( String )
    if String == "" then return "" end
    local Start, End = string.find( String, "/[%w%-]*.lua" )
    if not Start or not End then return String end
    return string.sub( String, Start + 1, End - 4 )
end

-- Call example. GPrefix.addEvent( Table )

function GPrefix.addEvent( Table )

    -- Crear la estructura
    for Patch, Parameters in pairs( Table ) do

        -- Validar los datos
        if not GPrefix.isTable( Patch ) then
            Patch = { Patch }
        end

        -- Variable contenedora
        local Container = GPrefix.Script

        -- Crear la estructura
        for _, Value in pairs( Patch ) do
            Container[ Value ] = Container[ Value ] or { }
            Container = Container[ Value ]
        end

        -- Incertar los parametros
        table.insert( Container, Parameters )
    end
end


-- Call example. GPrefix.getNumber( String )

function GPrefix.getNumber( String )

    -- Validación básica
    if not GPrefix.isString( String ) then return 0 end

    -- Leer el valor
    local Output
    for key, _ in string.gmatch( string.upper( String ), "%d*.?%d+") do
        Output = tonumber( key ) break
    end

    -- Identificar la unidad de energia
    local unit = string.upper( string.sub( String, -2, -2 ) )
    if tonumber( unit ) then unit = "" end

    -- Aplicar el cambio de unidad
    return Output * ( 10 ^ GPrefix.Unit[ unit ] )
end

-- Call example. GPrefix.getUnit( String )

function GPrefix.getUnit( String )

    -- Validación básica
    if not GPrefix.isString( String ) then return "" end

    -- Leer la unidad
    local unit = string.upper( string.sub( String, -1 ) )
    local units = { "J", "W" }

    -- La unidad es conocida
    if GPrefix.getKey( units, unit ) then return unit end

    -- La unidad es desconocida
    return ""
end

-- Call example. shortNumber( Number )

function GPrefix.shortNumber( Number )

    -- Valdación básica
    if not GPrefix.isNumber( Number ) then return "" end

    -- Acortar el número
    local Digits = math.floor( #tostring( Number ) / 3 )
    if #tostring( Number ) % 3 == 0 then Digits = Digits - 1 end
    local Output = tostring( Number * ( 10 ^ ( -3 * Digits ) ) )
    return Output .. GPrefix.Unit[ 3 * Digits ]
end

-- Call example. GPrefix.isResult( Recipe, Item )

function GPrefix.isResult( Recipe, Item )
    local function inRecipe( Results, ItemName )
        for _, Result in pairs( Results ) do
            if Result.name and Result.name == ItemName then return true
            elseif Result[ 1 ] and Result[ 1 ] == ItemName then return true end
        end return false
    end

    if Recipe.result == Item then return true end
	if Recipe.results and inRecipe( Recipe.results, Item ) then return true end
    if Recipe.normal and Recipe.normal.result == Item then return true end
	if Recipe.normal and Recipe.normal.results and inRecipe( Recipe.normal.results, Item ) then return true end
    if Recipe.expensive and Recipe.expensive.result == Item then return true end
	if Recipe.expensive and Recipe.expensive.results and inRecipe( Recipe.expensive.results, Item ) then return true end
	return false
end

-- Call example. GPrefix.setResult( Recipe, Result )

function GPrefix.setResult( Recipe, Result )

    -- Validación básica
    if not Recipe then return end

    -- Eliminar los resultados
    local function Clear( Table )
        if not Table.ingredients then return end
        Table.result = nil
        Table.results = nil
        Table.result_count = nil
    end

    -- Establecer los resultados
    local function Set( Table )
        if not Table.ingredients then return end
        Table.results = Result
    end

    -- Ubicación de los resutados
    local Tables = { }
    table.insert( Tables, Recipe )
    table.insert( Tables, Recipe.normal )
    table.insert( Tables, Recipe.expensive )

    -- Hacer el cambio
    for _, Table in pairs( Tables ) do
        Clear( Table )   Set( Table )
    end
end


-- Call example. GPrefix.CreateIcons( Table )

function GPrefix.CreateIcons( Table )

    -- No hace falta crear la tabla
    if Table.icons then return end

    -- Crear la nueva tabla
    local Icon = { }
    Icon.icon = Table.icon
    Icon.icon_size = Table.icon_size
    Icon.icon_mipmaps = Table.icon_mipmaps

    -- Hacer el cambio
    Table.icon = nil
    Table.icons = { Icon }
end

-- Call example 1. GPrefix.addTechnology( OldItemName, NewRecipeName )

function GPrefix.addTechnology( OldItemName, NewRecipeName )

    -- Variable contenedora
    local Array = { }
    Array.NewRecipe = data.raw.recipe[ NewRecipeName ]

    Array.Enabled = { }
    table.insert( Array.Enabled, Array.NewRecipe )
    table.insert( Array.Enabled, Array.NewRecipe.normal )
    table.insert( Array.Enabled, Array.NewRecipe.expensive )

    -- Saltar las tecnologías
    if data.raw.resource[ OldItemName ] then goto JumpTechnologies end
    if OldItemName == "" then goto JumpTechnologies end

    -- Buscar las recetas del objeto
    Array.Recipes = GPrefix.Recipes[ OldItemName ]
    if not Array.Recipes then goto JumpTechnologies end

    -- Tecnologías posibles
    Array.Technologies = { }
    Array.Found = { }

    -- Revisar cada tecnología
    for _, Recipe in pairs( Array.Recipes ) do

        -- Marcar como NO encontrado
        Array.Found[ Recipe.name ] = false

        -- Evitar la receta
        if Recipe.hide_from_player_crafting then
            Array.Found[ Recipe.name ] = true
        end

        -- Revisar las tecnologías
        for _, Technology in pairs( data.raw.technology ) do
            for _, Effect in pairs( Technology.effects or { } ) do

                -- Validar la si hay recetas a desbloquar
                if Effect.type ~= "unlock-recipe" then goto JumpEffect end

                -- Validar si es la receta que se busca
                if Effect.recipe ~= Recipe.name then goto JumpEffect end

                -- Marcar como encontrado
                Array.Found[ Recipe.name ] = true

                -- Esta en la lista
                Array.inList = GPrefix.getKey( Array.Technologies, Technology )
                if Array.inList then goto JumpEffect end

                -- Agregar la tecnología a la lista
                table.insert( Array.Technologies, Technology )

                -- Recepción del salto
                :: JumpEffect ::
            end
        end
    end

    -- No se requiere tecnología
    if #Array.Technologies < 1 then goto JumpTechnologies end

    Array.Find = GPrefix.Prefix_
    Array.Find = string.gsub( Array.Find, "-", "%%-" )
    for RecipeName, Found in pairs( Array.Found ) do
        if not string.find( RecipeName, Array.Find ) then
            if not Found then goto JumpTechnologies end
        end
    end

    -- Formato para agregar la tecnología
    Array.NewEffect = { }
    Array.NewEffect.type = "unlock-recipe"
    Array.NewEffect.recipe = NewRecipeName

    -- Deshabilitar la receta
    for _, Table in pairs( Array.Enabled ) do
        if Table.ingredients then
            Table.enabled = false
        end
    end

    -- Agregar la receta a las tecnologias
    for _, Technology in pairs( Array.Technologies ) do
        table.insert( Technology.effects, Array.NewEffect )
    end if true then return end

    -- Recepción del salto
    :: JumpTechnologies ::

    -- No se requiere una tecnología
    for _, Table in pairs( Array.Enabled ) do
        if Table.ingredients then
            Table.enabled = true
        end
    end
end

-- Call example: GPrefix.CreatelocalisedName( OldItem )

function GPrefix.CreateLocalisedName ( Item )

    -- Validación básica
    if Item.localised_name then return end

    -- Variables contenedoras
    local Element = { }
    local NickName = nil

    -- Objeto de una entidad
    if Item.place_result then
        Element = GPrefix.Entities[ Item.place_result ]
        if Element and Element.localised_name then
            NickName = GPrefix.DeepCopy( Element.localised_name )
        elseif Element and not Element.localised_name then
            NickName = { "entity-name." .. Item.place_result }
        else
            NickName = { "entity-name." .. Item.name }
        end
    end


    -- Objeto de un piso
    if Item.place_as_tile then
        Element = GPrefix.Tiles[ Item.place_as_tile ]
        if Element and Element.localised_name then
            NickName = GPrefix.DeepCopy( Element.localised_name )
        elseif Element and not Element.localised_name then
            NickName = { "title-name." .. Item.place_as_tile }
        else
            NickName = { "item-name." .. Item.name }
        end
    end

    -- Objeto de un equipo
    if Item.placed_as_equipment_result then
        Element = GPrefix.Equipaments[ Item.placed_as_equipment_result ]
        if Element and Element.localised_name then
            NickName = GPrefix.DeepCopy( Element.localised_name )
        elseif Element and not Element.localised_name then
            NickName = { "equipment-name." .. Item.placed_as_equipment_result }
        else
            NickName = { "equipment-name." .. Item.name }
        end
    end

    -- Objeto desconocido
    if not NickName then
        NickName = { "item-name." .. Item.name }
    end

    -- Establecer el apodo
    Item.localised_name = NickName
end

-- Call example 1: GPrefix.addLetter( Entity )
-- Call example 2: GPrefix.addLetter( Entity, Char )
-- Call example 3: GPrefix.addLetter( Entity, ThisMOD )

function GPrefix.addLetter( Table, ThisMOD )

    -- Inicializar la variable
    ThisMOD = ThisMOD or " ["
    if GPrefix.isString( ThisMOD ) then
        ThisMOD = { Char = ThisMOD }
        ThisMOD.Create = true
    end

    -- No existe el apodo
    if not Table.localised_name then

        -- Variables contenedoras
        local Type = ""
        local Element = nil

        -- Identificar el elemento
        if GPrefix.Items[ Table.name ] then
            Element = GPrefix.Items[ Table.name ]
            Type = "item"
        end

        if GPrefix.Fluids[ Table.name ] then
            Element = GPrefix.Fluids[ Table.name ]
            Type = "fluid"
        end

        if GPrefix.Entities[ Table.name ] then
            Element = GPrefix.Entities[ Table.name ]
            Type = "entity"
        end

        if GPrefix.Equipaments[ Table.name ] then
            Element = GPrefix.Equipaments[ Table.name ]
            Type = "equipment"
        end

        -- Establecer el apodo
        if Element and Element.localised_name then
            Table.localised_name = GPrefix.DeepCopy( Element.localised_name )
        end

        if Element and Type == "item" then
            GPrefix.CreateLocalisedName( Element )
            Table.localised_name = GPrefix.DeepCopy( Element.localised_name )
        end

        if Element and not Element.localised_name then
            Table.localised_name = { "", { Type .. "-name." .. Table.name }, " [", " ]" }
        end

        -- El elemento es una receta
        repeat

            -- Validación básica
            if Element then break end
            if Table.type ~= "recipe" then break end

            -- Variable contenedora
            local Result = GPrefix.getResults( Table ) or { }

            -- No hay un unico resultado
            if #Result ~= 1 then
                local Item = GPrefix.Items[ Table.main_product ]
                local Fluid = GPrefix.Fluids[ Table.main_product ]

                -- Crear el apodo del objeto
                if Item and not Item.localised_name then
                    GPrefix.CreateLocalisedName( Item )
                end

                -- Apodo existente
                if Item and Item.localised_name then
                    Table.localised_name = Item.localised_name
                end
                if Fluid and Fluid.localised_name then
                    Table.localised_name = Fluid.localised_name
                end

                -- Construir el apodo
                if Fluid and not Fluid.localised_name then
                    Table.localised_name = { "", { "fluid-name." .. Fluid.name }, " [", " +", " ]" }
                end
                if not Item and not Fluid then
                    Table.localised_name = { "", { "recipe-name." .. Table.name }, " [", " -", " ]" }
                end

                break
            end

            -- Hacer el cambio
            local Item = GPrefix.Items[ Result[ 1 ] ]
            GPrefix.CreateLocalisedName( Item )
            Table.localised_name = GPrefix.DeepCopy( Item.localised_name )
        until true
    end

    -- El apodo es un texto
    if not GPrefix.isTable( Table.localised_name ) then
        Table.localised_name = { "", Table.localised_name, " [", " ]" }
    end

    -- El apodo no es contruido
    if Table.localised_name[ 1 ] ~= "" then
        Table.localised_name = { "", Table.localised_name, " [", " ]" }
    end

    -- El apodo es contruido
    local Flag = not GPrefix.getKey( Table.localised_name, " [" )
    if Flag and Table.localised_name[ 1 ] == "" then
        table.insert( Table.localised_name, " [" )
        table.insert( Table.localised_name, " ]" )
    end

    -- Ocultar las maquinas que usa la receta
    if Table.type == "recipe" then
        Table.always_show_made_in = false
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Crear el nuevo valor
    local function set( Name )
        local Find = ""

        Find = GPrefix.Prefix_
        Find = string.gsub( Find, "-", "%%-" )
        Name = string.gsub( Name, Find, "" )

        return ThisMOD.Prefix_MOD_ .. Name
    end

    -- Solo se afecta el apodo
    if ThisMOD.Create then goto JumpPrefix end

    -- Nombre del prototipo
    Table.name = set( Table.name )

    -- Remplazar el objeto a minar
    if Table.minable and Table.minable.result then
        Table.minable.result = set( Table.minable.result )
    end

    -- Remplazar la entidad a crear
    if Table.place_result then
        Table.place_result = set( Table.place_result )
    end

    -- Remplazar el equipamiento a crear
    if Table.placed_as_equipment_result then
        Table.placed_as_equipment_result = set( Table.placed_as_equipment_result )
    end

    -- Recepción del salto
    :: JumpPrefix ::

    -- Agregar la letra en su posición
    local Array = Table.localised_name
    if not GPrefix.getKey( Array, " " .. ThisMOD.Char ) then

        -- Agregar la letra
        Position = GPrefix.getKey( Array, " ]" )
        local Index = tonumber( ( Position or "" ) .. "", 10 )
        table.insert( Array, Index, " " .. ThisMOD.Char )

        -- Ordenar las letras
        local Position = GPrefix.getKey( Array, " [" )
        Position = ( Position or 0 ) or 0
        if Position > 0 then
            local List = { }
            Position = Position + 1
            local Start = Position

            while Array[ Position ] ~= " ]" do
                table.insert( List, Array[ Position ] )
                Position = Position + 1
            end

            table.sort( List )
            local End = Start + #List - 1

            for i = Start, End, 1 do
                Array[ i ] = List[ i - Start + 1 ]
            end
        end
    end
end

-- Call example: GPrefix.newItemSubgroup( OldItem, ThisMOD )

function GPrefix.newItemSubgroup( OldItem, ThisMOD )

    -- Existe el subgrupo
    local SubGroup = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    SubGroup = string.gsub( OldItem.subgroup, SubGroup, "" )
    SubGroup = ThisMOD.Prefix_MOD_ .. SubGroup
    local newSubGroup = data.raw[ "item-subgroup" ][ SubGroup ]
    if newSubGroup then return end

    -- Crear el subgrupo
    newSubGroup = data.raw[ "item-subgroup" ][ OldItem.subgroup ]
    newSubGroup = GPrefix.DeepCopy( newSubGroup )
    newSubGroup.name = SubGroup
    newSubGroup.order = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    newSubGroup.order = string.gsub( OldItem.order, newSubGroup.order, "" )
    newSubGroup.order = ThisMOD.Prefix_MOD_ .. OldItem.order
    data:extend( { newSubGroup } )
end

-- Call example: GPrefix.AddIcon( Table, ThisMOD )

function GPrefix.AddIcon( Table, ThisMOD )
    GPrefix.CreateIcons( Table )

    -- Agregar el referencia
    local List = { icon = "" }
    List.icon = List.icon .. ThisMOD.Patch
    List.icon = List.icon .. "icons/status.png"
    List.icon_size = 32
    table.insert( Table.icons, List )
end

-- Call example: GPrefix.getResults( Recipe )

function GPrefix.getResults( Recipe )

    -- Validación básica
    if Recipe.type ~= "recipe" then return nil end

    -- Variable contenedora
    local Recipes = { Recipe, Recipe.expensive, Recipe.normal }
    local Result = { }

    -- Cargar los posibles resultados
    for _, Array in pairs( Recipes ) do
        if Array.result then
            if not GPrefix.getKey( Result, Array.result ) then
                table.insert( Result, Array.result )
            end
        end

        if Array.results then
            for _, result in pairs( Array.results ) do
                local Name = result.name or result[ 1 ]
                if not GPrefix.getKey( Result, Name ) then
                    table.insert( Result, Name )
                end
            end
        end
    end

    -- Devolver los resultados
    return Result
end

-- Call example: GPrefix.updateResults( ThisMOD )

function GPrefix.updateResults( ThisMOD )

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Inicializar y renombrar la variable
    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Eliminar los ingredientes
    for _, Recipe in pairs( Recipes ) do Recipe = Recipe[ 1 ]
        local Results = GPrefix.getResults( Recipe ) or { }
        if #Results == 1 then local Result = Results[ 1 ]

            -- Eliminar las propiedades incesarias
            Recipe.icon = nil
            Recipe.icons = nil
            Recipe.icon_size = nil
            Recipe.main_product = nil
            Recipe.icon_mipmaps = nil

            -- Recorrer los resultados
            for _, Table in ipairs( { Recipe, Recipe.normal, Recipe.expensive } ) do
                if Table.ingredients then

                    -- Nombre del objeto
                    local name = GPrefix.Prefix_
                    name = string.gsub( name, "-", "%%-" )
                    name = string.gsub( Result, name, "" )

                    -- Establecer el resultado
                    Table.result = ThisMOD.Prefix_MOD_ .. name
                    Table.results = nil
                end
            end
        end
    end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Call example: GPrefix.ClickRight( Data )

function GPrefix.ClickRight( Data )

    -- Renombrar la variable
    local Element = Data.Event.element
    local Event = Data.Event

    -- Validación básica
    if not Element.valid then return false end
    local ButtonRight = defines.mouse_button_type.right
    if Event.button ~= ButtonRight then return false end

    -- Es un clic derecho
    return true
end

-- Call example: GPrefix.ClickLeft( Data )

function GPrefix.ClickLeft( Data )

    -- Crea la variable si aún no ha sido creada
    local Click = Data.GPrefix

    Click.Click = Click.Click or { }
    Click = Click.Click

    Click.Players = Click.Players or { }
    Click = Click.Players

    Click[ Data.Player.index ] = Click[ Data.Player.index ] or { }
    Click = Click[ Data.Player.index ]

    -- Guardar la información
    Data.Click = Click

    -- Renombrar la variable
    local Element = Data.Event.element
    local Event = Data.Event

    -- Validación básica
    Event.tick = Event.tick or game.tick
    if not Element.valid then return false end
    local ButtonLeft = defines.mouse_button_type.left
    if Event.button ~= ButtonLeft then return false end
    if Data.Click.Tick and Data.Click.Tick == Event.tick then return true end

    -- Guardar datos del clic
    if not Click.Element or Click.Element ~= Element then
        Click.Tick = Click.Tick or game.tick
        Click.Element = Element
    end

    -- Es un clic izquierdo
    return true
end

-- Call example: GPrefix.ClickDouble( Data )

function GPrefix.ClickDouble( Data )

    -- El clic no es izquierdo
    if not GPrefix.ClickLeft( Data ) then return false end

    -- Tiempo entre clic
    local Time = Data.Event.tick - Data.Click.Tick

    -- El evento es el mismo
    if Time == 0 then return false end

    -- Doble clic muy lento
    if Time > 15 then
        Data.Click.Tick = Data.Event.tick
        return false
    end

    -- Es un doble clic
    return true
end

-- Call example: GPrefix.ToggleButton( Button )

function GPrefix.ToggleButton( Button )

    -- Renombrar la variable
    local Tags = Button.tags

    -- Hacer el cambio
    local Activated = Button.style.name == Tags.Disabled
    Button.style = ( Activated and Tags.Enabled or Tags.Disabled )
    if Tags.Size then Button.style.size = Tags.Size end
    Button.style.margin = 0
    Button.style.padding = 0

    -- Imagenes usadas en el botón cuando esta activado
    if Activated and Tags.White then Button.sprite         = Tags.White end
    if Activated and Tags.Black then Button.hovered_sprite = Tags.Black end
    if Activated and Tags.Black then Button.clicked_sprite = Tags.Black end

    -- Imagenes usadas en el botón cuando esta desactivado
    if not Activated and Tags.White then Button.sprite         = Tags.Black end
    if not Activated and Tags.Black then Button.hovered_sprite = Tags.White end
    if not Activated and Tags.Black then Button.clicked_sprite = Tags.White end
end

-- Call example: GPrefix.CreateData( Event, ThisMOD )

function GPrefix.CreateData( Event, ThisMOD )

    -- Variable contenedora
    local Data   = { }
    Data.GPrefix = GPrefix
    Data.GMOD    = ThisMOD
    Data.Event   = Event

    -- Identificar al jugador
    Data.Player = Event.Player
    if Event.player_index then Data.Player = game.get_player( Event.player_index ) end

    -- Grupo al cual pertenece
    Data.Force = Data.Event.force or nil

    if Data.Player and not GPrefix.isString( Data.Player.force ) then
        Data.Force = Data.Player.force
    end

    if Data.Player and GPrefix.isString( Data.Player.force ) then
        for _, Force in pairs( game.forces ) do
            local Players = Force.players
            if Players and Players[ Data.Player.index ] then
                Data.Force = Force break
            end
        end
    end

    -- Crear el espacio para la interfaz
    if Data.Player then
        Data.GMOD.Players = Data.GMOD.Players or { }
        local Players = Data.GMOD.Players

        Players[ Data.Player.index ] = Players[ Data.Player.index ] or { }
        Data.GPlayer = Players[ Data.Player.index ]

        Data.GPlayer.GUI = Data.GPlayer.GUI or { }
        Data.GUI = Data.GPlayer.GUI
    end

    -- Valores temporales
    Data.Temporal = { }

    -- Crear el acceso rápido a los valores para el doble clic
    if Data.Player and GPrefix.Click then
        Data.Click = GPrefix.Click.Players[ Data.Player.index ]
    end

    -- Crear el espacio para la cola
    global[ GPrefix.Prefix ] = global[ GPrefix.Prefix ] or { }
    Data.gPrefix = global[ GPrefix.Prefix ]

    Data.gPrefix[ Data.GMOD.Name ] = Data.gPrefix[ Data.GMOD.Name ] or { }
    Data.gMOD = Data.gPrefix[ Data.GMOD.Name ]

    -- Crear el espacio para el jugador
    if Data.Player then
        Data.gMOD.Players = Data.gMOD.Players or { }
        local Players = Data.gMOD.Players

        Players[ Data.Player.index ] = Players[ Data.Player.index ] or { }
        Data.gPlayer = Players[ Data.Player.index ]
    end

    -- Crear el espacio para los forces
    Data.gMOD.Forces = Data.gMOD.Forces or { }
    Data.gForce = Data.gMOD.Forces

    Data.GMOD.Forces = Data.GMOD.Forces or { }
    Data.GForce = Data.GMOD.Forces

    -- Crear el espacio para un forces
    Data.gForce[ Data.Force.index ] = Data.gForce[ Data.Force.index ] or { }
    Data.gForce = Data.gForce[ Data.Force.index ]

    Data.GForce[ Data.Force.index ] = Data.GForce[ Data.Force.index ] or { }
    Data.GForce = Data.GForce[ Data.Force.index ]

    -- Cargar la traducciones
    local Flag = Data.Player
    Flag = Flag and Data.gPlayer.Language
    if Flag and Data.GMOD.Language then
        local Language = Data.gPlayer.Language
        Data.Language = Data.GMOD.Language[ Language ]
    end

    return Data
end

---------------------------------------------------------------------------------------------------