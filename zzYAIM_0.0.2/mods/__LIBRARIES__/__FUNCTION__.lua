---------------------------------------------------------------------------------------------------

---> __FUNCTION__.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Validar se cargo este archivo
if GPrefix.isNil then return end

--- Contenedor de funciones y datos usados
--- unicamente en este archivo
local Private = { }

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

function GPrefix.isNil( Value )      return type( Value ) == "nil"      end
function GPrefix.isTable( Value )    return type( Value ) == "table"    end
function GPrefix.isString( Value )   return type( Value ) == "string"   end
function GPrefix.isNumber( Value )   return type( Value ) == "number"   end
function GPrefix.isBoolean( Value )  return type( Value ) == "boolean"  end
function GPrefix.isFunction( Value ) return type( Value ) == "function" end
function GPrefix.isUserData( Value ) return type( Value ) == "userdata" end



--- Contar los elementos en la tabla
---- __ADVERTENCIA:__ El conteo NO es recursivo
--- @param Table table
--- @return integer | nil #
---- __integer:__ Conteo de los elementos de la tabla
---- __nil:__ El valor dado no es valido
function GPrefix.getLength( Table )

    --- Valdación básica
    if not GPrefix.isTable( Table ) then return nil end

    --- Variable de salida
    local Output = 0

    --- Contar campos
    for _ in pairs( Table ) do
        Output = Output + 1
    end

    --- Devolver el resultado
    return Output
end

--- Hace una copia de la variable dada
--- @return any
function GPrefix.DeepCopy( Any )

    --- Valdación básica
    if not GPrefix.isTable( Any ) then return Any end

    --- Variable de salida
    local Output = { }

    --- Duplicar tabla
    for Key, Value in pairs( Any ) do
        Output[ Key ] = GPrefix.DeepCopy( Value )
    end

    --- Devolver el resultado
    return Output
end

--- Devuelve el indice que le corresponde al valor o valores entregados
--- @param Table table
--- @param Value any
--- @return integer|nil #
---- __integer:__ Posición de la primera coincidencia con el valor
---- __nil:__ El valor dado no es valido
function GPrefix.getKey( Table, Value )

    --- Valdación básica
    if not GPrefix.isTable( Table ) then return nil end
    if GPrefix.isNil( Value ) then return nil end

    --- Buscar el valor
    for key, value in pairs( Table ) do
        if Value == value then
            return key
        end
    end

    --- No se encontrado
    return nil
end

--- Buscar el objeto en la tabla dada por medio de la propiedad _name_
--- @param Element table
--- @param Table table
--- @return boolean # Respuesta de la busqueda
function GPrefix.inTable( Table, Element )

    --- Valdación básica
    if not GPrefix.isTable( Table ) then return false end
    local Length = GPrefix.getLength( Table )
    if not Length then return false end
    if Length < 1 then return false end

    --- Buscar el objeto en la tabla
    for _, tElement in pairs( Table ) do
        if tElement.name == Element.name then
            return true
        end
    end

    --- Elemento no encontrado
    return false
end



--- Devuelve la información dada en formato lua
--- @param Value any
--- @return string
function GPrefix.toString( Value )

    --- Variables a usar
    local Types = { }
    local varType = type( Value )

    --- Variables atomica
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
        return "'" .. Value .. "'"
    end

    Types = { "number" }
    if GPrefix.getKey( Types, varType ) then
        return Value
    end

    Types = { "boolean", "nil" }
    if GPrefix.getKey( Types, varType ) then
        return tostring( Value )
    end

    --- La variable es desconocida
    Types = { "table" }
    if not GPrefix.getKey( Types, varType ) then
        return "unknown"
    end

    --- Variables a usar
    local Array = { }
    local String = ""

    --- Recorrer los valores de la table
    for key, value in pairs( Value ) do

        --- Convertir la variable en cadena
        String = GPrefix.toString( value )
        String = " = " .. string.gsub( String, "\n", "\n\t" )
        String = "[ " .. GPrefix.toString( key ) .. " ]" .. String

        --- Guardar la variable convertida en cadena
        table.insert( Array, String )
    end

    --- La tabla esta vacia
    if #Array < 1 then return "{ }" end

    --- Valor de salida
    String = table.concat( Array, "," .. "\n\t" )
    String = "{" .. "\n\t" .. String .. "\n" .. "}"
    return String
end

-- Escribe en factorio-current.log la informacion contenida
--- en la variable dada
function GPrefix.Log( ... )

    --- Variable contenedora
    local Values = { ... }

    --- Validación básica
    if #Values == 0 then return end

    --- Variable de salida
    local Output = ""

    --- Convertir las variables
    for Index, Value in pairs( Values ) do

        --- Establecer el nombre de la variable
        local String = nil
        if GPrefix.isTable( Value ) and Value.name then String = Value.name end
        if not String then String = Index end

        --- Convertir la variable en cadena
        String = "[ " .. GPrefix.toString( String ) .. " ]"
        String = String .. " = " .. GPrefix.toString( Value )

        --- Guardar la variable convertida en cadena
        Output = Output .. "\n" .. String
    end

    --- Mostrar el resultado
    log( "\n>>>" .. Output .. "\n<<<" )
end



--- Separar el numero de la cadena, devuelve 0 si el valor no 
--- @param String string _Ejemplo:_ 0.3Mw
--- @return integer # _Ejemplo:_ 300000
function GPrefix.getNumber( String )

    --- Validación básica
    if not GPrefix.isString( String ) then return 0 end

    --- Leer el valor
    local Output = nil
    for key, _ in string.gmatch( string.upper( String ), "%d*.?%d+") do
        Output = tonumber( key ) break
    end Output = Output or 0

    --- Identificar la unidad de energia
    local unit = string.upper( string.sub( String, -2, -2 ) )
    if tonumber( unit ) then unit = "" end

    --- Aplicar el cambio de unidad
    return Output * ( 10 ^ GPrefix.Unit[ unit ] )
end

--- Separar la unidad de medida de la cadena
--- @param String string _Ejemplo:_ 0.3Mw
--- @return string # _Ejemplo:_ W
function GPrefix.getUnit( String )

    --- Validación básica
    if not GPrefix.isString( String ) then return "" end

    --- Leer la unidad
    local unit = string.upper( string.sub( String, -1 ) )
    local units = { "J", "W" }

    --- La unidad es conocida
    if GPrefix.getKey( units, unit ) then return unit end

    --- La unidad es desconocida
    return ""
end

--- Acortar el número
--- @param Number integer _Ejemplo:_ 300000
--- @return string # _Ejemplo:_ 300K
function GPrefix.ShortNumber( Number )

    --- Valdación básica
    if not GPrefix.isNumber( Number ) then return "" end

    --- Acortar el número
    local Digits = math.floor( #tostring( Number ) / 3 )
    if #tostring( Number ) % 3 == 0 then Digits = Digits - 1 end
    local Output = tostring( Number * ( 10 ^ ( -3 * Digits ) ) )
    return Output .. GPrefix.Unit[ 3 * Digits ]
end



--- Verificar si el objeto es uno de los resultados de la receta dada
--- @param Recipe table
--- @param Item string Nombre del objeto a buscar
--- @return boolean
function GPrefix.isResult( Recipe, Item )

    --- Validación básica
    if not Recipe then return false end
    if not GPrefix.isTable( Recipe ) then return false end
    if Recipe.type ~= "recipe" then return false end

    local Results = GPrefix.getResults( Recipe ) or { }

    ---Devolver el resultado d ela busqueda
    return GPrefix.inTable( Results, { name = Item } )
end

--- Coloca como resultado de receta la tabla de resultados dada
--- @param Recipe table
--- @param Results Results
--- @return boolean
function GPrefix.setResults( Recipe, Results )

    --- Validación básica
    if not Recipe then return false end
    if not GPrefix.isTable( Recipe ) then return false end
    if Recipe.type ~= "recipe" then return false end

    --- Ubicación de los resutados
    local Tables = { Recipe, Recipe.normal, Recipe.expensive }

    --- Eliminar los resultados
    for _, Table in pairs( Tables ) do
        if not GPrefix.isTable( Table ) then Table = { } end
        Table.result_count = nil
        Table.results = nil
    end


    --- La receta tiene un unico valor
    if not Recipe.normal and not Recipe.expensive then
        Recipe.results = Results
    end

    --- Modificar el precio normal
    if Recipe.normal then
        Recipe.normal.results = Results
    end

    --- Modificar el precio costoso
    if Recipe.expensive then
        Recipe.expensive.results = Results
    end


    --- El proceso finalizó sin problema
    return true
end

--- Obtener los resultados de la receta dada
--- @param Recipe table
--- @param Force? boolean __default: _true___
---- Hacer que los resultados sean contenidos en un único array
--- @return Results | { normal: Results, expensive: Results } | nil #
---- __Array simple:__ Results, Contiene todos los resultados
---- __Array complejo:__ { _normal:_ Results, _expensive:_ Results  }
---- __nil:__ El valor dado no es valido
function GPrefix.getResults( Recipe, Force )

    --- Validación básica
    if not Recipe then return nil end
    if not GPrefix.isTable( Recipe ) then return nil end
    if Recipe.type ~= "recipe" then return nil end
    if GPrefix.isNil( Force ) then Force = true end
    if not GPrefix.isBoolean( Force ) then return nil end

    --- @param Table table
    --- @return Results | nil
    local function getResults( Table )

        --- Array con los resultados de la receta
        --- @type Results
        local Result = { }

        --- @param Item Result
        for _, Item in pairs( Table.results or { } ) do

            --- Bandera para indicar si está en el array
            local Found = GPrefix.inTable( Result, Item )

            --- Guardar el objeto de ser necesario
            if not Found then Result[ #Result + 1 ] = Item end
        end

        --- No se encontró resultado
        if #Result < 1 then return nil end

        --- Devolver los resultados
        return Result
    end

    --- Array con los resultados de la receta
    --- @return Results | { normal: Results, expensive: Results }
    local Result = getResults( Recipe ) or { }
    Result.normal = getResults( Recipe.normal or { } )
    Result.expensive = getResults( Recipe.expensive or { } )

    --- Devolver los resultados
    if not Force then return Result end
    if not Result.normal and not Result.expensive then return Result end

    --- Forzar una respuesta simple
    --- @type Results
    local Results = { }

    --- Recorrer los resultados normales y costoso
    --- @param Array Results
    for _, Array in pairs( Result ) do

        --- Recorrer los objetos
        for _, Item in pairs( Array ) do

            --- Bandera para indicar si está en el array
            local Found = GPrefix.inTable( Results, Item )

            --- Guardar el objeto de ser necesario
            if not Found then Results[ #Results + 1 ] = Item end
        end
    end

    --- Devolver los resultados
    return Results
end

--- Agregar el prefijo del MOD al único resultado de las
--- recetas en la propiedad __ThisMOD.newElements.Recipes__
--- @param ThisMOD ThisMOD
function GPrefix.addPrefixResult( ThisMOD )

    --- Recorrer las recetas del MOD
    for _, Recipes in pairs( ThisMOD.NewRecipes ) do
        for _, Recipe in pairs( Recipes ) do

            --- Contenedor de las variables
            local Table = { }

            --- Cargar los resultados de la receta en una lista
            Table.Results = GPrefix.getResults( Recipe )

            --- La receta no tiene un único resultado
            if #Table.Results ~= 1 then goto JumpRecipe end
            Table.Result = Table.Results[ 1 ]

            --- Eliminar las propiedades incesarias
            Recipe.icon = nil
            Recipe.icons = nil
            Recipe.icon_size = nil
            Recipe.main_product = nil
            Recipe.icon_mipmaps = nil

            --- Cargar los resultados de la receta el formato esperado
            Table.Results = GPrefix.getResults( Recipe, false )
            Table.Array = { Table.Results.normal, Table.Results.expensive }

            --- Concentrar los objetos en una tabla
            for _, Result in pairs( Table.Array ) do
                if GPrefix.isTable( Result ) then
                    table.insert( Table.Results, Result )
                end
            end

            --- Eliminar las tables inecesarias
            Table.Results.expensive = nil
            Table.Results.normal = nil

            --- Recorrer el los resultados
            for _, Item in pairs( Table.Results ) do

                --- Retirar el prefijo del MOD en el nombre del resultado
                local name = GPrefix.Prefix_
                name = string.gsub( name, "-", "%%-" )
                name = string.gsub( Item.name, name, "" )

                --- Hacer el cambios en el nombre del resultado
                Item.name = ThisMOD.Prefix_MOD_ .. name
            end

            --- Recepción del salto
            :: JumpRecipe ::
        end
    end
end



--- Agrega la imagen de referencia del MOD a la receta u objeto dado
--- @param Element table
--- @param ThisMOD ThisMOD
function GPrefix.AddIcon( Element, ThisMOD )

    --- Indicador a agregar
    local Table = { icon = "" }
    Table.icon = Table.icon .. ThisMOD.Patch
    Table.icon = Table.icon .. "icons/status.png"
    Table.icon_size = 32

    --- El indicador del MOD existe
    for _, Icon in pairs( Element.icons ) do
        if Icon.icon == Table.icon then
            return
        end
    end

    --- Se agrega el indicador del MOD
    table.insert( Element.icons, Table )
end

--- Le agrega el prefijo del MOD al elemento dado
--- @param Element table
--- @param ThisMOD? ThisMOD | string
---- __string:__ Se agrega la letra al elemrnto dado
---- __nil:__ Se establece el apodo sin letra
function GPrefix.addLetter( Element, ThisMOD )

    --- Inicializar la variable
    ThisMOD = ThisMOD or "["
    if GPrefix.isString( ThisMOD ) then
        --- @cast ThisMOD -ThisMOD
        ThisMOD = { Char = ThisMOD }
        ThisMOD.Create = true
    end

    --- Crea el apodo para el objeto dado, según si es una entidad,
    --- piso, equipamento o un simple objeto
    --- @param Item table Sólo para los Items
    local function CreateLocalisedName( Item )

        --- Validación básica
        if Item.localised_name then return end

        --- Variables contenedoras
        local element = { }
        local NickName = nil

        --- Objeto de una entidad
        if Item.place_result then
            element = GPrefix.Entities[ Item.place_result ]
            if element and element.localised_name then
                NickName = GPrefix.DeepCopy( element.localised_name )
            elseif element and not element.localised_name then
                NickName = { "entity-name." .. Item.place_result }
            else
                NickName = { "entity-name." .. Item.name }
            end
        end


        --- Objeto de un piso
        if Item.place_as_tile then
            element = GPrefix.Tiles[ Item.place_as_tile ]
            if element and element.localised_name then
                NickName = GPrefix.DeepCopy( element.localised_name )
            elseif element and not element.localised_name then
                NickName = { "title-name." .. Item.place_as_tile }
            else
                NickName = { "item-name." .. Item.name }
            end
        end

        --- Objeto de un equipo
        if Item.placed_as_equipment_result then
            element = GPrefix.Equipaments[ Item.placed_as_equipment_result ]
            if element and element.localised_name then
                NickName = GPrefix.DeepCopy( element.localised_name )
            elseif element and not element.localised_name then
                NickName = { "equipment-name." .. Item.placed_as_equipment_result }
            else
                NickName = { "equipment-name." .. Item.name }
            end
        end

        --- Objeto desconocido
        if not NickName then NickName = { "item-name." .. Item.name } end

        --- Establecer el apodo
        Item.localised_name = NickName
    end

    --- No existe el apodo
    if not Element.localised_name then

        --- Variables contenedoras
        local Type = ""
        local Found = nil

        --- Identificar el elemento
        if GPrefix.Items[ Element.name ] then
            Found = GPrefix.Items[ Element.name ]
            Type = "item"
        end

        if GPrefix.Fluids[ Element.name ] then
            Found = GPrefix.Fluids[ Element.name ]
            Type = "fluid"
        end

        if GPrefix.Entities[ Element.name ] then
            Found = GPrefix.Entities[ Element.name ]
            Type = "entity"
        end

        if GPrefix.Equipaments[ Element.name ] then
            Found = GPrefix.Equipaments[ Element.name ]
            Type = "equipment"
        end

        if Element.type == "tile" and Element.minable then
            Found = GPrefix.Items[ Element.minable.result ]
            Type = "item"
        end

        --- Establecer el apodo
        if Found and Found.localised_name then
            Element.localised_name = GPrefix.DeepCopy( Found.localised_name )
        end

        if Element and Type == "item" then
            CreateLocalisedName( Element )
            Element.localised_name = GPrefix.DeepCopy( Element.localised_name )
        end

        if Found and not Found.localised_name then
            Element.localised_name = { "", { Type .. "-name." .. Element.name }, " [", " ]" }
        end

        if Element and Element.place_result then
            Element.localised_name[ 2 ] = { Type .. "-name." .. Element.place_result }
        end

        --- El elemento es una receta
        repeat

            --- Validación básica
            if Found then break end
            if Element.type ~= "recipe" then break end

            --- Variable contenedora
            local Results = GPrefix.getResults( Element ) or { }

            --- Hay un unico resultado
            if #Results == 1 then
                local ResultType = Results[ 1 ].type == "fluid" and "Fluids" or "Items"
                local Result = GPrefix[ ResultType ][ Results[ 1 ].name ]
                if not GPrefix.isTable( Result ) then break end
                CreateLocalisedName( Result )
                Element.localised_name = GPrefix.DeepCopy( Result.localised_name )
                break
            end

            --- Cargar los posibles elementos
            local Item = GPrefix.Items[ Element.main_product ]
            local Fluid = GPrefix.Fluids[ Element.main_product ]

            --- Crear el apodo del objeto
            if Item and not Item.localised_name then
                CreateLocalisedName( Item )
            end

            --- Apodo existente
            if Item and Item.localised_name then
                Element.localised_name = GPrefix.DeepCopy( Item.localised_name )
            end
            if Fluid and Fluid.localised_name then
                Element.localised_name = GPrefix.DeepCopy( Fluid.localised_name )
            end

            --- Construir el apodo
            if Fluid and not Fluid.localised_name then
                Element.localised_name = { "", { "fluid-name." .. Fluid.name }, " [", " Error", " ]" }
            end
            if not Item and not Fluid then
                Element.localised_name = { "", { "recipe-name." .. Element.name }, " [", " ]" }
            end
        until true
    end

    --- El apodo es un texto
    if not GPrefix.isTable( Element.localised_name ) then
        Element.localised_name = { "", Element.localised_name, " [", " ]" }
    end

    --- El apodo no es contruido
    if Element.localised_name[ 1 ] ~= "" then
        Element.localised_name = { "", Element.localised_name, " [", " ]" }
    end

    --- El apodo es contruido
    local Flag = not GPrefix.getKey( Element.localised_name, " [" )
    if Flag and Element.localised_name[ 1 ] == "" then
        table.insert( Element.localised_name, " [" )
        table.insert( Element.localised_name, " ]" )
    end

    --- Ocultar las maquinas que usa la receta
    if Element.type == "recipe" then
        Element.always_show_made_in = nil
    end

    --- Renombrar la funcion global
    local function addPrefixMOD( Name )
        --- @cast ThisMOD +ThisMOD
        --- @cast ThisMOD -string
        return GPrefix.addPrefixMOD( Name, ThisMOD )
    end

    --- Solo se afecta el apodo
    if ThisMOD.Create then goto JumpPrefix end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Nombre del prototipo
    Element.name = addPrefixMOD( Element.name )

    --- Remplazar el objeto a minar
    if Element.minable and Element.minable.result then
        Element.minable.result = addPrefixMOD( Element.minable.result )
    end

    --- Remplazar la entidad a crear
    if Element.place_result then
        Element.place_result = addPrefixMOD( Element.place_result )
    end

    --- Remplazar el equipamiento a crear
    if Element.placed_as_equipment_result then
        Element.placed_as_equipment_result = addPrefixMOD( Element.placed_as_equipment_result )
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Recepción del salto
    :: JumpPrefix ::

    --- Agregar la letra en su posición
    local Array = Element.localised_name
    if not GPrefix.getKey( Array, " " .. ThisMOD.Char ) then

        --- Agregar la letra
        Position = GPrefix.getKey( Array, " ]" )
        local Index = tonumber( ( Position or "" ) .. "", 10 )
        table.insert( Array, Index, " " .. ThisMOD.Char )

        --- Ordenar las letras
        local Position = GPrefix.getKey( Array, " [" )
        Position = ( Position or 0 ) or 0
        if Position > 0 then
            local Table = { }
            Position = Position + 1
            local Start = Position

            while Array[ Position ] ~= " ]" do
                table.insert( Table, Array[ Position ] )
                Position = Position + 1
            end

            table.sort( Table )
            local End = Start + #Table - 1

            for i = Start, End, 1 do
                Array[ i ] = Table[ i - Start + 1 ]
            end
        end
    end

    --- Borrar las llaves sin letras
    Flag = true and Array[ 3 ] == " ["
    Flag = Flag and Array[ 4 ] == " ]"
    while Flag and table.remove( Array, 3 ) do end
end



--- Eliminar el objero de los prototipos
--- @param Name string Nombre del objeto a eliminar
function GPrefix.RemoveItem( Name )

    --- Encontrar el objeto
    local Item = GPrefix.Items[ Name ]
    if not Item then return end

    --- Eliminar el objeto
    data.raw[ Item.type ][ Item.name ] = nil
    GPrefix.Items[ Name ] = nil

    --- Eliminar la entidad
    if Item.place_result then
        local Entity = GPrefix.Entities[ Item.place_result ]
        data.raw[ Entity.type ][ Entity.name ] = nil
        GPrefix.Entities[ Entity.name ] = nil
    end

    --- Eliminar el piso
    if Item.place_as_tile then
        local Title = GPrefix.Tiles[ Item.place_as_tile ]
        data.raw[ Title.type ][ Title.name ] = nil
        GPrefix.Tiles[ Title.name ] = nil
    end

    --- Eliminar el equipo
    if Item.placed_as_equipment_result then
        local Equipament = Item.placed_as_equipment_result
        Equipament = GPrefix.Equipaments[ Equipament ]
        data.raw[ Equipament.type ][ Equipament.name ] = nil
        GPrefix.Equipaments[ Equipament.name ] = nil
    end
end

--- Crea un subgrupo para el MOD basandose en el objeto dado
--- @param Item table
--- @param ThisMOD ThisMOD
function GPrefix.CreateItemSubgroup( Item, ThisMOD )

    --- Existe el subgrupo
    local SubGroup = GPrefix.addPrefixMOD( Item.subgroup, ThisMOD )
    local newSubGroup = data.raw[ "item-subgroup" ][ SubGroup ]
    if newSubGroup then return end

    --- Crear el subgrupo
    newSubGroup = data.raw[ "item-subgroup" ][ Item.subgroup ]
    newSubGroup = GPrefix.DeepCopy( newSubGroup )
    newSubGroup.order = GPrefix.addPrefixMOD( Item.order, ThisMOD )
    newSubGroup.name = SubGroup
    data:extend( { newSubGroup } )
end



--- Elimina los excesos de espacios, los espacios al inicio y al final
--- @param String string
--- @return string
function GPrefix.trim( String )

    --- Validación básica
    if not GPrefix.isString( String ) then return String end

    --- Eliminar los espacios internos
    String = string.gsub( String, "%s+", " " )

    --- Buscar los espacios de las puntas
    local End = string.len( String )
    local Start = string.find( String, "%s+" )
    local Reverse = string.reverse( String )
    local Result = string.find( Reverse, "%s+" )

    --- Hacer las correciones 
    Start = Start == 1 and 2 or 1
    End = Result == 1 and End - 1 or End

    --- Eliminar los espacios de las puntas
    return string.sub( String, Start, End )
end

--- Separa el nombre del archivo de la URL dada
--- @param URL string _Ejemplo:_ __zzYAIM/mods/pruebas.lua__
--- @return string # _Ejemplo:_ __pruebas__
function GPrefix.getFile( URL )
    if URL == "" then return "" end
    local Start, End = string.find( URL, "/[%w%-]*.lua" )
    if not Start or not End then return URL end
    return string.sub( URL, Start + 1, End - 4 )
end

--- Devolver el ThisMOD correspodiente al URL
--- @param URL string _Ejemplo:_ __zzYAIM/mods/pruebas.lua__
--- @return ThisMOD # _Ejemplo:_ __ThisMOD:__ { Name: "_pruebas_" }
function GPrefix.getThisMOD( URL )
    return GPrefix.MODs[ GPrefix.getFile( URL ) ]
end

--- Agrega el prefijo del MOD a la cadena dada
--- @param String string
--- @param ThisMOD ThisMOD
function GPrefix.addPrefixMOD( String, ThisMOD )

    --- El texto tiene el prefijo
    local hasPrefixMOD = GPrefix.hasPrefixMOD( { name = String }, ThisMOD )
    if hasPrefixMOD then return String end

    --- Agregar el prefijo
    local NewString = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    NewString = string.gsub( String, NewString, "" )
    NewString = ThisMOD.Prefix_MOD_ .. NewString
    return NewString
end

--- Validar sí el nombre del objeto tiene el indicador del MOD dado
--- @param Element table
--- @param ThisMOD ThisMOD
function GPrefix.hasPrefixMOD( Element, ThisMOD )
    local Found = string.find( Element.name, "%-" .. ThisMOD.MOD .. "%-" )
    if Found then return true end
    return false
end



--- Agrega __newRecipe__ a la tecnología que contenga
--- la receta de __oldItem__
--- @param oldItem string Nombre del objeto referencial
--- @param newRecipe string Nombre de la nueva receta
function GPrefix.addTechnology( oldItem, newRecipe )

    --- Variable contenedora
    local Array = { }
    Array.NewRecipe = data.raw.recipe[ newRecipe ]

    Array.Enabled = { }
    table.insert( Array.Enabled, Array.NewRecipe )
    table.insert( Array.Enabled, Array.NewRecipe.normal )
    table.insert( Array.Enabled, Array.NewRecipe.expensive )

    --- Saltar las tecnologías
    if data.raw.resource[ oldItem ] then goto JumpTechnologies end
    if oldItem == "" then goto JumpTechnologies end

    --- Buscar las recetas del objeto
    Array.Recipes = GPrefix.Recipes[ oldItem ]
    if not Array.Recipes then goto JumpTechnologies end

    --- Tecnologías posibles
    Array.Technologies = { }
    Array.Found = { }

    --- Revisar cada receta
    for _, Recipe in pairs( Array.Recipes ) do

        --- Marcar como NO encontrado
        Array.Found[ Recipe.name ] = false

        --- Evitar la receta
        if Recipe.hide_from_player_crafting then
            Array.Found[ Recipe.name ] = true
        end

        --- Revisar las tecnologías
        for _, Technology in pairs( data.raw.technology ) do
            for _, Effect in pairs( Technology.effects or { } ) do

                --- Validar la si hay recetas a desbloquar
                if Effect.type ~= "unlock-recipe" then goto JumpEffect end

                --- Validar si es la receta que se busca
                if Effect.recipe ~= Recipe.name then goto JumpEffect end

                --- Marcar como encontrado
                Array.Found[ Recipe.name ] = true

                --- Esta en la lista
                Array.inList = GPrefix.getKey( Array.Technologies, Technology )
                if Array.inList then goto JumpEffect end

                --- Agregar la tecnología a la lista
                table.insert( Array.Technologies, Technology )

                --- Recepción del salto
                :: JumpEffect ::
            end
        end
    end

    --- No se requiere tecnología
    if #Array.Technologies < 1 then goto JumpTechnologies end

    --- No se requiere tecnología
    Array.Find = GPrefix.Prefix_
    Array.Find = string.gsub( Array.Find, "-", "%%-" )
    for RecipeName, Found in pairs( Array.Found ) do
        if not string.find( RecipeName, Array.Find ) then
            if not Found then goto JumpTechnologies end
        end
    end

    --- Formato para agregar la tecnología
    Array.NewEffect = { }
    Array.NewEffect.type = "unlock-recipe"
    Array.NewEffect.recipe = newRecipe

    --- Deshabilitar la receta
    for _, Table in pairs( Array.Enabled ) do
        if not GPrefix.isTable( Table ) then Table = { } end
        if Table.ingredients then Table.enabled = false end
    end

    --- Agregar la receta a las tecnologias
    for _, Technology in pairs( Array.Technologies ) do
        table.insert( Technology.effects, Array.NewEffect )
    end if true then return end

    --- Recepción del salto
    :: JumpTechnologies ::

    --- No se requiere una tecnología
    for _, Table in pairs( Array.Enabled ) do
        if not GPrefix.isTable( Table ) then Table = { } end
        if Table.ingredients then Table.enabled = true end
    end
end

--- Remuve la receta de las tecnologías y del juego
--- @param Recipe string Nombre de la receta a eliminar
function GPrefix.DeleteRecipeOfTechnologies( Recipe )

    --- Variable contenedora
    local Table = { }

    --- Validación básica
    if not GPrefix.isString( Recipe ) then return end
    Recipe = data.raw.recipe[ Recipe ]
    if not Recipe then return end
    if not GPrefix.isTable( Recipe ) then return end
    Table.Technologies = data.raw.technology

    --- Cargar los indices de las recestas
    Table.Keys = { }
    for Key, _ in pairs( Table.Technologies ) do
        table.insert( Table.Keys, Key )
    end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Eliminar los prototipos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Eliminar el prototipo
    data.raw.recipe[ Recipe.name ] = nil

    --- Inicializar las variables
    Table.Deleted = { }
    Table.Results = GPrefix.getResults( Recipe )

    --- Validar los resultados
    for _, Item in pairs( Table.Results or { } ) do
        local _Recipes = GPrefix.Recipes[ Item.name ] or { }
        for _Key, _Recipe in pairs( _Recipes ) do
            if _Recipe.name == Recipe.name then
                table.insert( Table.Deleted, 1, {
                    name = Item.name, Key = _Key
                } )
            end
        end
    end

    --- Eliminar las recetas del listado
    for _, Array in pairs( Table.Deleted ) do
        table.remove( GPrefix.Recipes[ Array.name ], Array.key )
        if #GPrefix.Recipes[ Array.name ] < 1 then
            GPrefix.Recipes[ Array.name ] = nil
        end
    end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Eliminar la receta de las tecnologias
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Revisar las tecnologías
    while true do

        --- Siguiente tecnología
        Table.iTechnologies = Table.iTechnologies or 0
        Table.iTechnologies = Table.iTechnologies + 1
        if Table.iTechnologies > #Table.Keys then break end

        --- Cargar los detalles
        Table.Key = Table.Keys[ Table.iTechnologies ]
        Table.Technology = Table.Technologies[ Table.Key ]
        Table.Effects = Table.Technology.effects or { }
        Table.iEffect = 1

        while true do

            --- Validación básica
            if Table.iEffect > #Table.Effects then break end
            Table.Effect = Table.Effects[ Table.iEffect ]

            --- Validar la si hay recetas a desbloquar
            Table.Found = Table.Effect and Table.Effect.type == "unlock-recipe"
            if not Table.Found then Table.iEffect = Table.iEffect + 1 end
            if not Table.Found then goto JumpEffect end

            --- No es la receta que se busca
            Table.Found = Table.Effect.recipe == Recipe.name
            if not Table.Found then Table.iEffect = Table.iEffect + 1 end
            if not Table.Found then goto JumpEffect end

            --- Eliminar la receta de la tecnología
            table.remove( Table.Effects, Table.iEffect )

            --- Eliminar los indicadores vacío
            if #Table.Effects < 1 then Table.Effects = nil end

            --- Recepción del salto
            :: JumpEffect ::
        end
    end
end



--- Funciones para agregar informacion al juego
--- @param Type string
--- @param Table table
--- @param ThisMOD ThisMOD
function GPrefix.addPrototype( Type, Table, ThisMOD )

    --- Agregar la letra
    if ThisMOD then GPrefix.addLetter( Table, ThisMOD ) end

    --- Guardar los que NO son suelos
    if Type ~= "Tiles" then
        GPrefix[ Type ][ Table.name ] = Table
    end

    --- Guardar los suelos
    if Type == "Tiles" then
        local Tiles = GPrefix[ Type ][ Table.name ] or { }
        GPrefix[ Type ][ Table.name ] = Tiles
        table.insert( Tiles, Table )
    end

    --- Guardar el prototipo
    data:extend( { Table } )
end

--- Agregar un prototipo de una receta
--- @param NewRecipe table
--- @param ThisMOD ThisMOD
function GPrefix.addRecipe( NewRecipe, ThisMOD )

    --- Variable contenedora
    local Recipes = { NewRecipe, NewRecipe.normal, NewRecipe.expensive }

    --- Validar si la receta esta oculta
    for _, Recipe in pairs( Recipes ) do
        if not GPrefix.isTable( Recipe ) then Recipe = { } end
        if Recipe.hidden then return end
        local key = GPrefix.getKey( Recipe.flags, "hidden" ) or 0
        if key > 0 then return end
    end

    --- Agregar la letra a la nueva receta
    if ThisMOD then GPrefix.addLetter( NewRecipe, ThisMOD ) end

    --- Cargar los resultados de la receta
    local Results = GPrefix.getResults( NewRecipe ) or { }

    --- Recorrer los resultados
    for Recipe, Result in pairs( Results ) do

        --- Crear el espacio para las recetas
        Recipes = GPrefix.Recipes
        Recipe = Recipes[ Result.name ] or { }
        Recipes[ Result.name ] = Recipe

        --- Guardar la receta
        if not GPrefix.inTable( Recipe, NewRecipe ) then
            table.insert( Recipe, NewRecipe )
        end
    end

    --- Cargar el prototipo al juego
    data:extend( { NewRecipe } )
end

--- Cargar al juego los prototipos en _ThisMOD.New *_
--- @param ThisMOD ThisMOD
function GPrefix.CreateNewElements( ThisMOD )

    --- Darle formato a la recetas antes de agregarla al juego
    if GPrefix.getLength( ThisMOD.NewRecipes ) > 0 then
        for _, Recipes in pairs( ThisMOD.NewRecipes ) do
            for _, Recipe in pairs( Recipes ) do
                Private.FormatRecipe( Recipe )
            end
        end
    end

    --- Aplicar los los efectos de los MODs
    --- activados a en los nuevos elementos
    for _, TheMOD in pairs( GPrefix.MODs ) do
        if TheMOD.DoEffect then
            TheMOD.DoEffect( ThisMOD )
        end
    end

    --- Recorrer los prototipos
    for Type, Prototypes in pairs( ThisMOD.NewElements ) do

        --- Validación básica
        if GPrefix.getLength( Prototypes ) < 1 then goto JumpType end
        if string.find( Type, "NewRecipes" ) then goto JumpType end
        if string.find( Type, "NewTiles" ) then goto JumpType end

        --- Cargar los prototipos
        for _, Prototype in pairs( Prototypes ) do
            local _Type = string.sub( Type, 4 )
            GPrefix.addPrototype( _Type, Prototype, ThisMOD )
        end

        --- Recepción del salto
        :: JumpType ::
    end

    --- Cargar los pisos
    if GPrefix.getLength( ThisMOD.NewTiles ) > 0 then
        for _, Tiles in pairs( ThisMOD.NewTiles ) do
            for _, Title in pairs( Tiles ) do
                GPrefix.addPrototype( "Tiles", Title, ThisMOD )
            end
        end
    end

    --- Cargar las recetas
    if GPrefix.getLength( ThisMOD.NewRecipes ) > 0 then
        for ItemName, Recipes in pairs( ThisMOD.NewRecipes ) do
            for _, Recipe in pairs( Recipes ) do
                GPrefix.addRecipe( Recipe, ThisMOD )
                GPrefix.addTechnology( ItemName, Recipe.name )
            end
        end
    end
end

--- Crea un duplicado del elemento indicado y
--- lo deja listo para ser cargado en NewElements
--- @param Item string|table
--- @param ThisMOD ThisMOD
function GPrefix.DuplicateItem( Item, ThisMOD )

    --- Contenedor principal
    local Output = { }

    --- Validación básica
    if GPrefix.isString( Item ) then
        Item = GPrefix.Items[ Item ] or ThisMOD.NewItems[ Item ]
    end local OldItem = Item
    Item = GPrefix.DeepCopy( Item )
    if not Item then return end
    if not GPrefix.isTable( Item ) then return end
    if not Item.name then return end
    GPrefix.addLetter( Item, ThisMOD )

    --- Evitar la sobre escritura inecesarias
    local NewItems = ThisMOD.NewItems
    if NewItems[ Item.name ] then return end

    --- Buscar en los prototipos de MOD
    local function NewRecipes(  )
        local List = { }
        table.insert( List, OldItem.name )
        for _, _Recipes in pairs( ThisMOD.NewRecipes ) do
            for _, _Recipe in pairs( _Recipes ) do
                local Results = GPrefix.getResults( _Recipe )
                for _, Result in pairs( Results or { } ) do
                    if Result.name == OldItem.name then
                        table.insert( List, _Recipe.name )
                        break
                    end
                end
            end
        end

        for _, _Recipes in pairs( ThisMOD.NewRecipes ) do
            for _, _Recipe in pairs( _Recipes ) do
                local Results = GPrefix.getResults( _Recipe )
                for _, Result in pairs( Results or { } ) do
                    if Result.name == OldItem.name then
                        return { _Recipe }
                    end
                end
            end
        end
    end

    --- Duplicar la receta
    local Recipe = GPrefix.Recipes[ OldItem.name ] or ThisMOD.NewRecipes[ OldItem.name ]
    if not Recipe then Recipe = NewRecipes( ) end
    if not Recipe then return end Recipe = Recipe[ 1 ]
    local Recipes = ThisMOD.NewRecipes[ Recipe.name ] or { }
    ThisMOD.NewRecipes[ Recipe.name ] = Recipes
    Recipe = GPrefix.DeepCopy( Recipe )
    GPrefix.addLetter( Recipe, ThisMOD )
    table.insert( Recipes, Recipe )
    Recipe.main_product = nil
    Output.Recipes = Recipes

    --- Duplicar el suelo
    local Tile = OldItem.place_as_tile
    local TileName = Tile
    if not Tile then goto JumpTitle end
    Tile = GPrefix.Tiles[ Tile ] or ThisMOD.NewTiles[ Tile ]
    Tile = GPrefix.DeepCopy( Tile ) or { }
    for _, value in pairs( Tile ) do
        GPrefix.addLetter( value, ThisMOD )
    end ThisMOD.NewTiles[ TileName ] = Tile
    Output.Tile = Tile
    :: JumpTitle ::

    --- Duplicar la entidad
    local Entity = OldItem.place_result
    if not Entity then goto JumpEntity end
    Entity = GPrefix.Entities[ Entity ] or ThisMOD.NewEntities[ Entity ]
    Entity = GPrefix.DeepCopy( Entity )
    GPrefix.addLetter( Entity, ThisMOD )
    ThisMOD.NewEntities[ Entity.name ] = Entity
    Output.Entity = Entity
    :: JumpEntity ::

    --- Duplicar el equipamento
    local Equipament = OldItem.placed_as_equipment_result
    if not Equipament then goto JumpEquipament end
    Equipament = GPrefix.Equipaments[ Equipament ] or ThisMOD.NewEquipaments[ Equipament ]
    Equipament = GPrefix.DeepCopy( Equipament )
    GPrefix.addLetter( Equipament, ThisMOD )
    ThisMOD.NewEquipaments[ Equipament.name ] = Equipament
    Output.Equipament = Equipament
    :: JumpEquipament ::

    --- Guardar el resultado
    ThisMOD.NewItems[ Item.name ] = Item
    Output.Item = Item

    --- Devolver los nuevos valores
    return Output
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Function para la construción de los MODs
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Crea y carga los datos para crear la configuración
--- @param ThisMOD ThisMOD
--- @param Type? string __Type: _"int | bool" - Defaul: "bool"___ Se debe elegir el tipo de opción
function GPrefix.CreateSetting( ThisMOD, Type )
    local FileValid = { "settings-final-fixes" }
    local Active = GPrefix.getKey( FileValid, GPrefix.File ) or 0
    if Active < 1 then return end

    --- Propiedades básicas
    local SettingOption =  { }
    SettingOption.name  = ThisMOD.Prefix_MOD
    SettingOption.order = ThisMOD.Char
    SettingOption.setting_type = "startup"

    if not Type or ( Type and Type == "bool" ) then
        SettingOption.type = "bool-setting"
        SettingOption.default_value  = true
        SettingOption.allowed_values = { "true", "false" }
    end

    if Type and Type == "int" then
        SettingOption.type = "int-setting"
        SettingOption.default_value = 1000
        SettingOption.minimum_value = 1
        SettingOption.maximum_value = 65000
    end

    --- Nombre visible
    local Name = { }
    table.insert( Name, "" )
    table.insert( Name, { GPrefix.Local .. "setting-char", ThisMOD.Char } )
    table.insert( Name, { ThisMOD.Local .. "setting-name" } )
    SettingOption.localised_name = Name

    --- Cargar los datos
    data:extend( { SettingOption } )

    --- El MOD no tiene requisitos
    if GPrefix.getLength( ThisMOD.Requires ) < 1 then return end

    --- Cargar las letras de los requisitos
    local Letters = { }
    for _, Required in pairs( ThisMOD.Requires ) do
        table.insert( Letters, Required.Char )
    end

    --- Establecer el nuevo nombre
    local Base = GPrefix.Local .. "setting-require"
    Name = { Base, Name, table.concat( Letters, " " ) }
    SettingOption.localised_name = Name
end

--- Valida si el MOD esta activo y listo para usarse
--- @param ThisMOD ThisMOD
--- @param Table table Lista de los archivos validos
function GPrefix.isActive( ThisMOD, Table )
    if not GPrefix.getKey( Table, GPrefix.File ) then return false end
    for _, Required in pairs( ThisMOD.Requires ) do
        if not Required.Active then return false end
    end if not ThisMOD.Active then return false end
    return true
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Function de uso en tiempo de ejecución
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Contenedor de los valores y funciones para
--- para los eventos de ejecución automatica
Private.Automatic = { }

--- Agregar la función dada a la correspodiente lista de eventos
--- automaticos, se ejecutar 60 veces cada segundo
--- @param NewEvent AutomaticEvent
function GPrefix.addAutomaticFunction( NewEvent )

    --- Separar el contenedor
    local Data = NewEvent.Data or { }

    --- Inicializar el indicador
    local Index = ""
    if Index == "" and Data.Player then
        Index = "PlayerID: " .. Data.Player.index
    end

    if Index == "" and Data.Force then
        Index = "ForceID: " .. Data.Force.index
    end

    --- Crear el espacio para los eventos
    local Events = Private.Automatic.Events or { }
    Private.Automatic.Events = Events

    --- Crear y renombrar la variable
    local Event = Events[ Index ] or { }
    Events[ Index ] = Event

    --- Verificar si se agregó con aterioridad
    --- @param OldEvent AutomaticEvent
    for _, OldEvent in pairs( Event ) do
        if OldEvent.Name == NewEvent.Name then
            return
        end
    end

    --- Cargar los valores por defecto
    if GPrefix.isNil( NewEvent.Infinite ) then
        NewEvent.Infinite = true
    end NewEvent.Index = Index

    --- Guardar la función
    table.insert( Event, NewEvent )
end

--- Agregar la información a la lista a traducción
---@param DataToTranslated DataToTranslated
function GPrefix.addLocalisedToTranslated( DataToTranslated )

    --- Dar el formato deseado
    if GPrefix.isString( DataToTranslated.Localised ) then
        DataToTranslated.Localised = { DataToTranslated.Localised }
    end

    --- Inicializar la variable
    local Received = game.table_to_json( DataToTranslated.Localised )
    local Expected = game.table_to_json( { "locale-identifier" } )

    --- Listado de texto que se desea traducir y aún no se pide traducir
    local Queues = Private.Automatic.Queues or { }
    Private.Automatic.Queues = Queues

    --- Añade los datos a la lista
    local function AddToQueue( Queue, Data )

        --- Validación básica
        if not Queue[ 1 ] then table.insert( Queue, { } ) end

        --- Peticiones por Ticks
        local TickRequest = 25

        --- Validar si se llegó al limite
        if #Queue[ 1 ] >= TickRequest then
            table.insert( Queue, 1, { } )
        end

        --- Agregar datos a la lista
        table.insert( Queue[ 1 ], Data )
    end

    --- Se esta traduciendo el idioma del jagador
    if Received == Expected then
        Queues.Language = Queues.Language or { }
        AddToQueue( Queues.Language, DataToTranslated )
    end

    --- Se esta traduciendo un texto cualquiera
    if Received ~= Expected then
        AddToQueue( Queues, DataToTranslated )
    end
end

--- Agrega un evento a la lista de eventos del juego,
--- como por __Ejemplo:__ _defines.events.on_gui_click_
--- @param Event Event
function GPrefix.addEventOnControl( Event )
    if not Event.Name and Event.ID then Event.Name = "on_event" end

    --- Variable contenedora
    local Container = GPrefix.Script

    --- Crear la estructura
    for _, Value in pairs( { Event.Name, Event.ID } ) do
        Container[ Value ] = Container[ Value ] or { }
        Container = Container[ Value ]
    end

    --- Incertar los parametros
    table.insert( Container, Event.Function )
end

--- Crea un consolidado de variables para usar en tiempo de ejecuión
--- @param Event table
--- @param ThisMOD ThisMOD
--- @return Data
function GPrefix.CreateData( Event, ThisMOD )

    --- Contenedor de variable
    local Temporal = { }

    --- Variable de salida
    --- @type Data
    local Data = { }
    Data.Event = Event

    --- Identificar al jugador
    Data.Player = Event.Player
    if Event.player_index then Data.Player = game.get_player( Event.player_index ) end

    --- El grupo al cual pertenece el jugador está en el evento dado
    Data.Force = Data.Event.force or nil

    --- El grupo al cual pertenece el jugador está en el jugador
    if Data.Player and not GPrefix.isString( Data.Player.force ) then
        Data.Force = Data.Player.force
    end

    --- El grupo al cual pertenece el jugador se debe buscar busca
    if Data.Player and GPrefix.isString( Data.Player.force ) then
        Data.Force = game.forces[ Data.Player.force ]
    end

    --- No se tiene un jugador
    if not Data.Player then goto Jump1 end

    --- Crea la variable si aún no ha sido creada
    Temporal.Click = GPrefix

    Temporal.Click.Click = Temporal.Click.Click or { }
    Temporal.Click = Temporal.Click.Click

    Temporal.Click.Players = Temporal.Click.Players or { }
    Temporal.Click = Temporal.Click.Players

    --- Guardar el espacio para los clic del jugador no guardable
    Temporal.Click[ Data.Player.index ] = Temporal.Click[ Data.Player.index ] or { }
    Temporal.Click = Temporal.Click[ Data.Player.index ]
    Data.Click = Temporal.Click

    --- Espacio no guardable
    ThisMOD.Players = ThisMOD.Players or { }
    Temporal.Players = ThisMOD.Players

    --- Espacio no guardable del jugador
    Temporal.Players[ Data.Player.index ] = Temporal.Players[ Data.Player.index ] or { }
    Data.GPlayer = Temporal.Players[ Data.Player.index ]

    --- Espacio para el GUI
    Data.GPlayer.GUI = Data.GPlayer.GUI or { }
    Data.GUI = Data.GPlayer.GUI

    --- Recepción del salto
    :: Jump1 ::

    --- Contenedor para valores temporales
    Data.Temporal = { }

    --- Espacio guardable es para TODOS los MODs
    global[ GPrefix.Prefix ] = global[ GPrefix.Prefix ] or { }
    Data.gPrefix = global[ GPrefix.Prefix ]

    --- Espacio guardable para este MOD
    Data.gPrefix[ ThisMOD.Name ] = Data.gPrefix[ ThisMOD.Name ] or { }
    Data.gMOD = Data.gPrefix[ ThisMOD.Name ]

    --- No se tiene un jugador
    if not Data.Player then goto Jump2 end

    --- Espacio guardable para el jugador
    Data.gMOD.Players = Data.gMOD.Players or { }
    Temporal.Players = Data.gMOD.Players

    Temporal.Players[ Data.Player.index ] = Temporal.Players[ Data.Player.index ] or { }
    Data.gPlayer = Temporal.Players[ Data.Player.index ]

    --- Cargar la traducciones
    Temporal.Index = Data.Player.index
    ThisMOD.Languages = ThisMOD.Languages or nil
    Temporal.Languages = ThisMOD.Languages or { }
    Temporal.Players = Temporal.Languages.Players or { }
    Temporal.Language = Temporal.Players[ Temporal.Index ] or ""
    Data.Language = Temporal.Languages[ Temporal.Language ]

    --- Recepción del salto
    :: Jump2 ::

    --- Crear el espacio para los forces
    Data.gMOD.Forces = Data.gMOD.Forces or { }
    Data.gForce = Data.gMOD.Forces

    ThisMOD.Forces = ThisMOD.Forces or { }
    Data.GForce = ThisMOD.Forces

    --- Crear el espacio para un forces
    Data.gForce[ Data.Force.index ] = Data.gForce[ Data.Force.index ] or { }
    Data.gForce = Data.gForce[ Data.Force.index ]

    Data.GForce[ Data.Force.index ] = Data.GForce[ Data.Force.index ] or { }
    Data.GForce = Data.GForce[ Data.Force.index ]

    --- Devolver el consolidado de los datos
    return Data
end



--- Validar si se dió clic con el botón de la izquierda
--- @param Data Data
--- @return boolean
function GPrefix.ClickLeft( Data )

    --- Renombrar la variable
    local Element = Data.Event.element
    local Event = Data.Event

    --- Validación básica
    Event.tick = Event.tick or game.tick
    if not Element.valid then return false end
    local ButtonLeft = defines.mouse_button_type.left
    if Event.button ~= ButtonLeft then return false end
    if Data.Click.Tick and Data.Click.Tick == Event.tick then return true end

    --- Guardar datos del clic
    if not Data.Element or Data.Element ~= Element then
        Data.Tick = Data.Tick or game.tick
        Data.Element = Element
    end

    --- Es un clic izquierdo
    return true
end

--- Validar si se dió clic con el botón de la derecho
--- @param Data Data
--- @return boolean
function GPrefix.ClickRight( Data )

    --- Renombrar la variable
    local Element = Data.Event.element
    local Event = Data.Event

    --- Validación básica
    if not Element.valid then return false end
    local ButtonRight = defines.mouse_button_type.right
    if Event.button ~= ButtonRight then return false end

    --- Es un clic derecho
    return true
end

--- Validar si se dió doble clic con el botón de la izquierda
--- @param Data Data
--- @return boolean
function GPrefix.ClickDouble( Data )

    --- El clic no es izquierdo
    if not GPrefix.ClickLeft( Data ) then return false end

    --- Tiempo entre clic
    local Time = Data.Event.tick - Data.Click.Tick

    --- El evento es el mismo
    if Time == 0 then return false end

    --- Doble clic muy lento
    if Time > 15 then
        Data.Click.Tick = Data.Event.tick
        return false
    end

    --- Es un doble clic
    return true
end

--- Hacer que el botón tenga el efecto de mantenerse presionado
--- @param Button table
function GPrefix.ToggleButton( Button )

    --- Renombrar la variable
    local Tags = Button.tags

    --- Hacer el cambio
    local Activated = Button.style.name == Tags.Disabled
    Button.style = ( Activated and Tags.Enabled or Tags.Disabled )
    if Tags.Size then Button.style.size = Tags.Size end
    Button.style.margin = 0
    Button.style.padding = 0

    --- Imagenes usadas en el botón cuando esta activado
    if Activated and Tags.White then Button.sprite         = Tags.White end
    if Activated and Tags.Black then Button.hovered_sprite = Tags.Black end
    if Activated and Tags.Black then Button.clicked_sprite = Tags.Black end

    --- Imagenes usadas en el botón cuando esta desactivado
    if not Activated and Tags.White then Button.sprite         = Tags.Black end
    if not Activated and Tags.Black then Button.hovered_sprite = Tags.White end
    if not Activated and Tags.Black then Button.clicked_sprite = Tags.White end
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Function de uso interno
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Con solida las imagenes en una variable
--- @param Element table
function Private.CreateIcons( Element )

    --- No hace falta crear la tabla
    if Element.icons then return end

    --- Crear la nueva tabla
    local Icon = { }
    Icon.icon = Element.icon
    Icon.icon_size = Element.icon_size
    Icon.icon_mipmaps = Element.icon_mipmaps

    --- Hacer el cambio
    Element.icon = nil
    Element.icons = { Icon }
end



--- Funcion que ejecuta las funciones automaticas
function Private.StartAutomatic( )

    --- No hay funciones a ejecutar
    if not Private.Automatic.Events then return end

    --- Directorio de eventos a ejecutar
    --- @type { [ integer ]: AutomaticEvent }
    local Events = Private.Automatic.Events

    --- Lista de funciones a eliminar
    local toDelete = { }

    --- Ejecutar las fuciones deseada
    for i, Value in pairs( Events ) do
        for j, Event in pairs( Value ) do
            if Event.Data then Event.Data.Automatic = Event end
            local Return = Event.Function( Event.Data )
            if not Event.Infinite and Return then
                table.insert( toDelete, 1, { i = i, j = j } )
            end
        end
    end

    --- Eliminar las funciones indicadas
    for _, Array in pairs( toDelete ) do
        local Event = Events[ Array.i ]
        table.remove( Event, Array.j )
        if #Event < 1 then Events[ Array.i ] = nil end
    end

    --- Eliminar la variable vacía
    if GPrefix.getLength( Events ) < 1 then
        Private.Automatic.Events = nil
    end
end

--- Traducir el texto en cola
function Private.TranslationLocalised( )

    --- Validación básica
    if not Private.Automatic.Queues then return end
    local Queues = Private.Automatic.Queues or { }

    --- Contenedor de texto que se ha solicitado traducir y
    --- se espera la traducción
    local OnWaiting =  Private.Automatic.OnWaiting or { }
    Private.Automatic.OnWaiting = OnWaiting

    --- Se solcita la tradución del idioma del jugador
    if Queues.Language then
        local Language = table.remove( Queues.Language )
        OnWaiting.Language = OnWaiting.Language or { }
        if #Queues.Language < 1 then Queues.Language = nil end
        --- @param Data DataToTranslated
        for _, Data in pairs( Language ) do
            table.insert( OnWaiting.Language, Data )
            Data.Player.request_translation( Data.Localised )
        end return
    end

    --- Se solcita la tradución del un texto cualquiera
    local Element = table.remove( Queues )
    if #Queues < 1 then Private.Automatic.Queues = nil end
    --- @param Data DataToTranslated
    for _, Data in pairs( Element ) do
        table.insert( OnWaiting, Data )
        Data.Player.request_translation( Data.Localised )
    end
end



--- Función que recibe la traducción
function Private.TranslatedString( Event )

    --- Validación básica
    if not Private.Automatic.OnWaiting then return end

    --- Inicializar las variables
    local Data = { }
    Data.Event = Event
    Data.Player = game.get_player( Event.player_index )
    Data.Received = game.table_to_json( Event.localised_string )
    local Expected = game.table_to_json( { "locale-identifier" } )
    local OnWaiting = Private.Automatic.OnWaiting

    --- Se esta traduciendo el idioma del jagador
    if Data.Received ~= Expected then goto JumpLanguage end
    if not OnWaiting.Language then goto JumpLanguage end
    Data.OnWaiting = OnWaiting.Language
    Private.setLanguage( Data )
    if true then return end
    :: JumpLanguage ::

    --- Se esta traduciendo el texto cualquiera
    if not OnWaiting then goto JumpLocalised end
    Data.OnWaiting = OnWaiting
    Private.SaveTranslate( Data )
    if true then return end
    :: JumpLocalised ::
end

--- Asingnar el lenguaje y obrar en consecuencia
function Private.setLanguage( Data )

    --- Ubicar la traducción
    Private.getDataToTranslated( Data )

    --- Traducción no esperada
    if not Data.DataToTranslated then return end

    --- Renombrar la variable
    local Event = Data.Event
    local ThisMOD = Data.DataToTranslated.ThisMOD
    local Index = Event.player_index

    --- Crear el espacio para las traducciones
    local Languages = ThisMOD.Languages or { }
    ThisMOD.Languages = Languages

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Idioma no identificado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    if not Event.translated then
        Languages.Players = Languages.Players or { }
        Languages.Players[ Index ] = { }
        return
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Idioma identificado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Inicializar las variables
    local Deleted = { }

    --- Asignar un idioma al jugador
    local Language = Languages[ Event.result ] or { }
    Languages[ Event.result ] = Language

    --- Asignar el idioma al jugador
    Languages.Players = Languages.Players or { }
    Languages.Players[ Index ] = Language

    --- Idioma sin traducciones
    if #Language < 1 then return end

    --- Buscar los texto ya traducidos de este idioma
    --- @type { [ integer ]: DataToTranslated }
    local OnWaiting = Private.Automatic.OnWaiting
    for Key = 1, #OnWaiting, 1 do

        --- Renombrar la variable
        local DataToTranslated = OnWaiting[ Key ]
        local Player = DataToTranslated.Player.index == Event.player_index
        local MOD = DataToTranslated.ThisMOD.Name == ThisMOD.Name
        local JSON = game.table_to_json( DataToTranslated.Localised )
        local Translated = Language[ JSON ] and true or false

        --- Verificar que sea la traducción que se busca
        if Player and MOD and Translated then
            table.insert( Deleted, 1, Key )
        end
    end

    --- Eliminar los textos ya traducidos de la lista
    for _, Key in pairs( Deleted ) do
        Private.Remove( { Key = Key, OnWaiting = OnWaiting } )
    end
end

--- Guardar la traducción en su lugar
function Private.SaveTranslate( Data )

    --- Ubicar la traducción
    Private.getDataToTranslated( Data )

    --- Traducción no esperada
    if not Data.DataToTranslated then return end

    --- Renombrar la variable
    local Event = Data.Event
    local ThisMOD = Data.DataToTranslated.ThisMOD
    local Index = Event.player_index

    --- Cargar el idimo del jagador
    local Languages = ThisMOD.Languages or { }
    ThisMOD.Languages = Languages

    local Players = Languages.Players or { }
    Languages.Players = Players

    local Language = Players[ Index ] or { }
    Players[ Index ] = Language

    --- Inicializar las variables
    local JSON = game.table_to_json( Data.DataToTranslated.Localised )

    --- Guardar la traducción
    Language[ JSON ] = Event.translated and GPrefix.trim( Event.result ) or JSON

    --- Eliminar el elemento de la lista
    Private.Remove( Data )
end

--- Buscar la traducción en la lista de traducción
function Private.getDataToTranslated( Data )

    --- Renombrar la variable
    --- @param Key integer
    --- @param DataToTranslated DataToTranslated
    for Key, DataToTranslated in pairs( Data.OnWaiting ) do
        local Expected = game.table_to_json( DataToTranslated.Localised )
        local Player = DataToTranslated.Player == Data.Player
        local Localised = Expected == Data.Received

        --- Verificar que sea la traducción que se busca
        if Player and Localised then   Data.Key = Key
            Data.DataToTranslated = DataToTranslated
            return
        end
    end
end

--- Eliminar el texto traducidor
--- _{ Key = __Index__, OnWaiting = __List__ }_
function Private.Remove( Data )

    --- Elemento encontrado
    if not Data.Key then return end
    if not Data.OnWaiting then return end

    --- Remover el elemento de la tabla
    table.remove( Data.OnWaiting, Data.Key )
    Data.DataToTranslated = nil

    --- Validar si se espera más texto por traducir en la lista
    if #Data.OnWaiting > 0 then return end

    --- Eliminar la tabla vacia
    local Table = Private.Automatic
    if Data.OnWaiting == Table.OnWaiting.Language then Table.OnWaiting.Language = nil end
    if Data.OnWaiting == Table.OnWaiting then Table.OnWaiting = nil end
end



--- Dar un único formato a las recetas
--- @param Recipe table
function Private.FormatRecipe( Recipe )

    --- Validación básica
    if not Recipe then return end
    if not GPrefix.isTable( Recipe ) then return end
    if Recipe.type ~= "recipe" then return end

    --- Ubicación de los resutados
    local Tables = { Recipe, Recipe.normal, Recipe.expensive }

    --- Eliminar los resultados
    for _, Table in pairs( Tables ) do
        if not GPrefix.isTable( Table ) then Table = { } end

        --- Variable contenedora
        --- @type ItemResult
        local Item = nil

        --- Dar formato a los resultados
        if Table.results then
            for key, value in pairs( Table.results ) do
                if value.name and not value.type then value.type = "item" end
                if not value[ 1 ] then goto JumItem end

                --- Cargar la informacion en el formato deseado
                Item = { }
                Item.type = "item"
                Item.name = value[ 1 ]
                Item.amount = value[ 2 ]

                --- Guardar el objeto con el formato deseado
                Table.results[ key ] = Item

                --- Recepción del salto
                :: JumItem ::
            end
        end

        --- Dar formato al único resultado
        if Table.result then

            --- Cargar la informacion en el formato deseado
            Item = { }
            Item.type = "item"
            Item.name = Table.result
            Item.amount = Table.result_count or 1

            --- Guardar el objeto con el formato deseado
            Table.results = { Item }

            --- Iliminar los valor iniciales
            Table.result = nil
            Table.result_count = nil
        end

        --- Dar formato a los ingredientes
        for key, value in pairs( Table.ingredients or { } ) do
            if value.name and not value.type then value.type = "item" end
            if not value[ 1 ] then goto JumItem end

            --- Cargar la informacion en el formato deseado
            Item = { }
            Item.type = "item"
            Item.name = value[ 1 ]
            Item.amount = value[ 2 ]

            --- Guardar el objeto con el formato deseado
            Table.ingredients[ key ] = Item

            --- Recepción del salto
            :: JumItem ::
        end

        --- Eliminar las tablas incesarias
        if not Table.ingredients then
            Table.results = nil
        end
    end
end

--- Clasificar la información de data.raw
function Private.LoadData( )

    --- Contenedor de los elementos
    GPrefix.Items = { }
    GPrefix.Tiles = { }
    GPrefix.Fluids = { }
    GPrefix.Recipes = { }
    GPrefix.Entities = { }
    GPrefix.Equipaments = { }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Agregar el item a GPrefix.Items
    local function addItem( item )

        --- Objeto no apilable
        if not item.stack_size then return end

        --- Objeto oculto
        local Hidden = item.hidden
        Hidden = Hidden or GPrefix.getKey( item.flags, "hidden" )
        Hidden = Hidden or GPrefix.getKey( item.flags, "spawnable" )
        if Hidden then return end

        --- Guardar objeto
        GPrefix.Items[ item.name ] = item

        --- Guardar suelo de no estarlo
        if item.place_as_tile and not GPrefix.Tiles[ item.name ] then
            local tile = data.raw.tile[ item.place_as_tile.result ]
            GPrefix.Tiles[ item.name ] = { tile }
        end

        --- Guardar la entidad
        if item.place_result then

            --- Entidad con nombre igual al objeto
            if item.place_result == item.name then
                GPrefix.Entities[ item.name ] = true
            end

            --- Entidad con nombre distinto al objeto
            if item.place_result ~= item.name then
                GPrefix.Entities[ item.place_result ] = true
                GPrefix.Entities[ item.name ] = item.place_result
            end
        end

        --- Guardar el equipable
        if item.placed_as_equipment_result then
            GPrefix.Equipaments[ item.name ] = item.placed_as_equipment_result
        end
    end

    --- Agregar la receta a GPrefix.Recipes
    local function addRecipe( recipe )

        --- Darle el formato deseado a la receta
        Private.FormatRecipe( recipe )

        --- Variable contenedora
        local Recipes = { recipe, recipe.normal, recipe.expensive }

        --- Validar si la receta esta oculta
        for _, Recipe in pairs( Recipes ) do
            if not GPrefix.isTable( Recipe ) then Recipe = { } end
            if Recipe.hidden then return end
            local key = GPrefix.getKey( Recipe.flags, "hidden" ) or 0
            if key > 0 then return end
        end

        --- Resultados de la recera
        local Results = GPrefix.getResults( recipe )

        --- Recorrer los resultados
        for _, Result in pairs( Results or { } ) do

            --- Prepararse para guardar receta
            local recipes = GPrefix.Recipes[ Result.name ] or { }
            GPrefix.Recipes[ Result.name ] = recipes
            if not GPrefix.inTable( recipes, recipe ) then
                table.insert( recipes, recipe )
            end

            --- Guardar referencia del resultado
            if Result.type ~= "fluid" then GPrefix.Items[ Result.name ]  = true end
            if Result.type == "fluid" then GPrefix.Fluids[ Result.name ] = true end
        end

        --- Ingredientes de la recera
        for _, Recipe in pairs( Recipes ) do
            if not GPrefix.isTable( Recipe ) then Recipe = { } end
            if not Recipe.ingredients then goto JumpIngredients end
            for _, ingredient in pairs( Recipe.ingredients ) do
                if ingredient.type ~= "fluid" then GPrefix.Items[ ingredient.name ]  = true end
                if ingredient.type == "fluid" then GPrefix.Fluids[ ingredient.name ] = true end
            end :: JumpIngredients ::
        end
    end

    --- Agregar la teja a GPrefix.Tiles
    local function addTile( tile )

        --- El suelo no se puede quitar
        if not tile.minable then return end
        if not tile.minable.result then return end

        --- El suelo no tiene receta
        local result = tile.minable.result
        if GPrefix.Items[ result ] then
            GPrefix.Items[ result ] = true
        end

        --- Guardar el suelo
        local Title = GPrefix.Tiles[ result ] or { }
        GPrefix.Tiles[ result ] = Title
        table.insert( Title, tile )
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Recorrer las recetas
    for _, recipe in pairs( data.raw.recipe ) do
        addRecipe( recipe )
    end

    --- Cargar los suelos
    for _, tile in pairs( data.raw.tile ) do
        addTile( tile )
    end

    --- Cargar los fluidos
    for FluidName, _ in pairs( GPrefix.Fluids ) do
        local Fluid = data.raw.fluid[ FluidName ]
        if Fluid then GPrefix.Fluids[ FluidName ] = Fluid end
    end

    --- Cargar los objetos
    for _, subGrupo in pairs( data.raw ) do
        for _, Item in pairs( subGrupo ) do
            addItem( Item )
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Evitar estos tipos
    local AvoidTypes = { }
    table.insert( AvoidTypes, "tile" )
    table.insert( AvoidTypes, "fluid" )
    table.insert( AvoidTypes, "recipe" )

    --- Cargar las entidades de forma directa
    for EntityName, _ in pairs( GPrefix.Entities ) do

        --- Validar el valor de la entidad
        local EntityValue = GPrefix.Entities[ EntityName ]
        if GPrefix.isString( EntityValue ) then goto JumpString end

        --- Recorrer los prototipos
        for _, Entity in pairs( data.raw ) do

            --- Objeto encontrado
            Entity = Entity[ EntityName ]
            if not Entity then goto JumpEntity end
            if not Entity.minable then goto JumpEntity end
            if GPrefix.getKey( AvoidTypes, Entity.type ) then goto JumpEntity end
            if not Entity.minable.result then goto JumpEntity end

            --- Guardar entidad
            GPrefix.Entities[ EntityName ] = Entity

            --- Recepción del salto
            :: JumpEntity ::
        end

        --- Recepción del salto
        :: JumpString ::
    end

    --- Cargar las entidades de forma indirecta
    for EntityName, _ in pairs( GPrefix.Entities ) do

        --- Validar el valor de la entidad
        local EntityValue = GPrefix.Entities[ EntityName ]
        if not GPrefix.isString( EntityValue ) then goto JumpEntity end

        --- Guardar la entidad
        GPrefix.Entities[ EntityName ] = GPrefix.Entities[ EntityValue ]

        --- Recepción del salto
        :: JumpEntity ::
    end

    --- Cargar los equipos
    for ItemName, _ in pairs( GPrefix.Equipaments ) do
        for _, Equipment in pairs( data.raw ) do

            --- Objeto encontrado
            Equipment = Equipment[ ItemName ]
            if not Equipment then goto JumpEquipment end
            if not Equipment.shape then goto JumpEquipment end
            if not Equipment.sprite then goto JumpEquipment end

            --- Guardar objeto
            GPrefix.Equipaments[ ItemName ] = Equipment

            --- Recepción del salto
            :: JumpEquipment ::
        end
    end
end

--- Eliminar todo lo no encontrado u oculto
function Private.DeleteData( )

    --- Variable contenedora
    local Deleted = { }
    local String = ""
    local Table = { }

    --- Valores a evaluar
    Table.Items = GPrefix.Items
    Table.Tiles = GPrefix.Tiles
    Table.Fluids = GPrefix.Fluids
    Table.Entities = GPrefix.Entities
    Table.Equipaments = GPrefix.Equipaments
    Recipes = GPrefix.Recipes

    --- Identificar valores vacios
    for name, list in pairs( Table ) do
        for key, Value in pairs( list ) do
            if GPrefix.isBoolean( Value ) then

                String = String .. "\n" .. "    " .. "   "
                String = String .. string.sub( name, 1, #name - 1 )
                String = String .. " not found or hidden: " .. key

                table.insert( Deleted, key )
            end
        end
    end

    --- Eliminar valores vacios
    for _, list in pairs( Table ) do
        for _, value in pairs( Deleted ) do
            list[ value ] = nil
        end
    end

    --- Construir el apodo de los elementos
    --- Concentrar las imagenes en una variable
    for _, list in pairs( Table ) do
        for _, Value in pairs( list ) do
            if Value.name then Value = { Value } end
            for _, Element in pairs( Value ) do
                GPrefix.addLetter( Element )
                Private.CreateIcons( Element )
                local Received = GPrefix.toString( Element.icons )
                local Expected = GPrefix.toString( { { } } )
                if Received == Expected then Element.icons = nil end
            end
        end
    end

    --- Imprimir un informe de lo eliminados
    if #Deleted >= 1 then log( String ) end
end



--- Cargar los valores de Settings a ThisMOD
function Private.LoadSettingValues( )

    --- Recorrer los MODs a cargar
    for NameMOD, _ in pairs( GPrefix.MODs ) do

        --- Crea la variable si aún no ha sido creada
        GPrefix.MODs[ NameMOD ] = GPrefix.MODs[ NameMOD ] or { }

        --- Renombrar la variable
        _G.settings = settings
        local ThisMOD = GPrefix.MODs[ NameMOD ]
        local Option = settings.startup[ ThisMOD.Prefix_MOD ]

        --- Guardar el valor de la configuración
        if GPrefix.isNumber( Option.value ) then ThisMOD.Value = Option.value end
        if GPrefix.isNumber( Option.value ) then ThisMOD.Active = Option.value > 1 end
        if GPrefix.isBoolean( Option.value ) then ThisMOD.Active = Option.value end

        --- Eliminar si el MOD no esta activo
        if not ThisMOD.Active then ThisMOD.Active = nil end
    end
end

--- Cargar los valores de los prototipos
function Private.DataFinalFixes( )

    --- Valicación básica
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end

    --- Cargar la configuración del MOD
    Private.LoadSettingValues( )

    --- Cargar los datos de los prototipos
    Private.LoadData( )   Private.DeleteData( )
end

--- Cargar los valores en tiempo de ejecución
function Private.Control( )

    --- Valicación básica
    if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end

    --- Cargar la configuración del MOD
    Private.LoadSettingValues( )



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    ---> Activar los evetos automaticos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Activar los evetos automaticos    1 Segundo == 60 tick
    GPrefix.addEventOnControl( {
        Function = Private.StartAutomatic,
        ID = defines.events.on_tick
    } )



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    ---> Coloca en fucnionamiento el Traductor
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Cargar el evento
    GPrefix.addAutomaticFunction( {
        Function = Private.TranslationLocalised,
        Name = "Traductor"
    } )

    --- Asignar la función de traducción
    GPrefix.addEventOnControl( {
        Function = Private.TranslatedString,
        ID = defines.events.on_string_translated
    } )
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Ejecutar la accion correspodiente
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

GPrefix.File = GPrefix.getFile( GPrefix.File )
Private.Control( ) --- Cargar los datos en tiempo de ejecución
Private.DataFinalFixes( ) --- Cargar los datos en tiempo de carga

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Estructura para agregar un evento a la lista
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- @class Event
--- @field ID number | string
--- @field Name string _Default:_ on_event
--- @field Function function

--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Estructura para los resultados de las recetas
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- @class tmpResult
--- @field type string
--- @field name string
--- @field amount integer
--- @field probability integer default: 1   0 = 0% y 1 = 100%
--- @field amount_min integer
--- @field amount_max integer
--- @field catalyst_amount integer

--- @class ItemResult : tmpResult

--- @class FluidResult : tmpResult
--- @field temperature integer

--- @alias Results { [ integer ]: Result }
--- @alias Result ItemResult | FluidResult

---- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Estructura para los ingredientes de las recetas
---- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- @class tmpIngredient
--- @field type string
--- @field name string
--- @field amount integer
--- @field catalyst_amount integer

--- @class ItemIngredient : tmpIngredient

--- @class FluidIngredient : tmpIngredient
--- @field temperature integer
--- @field minimum_temperature integer
--- @field maximum_temperature integer

--- @alias Ingredients { [ integer ]: Ingredient }
--- @alias Ingredient ItemIngredient | FluidIngredient

--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Estructura para el Data del juego en ejecución
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- @class Data
--- @field Click table
--- @field Event table
--- @field Force table | nil
--- @field GForce table
--- @field GPlayer table
--- @field GUI table
--- @field Language table
--- @field Player table
--- @field Temporal table
--- @field gForce table
--- @field gMOD table
--- @field gPlayer table
--- @field gPrefix table

--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Estructura para agregar un evento de ejecución automatica
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- @class AutomaticEvent
--- @field Data Data Contenedor de variable en tiempo de ejecución
--- @field Name string Nombre del evento
--- @field Index string Nombre de la lista en la cual esta la función
--- @field Infinite boolean __default: _true___ Si la función devuelve un _true_ no se volverá a ejecutar
--- @field Function function Función que hará el trabajo

--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
---> Estructura de los parametros para traducidor el texto dado
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- @class DataToTranslated
--- @field Localised table | string
--- @field Player table Tabla con todos los valores correspondiente al jugador
--- @field ThisMOD ThisMOD

---------------------------------------------------------------------------------------------------