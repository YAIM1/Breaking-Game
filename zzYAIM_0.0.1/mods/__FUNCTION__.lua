--------------------------------------

-- __FUNCTION__.lua

--------------------------------------
--------------------------------------

if isNil then return true end

--------------------------------------
--------------------------------------

function _G.isNil( _value )         return type( _value ) == "nil"      end
function _G.isTable( _value )       return type( _value ) == "table"    end
function _G.isString( _value )      return type( _value ) == "string"   end
function _G.isNumber( _value )      return type( _value ) == "number"   end
function _G.isBoolean( _value )     return type( _value ) == "boolean"  end
function _G.isUserData( _value )    return type( _value ) == "userdata" end

--------------------------------------
--------------------------------------

-- Call example 1. table.getKey( table, Value )
-- Call example 2. table.getKey( table, Value1, ... , ValueN )

function table.getKey( List, ... )

    -- Variable contenedora
    local Values = { ... }

    -- Valdación básica
    if not isTable( List ) then return nil end
    if isNil( Values ) then return nil end

    -- Variable de salida
    local Output  = { }

    -- Buscar el valor
    for _, Value in pairs( Values ) do
        for key, value in pairs( List ) do
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

-- Call example 1. string.leftPad( String, Length )
-- Call example 2. string.leftPad( String, Length, Char )

function string.leftPad( String, Length, Char )

    -- Validación básica
    if     isNumber( String ) then String = tostring( String ) end
    if not isString( String ) then return String end
    if not isNumber( Length ) then return String end

    -- Validando parametros
    Char = Char or " "
    if #String >= Length then return String end
    if #Char > 1 then return String end

    -- Enviar resultado
    return string.rep( Char, Length - #String, "" ) .. String
end

-- Call example. toString( AnyVariable )

function _G.toString( Variable, Cache )

    -- Variables
    local Types  = { }
    Cache = Cache or { }
    local varType = type( Variable )

    -- La variable es simple
    Types = { "function", "thread", "userdata" }
    if table.getKey( Types, varType ) then
        return varType .. "( )"
    end

    Types = { "string" }
    if table.getKey( Types, varType ) then
        return "'" .. Variable .. "'"
    end

    Types = { "number" }
    if table.getKey( Types, varType ) then
        return Variable
    end

    Types = { "boolean", "nil" }
    if table.getKey( Types, varType ) then
        return tostring( Variable )
    end

    -- La vabriable es compleja
    Types = { "table" }
    if table.getKey( Types, varType ) then
        local Loop   = table.getKey( Cache, Variable )
        local output = ""

        -- La variable no ha sido revisada
        if not Loop then
            output = "{"
            table.insert( Cache, Variable )
            for key, value in pairs( Variable ) do

                if isNil( table.getKey( Types, type( key ) ) ) then
                    output = output .. "\n\t[ " .. toString( key, Cache ) .. " ] = "
                end

                if table.getKey( Types, type( key ) ) then
                    output = output .. "[ '" .. type( key ) .. "' ] = "
                end

                local String = toString( value, Cache )
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

-- Call example. Log( Variable1, ... , VariableN )

function _G.Log( ... )

    -- Variable contenedora
    local Values = { ... }

    -- Validación básica
    if #Values == 0 then return false end

    -- Variable de salida
    local Output = ""

    -- Convertir las variables
    for Index, Value in pairs( Values ) do
        local String = ""
        if isTable( Value ) and Value.name then String = Value.name end
        if String == "" then String = Index end
        String = "[ " .. toString( String ) .. " ]"

        Output = Output .. "\n" .. String
        Output = Output .. " = " .. toString( Value )
    end

    -- Mostrar el resultado
    log( "\n>>>" .. Output .. "\n<<<" )
end

-- Call example. getNumber( String )

function _G.getNumber( String )

    -- Validación básica
    if not isString( String ) then return 0 end

    -- Leer el valor
    local Output
    for key, _ in string.gmatch( string.upper( String ), "%d*.?%d+") do
        Output = tonumber( key ) break
    end

    -- Identificar la unidad de energia
    local unit = string.upper( string.sub( String, -2, -2 ) )
    if tonumber( unit ) then unit = "" end

    -- Aplicar el cambio de unidad
    return Output * ( 10 ^ Unit[ unit ] )
end

-- Call example. getUnit( String )

function _G.getUnit( String )

    -- Validación básica
    if not isString( String ) then return "" end

    -- Leer la unidad
    local unit = string.upper( string.sub( String, -1 ) )
    local units = { "J", "W" }

    -- La unidad es conocida
    if table.getKey( units, unit ) then return unit end

    -- La unidad es desconocida
    return ""
end

-- Call example. shortNumber( Number )

function _G.shortNumber( Number )

    -- Valdación básica
    if not isNumber( Number ) then return "" end

    -- Acortar el número
    local Digits = math.floor( #tostring( Number ) / 3 )
    if #tostring( Number ) % 3 == 0 then Digits = Digits - 1 end
    local Output = tostring( Number * ( 10 ^ ( -3 * Digits ) ) )
    return Output .. Unit[ 3 * Digits ]
end

-- Call example. getFile( String )

function _G.getFile( String )
    if String == "" then return "" end
    local Start, End = string.find( String, "/[%w%-]*.lua" )
    return string.sub( String, Start + 1, End - 4 )
end

-- Call example. addSubGroup( String )

function _G.addSubGroup( modName, subGroups )

    -- Renombrar la variable
    local _Prefix = Prefix .. modName .. "-"

    -- Crear los subgrupos
    for subGroup, _ in pairs( subGroups ) do
        local prefix = string.gsub( Prefix, "-", "%%-" )
        prefix = string.find( subGroup, prefix )
        if not prefix then

            -- Selecionar el subgrupo
            local SubGroup = data.raw[ "item-subgroup" ]
            SubGroup = SubGroup[ subGroup ]

            -- Duplicar el subgrupo
            SubGroup = table.deepcopy( SubGroup )
            SubGroup.name = _Prefix .. SubGroup.name
            SubGroup.order = _Prefix .. SubGroup.order

            -- Cargar los datos al juego
            data:extend( { SubGroup } )
        end
    end
end

-- Call example. isIngredient( Recipe, NameItem )

function _G.inRecipe( Recipe, NameItem )
	for _, Result in pairs( Recipe ) do
		if Result.name and Result.name == NameItem then return true
		elseif Result[ 1 ] == NameItem then return true end
	end return false
end

-- Call example. isIngredient( Recipe, Item )

function _G.isIngredient( Recipe, Item )
	if Recipe.ingredients and inRecipe( Recipe.ingredients, Item ) then return true end
	if Recipe.expensive and Recipe.expensive.ingredients and inRecipe( Recipe.expensive.ingredients, Item ) then return true end
	if Recipe.normal and Recipe.normal.ingredients and inRecipe( Recipe.normal.ingredients, Item ) then return true end
    return false
end

-- Call example. isResult( Recipe, Item )

function _G.isResult( Recipe, Item )
	if Recipe.result == Item then return true end
	if Recipe.results and inRecipe( Recipe.results, Item ) then return true end
    if Recipe.normal and Recipe.normal.result == Item then return true end
	if Recipe.normal and Recipe.normal.results and inRecipe( Recipe.normal.results, Item ) then return true end
    if Recipe.expensive and Recipe.expensive.result == Item then return true end
	if Recipe.expensive and Recipe.expensive.results and inRecipe( Recipe.expensive.results, Item ) then return true end
	return false
end

-- Call example 1. addIcon( itemOld, newItem )
-- Call example 2. addIcon( itemOld, newItem, true )
-- Call example 3. addIcon( itemOld, newItem, false )
-- Call example 4. addIcon( itemOld, newItem, newIcon )

function _G.addIcon( itemOld, itemNew, newIcon )

    -- Variable contenedora
    local icons = { }

    -- Imagenes solapadas
    if itemOld.icons then
        for _, icon in pairs( itemOld.icons ) do
            icon = table.deepcopy( icon )
            table.insert( icons, icon )
        end
    end

    -- Imagen unica
    if itemOld.icon and not itemOld.icons then

        local icon = {
            icon = itemOld.icon,
            icon_size = itemOld.icon_size,
            icon_mipmaps = itemOld.icon_mipmaps
        }

        itemNew.icon  = nil
        table.insert( icons, icon )
    end

    -- Example 2. Crear la imagen solapada de descompactado
    if isBoolean( newIcon ) and newIcon then

        -- Variable contenedora
        local Icons = { }

        -- Agregar la imagen de fondo
        if not addBackground then
            local icon = { }
            icon.icon = "__zzYAIM__/mods/graphics/icons/blank.png"
            icon.icon_size = 64
            icon.icon_mipmaps = 4
            table.insert( Icons, icon )
        end

        -- Cuadricula de imagenes
        for X = -1, 1, 1 do
            for Y = -1, 1, 1 do
                for _, icon in pairs( icons ) do
                    icon = table.deepcopy( icon )
                    icon.scale = 0.25
                    icon.shift = { X * 8, Y * 8 }
                    table.insert( Icons, icon )
                end
            end
        end

        -- Imagen central
        for _, icon in pairs( icons ) do
            icon = table.deepcopy( icon )
            icon.scale = 0.3
            table.insert( Icons, icon )
        end

        -- Guardar las nuemas imagenes
        icons = Icons
    end

    -- La última image a agregar
    local lastIcon = { }
    lastIcon.icon_size = 64
    lastIcon.icon_mipmaps = 4

    -- Example 1, 2 y 3. Agregar el pez de referencia
    if isBoolean( newIcon ) or isNil( newIcon ) then
        lastIcon.icon = Items[ 'raw-fish' ].icon
        lastIcon.scale = 0.3
    end

    -- Example 1 y 3. Mover pez a la derecha
    if not newIcon then lastIcon.shift = { 8, -8 } end

    -- Example 2. Mover pez a la izquierda
    if isBoolean( newIcon ) and newIcon then
        lastIcon.shift = { -8, 8 }
    end

    -- Example 4. Agregar imagen adicional
    if isTable( newIcon ) then
        for key, value in pairs( newIcon ) do
            lastIcon[ key ] = value
        end
    end

    -- Establecer la imagen del nuevo objeto
    itemNew.icon_size = 64
    table.insert( icons, lastIcon )
    itemNew.icons = icons
end

-- Call example. addTechnology( itemOld, recipeNew )

function _G.addTechnology( NameItemOld, NameRecipeNew )

    -- Valdación básica
    if not isString( NameItemOld ) then return false end
    if not isString( NameRecipeNew ) then return false end

    -- Bandera referencial
    local Added = false

    -- Revisar cada tecnología
    for _, technology in pairs( data.raw.technology ) do
        repeat

            -- Renombrar la variable
            local effects = technology.effects

            -- Valdación básica
            if not effects then break end

            local flag = false
            for _, effect in pairs( effects ) do
                if effect.type == "unlock-recipe" then
                    flag = effect.recipe == Recipe
                    if flag then break end
                end
            end if flag then break end
            flag = false

            -- Revisar cada recetas a desbloquear
            for _, effect in pairs( effects ) do
                while effect.type == "unlock-recipe" do

                    -- Evitar un bucle
                    local prefix = Prefix
                    prefix = string.gsub( prefix, "-", "%%-" )
                    prefix = string.find( effect.recipe, prefix )
                    if prefix then break end

                    -- Encontrar la investigación
                    local recipe = data.raw.recipe[ effect.recipe ]
                    recipe = isResult( recipe, NameItemOld )
                    if not recipe then break end

                    -- Crear la nueva tecnología
                    local newtechnology = { }
                    newtechnology.type = "unlock-recipe"
                    newtechnology.recipe = NameRecipeNew

                    -- Guardar la nueva tecnología
                    table.insert( effects, newtechnology )
                    Added = true flag = true break
                end

                -- Receta agregada e una tecnología
                if flag then break end
            end

        until true
    end

    -- Receta agregada e una tecnología
    if Added then return true end

    -- No se requiere una tecnología
    local recipe = data.raw.recipe
    recipe = recipe[ NameRecipeNew ]
    if not recipe then Log( "Recipe not found: " .. NameRecipeNew ) end
    if not recipe then return false end
    recipe.enabled = true
end

--------------------------------------