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
    for _, _ in pairs( Table ) do
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


-- Call example. GPrefix.addSubGroup( String, ThisMOD )

function GPrefix.addSubGroup( SubGroups, ThisMOD )

    -- Inicializar la variable
    local Array = { Result = { } }

    for SubGroup, _ in pairs( SubGroups ) do

        -- Evitar bucle
        Array.PrefixFind = string.gsub( GPrefix.Prefix, "-", "%%-" )
        Array.Find = string.find( SubGroup, Array.PrefixFind )
        if Array.Find then goto JumpSubGroup end

        -- Renombrar la variable
        Array.SubGroup = data.raw[ "item-subgroup" ]

        -- Validar si el nuevo grupo existe
        Array.SubGroupExist = ThisMOD.Prefix_MOD_ .. SubGroup
        Array.SubGroupExist = Array.SubGroup[ Array.SubGroupExist ]
        if Array.SubGroupExist then goto JumpSubGroup end

        -- Cargar el grupo de muestra
        Array.NewSubGroup = Array.SubGroup[ SubGroup ]

        -- Duplicar el subgrupo
        Array.NewSubGroup = GPrefix.DeepCopy( Array.NewSubGroup )

        -- Hacer los cambios en el subgrupo
        Array.NewSubGroup.name = ThisMOD.Prefix_MOD_ .. Array.NewSubGroup.name
        Array.NewSubGroup.order = ThisMOD.Prefix_MOD_ .. Array.NewSubGroup.order
        table.insert( Array.Result, Array.NewSubGroup )

        -- Recepción del salto
        :: JumpSubGroup ::
    end

    -- Cargar los datos al juego
    if #Array.Result > 0 then
        data:extend( Array.Result )
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


-- Call example. GPrefix.isIngredient( Recipe, ItemName )

function GPrefix.inRecipe( Recipe, ItemName )
	for _, Result in pairs( Recipe ) do
		if Result.name and Result.name == ItemName then return true
		elseif Result[ 1 ] == ItemName then return true end
	end return false
end

-- Call example. GPrefix.isIngredient( Recipe, Item )

function GPrefix.isIngredient( Recipe, Item )
	if Recipe.ingredients and GPrefix.inRecipe( Recipe.ingredients, Item ) then return true end
	if Recipe.expensive and Recipe.expensive.ingredients and GPrefix.inRecipe( Recipe.expensive.ingredients, Item ) then return true end
	if Recipe.normal and Recipe.normal.ingredients and GPrefix.inRecipe( Recipe.normal.ingredients, Item ) then return true end
    return false
end

-- Call example. GPrefix.isResult( Recipe, Item )

function GPrefix.isResult( Recipe, Item )
	if Recipe.result == Item then return true end
	if Recipe.results and GPrefix.inRecipe( Recipe.results, Item ) then return true end
    if Recipe.normal and Recipe.normal.result == Item then return true end
	if Recipe.normal and Recipe.normal.results and GPrefix.inRecipe( Recipe.normal.results, Item ) then return true end
    if Recipe.expensive and Recipe.expensive.result == Item then return true end
	if Recipe.expensive and Recipe.expensive.results and GPrefix.inRecipe( Recipe.expensive.results, Item ) then return true end
	return false
end


-- Call example. GPrefix.ReplaceRecipe( Recipe, OldNameItem, NewNameItem )

function GPrefix.ReplaceRecipe( Recipe, OldNameItem, NewNameItem )
	for _, Result in pairs( Recipe ) do
		if Result.name and Result.name == OldNameItem then Result.name = NewNameItem return true
		elseif Result[ 1 ] == OldNameItem then Result.name = NewNameItem return true end
	end return false
end

-- Call example. GPrefix.ReplaceIngredient( Recipe, OldNameItem, NewNameItem )

function GPrefix.ReplaceIngredient( Recipe, OldNameItem, NewNameItem )
	if Recipe.ingredients then GPrefix.ReplaceRecipe( Recipe.ingredients, OldNameItem, NewNameItem ) end
	if Recipe.normal and Recipe.normal.ingredients then GPrefix.ReplaceRecipe( Recipe.normal.ingredients, OldNameItem, NewNameItem ) end
	if Recipe.expensive and Recipe.expensive.ingredients then GPrefix.ReplaceRecipe( Recipe.expensive.ingredients, OldNameItem, NewNameItem ) end
end

-- Call example. GPrefix.ReplaceResult( Recipe, OldNameItem, NewNameItem )

function GPrefix.ReplaceResult( Recipe, OldNameItem, NewNameItem )
	if Recipe.result == OldNameItem then Recipe.result = NewNameItem end
	if Recipe.results then GPrefix.ReplaceRecipe( Recipe.results, OldNameItem, NewNameItem ) end
    if Recipe.normal and Recipe.normal.result == OldNameItem then Recipe.normal.result = NewNameItem end
	if Recipe.normal and Recipe.normal.results then GPrefix.ReplaceRecipe( Recipe.normal.results, OldNameItem, NewNameItem ) end
    if Recipe.expensive and Recipe.expensive.result == OldNameItem then Recipe.expensive.result = NewNameItem end
	if Recipe.expensive and Recipe.expensive.results then GPrefix.ReplaceRecipe( Recipe.expensive.results, OldNameItem, NewNameItem ) end
end


-- Call example 1. GPrefix.addIcon( OldItem, NewItem )
-- Call example 2. GPrefix.addIcon( OldItem, NewItem, true )
-- Call example 3. GPrefix.addIcon( OldItem, NewItem, false )
-- Call example 4. GPrefix.addIcon( OldItem, NewItem, newIcon )

function GPrefix.addIcon( OldItem, NewItem, newIcon )

    -- Variable contenedora
    local icons = { }

    -- Imagenes solapadas
    if OldItem.icons then
        for _, icon in pairs( OldItem.icons ) do
            icon = GPrefix.DeepCopy( icon )
            table.insert( icons, icon )
        end
    end

    -- Imagen unica
    if OldItem.icon and not OldItem.icons then

        local icon = {
            icon = OldItem.icon,
            icon_size = OldItem.icon_size,
            icon_mipmaps = OldItem.icon_mipmaps
        }

        NewItem.icon  = nil
        table.insert( icons, icon )
    end

    -- Example 2. Crear la imagen solapada de descompactado
    if GPrefix.isBoolean( newIcon ) and newIcon then

        -- Variable contenedora
        local Icons = { }

        -- Agregar la imagen de fondo
        if not false then
            local icon = { }
            icon.icon = "__zzYAIM__/mods/__MULTIMEDIES__/blank.png"
            icon.icon_size = 64
            icon.icon_mipmaps = 4
            table.insert( Icons, icon )
        end

        -- Cuadricula de imagenes
        for X = -1, 1, 1 do
            for Y = -1, 1, 1 do
                for _, icon in pairs( icons ) do
                    icon = GPrefix.DeepCopy( icon )
                    icon.scale = 0.25
                    icon.shift = { X * 8, Y * 8 }
                    table.insert( Icons, icon )
                end
            end
        end

        -- Imagen central
        for _, icon in pairs( icons ) do
            icon = GPrefix.DeepCopy( icon )
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
    if GPrefix.isBoolean( newIcon ) or GPrefix.isNil( newIcon ) then
        lastIcon.icon = GPrefix.Items[ "raw-fish" ].icon
        lastIcon.scale = 0.3
    end

    -- Example 1 y 3. Mover pez a la derecha
    if not newIcon then lastIcon.shift = { 8, -8 } end

    -- Example 2. Mover pez a la izquierda
    if GPrefix.isBoolean( newIcon ) and newIcon then
        lastIcon.shift = { -8, 8 }
    end

    -- Example 4. Agregar imagen adicional
    if GPrefix.isTable( newIcon ) then
        for key, value in pairs( newIcon ) do
            lastIcon[ key ] = value
        end
    end

    -- Establecer la imagen del nuevo objeto
    NewItem.icon_size = 64
    table.insert( icons, lastIcon )
    NewItem.icons = icons
end

-- Call example. GPrefix.addTechnology( OldItemName, NewRecipeName )

function GPrefix.addTechnology( OldItemName, NewRecipeName )

    -- Variable contenedora
    local Array = { }
    Array.NewRecipe = data.raw.recipe[ NewRecipeName ]
    Array.Enabled = { Array.NewRecipe, Array.NewRecipe.normal, Array.NewRecipe.expensive }
    Array.Technologies = OldItemName and data.raw.technology or { }

    -- Revisar cada tecnología
    for _, Technology in pairs( Array.Technologies ) do

        -- Validar si la teccnología tiene effectos
        if not Technology.effects then goto JumpTechnology end

        -- Revsar cada efecto
        for _, Effect in pairs( Technology.effects ) do

            -- Validar la si hay recetas a desbloquar
            if Effect.type ~= "unlock-recipe" then goto JumpEffect end

            -- Validar si es la receta que se busca
            Array.Recipe = data.raw.recipe[ Effect.recipe ]
            Array.Recipe = GPrefix.isResult( Array.Recipe, OldItemName )
            if not Array.Recipe then goto JumpEffect end

            -- Crear el nuevo efecto
            Array.NewEffect = { }
            Array.NewEffect.type = "unlock-recipe"
            Array.NewEffect.recipe = NewRecipeName

            -- Guardar el nuevo efecto en la tecnología
            table.insert( Technology.effects, Array.NewEffect )
            for _, Table in pairs( Array.Enabled ) do Table.enabled = false end
            if true then return end

            -- Recepción del salto
            :: JumpEffect ::
        end

        -- Recepción del salto
        :: JumpTechnology ::
    end

    -- No se requiere una tecnología
    for _, Table in pairs( Array.Enabled ) do Table.enabled = true end
end

-- Call example: GPrefix.addLetter( Entity, ThisMOD )

function GPrefix.addLetter( Table, ThisMOD )

    -- Inicializsar la variable
    if GPrefix.isString( ThisMOD ) then
        ThisMOD = { Char = ThisMOD }
        ThisMOD.Create = true
    end

    -- No existe el apodo
    if not Table.localised_name then
        local Tipe = ""
        if GPrefix.Items[ Table.name ] then Tipe = "item" end
        if GPrefix.Entities[ Table.name ] then Tipe = "entity" end
        if GPrefix.Equipaments[ Table.name ] then Tipe = "equipment" end
        Table.localised_name = { "", { Tipe .. "-name." .. Table.name }, " [", " ]" }
    end

    -- El apodo es un texto
    if not GPrefix.isTable( Table.localised_name ) then
        Table.localised_name = { "", Table.localised_name, " [", " ]" }
    end

    -- El apodo es contruido
    if Table.localised_name[ 1 ] ~= "" then
        Table.localised_name = { "", Table.localised_name, " [", " ]" }
    end
    -- Inicializar la variable contenedora
    local Array = { }   Array.Name = Table.name
    if ThisMOD.Create then goto JumpPrefix end

    -- Nombre del prototipo
    Array.StringFind = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    Table.name = string.gsub( Table.name, Array.StringFind, "" )
    Table.name = ThisMOD.Prefix_MOD_ .. Table.name

    -- Remplazar el objeto a minar
    Array.Flag = Table
    Array.Flag = Array.Flag and Table.minable
    Array.Flag = Array.Flag and Table.minable.result
    Array.Flag = Array.Flag and Table.minable.result == Array.Name
    if Array.Flag then
        Array.Flag = Table.minable
        Array.Flag.result = Table.name
    end

    if Table.minable and Table.minable.results then
        for _, Result in pairs( Table.minable.results ) do
            if Result.name == Array.Name then
                Result.name = Table.name
            end
        end
    end

    -- Remplazar el objeto de la receta
    if Table.type == "recipe" then
        GPrefix.ReplaceResult( Table, Array.Name, Table.name )
    end

    -- Remplazar la entidad a crear
    if Table.place_result then
        Table.place_result = Table.name
    end

    -- Remplazar el equipamiento a crear
    if Table.placed_as_equipment_result then
        Table.placed_as_equipment_result = Table.name
    end

    -- Recepción del salto
    :: JumpPrefix ::

    -- Agregar la letra en su posición
    local Position = GPrefix.getKey( Table.localised_name, " ]" ) or ""
    local Index = tonumber( Position, 10 )
    table.insert( Table.localised_name, Index, " " .. ThisMOD.Char )
end

---> <---     ---> <---     ---> <---

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