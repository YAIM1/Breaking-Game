---------------------------------------------------------------------------------------------------

--> __GLOBALS_VALUES__.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Cargar los valores basicos en cualquier tiempo de ejecución
local function LoadSettingValues( )

    -- Carga los valores de la configuración
    for NameMOD, _ in pairs( GPrefix.MODs ) do

        -- Crea la variable si aún no ha sido creada
        GPrefix.MODs[ NameMOD ] = GPrefix.MODs[ NameMOD ] or { }

        -- Renombrar la variable
        _G.settings = settings
        local ThisMOD = GPrefix.MODs[ NameMOD ]
        local Option = settings.startup[ ThisMOD.Prefix_MOD ]

        -- Guardar el valor de la configuración
        if GPrefix.isNumber( Option.value ) then ThisMOD.Value = Option.value end
        if GPrefix.isNumber( Option.value ) then ThisMOD.Active = Option.value > 1 end
        if GPrefix.isBoolean( Option.value ) then ThisMOD.Active = Option.value end

        -- Eliminar si el MOD no esta activo
        if not ThisMOD.Active then ThisMOD.Active = nil end
    end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local OnTick = { }

-- Call example: GPrefix.AddOnTick( Event, ThisMOD )

local function addOnTick( Data )

    -- Here = {
    --     Name = "" <-- Nombre del evento
    --     Infinite = Boolean? <-- Si todo sale bien, dejar de ejecutar la función ??
    --     Function = function( ) <-- Función que hará el trabajo
    --                Si la función devuelve un true se puede eliminar la función
    -- }

    -- Cargar espacio con la infornación
    local Here = Data.Temporal[ #Data.Temporal ]
    Here.Data = Data

    -- Inicializar el indicador
    local Index = ""
    if Index == "" and Data.Player then
        Index = "PlayerID: " .. Data.Player.index
    end

    if Index == "" and Data.Force then
        Index = "ForceID: " .. Data.Force.index
    end

    -- Crear el espacio
    OnTick.Events = OnTick.Events or { }
    local Event = OnTick.Events or { }

    Event[ Index ] = Event[ Index ] or { }
    Event = Event[ Index ]

    -- Verificar si ya se agregó
    for _, Table in pairs( OnTick.Events ) do
        for _, Element in pairs( Table ) do
            if Element.Name == Here.Name then
                return
            end
        end
    end

    -- Guardar el botón de acceso rapido
    table.insert( Event, Here )
end

-- Seleccionador de función a ejecutar
local function StarOnTick( )

    -- Verificar que existan botones a habilitar
    if not OnTick.Events then return end

    -- Jugadores pendientes
    local Keys = { }
    for Key, _ in pairs( OnTick.Events ) do
        table.insert( Keys, Key )
    end

    -- Revisar los jugadores
    for i = 1, #Keys, 1 do
        local Key = Keys[ i ]
        local Event = OnTick.Events[ Key ]

        local Index = 0
        for j = 1, #Event, 1 do
            Event[ j ].Data.Temporal = { }
            Event[ j ].Data.OnTick = Event
            local Return = Event[ j ].Function( Event[ j ].Data )
            if not Event[ j ].Infinite and Return then Index = j end
        end

        -- Eliminar el botones activado
        if  Index > 0 then table.remove( Event, Index ) end
        if #Event < 1 then OnTick.Events[ Key ] = nil end
    end

    -- Eliminar la variable
    if GPrefix.getLength( OnTick.Events ) < 1 then OnTick.Events = nil end
end

-- Peticiones por Ticks
local TickRequest = 25

-- Añade los datos a la lista
local function Add( Queue, Data )

    -- Validación básica
    if not Queue[ 1 ] then table.insert( Queue, { } ) end

    -- Validar si se llegó al limite
    if #Queue[ 1 ] > TickRequest - 1 then table.insert( Queue, 1, { } ) end

    -- Agregar datos a la lista
    table.insert( Queue[ 1 ], Data )
end

-- Call example: GPrefix.AddLocalised( Data )

local function addLocalised( Data )

    -- Cargar espacio de respuesta
    local Up = GPrefix.DeepCopy( Data.Temporal[ #Data.Temporal ] )

    -- Validar el formato del texto a traducir
    if GPrefix.isString( Up.Localised ) then
        Up.Localised = { Up.Localised }
    end

    -- Consolidar la información
    Up.Player = Data.Player
    Up.ThisMOD = Data.GMOD

    -- Inicializar la variable
    local Received = game.table_to_json( Up.Localised )
    local Expected = game.table_to_json( { "locale-identifier" } )

    -- Inicializar la variable
    OnTick.Queue = OnTick.Queue or { }

    -- Renombrar la variable
    local Queue = OnTick.Queue or { }

    -- Se esta traduciendo el idioma del jagador
    if Received == Expected then
        Queue.Language = Queue.Language or { }
        Add( Queue.Language, Up )
    end

    -- Se esta traduciendo un texto cualquiera
    if Received ~= Expected then Add( Queue, Up ) end
end

-- Traducir el texto en cola
local function TranslationLocalised( )

    -- Validación básica
    if not OnTick.Queue then return end
    local Queue = OnTick.Queue or { }

    -- Inicializar la variable
    local Translated =  OnTick.Translated or { }
    OnTick.Translated = Translated

    -- Se esta traduciendo el idioma del jugador
    if Queue.Language then
        local Language = table.remove( Queue.Language )
        Translated.Language = Translated.Language or { }
        table.insert( Translated.Language, Language )
        if #Queue.Language < 1 then Queue.Language = nil end
        for _, Data in pairs( Language ) do
            Data.Player.request_translation( Data.Localised )
        end return
    end

    -- Se esta traduciendo el texto cualquiera
    local Element = table.remove( Queue )
    table.insert( Translated, Element )
    if #Queue < 1 then OnTick.Queue = nil end
    for _, Data in pairs( Element ) do
        Data.Player.request_translation( Data.Localised )
    end
end

-- Buscar la traducción en la lista de traducción
local function getElement( Data )

    -- Recorrer los elementos
    for i = 1, #Data.Table, 1 do
        for j = 1, #Data.Table[ i ], 1 do

            -- Renombrar la variable
            local Element = Data.Table[ i ][ j ]
            local Expected = game.table_to_json( Element.Localised )
            local Player = Element.Player == Data.Player
            local Localised = Expected == Data.Received

            -- Verificar que sea la traducción que se busca
            if Player and Localised then
                Data.Element = Element
                Data.i = i  Data.j = j
                return
            end
        end
    end
end

-- Eliminar el texto traducidor
local function Remove( Data )

    -- Elemento encontrado
    if not Data.Element then return end

    -- Remover el elemento de la tabla
    table.remove( Data.Table[ Data.i ], Data.j )

    -- Validar si se espera más texto por traducir en este tick
    if #Data.Table[ Data.i ] < 1 then table.remove( Data.Table, Data.i ) end

    -- Validar si se espera más texto por traducir en la lista
    if #Data.Table > 0 then return end

    -- Eliminar la tabla vacia
    if Data.Table == OnTick.Translated.Language then OnTick.Translated.Language = nil end
    if Data.Table == OnTick.Translated then OnTick.Translated = nil end

    -- Liberar el espacio
    Data.Element = nil   Data.i = nil   Data.j = nil
end

-- Guardar la traducción en su lugar
local function SaveTranslate( Data )

    -- Ubicar la traducción
    getElement( Data )

    -- Traducción no esperada
    if not Data.Element then return end

    -- Renombrar la variable
    local Event = Data.Event
    local ThisMOD = Data.Element.ThisMOD

    -- Inicializar las variables
    local NewData = GPrefix.CreateData( Event, ThisMOD ) or { }
    local JSON = game.table_to_json( Data.Element.Localised )
    local Language = NewData.GMOD.Language
    Language = Language[ NewData.gPlayer.Language or NewData.Player.index ]

    -- Guardar la traducción
    Language[ JSON ] = string.trim( Event.result )

    -- Eliminar el elemento de la lista
    Remove( Data )
end

-- Asingnar el lenguaje y obrar en consecuencia
local function setLanguage( Data )

    -- Ubicar la traducción
    getElement( Data )

    -- Traducción no esperada
    if not Data.Element then return end

    -- Renombrar la variable
    local Event = Data.Event
    local ThisMOD = Data.Element.ThisMOD

    -- Inicializar las variables
    local NewData = GPrefix.CreateData( Event, ThisMOD ) or { }

    local GLanguage = NewData.GMOD.Language or { }
    NewData.GMOD.Language = GLanguage

    -- Eliminar el elemento de la lista
    Remove( Data )

    -- Idioma no identificado
    if not Event.translated then
        local Language = GLanguage[ NewData.Player.index ] or { }
        GLanguage[ NewData.Player.index ] = Language
        return
    end

    -- Inicializar las variables
    Data.Deleted = { }

    -- Asignar un idioma al jugador
    local Language = GLanguage[ Event.result ] or { }
    GLanguage[ Event.result ] = Language

    -- Asignar el idioma al jugador
    NewData.gPlayer.Language = Event.result

    -- Buscar los texto ya traducidos de este idioma
    for i = 1, #Data.Table, 1 do
        for j = 1, #Data.Table[ i ], 1 do

            -- Renombrar la variable
            local Element = Data.Table[ i ][ j ]
            local Player = Element.Player == NewData.Player
            local MOD = Element.ThisMOD.Name == ThisMOD.Name
            local JSON = game.table_to_json( Element.Localised )
            local Translated = Language[ JSON ] and true or false

            -- Verificar que sea la traducción que se busca
            if Player and MOD and Translated then
                local Position = { i = i, j = j }
                table.insert( Data.Deleted, Position )
            end
        end
    end

    -- Eliminar los textos ya traducidos de la lista
    for i = #Data.Deleted, 1, -1 do
        local Position = Data.Deleted[ i ]
        Data.Element = Data.Table[ Position.i ][ Position.j ]
        Data.i = Position.i   Data.j = Position.j
        Remove( Data )
    end
end

-- Función que recibe la traducción
local function TranslatedString( Event )
    if not OnTick.Translated then return end
    if not Event.translated then return end
    local Expected = game.table_to_json( { "locale-identifier" } )
    local Translated = OnTick.Translated or { }

    -- Inicializar las variables
    local Data = { }
    Data.Event = Event
    Data.Player = game.get_player( Event.player_index )
    Data.Received = game.table_to_json( Event.localised_string )

    -- Se esta traduciendo el idioma del jagador
    if Data.Received ~= Expected then goto JumpLanguage end
    if not Translated.Language then goto JumpLanguage end
    Data.Table = Translated.Language
    setLanguage( Data )
    if true then return true end
    :: JumpLanguage ::

    -- Se esta traduciendo el texto cualquiera
    if not Translated then goto JumpLocalised end
    Data.Table = Translated
    SaveTranslate( Data )
    if true then return true end
    :: JumpLocalised ::
end

local function LoadOnTick( )

    -- Renombrar las funciones principales
    GPrefix.addOnTick = addOnTick
    GPrefix.addLocalised  = addLocalised

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Codigo ejecutado en cada tick   1 Segundo == 60 tick
    GPrefix.addEvent( {
        [ { "on_event", defines.events.on_tick } ] =  StarOnTick
    } )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Datos básicos
    local Data = { }
    Data.Temporal = { }
    Data.Player = { index = 0 }

    -- Datos para el evento
    local Here = { }
    Here.Name = "TranslationLocalised"
    Here.Function = TranslationLocalised
    table.insert( Data.Temporal, Here )

    -- Cargar el evento
    GPrefix.addOnTick( Data )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Asignar la función de traducción
    GPrefix.addEvent( {
        [ { "on_event", defines.events.on_string_translated } ] = TranslatedString,
    } )
end



-- Cargar los valores en tiempo de ejecución
local function Control( )

    -- Filtrar el nombre del archivo
    -- desde el cual se realizó la llamada
    GPrefix.File = GPrefix.getFile( GPrefix.File )
    if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end

    -- Cargar la figuración del MOD
    LoadSettingValues( )

    -- Activar el manejador de evento
    LoadOnTick( )
end

-- Cargar los datos desde el juego
Control( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Funciones para agregar informacion al juego
local function add( Type, Table, ThisMOD )

    -- Agregar la letra
    if ThisMOD then GPrefix.addLetter( Table, ThisMOD ) end

    -- Guardar el prototipo
    GPrefix[ Type ][ Table.name ] = GPrefix[ Type ][ Table.name ] or { }
    GPrefix[ Type ][ Table.name ] = Table
    data:extend( { Table } )
end

-- Funciones para crear los prototipos
local function create( Type, ThisMOD )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Tables = Info[ Type ] or { }
    Info[ Type ] = Tables

    -- Cambiar los objetos
    for _, Table in pairs( Tables ) do
        add( Type, Table, ThisMOD )
    end
end

local function addRecipe( NewRecipe, ThisMOD )

    -- Variable contenedora
    local Recipes = { NewRecipe, NewRecipe.expensive, NewRecipe.normal }

    -- Validar si la receta esta oculta
    for _, Recipe in pairs( Recipes ) do
        local Result = GPrefix.getKey( Recipe.flags, "hidden" )
        if Result then return end
    end

    -- Agregar la letra a la nueva receta
    if ThisMOD then GPrefix.addLetter( NewRecipe, ThisMOD ) end

    -- Consolidar los resultados de la recera
    local Results = { }
    for _, Recipe in pairs( Recipes ) do

        -- La receta dará un unico objeto
        if Recipe.result then
            local Result = { }
            table.insert( Results, Result )
            table.insert( Result, Recipe.result )
            table.insert( Result, Recipe.result_count or 1 )
        end

        -- La receta dará varios objetos
        if Recipe.results then
            for _, Result in pairs( Recipe.results ) do
                table.insert( Results, Result )
            end
        end
    end

    -- Recorrer los resultados
    for Recipe, Result in pairs( Results ) do

        -- Identificar el resultado
        Result = Result.name and Result.name or Result[ 1 ]

        -- Crear el espacio para las recetas
        Recipes = GPrefix.Recipes
        Recipes[ Result ] = Recipes[ Result ] or { }
        Recipe = Recipes[ Result ]

        -- Guardar las recetas
        if not GPrefix.getKey( Recipe, NewRecipe ) then
            table.insert( Recipe, NewRecipe )
        end
    end

    -- Cargar el prototipo al juego
    data:extend( { NewRecipe } )
end

local function ActiveForceProduction( RecipeName )
    if not GPrefix.ForceProduction then return end
    GPrefix.ForceProduction.addRecipe( RecipeName )
end

local function createRecipe( ThisMOD )

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Cambiar los objetos
    for ItemName, Table in pairs( Recipes ) do
        for _, Recipe in pairs( Table ) do
            GPrefix.addRecipe( Recipe, ThisMOD )
            GPrefix.addTechnology( ItemName, Recipe.name )
            ActiveForceProduction( Recipe.name )
        end
    end
end

-- Duplicar la entidad, objeto y recestas
local function duplicateEntity( Entity, ThisMOD )

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Entities = Info.Entities or { }
    Info.Entities = Entities

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    local Items = Info.Items or { }
    Info.Items = Items

    -- Posible afectados
    Entity = GPrefix.DeepCopy( Entity )
    Entities[ Entity.name ] = Entity

    -- Cambiar el objeto al minar
    if not Entity.minable then return end
    if not Entity.minable.result then return end

    -- Nombre del objeto
    local Name = Entity.minable.result
    if not Name then return end

    -- Cargar el objeto
    local Item = GPrefix.Items[ Name ]
    Item = GPrefix.DeepCopy( Item )
    Items[ Name ] = Item

    -- Cargar las recetas
    local Recipe = GPrefix.Recipes[ Name ]
    Recipe = GPrefix.DeepCopy( Recipe )
    Recipes[ Name ] = Recipe

    -- Iliminar las recetas
    if GPrefix.Compact then
        for position, recipe in pairs( Recipe ) do

            -- Variable temporal
            local Category = ""

            -- La receta es de compactado??
            Category = GPrefix.Compact.Prefix_MOD_ .. "compact"
            local Compact = recipe.category == Category

            -- La receta es de descompactado??
            Category = GPrefix.Compact.Prefix_MOD_ .. "uncompact"
            local Uncompact = recipe.category == Category

            -- De serlo, elimnar el duplicado
            if Compact or Uncompact then
                table.remove( Recipe, position )
            end
        end

        -- Eliminar las recetas vacias
        if GPrefix.getLength( Recipe ) < 1 then
            Recipes[ Name ] = nil
        end
    end

    -- Eliminar un posible problema
    for _, recipe in pairs( Recipe ) do
        recipe.main_product = nil
    end
end

-- Clasificar la información desde data.raw
local function LoadData( )

    -- Crear las variables
    GPrefix.Items = { }
    GPrefix.Tiles = { }
    GPrefix.Fluids = { }
    GPrefix.Recipes = { }
    GPrefix.Entities = { }
    GPrefix.Equipaments = { }

    -- Cargar las recetas
    for _, recipe in pairs( data.raw.recipe ) do
        repeat

            -- Variable contenedora
            local _recipes = { recipe, recipe.expensive, recipe.normal }

            -- Validar si la receta esta oculta
            local Hidden = 1
            for _, _recipe in pairs( _recipes ) do
                local Result = ( GPrefix.getKey( _recipe.flags, "hidden" ) or "" ) .. ""
                Hidden = tonumber( Result, 10 )
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
                    GPrefix.Recipes[ Result.name ] = GPrefix.Recipes[ Result.name ] or { }
                    if not GPrefix.getKey( GPrefix.Recipes[ Result.name ], recipe ) then
                        table.insert( GPrefix.Recipes[ Result.name ], recipe )
                    end


                    -- Guardar referencia del resultado
                    if Result.type ~= "fluid" then GPrefix.Items[ Result.name ]  = true end
                    if Result.type == "fluid" then GPrefix.Fluids[ Result.name ] = true end
                end

                -- { Nombre, Contidad }
                if not Result.name then

                    -- Prepararse para guardar receta
                    GPrefix.Recipes[ Result[ 1 ] ] = GPrefix.Recipes[ Result[ 1 ] ] or { }
                    if not GPrefix.getKey( GPrefix.Recipes[ Result[ 1 ] ], recipe ) then
                        table.insert( GPrefix.Recipes[ Result[ 1 ] ], recipe )
                    end

                    -- Guardar referencia del resultado
                    GPrefix.Items[ Result[ 1 ] ] = true
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
                    if Ingredient.type ~= "fluid" then GPrefix.Items[ Ingredient.name ]  = true end
                    if Ingredient.type == "fluid" then GPrefix.Fluids[ Ingredient.name ] = true end
                end

                -- { Nombre, Contidad }
                if not Ingredient.name then GPrefix.Items[ Ingredient[ 1 ] ] = true end
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
            if GPrefix.Items[ tile.minable.result ] then
                GPrefix.Items[ tile.minable.result ] = true
            end

            -- Guardar el suelo
            GPrefix.Tiles[ tile.minable.result ] = GPrefix.Tiles[ tile.minable.result ] or { }
            table.insert( GPrefix.Tiles[ tile.minable.result ], tile )

        until true
    end

    -- Cargar los fluidos
    for FluidName, _ in pairs( GPrefix.Fluids ) do
        local Fluid = data.raw.fluid[ FluidName ]
        if Fluid then GPrefix.Fluids[ FluidName ] = Fluid end
    end

    -- Cargar los objetos
    for _, subGrupo in pairs( data.raw ) do
        for ItemName, Item in pairs( subGrupo ) do
            repeat

                -- Objeto no apilable
                if not Item.stack_size then break end

                -- Objeto oculto
                local Hidden = Item.hidden
                Hidden = Hidden or GPrefix.getKey( Item.flags, "hidden" )
                Hidden = Hidden or GPrefix.getKey( Item.flags, "spawnable" )
                if Hidden then break end

                -- Guardar objeto
                GPrefix.Items[ ItemName ] = Item

                -- Guardar suelo
                if Item.place_as_tile then
                    if not GPrefix.Tiles[ ItemName ] then
                        local tile = data.raw.tile
                        tile = tile[ Item.place_as_tile.result ]
                        GPrefix.Tiles[ ItemName ] = { tile }
                    end
                end

                -- Guardar la entidad
                if Item.place_result then

                    -- Entidad con nombre igual al objeto
                    if Item.place_result == ItemName then
                        GPrefix.Entities[ ItemName ] = true
                    end

                    -- Entidad con nombre distinto al objeto
                    if Item.place_result ~= ItemName then
                        GPrefix.Entities[ Item.place_result ] = true
                        GPrefix.Entities[ ItemName ] = Item.place_result
                    end
                end

                -- Guardar el equipable
                if Item.placed_as_equipment_result then
                    GPrefix.Equipaments[ ItemName ] = ItemName
                end

            until true
        end
    end

    -- Evitar estos tipos
    local AvoidTypes = { }
    table.insert( AvoidTypes, "tile" )
    table.insert( AvoidTypes, "fluid" )
    table.insert( AvoidTypes, "recipe" )

    -- Cargar las entidades
    for EntityName, _ in pairs( GPrefix.Entities ) do
        repeat

            if GPrefix.isString( GPrefix.Entities[ EntityName ] ) then
                GPrefix.Entities[ EntityName ] = GPrefix.Entities[ GPrefix.Entities[ EntityName ] ]
            end

            for _, subGroup in pairs( data.raw ) do
                repeat

                    -- Objeto encontrado
                    local Entity = subGroup[ EntityName ]
                    if not Entity then break end
                    if not Entity.minable then break end
                    if GPrefix.getKey( AvoidTypes, Entity.type ) then break end
                    if not( Entity.minable.result or Entity.minable.results ) then break end

                    -- Guardar entidad
                    GPrefix.Entities[ EntityName ] = Entity

                until true
            end

        until true
    end

    -- Cargar los equipables
    for ItemName, _ in pairs( GPrefix.Equipaments ) do
        for _, subGrupo in pairs( data.raw ) do
            repeat

                -- Objeto encontrado
                local Equipment = subGrupo[ ItemName ]
                if not Equipment then break end
                if not Equipment.shape then break end
                if not Equipment.sprite then break end

                -- Guardar objeto
                GPrefix.Equipaments[ ItemName ] = Equipment

            until true
        end
    end
end

-- Eliminar todo lo no encontrado u oculto
local function DeleteData( )

    -- Variable contenedora
    local Deleted = { }
    local String = ""
    local List = { }
    List.Items = GPrefix.Items
    List.Tiles = GPrefix.Tiles
    List.Fluids = GPrefix.Fluids
    List.Entities = GPrefix.Entities
    List.Recipes = GPrefix.Recipes
    List.Equipaments = GPrefix.Equipaments

    -- Identificar valores vacios
    for name, list in pairs( List ) do
        for key, value in pairs( list ) do
            if GPrefix.isBoolean( value ) then

                String = String .. "\n\t\t"
                String = String .. string.sub( name, 1, #name - 1 )
                String = String .. " not found or hidden: " .. key

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
    if #Deleted >= 1 then log( String ) end
end

-- Commpactar el objeto de ser posible
local function ActivateCompact( ThisMOD )

    -- Validación básica
    if not GPrefix.Compact then return end
    if not ThisMOD.Information then return end
    if not ThisMOD.Information.Items then return end
    if ThisMOD.Information.Break then return end

    -- Renombrar la variable
    local Items = ThisMOD.Information.Items
    Items = GPrefix.DeepCopy( Items )

    -- Crea el objeto compactado
    GPrefix.Compact.Information = nil
    for _, Item in pairs( Items ) do
        GPrefix.Compact.Compact( Item, GPrefix.Compact )
    end create( "Items", GPrefix.Compact )

    -- Crear las recetas para compactar el objeto
    GPrefix.Compact.Information = nil
    for _, Item in pairs( Items ) do
        GPrefix.Compact.CreateRecipe( Item )
    end createRecipe( GPrefix.Compact )

    -- Crear una versión mejorada de ser posible
    if not GPrefix.Improve then return end
    GPrefix.Improve.LoadStar( )
end

-- Cargar al juego las prototipos
local function createInformation( ThisMOD )
    if not ThisMOD.Information then return end

    if ThisMOD.Information.Items then create( "Items", ThisMOD ) end
    if ThisMOD.Information.Fluids then create( "Fluids", ThisMOD ) end
    if ThisMOD.Information.Entities then create( "Entities", ThisMOD ) end
    if ThisMOD.Information.Equipaments then create( "Equipaments", ThisMOD ) end

    if ThisMOD.Information.Recipes then createRecipe( ThisMOD ) end
    ActivateCompact( ThisMOD )
end

-- Cargar los valores en el prototipado
local function DataFinalFixes( )

    -- Filtrar el nombre del archivo
    -- desde el cual se realizó la llamada
    GPrefix.File = GPrefix.getFile( GPrefix.File )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end

    -- Cargar la figuración del MOD
    LoadSettingValues( )

    -- Cargar los datos de los prototipos
    LoadData( )   DeleteData( )

    -- Inicializar las funciones
    GPrefix.addItem = function( NewItem, ThisMOD ) add( "Items", NewItem, ThisMOD ) end
    GPrefix.addFluid = function( NewFluid, ThisMOD ) add( "Fluids", NewFluid, ThisMOD ) end
    GPrefix.addEntity = function( NewEntity, ThisMOD ) add( "Entities", NewEntity, ThisMOD ) end
    GPrefix.addRecipe = function( NewRecipe, ThisMOD ) addRecipe( NewRecipe, ThisMOD ) end
    GPrefix.addEquipament = function( NewEquipament, ThisMOD ) add( "Equipments", NewEquipament, ThisMOD ) end

    GPrefix.duplicateEntity = function ( Entity, ThisMOD ) duplicateEntity( Entity, ThisMOD ) end

    GPrefix.createInformation = function( ThisMOD ) createInformation( ThisMOD ) end
end

-- Cargar los datos desde los prototipos
DataFinalFixes( )

---------------------------------------------------------------------------------------------------