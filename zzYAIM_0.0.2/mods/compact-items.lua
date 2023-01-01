---------------------------------------------------------------------------------------------------

---> compact-items.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor de este MOD
local ThisMOD = GPrefix.getThisMOD( debug.getinfo( 1 ).short_src )
local Private = { }

--- Cargar la configuración del MOD
GPrefix.CreateSetting( ThisMOD, "int" )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Valores de referencia
ThisMOD.PrefixDo = "compact"
ThisMOD.PrefixUndo = "uncompact"

Private.PrefixDo = "stacking"
Private.PrefixUndo = "unstacking"

Private.Categories = { Private.PrefixDo, Private.PrefixUndo }

--- Sección para los prototipos
function Private.DataFinalFixes( )
    local FileValid = { "data-final-fixes" }
    local Active = GPrefix.isActive( ThisMOD, FileValid )
    if not Active then return end

    --- El prototipo no existe
    local Compact = GPrefix.Items[ "transport-belt-beltbox" ]
    if not Compact then ThisMOD.Active = false return end

    --- Aplicar el efecto del MOD por fuera del mismo
    --- @param TheMOD ThisMOD
    function ThisMOD.DoEffect( TheMOD )
        Private.DoEffect( TheMOD )
    end

    --- Verificar si el objeto o la receta esta compactado
    --- @param Element table
    --- @param TheMOD ThisMOD
    function ThisMOD.UpdateDescription( Element, TheMOD )
        Private.UpdateDescription( Element, TheMOD )
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
    Private.CustomizeDeadlockStacking( )
    Private.DuplicateItems( )
    ThisMOD.DoEffect( ThisMOD )
    Private.DeleteDuplicateItems( )
end

--- Personalizar Deadlock's Stacking Beltboxes & Compact Loaders
function Private.CustomizeDeadlockStacking( )
    Private.newRecipeCategory( )
    Private.setRecipeCategory( )

    local Data = { }
    Private.removeItems( Data )
    Private.removeRecipes( Data )
end

--- Crear las categorias para las recetas
function Private.newRecipeCategory( )

    --- Existen las categorias
    local RecipeCategory = data.raw[ 'recipe-category' ]
    RecipeCategory = RecipeCategory[ ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixDo ]
    if RecipeCategory then return end

    --- Crear la categoria para hacer
    data:extend( { {
        [ 'type' ] = 'recipe-category',
        [ 'name' ] = ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixDo,
    } } )

    --- Crear la categoria para deshacer
    data:extend( { {
        [ 'type' ] = 'recipe-category',
        [ 'name' ] = ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixUndo,
    } } )
end

--- Establecer las nuevas recetas
function Private.setRecipeCategory( )

    --- Buscar las entidades
    for _, Entity in pairs( GPrefix.Entities ) do
        if not Entity.crafting_categories then goto JumpEntity end

        --- Validar las categorias disponibles
        for _, Category in pairs( Entity.crafting_categories ) do
            if not GPrefix.getKey( Private.Categories, Category ) then goto JumpCategory end

            --- Establecer el las nuevas recetas
            Entity.crafting_categories = {
                ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixDo,
                ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixUndo,
            } if true then break end

            --- Recepción del salto
            :: JumpCategory ::
        end

        --- Recepción del salto
        :: JumpEntity ::
    end
end

--- Eliminar los objetos inecesarios
--- @param Data table
function Private.removeItems( Data )

    --- Identificador los objetos
    Data.Find = "deadlock%-stack%-"

    --- Cargar los indices de los objetos
    Data.Keys = { }
    for Key, _ in pairs( GPrefix.Items ) do
        if string.find( Key, Data.Find ) then
            table.insert( Data.Keys, Key )
        end
    end

    --- Eliminar los objetos
    for _, ItemName in pairs( Data.Keys ) do
        GPrefix.RemoveItem( ItemName )
    end
end

--- Eliminar las recetas inecesarios
--- @param Data table
function Private.removeRecipes( Data )

    --- No se tiene los objetos a eliminar
    if not Data.Keys then return end

    --- Eliminar la categorias
    local RecipeCategory = data.raw[ 'recipe-category' ]
    for Key, _ in pairs( Private.Categories ) do
        RecipeCategory[ Key ] = nil
    end

    --- Listado de recetas a eliminar
    local Delete = { }

    --- Enlistar las recetas a eliminar
    for _, Recipe in pairs( data.raw.recipe ) do

        --- Eliminar las recetas con esta categoria
        if GPrefix.getKey( Private.Categories, Recipe.category ) then
            table.insert( Delete, 1, Recipe.name )
        end

        --- Elimnar las recetas que usan objetos comprimidos
        local Recipes = { Recipe, Recipe.normal, Recipe.expensive }
        for _, ItemName in pairs( Data.Keys ) do
            for _, recipe in pairs( Recipes ) do
                if GPrefix.inTable( recipe.ingredients, { name = ItemName } ) then
                    if not GPrefix.getKey( Delete, Recipe.name ) then
                        table.insert( Delete, 1, Recipe.name )
                    end
                end
            end
        end
    end

    --- Eliminar las recetas enlistadas
    for _, RecipeName in pairs( Delete ) do
        GPrefix.DeleteRecipeOfTechnologies( RecipeName )
    end
end

--- Validar si el objeto es compactable
--- @param Item table
function Private.ValidateItem( Item )

    --- Tipos a evitar
    local AvoidTypes = { }
    table.insert( AvoidTypes, "car" )
    table.insert( AvoidTypes, "gun" )
    table.insert( AvoidTypes, "armor" )
    table.insert( AvoidTypes, "selection-tool" )
    table.insert( AvoidTypes, "spider-vehicle" )
    table.insert( AvoidTypes, "belt-immunity-equipment" )

    --- Evitar estos tipos
    if GPrefix.getKey( AvoidTypes, Item.type ) then return false end

    --- Evitar lo inapilable
    if GPrefix.getKey( Item.flags, "hidden" ) then return false end
    if GPrefix.getKey( Item.flags, "not-stackable" ) then return false end

    --- Patrones a evitar
    local AvoidPatterns = { }
    table.insert( AvoidPatterns, "%-remote" )

    --- Evitar estos patrones
    for _, Pattern in pairs( AvoidPatterns ) do
        if string.find( Item.name, Pattern ) then return false end
    end

    --- El objeto es compactable
    return true
end

--- Duplicar los objetos que se compactaran
function Private.DuplicateItems( )

    --- Buscar los objetos
    for _, Item in pairs( GPrefix.Items ) do

        --- El objetos no es compactable
        if not Private.ValidateItem( Item ) then goto JumpItem end

        --- Duplicar el objeto original
        ThisMOD.NewItems[ Item.name ] = GPrefix.DeepCopy( Item )

        --- Recepción del salto
        :: JumpItem ::
    end
end

--- Eliminar los objetos copiados y no afectados
function Private.DeleteDuplicateItems( )
    for Index, Item in pairs( ThisMOD.NewItems ) do
        if not GPrefix.hasPrefixMOD( { name = Index }, ThisMOD ) then
            ThisMOD.NewItems[ Index ] = nil
        end
    end
end

--- Aplicar el efecto del MOD por fuera del mismo
--- @param TheMOD ThisMOD
function Private.DoEffect( TheMOD )

    --- Contenedor de los objetos a afectar
    local Datas = { }

    --- Enlistar los objetos a afectar
    for _, Item in pairs( TheMOD.NewItems ) do

        --- Evitar estos elementos
        local MODs = { ThisMOD }
        for _, MOD in pairs( MODs ) do
            local isMOD = GPrefix.hasPrefixMOD( Item, MOD )
            if isMOD then goto JumpItem end
        end

        --- El objetos no es compactable
        if not Private.ValidateItem( Item ) then goto JumpItem end

        --- Agregar el objeto a la lista
        table.insert( Datas, { OldItem = Item } )

        --- Recepción del salto
        :: JumpItem ::
    end

    --- Modificar los objetos enlistados
    for _, Data in pairs( Datas ) do

        --- Inicializar las variables
        Data.TheMOD = TheMOD
        Data.NewItem = { }

        --- Aplicar el efecto del MOD
        Private.CreateCompactedItem( Data )
        Private.CreateCompactedRecipe( Data )
        GPrefix.CreateItemSubgroup( Data.OldItem, ThisMOD )
    end
end

--- Crear el objeto compactado
--- @param Data DataCompact
function Private.CreateCompactedItem( Data )

    --- Renombrar las variables
    local TheMOD = Data.TheMOD
    local NewItem = Data.NewItem
    local OldItem = Data.OldItem

    --- Contenedor del nuevo objeto
    NewItem.type = "item"

    --- Duplicar las propiedades
    local Properties = { }
    table.insert( Properties, "name" )
    table.insert( Properties, "icons" )
    table.insert( Properties, "order" )
    table.insert( Properties, "subgroup" )
    table.insert( Properties, "icon_size" )
    table.insert( Properties, "stack_size" )
    table.insert( Properties, "icon_mipmaps" )
    table.insert( Properties, "localised_name" )
    for _, Property in pairs( Properties ) do
        NewItem[ Property ] = GPrefix.DeepCopy( OldItem[ Property ] )
    end

    --- Agregar el indicador del MOD al apodo
    GPrefix.addLetter( NewItem, ThisMOD.Char )

    --- Asignaer el grupo donde se verá
    NewItem.subgroup = GPrefix.addPrefixMOD( NewItem.subgroup, ThisMOD )

    --- Guardar el objeto en los MODs correspondientes
    NewItem.name = GPrefix.addPrefixMOD( NewItem.name, ThisMOD )
    ThisMOD.NewItems[ NewItem.name ] = NewItem
    TheMOD.NewItems[ NewItem.name ] = NewItem

    --- Sobre escribir la descripcion
    local Array = GPrefix.DeepCopy( NewItem.localised_name )
    if Array[ 1 ] ~= "" then Array = { "", Array } end
    NewItem.localised_description = Array
    table.insert( Array, 2, { ThisMOD.Local .. "item-description" } )
    table.insert( Array, 3, " " .. ThisMOD.Value .. " " )
    table.insert( Array, 4, "[item=" .. OldItem.name .. "] " )

    --- Eliminar el indicador de este MOD
    local Index = GPrefix.getKey( Array, " " .. ThisMOD.Char )
    if Index then table.remove( Array, Index ) end

    --- Eliminar los corchetes vacios
    Index = #Array
    if Array[ Index - 0 ] == " ]" and Array[ Index - 1 ] == " [" then
        table.remove( Array, Index - 0)
        table.remove( Array, Index - 1)
    end

    --- Ajustar los iconos a la imagen de referencia
    for _, Image in pairs( NewItem.icons ) do

        --- Validar el tamaño completo 
        if not Image.icon_size then goto JumpImage end
        if Image.icon_size < 64 then goto JumpImage end

        --- Establecer la escala inicial
        if not Image.scale then Image.scale = 1 end
        if Image.scale < 1 then goto JumpImage end

        --- Calcular la escala
        Image.scale = Image.scale / ( Image.icon_size / 32 )

        --- Recepción del salto
        :: JumpImage ::
    end

    --- Agregar la imagen de referencia
    GPrefix.AddIcon( NewItem, ThisMOD )
end

--- Crear el objeto compactado
--- @param Data DataCompact
function Private.CreateCompactedRecipe( Data )

    --- Renombrar las variables
    local NewItem = Data.NewItem
    local OldItem = Data.OldItem

    --- Evitar crear recetas para los compactados mejorados
    if GPrefix.IC then
        local Improve = GPrefix.IC
        local isImprove = GPrefix.hasPrefixMOD( NewItem, Improve )
        if isImprove then return end
    end

    --- Valores para la receta
    local Table = { }
    Table[ ThisMOD.PrefixDo   ] = { }
    Table[ ThisMOD.PrefixUndo ] = { }

    --- Nombre del objeto a compactar
    local OldName = ThisMOD.Prefix_MOD_
    OldName = string.gsub( OldName, "-", "%%-" )
    OldName = string.gsub( NewItem.name, OldName, "" )

    --- Nombre del objeto compactado
    local NewName = GPrefix.addPrefixMOD( NewItem.name, ThisMOD )

    --- Valores para la descompresion
    Table[ ThisMOD.PrefixUndo ].name        = ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixUndo .. "-" .. OldName
    Table[ ThisMOD.PrefixUndo ].results     = { { type = "item", amount = ThisMOD.Value, name = OldItem.name } }
    Table[ ThisMOD.PrefixUndo ].ingredients = { { type = "item", amount = 1 , name = NewName } }
    Table[ ThisMOD.PrefixUndo ].action      = false

    --- Valores para la compresion
    Table[ ThisMOD.PrefixDo ].name        = ThisMOD.Prefix_MOD_ .. ThisMOD.PrefixDo .. "-" .. OldName
    Table[ ThisMOD.PrefixDo ].results     = { { type = "item", amount = 1 , name = NewName } }
    Table[ ThisMOD.PrefixDo ].ingredients = { { type = "item", amount = ThisMOD.Value, name = OldItem.name } }
    Table[ ThisMOD.PrefixDo ].action      = true

    for Category, Recipe in pairs( Table ) do

        --- Copiar el objeto
        local NewRecipe = { }

        --- Crear las recetas
        NewRecipe.name = Recipe.name
        NewRecipe.type = "recipe"

        NewRecipe.order    = NewItem.order
        NewRecipe.category = ThisMOD.Prefix_MOD_ .. Category
        NewRecipe.subgroup = NewItem.subgroup

        NewRecipe.results      = Recipe.results
        NewRecipe.ingredients  = Recipe.ingredients
        NewRecipe.main_product = ""

        NewRecipe.energy_required = 10
        NewRecipe.hide_from_player_crafting = not Recipe.action
        NewRecipe.localised_name = GPrefix.DeepCopy( OldItem.localised_name )
        table.insert( NewRecipe.localised_name, 2, { ThisMOD.Local .. Category .. "-process" } )
        table.insert( NewRecipe.localised_name, 3, " " )

        --- Agregar el indicador del MOD al apodo
        GPrefix.addLetter( NewRecipe, ThisMOD.Char )

        --- Duplicar la imagen del objeto
        NewRecipe.icons = GPrefix.DeepCopy( NewItem.icons )
        NewRecipe.icon_size = NewItem.icon_size
        NewRecipe.icon_mipmaps = NewItem.icon_mipmaps

        --- Agregar la flecha
        local List = { }

        List = { icon = "" }
        List.icon = List.icon .. ThisMOD.Patch
        List.icon = List.icon .. "icons/stacking-arrow-"
        List.icon = List.icon .. ( Recipe.action and "d" or "u" )
        List.icon = List.icon .. ".png"

        List.scale = 0.3
        List.icon_size = 64
        List.icon_mipmaps = 1

        table.insert( NewRecipe.icons, List )

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

        --- Renombrar las variables 
        local newRecipes = { }
        table.insert( newRecipes, ThisMOD.NewRecipes )
        table.insert( newRecipes, Data.TheMOD.NewRecipes )
        local OldItemName = OldItem.name

        --- Guardar la nueva recera
        for _, NewRecipes in pairs( newRecipes ) do

            --- Buscar el lugar de la receta
            NewRecipes[ OldItemName ] = NewRecipes[ OldItemName ] or { }
            NewRecipes = NewRecipes[ OldItemName ]

            --- Guardar la receta de la maquina
            local Flag = not GPrefix.inTable( NewRecipes, NewRecipe )
            if Flag then table.insert( NewRecipes, NewRecipe ) end
        end
    end
end

--- Verificar si el objeto o la receta esta compactado
--- @param Element table
--- @param TheMOD ThisMOD
function Private.UpdateDescription( Element, TheMOD )

    --- La descripción puede ser la que se busca
    if not GPrefix.hasPrefixMOD( Element, ThisMOD ) then return end
    local Array = Element.localised_description
    if not Array then return end
    if not GPrefix.isTable( Array ) then return end
    if #Array < 2 then return end
    if Array[ 1 ] ~= "" then return end

    --- La descripción es la que se busca
    if not GPrefix.isTable( Array[ 2 ] ) then return end
    local PrefixFind = ThisMOD.Local .. "item-description"
    if Array[ 2 ][ 1 ] ~= PrefixFind then return end

    --- Se actualiza el cambio
    Array = { localised_name = Array }
    GPrefix.addLetter( Array, TheMOD.Char )
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Configuración del MOD
function Private.Control( )
    local FileValid = { "control" }
    local Active = GPrefix.isActive( ThisMOD, FileValid )
    if not Active then return end

    --- Eventos a cargar
    Private.LoadEvents( )

    --- Guardar el MOD
    GPrefix.CI = ThisMOD
end

--- Crea un consolidado de variables para
--- usar en tiempo de ejecuión
--- @param Event table
--- @return DataThisMOD
function Private.CreateData( Event )
    local Data = GPrefix.CreateData( Event, ThisMOD )

    --- Crear el espacio para los objetos entregados
    Data.gGiven = Data.gForce[ Data.Player.index ] or { }
    Data.gForce[ Data.Player.index ] = Data.gGiven

    --- Eliminar los espacios vacios
    Data.gMOD.Players = nil
    Data.gPlayers = nil

    --- Devolver la información
    --- @cast Data +DataThisMOD
    --- @cast Data -Data
    return Data
end

--- Cargar los eventos a ejecutar
function Private.LoadEvents( )

    --- Al crear el mapa
    GPrefix.addEventOnControl( {
        Name = "on_init",
        Function = Private.Initialize,
    } )

    --- Al cargar el mapa
    GPrefix.addEventOnControl( {
        Name = "on_load",
        Function = Private.Initialize,
    } )

    --- Antes de eliminar al jugador de la partida
    GPrefix.addEventOnControl( {
        ID = defines.events.on_pre_player_removed,
        Function = function( Event )
            Private.BeforeDelete( Private.CreateData( Event ) )
        end,
    } )

    --- Antes de que el jugador salga de la partida
    GPrefix.addEventOnControl( {
        ID = defines.events.on_pre_player_left_game,
        Function = function( Event )
            Private.BeforeLogout( Private.CreateData( Event ) )
        end,
    } )
end

--- Inicializa el evento
function Private.Initialize( )

    --- Cargar el evento
    GPrefix.addAutomaticFunction( {
        Function = Private.ValidatePlayers,
        Name = ThisMOD.Name .. ": Private.ValidatePlayers( )"
    } )

    --- Indicador para revizar que todos
    --- los jugadores esten inicializados
    Private.CheckAllPlayers = true
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Funciones para agregar los objetos
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Contenedor de los jugadores a inicializar
Private.PlayersToInitialize = { }

--- Lista de objetos a agregar
Private.ItemsToAdd = { }
table.insert( Private.ItemsToAdd, { count = 1, name = "iron-plate" } )
table.insert( Private.ItemsToAdd, { count = 1, name = "copper-plate" } )
table.insert( Private.ItemsToAdd, { count = 1, name = "stone" } )
table.insert( Private.ItemsToAdd, { count = 1, name = "coal" } )

--- Función que ejecuta el evento
function Private.ValidatePlayers( )

    --- Agregar todos los jugadores para una validación
    if not Private.CheckAllPlayers then goto JumpAllPlayers end

    --- Agregar los jugadores
    for _, Player in pairs( game.players ) do
        Private.addPlayer( { Player = Player } )
    end

    --- Eliminar el indicador
    Private.CheckAllPlayers = nil

    --- Recepción del salto
    :: JumpAllPlayers ::

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- No hay jugadores por validar
    if #Private.PlayersToInitialize < 1 then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Verificar cada jugador
    for _, Data in pairs( Private.PlayersToInitialize ) do
        Private.addItems( Data )
    end
end

--- Agregar los jugadores a la cola
--- @param Event table
function Private.addPlayer( Event )
    local Data = Private.CreateData( Event )
    Private.PlayersToInitialize[ Data.Player.index ] = Data
end

--- Agregar los objetos al jugador
--- @param Data DataThisMOD
function Private.addItems( Data )

    --- Validar el modo del jugador
    local Controller = Data.Player.controller_type
    local isCharacter = Controller ~= defines.controllers.character
    local isGod = Controller ~= defines.controllers.god
    if isGod and isCharacter then return end

    --- Renombrar las variables
    local IDPlayer = Data.Player.index
    local Level = script.level.level_name
    local Beltbox = { count = 1, name = "express-transport-belt-beltbox" }

    --- El jugador se desconectó
    if not Data.Player.connected then
        Private.PlayersToInitialize[ IDPlayer ] = nil return
    end

    --- No hacer nada en los escesarios especificos
    if script.level.campaign_name then
        Private.PlayersToInitialize[ IDPlayer ] = nil return
    end

    --- Esperar que esté en el destino final
    local Flag = false
    Flag = Level == "wave-defense" and true or false
    Flag = Flag and Data.Player.surface.index < 2
    if Flag then return end

    Flag = Level == "team-production" and true or false
    Flag = Flag and Data.Player.force.index < 2
    if Flag then return end

    --- El prototipo no existe
    local Compact = game.item_prototypes[ "transport-belt-beltbox" ]
    if not Compact then ThisMOD.Active = false return end

    --- -- --- -- --- -- --- -- --- -- --- -- --- --

    --- Validar los nombres de los objetos a entregar
    for _, NewItem in pairs( Private.ItemsToAdd ) do
        local Name = ""
        Name = Name .. ThisMOD.Prefix_MOD_
        Name = Name .. ThisMOD.PrefixDo .. "-"
        Name = Name .. NewItem.name
        local Recipe = game.recipe_prototypes[ Name ]
        if Recipe then NewItem.name = Recipe.products[ 1 ].name end
    end

    --- Validar si se entregarón todos los objetos
    local ItemsToAdd = { }
    for _, NewItem in pairs( Private.ItemsToAdd ) do

        --- Objetos agregados
        local Start = #ItemsToAdd

        --- Recorrer los objetos entregados
        for _, OldItem in pairs( Data.gGiven ) do

            --- Contenedor
            local Item = { }

            --- Identificar al objeto
            if NewItem.name ~= OldItem.name then goto JumpOldItem end

            --- Calcular la cantidad de objetos a gregar
            Item.name = NewItem.name
            Item.count = NewItem.count - OldItem.count

            --- No es necesario agregar el objeto
            if Item.count < 1 then goto JumpNewItem end

            --- Agregar el objeto  a la lista
            table.insert( ItemsToAdd, Item )

            --- Recepción del salto
            :: JumpOldItem ::
        end

        --- Agregar el objeto  a la lista
        if Start == #ItemsToAdd then
            table.insert( ItemsToAdd, NewItem )
        end

        --- Recepción del salto
        :: JumpNewItem ::
    end

    --- Se le ha dado los objetos con anterioridad
    if #ItemsToAdd < 1 then
        Private.PlayersToInitialize[ IDPlayer ] = nil return
    end

    --- -- --- -- --- -- --- -- --- -- --- -- --- --

    --- El jugador no tiene un cuerpo
    if not Data.Player.character then
        Data.Player.insert( Beltbox )
        for _, Item in pairs( ItemsToAdd ) do
            Data.Player.insert( Item )
        end
    end

    --- El jugador tiene un cuerpo
    if Data.Player.character then
        local Inventory = Data.Player.character
        local IDInvertory = defines.inventory.character_main
        Inventory = Inventory.get_inventory( IDInvertory )
        Inventory.insert( Beltbox )
        for _, Item in pairs( ItemsToAdd ) do
            Inventory.insert( Item )
        end
    end

    --- -- --- -- --- -- --- -- --- -- --- -- --- --

    --- Marcar cómo hecho
    Private.PlayersToInitialize[ IDPlayer ] = nil
    for _, NewItem in pairs( Private.ItemsToAdd ) do
        local AddItems = true
        for _, OldItem in pairs( Data.gGiven ) do
            if OldItem.name == NewItem.name then
                OldItem.count = NewItem.count
                AddItems = false break
            end
        end
        if AddItems then
            table.insert( Data.gGiven, NewItem )
        end
    end
end

--- Hacer antes de borrar a un jugador
--- @param Data DataThisMOD
function Private.BeforeDelete( Data )
    local IDPlayer = Data.Player.index
    local IDForce = Data.Player.force.index
    Data.gForce[ IDForce ][ IDPlayer ] = nil
end

--- Hacer antes e salir de la partida
--- @param Data DataThisMOD
function Private.BeforeLogout( Data )
    Private.PlayersToInitialize[ Data.Player.index ] = nil
end

--- Cargar los eventos
Private.Control( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- @class DataCompact
--- @field TheMOD ThisMOD
--- @field NewItem table
--- @field OldItem table

--- @class DataThisMOD : Data
--- @field gGiven table Lista de objetos entregados al jugador

---------------------------------------------------------------------------------------------------