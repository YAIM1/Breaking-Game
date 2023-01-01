---------------------------------------------------------------------------------------------------

---> start-with-items.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Vanilla: eNqdkT8PgkAMxb/LzTQRRzdDGBhYTByMcTixKgGu2OsFwfjdPdFBE//h1KXv9/pelydldIVqorpuMU1SSCKIEojDYwhbZ3MywKgzIQY8uLyu0IgKVEbOz0k4OgevAbNmHkNGxgq7THoMrelJ+lbbm6NB3rVg9zmWG6iK8TD/nlEjWzK6hFJbZNjgFo3FP0BrLYLcDj8jjaO7uThmfM7/QnWLfiRbYIniW/vmVlPj4Zor/yB/3cPWb81cv1ITy4doqwsjuLSh

--- All: eNqdkb1uwkAQhN/lakaKCaSgQ4jCBQ1SiiiiONsbc7LvJ3t7IRDx7jloMFIiSLotZuab1bx+KactqZk6HF7m5QrlAosSy+KzQCSwtKD3ZIIlJxirkap9cqJmxcNx9LN1vXteovYuCqdajHdgX3kZWn/1nrGVaVFpEeI9bPd44d9DZwraMIKuu4t8eoMYiKN3ukevIzEaeiOXn7fd5G/w67DT28Gz5JzxP3JyAd3oIOYjH2x94sES07tjyBG3e8Stob7JVZ5uVslg2XKKeQDEZASTgfC4+QZu3bfV

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

    --- Procesar los prototipos del MOD
    Private.LoadPropotypes( )
    GPrefix.CreateNewElements( ThisMOD )

    --- Crear acceso directo al MOD
    GPrefix[ ThisMOD.MOD ] = ThisMOD
end

--- Procesar los prototipos cargados en el juego y
--- cargar los prototipos del MOD
function Private.LoadPropotypes( )
    Private.KeySequence( )
end

--- Conbinaciones de teclas
function Private.KeySequence( )
    local Table = { }
    Table.type = "custom-input"
    Table.localised_name = { ThisMOD.Local .. "setting-name"}
    Table.name = ThisMOD.Prefix_MOD
    Table.key_sequence = "CONTROL + I"
    data:extend( { Table } )
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Sección para los eventos
function Private.Control( )
    local FileValid = { "control" }
    local Active = GPrefix.isActive( ThisMOD, FileValid )
    if not Active then return end

    --- Eventos a cargar
    Private.LoadEvents( )
end

--- Crea un consolidado de variables para
--- usar en tiempo de ejecuión
--- @param Event table
--- @return DataThisMOD
function Private.CreateData( Event )
    local Data = GPrefix.CreateData( Event, ThisMOD )

    --- Lista de objetos con confirmación
    Data.gMOD.ItemsToGive = Data.gMOD.ItemsToGive or { }
    Data.gItemsToGive = Data.gMOD.ItemsToGive

    --- Lista de objetos sin confirmación
    local Items = GPrefix.DeepCopy( Data.gItemsToGive )
    Data.gPlayer.MyListToGive = Data.gPlayer.MyListToGive or Items
    Data.MyListToGive = Data.gPlayer.MyListToGive

    --- Lista de objeto entregados al jugador
    Data.gPlayer.ItemsGiven = Data.gPlayer.ItemsGiven or { }
    Data.gItemsGiven = Data.gPlayer.ItemsGiven

    --- Eliminar los espacios vacios
    Data.gMOD[ "Forces" ] = nil
    Data.gForce = nil

    --- Devolver la información
    --- @cast Data +DataThisMOD
    --- @cast Data -Data
    return Data
end

--- Cargar los eventos del MOD
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

    --- Jugadores a inicializar
    GPrefix.addEventOnControl( {
        ID = defines.events.on_player_created,
        Function = Private.addPlayer,
    } )

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

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

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Al usar la combinación de teclas
    GPrefix.addEventOnControl( {
        ID = ThisMOD.Prefix_MOD,
        Function = function( Event )
            Private.ToggleWindow( Private.CreateData( Event ) )
        end,
    } )

    --- Al cerrar la interfaz cuando se abre otra
    GPrefix.addEventOnControl( {
        ID = defines.events.on_gui_closed,
        Function = function( Event )
            Private.ToggleWindow( Private.CreateData( Event ) )
        end,
    } )

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Se cambia el valor del Slider
    GPrefix.addEventOnControl( {
        ID = defines.events.on_gui_value_changed,
        Function = function( Event )
            Private.ChangeSlider( Private.CreateData( Event ) )
        end,
    } )

    --- Al cambiar la cantidad de la caja de texto
    GPrefix.addEventOnControl( {
        ID = defines.events.on_gui_text_changed,
        Function = function( Event )

            --- Cargar la información en una estructura
            local Data = Private.CreateData( Event )

            --- Acciones del jugador
            Private.ChangeCount( Data )
            Private.EnableImportProsses( Data )
        end,
    } )

    --- Se cambió el objeto selecionado
    GPrefix.addEventOnControl( {
        ID = defines.events.on_gui_elem_changed,
        Function = function( Event )

            --- Cargar la información en una estructura
            local Data = Private.CreateData( Event )

            --- Acciones del jugador
            Private.NewItem( Data )
            Private.ClearItem( Data )
        end,
    } )

    --- Al hacer clic en algún elemento de la ventana
    GPrefix.addEventOnControl( {
        ID = defines.events.on_gui_click,
        Function = function( Event )

            --- Cargar la información en una estructura
            local Data = Private.CreateData( Event )

            --- Acciones del jugador
            Private.DiscardItemsConfirm( Data )
            Private.DiscardItemsCancel( Data )
            Private.DiscardItems( Data )

            Private.ApplyItemsConfirm( Data )
            Private.ApplyItemsCancel( Data )
            Private.ApplyItems( Data )

            Private.UpdateItem( Data )
            Private.RemoveItem( Data )
            Private.AddItem( Data )

            Private.ImportProsses( Data )
            Private.ExportButton( Data )
            Private.ImportButton( Data )
            Private.CloseWinowIO( Data )

            Private.ToggleWindow( Data )
            Private.ToggleSlot( Data )
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
--- Funciones de soporte
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Reiniciar las elementos del nuevo objetos
--- @param Data DataThisMOD
function Private.DisableSelection( Data )
    Data.GUI.Picture.elem_value = nil
    Data.Event.element = Data.GUI.Picture
    Private.ShowItems( Data )
    Private.UpdateTitleButton( Data )
    Private.ClearItem( Data )
end

--- Destruir la ventana y los enlacesa a la misma
--- @param Data DataThisMOD
function Private.DestroyWindow( Data )
    Data.GUI.WindowFrame.destroy( )
    Data.GPlayer.GUI = nil
    if GPrefix.Click then
        GPrefix.Click.Players[ Data.Player.index ] = nil
    end
end

--- Validar si se debe crear la ventana
--- @param Data DataThisMOD
function Private.ValidateToggleWindow( Data )

    --- Conbinación de teclas
    local PressKeySequence = false

    PressKeySequence = Data.Event.input_name
    if not PressKeySequence then goto JumpPressKeySequence end

    PressKeySequence = PressKeySequence == ThisMOD.Prefix_MOD
    if not PressKeySequence then goto JumpPressKeySequence end

    --- Evento identificado
    if true then return true end

    --- Recepción del salto
    :: JumpPressKeySequence ::

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Abriendo otra ventana
    local OpenOtherWindow = false

    OpenOtherWindow = Data.GUI.WindowFrame
    if not OpenOtherWindow then goto JumpOpenOtherWindow end

    OpenOtherWindow = defines.events.on_gui_closed
    OpenOtherWindow = Data.Event.name == OpenOtherWindow
    if not OpenOtherWindow then goto JumpOpenOtherWindow end

    --- Evento identificado
    if true then return true end

    --- Recepción del salto
    :: JumpOpenOtherWindow ::

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Cerrando con el boton de la ventana
    local CloseWindowButton = false

    CloseWindowButton = defines.events.on_gui_click
    CloseWindowButton = Data.Event.name == CloseWindowButton
    if not CloseWindowButton then goto JumpCloseWindowButton end

    CloseWindowButton = Data.GUI.CloseWindowButton
    CloseWindowButton = Data.Event.element == CloseWindowButton
    if not CloseWindowButton then goto JumpCloseWindowButton end

    --- Evento identificado
    if true then return true end

    --- Recepción del salto
    :: JumpCloseWindowButton ::

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    return false
end

--- Mostra los objetos en el cuerpo de la ventana
--- @param Data DataThisMOD
function Private.ShowItems( Data )

    --- Renombrar las varebles
    local Table = Data.GUI.ItemsTable
    local Items = Data.MyListToGive

    --- Valores predeterminados
    local Tags = { }
    Tags.Disabled = "inventory_slot"
    Tags.Enabled = "image_tab_selected_slot"
    Tags.Size = 40
    Tags.MOD = ThisMOD.Prefix_MOD

    --- Agregar los objetos
    Table.clear( )
    Private.SortItems( Data )
    for _, Item in pairs( Items ) do
        local Picture = { }
        Picture.tags = Tags
        Picture.type = "sprite-button"
        Picture.sprite = "item/" .. Item.name
        Picture.number = Item.count
        Picture = Table.add( Picture )
        Picture.style = Tags.Disabled
        Picture.style.padding = 0
        Picture.style.margin  = 0
        Picture.style.size = Tags.size
    end

    --- Calcular los espacio vacios
    local Count = math.ceil( #Items / Table.column_count )
    if Count < 4 then Count = 3 end
    Count = ( Count + 1 ) * 10
    Count = Count - #Items

    --- Agregar espacios vacios
    for _ = 1, Count, 1 do
        local Picture = { }
        Picture.type = "sprite-button"
        Picture = Table.add( Picture )
        Picture.style = Tags.Disabled
        Picture.style.padding = 0
        Picture.style.margin  = 0
        Picture.style.size = Tags.size
    end
end

--- Ordena los objos en la lista según su propedad order
--- @param Data DataThisMOD
function Private.SortItems( Data )

    --- Renombrar la vareble
    local Items = Data.MyListToGive

    --- Validación básica
    if #Items < 2 then return end

    --- Eliminar objetos que no existan
    local Delete = { }
    for Key, Item in pairs( Items ) do
        if not game.item_prototypes[ Item.name ] then
            table.insert( Delete, 1, Key )
        end
    end
    for _, Key in pairs( Delete ) do
        table.remove(  Items, Key)
    end

    --- Inicializa la vareble y renombrar
    local Table = { ToSort = { }, Source = { } }
    Table.Source = GPrefix.DeepCopy( Items )

    --- Eliminar las redundancias
    if true then
        local i = 1
        while i < #Table.Source do
            local iItem = Table.Source[ i ]
            local j = #Table.Source
            while j > i do
                local jItem = Table.Source[ j ]
                if iItem.name == jItem.name then
                    iItem.count = iItem.count + jItem.count
                    table.remove( Table.Source, j )
                end j = j - 1
            end i = i + 1
        end
    end

    --- Cargar los objetos
    local Delete = { }
    for _, Item in pairs( Table.Source ) do
        local m = 0
        Item.order = game.item_prototypes[ Item.name ].order
        table.insert( Table.ToSort, Item.order or "" )
    end

    --- Ordenar los objetos
    table.sort( Table.ToSort )

    --- Duplicar los detalles del objeto
    for Key, order in pairs( Table.ToSort ) do
        for key, Item in pairs( Table.Source ) do
            if Item.order == order then
                Table.ToSort[ Key ] = Item
                table.remove( Table.Source, key )
                break
            end
        end
    end

    --- Eliminar la lista vacia
    if #Table.Source < 1 then
        Table.Source = Table.ToSort
        Table.ToSort = nil
    end

    --- Hay almenos un objeto sin ordenar
    if Table.ToSort then
        local Msg = "ERROR: No se pudo organizar todos los objetos"
        GPrefix.Log( Msg, Items, Table )
        return
    end

    --- Ordernar los order duplicados
    if true then
        local i = 1
        while i < #Table.Source do

            --- Separar a los duplicados
            local iItem = Table.Source[ i ]
            Table.ToSort = { iItem.name }
            local j = i + 1
            while j <= #Table.Source do
                local jItem = Table.Source[ j ]
                if iItem.order == jItem.order then
                    table.insert( Table.ToSort, jItem.name )
                end j = j + 1
            end

            --- No hace falta ordenar
            if #Table.ToSort < 2 then goto JumpItem end

            --- Ordenarlos los duplicados
            table.sort( Table.ToSort )

            --- Guardar los duplicados
            for Key, ItemName in pairs( Table.ToSort ) do
                for key, Item in pairs( Table.Source ) do
                    if Item.name == ItemName then
                        Table.Source[ key ] = nil
                        Table.ToSort[ Key ] = Item
                    end
                end
            end

            --- Establecer el nuevo orden
            for k, Item in pairs( Table.ToSort ) do
                Table.Source[ i + k - 1 ] = Item
            end

            --- Recepción del salto
            :: JumpItem ::

            --- Saltar los duplicados
            i = i + #Table.ToSort
            Table.ToSort = nil
        end
    end

    --- Asignar el nuevo orden
    while #Items > 0 do table.remove( Items, 1 ) end
    for _, Item in pairs( Table.Source ) do
        table.insert( Items, Item )
        Item.order = nil
    end
end

--- Actualizar el estado de los botones en la barra de titulo
--- @param Data DataThisMOD
function Private.UpdateTitleButton( Data )

    --- Activar el botón
    local OldItems = GPrefix.toString( Data.gItemsToGive )
    local NewItems = GPrefix.toString( Data.MyListToGive )
    local Eneable = false
    local Button = { }

    --- Actualizar el boton
    Eneable = OldItems ~= NewItems
    Button = Data.GUI.GreenButton
    Button.enabled = Eneable
    Button.tooltip = Eneable and { ThisMOD.Local .. "apply"} or ""

    --- Actualizar el boton
    Eneable = OldItems ~= NewItems
    Button = Data.GUI.RedButton
    Button.enabled = Eneable
    Button.tooltip = Eneable and { ThisMOD.Local .. "discard"} or ""

    --- Actualizar el boton
    Eneable = #Data.MyListToGive > 0
    Button = Data.GUI.ExportButton
    Button.enabled = Eneable
    Button.tooltip = Eneable and { ThisMOD.Local .. "export"} or ""

    --- Actualizar el boton
    Eneable = true
    Button = Data.GUI.ImportButton
    Button.enabled = Eneable
    Button.tooltip = Eneable and { ThisMOD.Local .. "import"} or ""
end

--- Habilitar el boton de importar si hay texto en la caja
--- @param Data DataThisMOD
function Private.EnableImportProsses( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.TextBox then return end
    if not Data.GUI.WindowIOFlow.visible then return end
    if Data.GUI.TextBox.read_only then return end

    --- Actualizar el boton
    local Eneable = string.len( Data.GUI.TextBox.text ) > 0
    local Button = Data.GUI.GreenButton
    Button.enabled = Eneable
    Button.tooltip = Eneable and { ThisMOD.Local .. "import"} or ""
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Funciones para agregar los objetos
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Contenedor de los jugadores a inicializar
Private.PlayersToInitialize = { }

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

    --- Validar si se entregarón todos los objetos
    local ItemsToAdd = { }
    for _, NewItem in pairs( Data.gItemsToGive ) do

        --- Objetos agregados
        local Start = #ItemsToAdd

        --- Recorrer los objetos entregados
        for _, OldItem in pairs( Data.gItemsGiven ) do

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

    --- Renombrar las variables
    local IDPlayer = Data.Player.index

    --- Se le ha dado los objetos con anterioridad
    if #ItemsToAdd < 1 then
        Private.PlayersToInitialize[ IDPlayer ] = nil return
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --

    --- El jugador no tiene un cuerpo
    if not Data.Player.character then
        for _, Item in pairs( ItemsToAdd ) do
            Data.Player.insert( Item )
        end
    end

    --- El jugador tiene un cuerpo
    if Data.Player.character then
        local Inventory = Data.Player.character
        local IDInvertory = defines.inventory.character_main
        Inventory = Inventory.get_inventory( IDInvertory )
        for _, Item in pairs( ItemsToAdd ) do
            Inventory.insert( Item )
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --

    --- Marcar cómo hecho
    Private.PlayersToInitialize[ IDPlayer ] = nil
    for _, NewItem in pairs( Data.gItemsToGive ) do
        local AddItems = true
        for _, OldItem in pairs( Data.gItemsGiven ) do
            if OldItem.name == NewItem.name then
                OldItem.count = NewItem.count
                AddItems = false break
            end
        end
        if AddItems then
            table.insert( Data.gItemsGiven, NewItem )
        end
    end
end

--- Hacer antes de borrar a un jugador
--- @param Data DataThisMOD
function Private.BeforeDelete( Data )
    local IDPlayer = Data.Player.index
    Data.gMOD.Players[ IDPlayer ] = nil
end

--- Hacer antes e salir de la partida
--- @param Data DataThisMOD
function Private.BeforeLogout( Data )
    Private.PlayersToInitialize[ Data.Player.index ] = nil
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Prototipo de la ventana principal
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Crear la ventana
--- @param Data DataThisMOD
function Private.BuildWindow( Data )

    --- Ventana principal
    local WindowFrame =  { }
    WindowFrame.type = "frame"
    WindowFrame.direction = "vertical"

    --- Mostra la ventana
    local Screen = Data.Player.gui.screen
    WindowFrame = Screen.add( WindowFrame )
    WindowFrame.auto_center = true

    --- Indicar que la ventana esta abierta
    --- Cerrar la ventana al abrir otra ventana, presionar E o Esc
    Data.Player.opened = WindowFrame

    --- Contenedor principal
    local WindowFlow = { }
    WindowFlow.type = "flow"
    WindowFlow.direction = "vertical"
    WindowFlow = WindowFrame.add( WindowFlow )
    WindowFlow.style.vertical_spacing = 9
    WindowFlow.style.horizontally_stretchable = true

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.WindowFrame = WindowFrame
    Data.GUI.WindowFlow = WindowFlow

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Cotruir la interfaz
    Private.BuildWindowTitle( Data )
    Private.BuildWindowSelection( Data )
    Private.BuildWindowIO( Data )

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Eliminar la referencia
    Data.GUI.WindowFlow = nil
end

--- Construir el titulo de la ventana
--- @param Data table
function Private.BuildWindowTitle( Data )

    --- Contenedor
    local TitleBar = { }
    TitleBar.type = "flow"
    TitleBar.direction = "horizontal"
    TitleBar = Data.GUI.WindowFlow.add( TitleBar )
    TitleBar.style.horizontal_spacing = 9
    TitleBar.style.height = 24

    --- Etiqueta con el titulo
    local Lable = { }
    Lable.type = "label"
    Lable.caption = { ThisMOD.Local .. "setting-name"}
    Lable = TitleBar.add( Lable )
    Lable.style = "frame_title"

    --- Indicador para mover la ventana
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = TitleBar.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.WindowFrame
    EmptyWidget.style = "draggable_space_header"
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
    EmptyWidget.style.margin = 0


    --- Contenedor
    local Flow = { }


    --- Contenedor
    Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = TitleBar.add( Flow )
    Flow.style.horizontal_spacing = 3

    --- Botón para importar
    local ImportButton = { }
    ImportButton.type = "sprite-button"
    ImportButton.sprite = "utility/import"
    ImportButton.tooltip = { ThisMOD.Local .. "import"}
    ImportButton = Flow.add( ImportButton )
    ImportButton.style = "tool_button_blue"
    ImportButton.style.padding = 0
    ImportButton.style.margin = 0
    ImportButton.style.size = 24

    --- Botón para exportar
    local ExportButton = { }
    ExportButton.type = "sprite-button"
    ExportButton.sprite = "utility/export"
    ExportButton = Flow.add( ExportButton )
    ExportButton.style = "tool_button_blue"
    ExportButton.style.padding = 0
    ExportButton.style.margin = 0
    ExportButton.style.size = 24

    --- Activar el botón
    ExportButton.enabled = #Data.MyListToGive > 0


    --- Contenedor
    Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = TitleBar.add( Flow )
    Flow.style.horizontal_spacing = 3

    --- Activar el botón
    local OldItems = GPrefix.toString( Data.gItemsToGive )
    local NewItems = GPrefix.toString( Data.MyListToGive )

    --- Botón para cancelar los cambios
    local RedButton = { }
    RedButton.type = "sprite-button"
    RedButton.sprite = "utility/close_fat"
    RedButton = Flow.add( RedButton )
    RedButton.style = "tool_button_red"
    RedButton.style.padding = 0
    RedButton.style.margin = 0
    RedButton.style.size = 24
    RedButton.enabled = OldItems ~= NewItems

    --- Botón para aplicar los cambios
    local GreenButton = { }
    GreenButton.type = "sprite-button"
    GreenButton.sprite = "utility/play"
    GreenButton = Flow.add( GreenButton )
    GreenButton.style = "tool_button_green"
    GreenButton.style.padding = 0
    GreenButton.style.margin = 0
    GreenButton.style.size = 24
    GreenButton.enabled = OldItems ~= NewItems


    --- Contenedor
    Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = TitleBar.add( Flow )
    Flow.style.horizontal_spacing = 3

    --- Botón de cierre
    local CloseButton = { }
    CloseButton.type = "sprite-button"
    CloseButton.sprite = "utility/close_white"
    CloseButton.hovered_sprite = "utility/close_black"
    CloseButton.clicked_sprite = "utility/close_black"
    CloseButton.tooltip = { ThisMOD.Local .. "close" }
    CloseButton = Flow.add( CloseButton )
    CloseButton.style = "frame_action_button"
    CloseButton.style.padding = 0
    CloseButton.style.margin = 0
    CloseButton.style.size = 24

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.ExportButton = ExportButton
    Data.GUI.ImportButton = ImportButton

    Data.GUI.GreenButton = GreenButton
    Data.GUI.RedButton = RedButton

    Data.GUI.CloseWindowButton = CloseButton

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    Private.UpdateTitleButton( Data )
end

--- Construir el cuerpo de la ventana
--- @param Data table
function Private.BuildWindowSelection( Data )

    --- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.WindowFlow.add( Flow )
    Flow.style.vertical_spacing = 3

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.WindowSelectionFlow = Flow

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Cotruir la interfaz
    Private.BuildSelectionListSection( Data )
    Private.BuildSelectionItemSection( Data )
end

--- Construir las opciones de los items a elegir
--- @param Data DataThisMOD
function Private.BuildSelectionListSection( Data )

    --- Fondo de la lLista
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.WindowSelectionFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    --- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.size = { 420, 168 }

    --- Tabla contenedora
    local Table = { }
    Table.type = "table"
    Table.column_count = 10
    Table = ScrollPane.add( Table )
    Table.style.vertically_stretchable = true
    Table.style.horizontally_stretchable = true
    Table.style.horizontal_spacing = 0
    Table.style.vertical_spacing = 0

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.ItemsTable = Table

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Cargar los objetos
    Private.ShowItems( Data )
end

--- Construir la seccion baja de la ventana
--- @param Data DataThisMOD
function Private.BuildSelectionItemSection( Data )

    --- Fondo de la lLista
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Data.GUI.WindowSelectionFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    --- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true
    ScrollPane.style.size = { 420, 70 }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.ScrollPane = ScrollPane

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Cotruir la interfaz
    Private.BuildSelectionItem( Data )
    Private.BuildSelectionMenssage( Data )

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Eliminar la referencia
    Data.GUI.ScrollPane = nil
end

--- Construir la configuración con la que se
--- puede agregar un objeto
--- @param Data DataThisMOD
function Private.BuildSelectionItem( Data )

    --- Inicializa la vareble y renombrar
    local ScrollPane = Data.GUI.ScrollPane

    --- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = ScrollPane.add( Flow )
    Flow.style.horizontal_spacing = 9
    Flow.style.vertical_align = "center"
    Flow.style.margin = { 10, 20 }

    --- Crear la imagen de selección
    local Picture = { }
    Picture.type = "choose-elem-button"
    Picture.style = "transparent_slot"
    Picture.elem_type = "item"
    Picture.elem_value = "iron-chest"
    Picture = Flow.add( Picture )
    Picture.style = "inventory_slot"
    Picture.style.margin = 0
    Picture.style.padding = 0
    Picture.style.size = 40

    --- Slider
    local Slider = { }
    Slider.type = "slider"
    Slider.minimum_value = 1
    Slider.maximum_value = 10
    Slider.value_step = 1
    Slider = Flow.add( Slider )
    Slider.style = "notched_slider"
    Slider.style.horizontally_stretchable = true
    Slider.enabled = false

    --- Valor del slider
    local Textfield = { }
    Textfield.type = "textfield"
    Textfield.text = ""
    Textfield = Flow.add( Textfield )
    Textfield.style = "slider_value_textfield"
    Textfield.enabled = false

    --- Botón de confirmación
    local Button = { }
    Button.type = "sprite-button"
    Button.sprite = "utility/check_mark_white"
    Button = Flow.add( Button )
    Button.style = "tool_button_green"
    Button.style.padding = 0
    Button.style.margin = 0
    Button.style.size = 28
    Button.enabled = false

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.SelectFlow = Flow

    Data.GUI.Slider = Slider
    Data.GUI.Picture = Picture
    Data.GUI.Button = Button
    Data.GUI.Textfield = Textfield
end

--- Constructor la configuración para mostrar
--- un mensaje en la ventana
--- @param Data DataThisMOD
function Private.BuildSelectionMenssage( Data )

    --- Inicializa la vareble y renombrar
    local ScrollPane = Data.GUI.ScrollPane

    --- Contenedor
    local OutFlow = { }
    OutFlow.type = "flow"
    OutFlow.direction = "vertical"
    OutFlow = ScrollPane.add( OutFlow )
    OutFlow.style.vertical_spacing = 0
    OutFlow.style.horizontal_align = "center"
    OutFlow.style.width = 400
    OutFlow.visible = false


    --- Contenedor
    local InFlow = { }
    InFlow.type = "flow"
    InFlow.direction = "horizontal"
    InFlow = OutFlow.add( InFlow )
    InFlow.style.horizontal_spacing = 0
    InFlow.style.vertical_align = "center"
    InFlow.style.height = 24

    --- Botón para cancelar los cambios
    local NoButton = { }
    NoButton.type = "sprite-button"
    NoButton.sprite = "utility/close_fat"
    NoButton = InFlow.add( NoButton )
    NoButton.style = "tool_button_red"
    NoButton.style.padding = 0
    NoButton.style.margin = 0
    NoButton.style.size = 24

    --- Espacio "vacio"
    local LeftEmptyWidget = { }
    LeftEmptyWidget.type = "empty-widget"
    LeftEmptyWidget = InFlow.add( LeftEmptyWidget )
    LeftEmptyWidget.drag_target = Data.GUI.WindowFrame
    LeftEmptyWidget.style.horizontally_stretchable = true
    LeftEmptyWidget.style.vertically_stretchable = true
    LeftEmptyWidget.style.margin = 0

    --- Etiqueta con el titulo
    local Title = { }
    Title.type = "label"
    Title = InFlow.add( Title )
    Title.style = "heading_1_label"

    --- Espacio "vacio"
    local RightEmptyWidget = { }
    RightEmptyWidget.type = "empty-widget"
    RightEmptyWidget = InFlow.add( RightEmptyWidget )
    RightEmptyWidget.drag_target = Data.GUI.WindowFrame
    RightEmptyWidget.style.horizontally_stretchable = true
    RightEmptyWidget.style.vertically_stretchable = true
    RightEmptyWidget.style.margin = 0

    --- Botón para aplicar los cambios
    local YesButton = { }
    YesButton.type = "sprite-button"
    YesButton.sprite = "utility/play"
    YesButton = InFlow.add( YesButton )
    YesButton.style = "tool_button_green"
    YesButton.style.padding = 0
    YesButton.style.margin = 0
    YesButton.style.size = 24


    --- Etiqueta con el mensaje
    local Message = { }
    Message.type = "label"
    Message = OutFlow.add( Message )
    Message.style.single_line = false

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.MessageFlow = OutFlow

    Data.GUI.TitleLabel = Title
    Data.GUI.MessageLabel = Message

    Data.GUI.NoButton = NoButton
    Data.GUI.YesButton = YesButton
end

--- Constuir el cuerpo del seccion donde agregar
--- la cadena de texto
---@param Data DataThisMOD
function Private.BuildWindowIO( Data )

    --- Contenedor - Cuerpo
    local OutFlow = { }
    OutFlow.type = "flow"
    OutFlow.direction = "vertical"
    OutFlow = Data.GUI.WindowFlow.add( OutFlow )
    OutFlow.style.vertical_spacing = 9
    OutFlow.style.size = { 428, 257 }
    OutFlow.visible = false


    --- Fondo de la lista
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = OutFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    --- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"


    --- Texto de entrada o salida
    local TextBox = { }
    TextBox.type = "text-box"
    TextBox = ScrollPane.add( TextBox )
    TextBox.word_wrap = true
    TextBox.read_only = true
    TextBox.text = ""
    TextBox.style.size = { 400, 241 }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Guardar instancia
    Data.GUI.WindowIOFlow = OutFlow
    Data.GUI.TextBox = TextBox
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Acciones del jugador en la ventana
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Hacer crear o destruir la ventana
--- @param Data DataThisMOD
function Private.ToggleWindow( Data )

    --- Validación básico
    if not Data.Player.connected then return end
    if not Data.Player.admin then return end
    if not Private.isValid( Data ) then return end

    --- Validar evento
    if not Private.ValidateToggleWindow( Data ) then return end

    --- Acción a ejecutar
    if Data.GUI.WindowFrame then
        Private.DestroyWindow( Data )
    else
        Private.BuildWindow( Data )
    end
end

--- Validar si se ejecuta el MOD
--- @param Data DataThisMOD
function Private.isValid( Data )

    --- Validar el modo del jugador
    local Controller = Data.Player.controller_type
    local isCharacter = Controller ~= defines.controllers.character
    local isGod = Controller ~= defines.controllers.god
    if isGod and isCharacter then return end

    --- Renombrar las variables
    local IDPlayer = Data.Player.index
    local Level = script.level.level_name

    --- El jugador se desconectó
    if not Data.Player.connected then
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
    return true
end

--- Selecionar un objeto de la lista
--- @param Data DataThisMOD
function Private.ToggleSlot( Data )

    --- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    --- Validación básica
    local OldButton = Data.Click and Data.Click.Selected or nil
    if not GPrefix.ClickLeft( Data ) then return end

    --- Renombrar la variable
    local NewButton = Data.Event.element
    local Tags = Data.Event.element.tags

    --- Validar botón
    if not( Tags and Tags.Enabled and Tags.Disabled ) then return end
    if not Tags.MOD and Tags.MOD ~= ThisMOD.Prefix_MOD then return end
    if OldButton and OldButton == NewButton then return end
    if Data.GUI.MessageFlow.visible then return end

    --- Hacer el cambio
    Data.Click.Selected = NewButton
    for _, Button in pairs( { NewButton, OldButton } ) do
        GPrefix.ToggleButton( Button )
    end

    --- Habilitar los elementos
    Data.GUI.Slider.enabled = true
    Data.GUI.Button.enabled = true
    Data.GUI.Textfield.enabled = true

    --- Selecionar un objeto
    local ItemName = string.gsub( NewButton.sprite, "item/", "" )
    local StackSize = game.item_prototypes[ ItemName ].stack_size
    Data.GUI.Slider.set_slider_minimum_maximum( 0, 10 * StackSize )
    Data.GUI.Slider.set_slider_value_step( StackSize )

    Data.GUI.Picture.elem_value = ItemName
    Data.GUI.Slider.slider_value = NewButton.number or 0
    Data.GUI.Textfield.text = tostring( NewButton.number or 0 )
    Data.GUI.Button.tooltip = { ThisMOD.Local .. "update"}
end

--- Actualizar la cantidad del objeto a agregar
--- en la caja de texto segun lo indique el Slider
--- @param Data DataThisMOD
function Private.ChangeSlider( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Slider then return end

    --- Establecer el valor
    local Value = Data.GUI.Slider.slider_value
    Data.GUI.Textfield.text = tostring( Value )
end

--- Actualizar la cantidad del objeto a agregar
--- en la Slider segun lo indique la caja de texto
--- @param Data DataThisMOD
function Private.ChangeCount( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Textfield then return end

    --- Establecer el valor
    local Text = Data.GUI.Textfield.text
    local Value = tonumber( Text, 10 ) or 0
    if Value > Data.GUI.Slider.get_slider_maximum( ) then
        Value = Data.GUI.Slider.get_slider_maximum( )
    end Data.GUI.Slider.slider_value = Value
end

--- Cargar los datos del nuevo objeto
--- @param Data DataThisMOD
function Private.NewItem( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Picture then return end

    local ItemName = Data.GUI.Picture.elem_value
    if not GPrefix.isString( ItemName ) then return end

    --- Limpiar el objeto seleccionado
    if Data.Click and Data.Click.Selected then
        local Item = Data.GUI.Picture.elem_value
        Data.Event.element = Data.GUI.Picture
        Data.GUI.Picture.elem_value = nil
        Private.ClearItem( Data )
        Data.GUI.Picture.elem_value = Item
    end

    --- Habilitar los elementos
    Data.GUI.Slider.enabled = true
    Data.GUI.Button.enabled = true
    Data.GUI.Textfield.enabled = true

    --- Establecer los valores
    local StackSize = game.item_prototypes[ ItemName ].stack_size
    Data.GUI.Slider.set_slider_minimum_maximum( 0, 10 * StackSize )
    Data.GUI.Slider.set_slider_value_step( StackSize )

    Data.GUI.Textfield.text = tostring( StackSize )
    Data.GUI.Slider.slider_value = StackSize
    Data.GUI.Button.tooltip = { ThisMOD.Local .. "add"}
end

--- Eliminar los datos del nuevo objeto
--- @param Data DataThisMOD
function Private.ClearItem( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Picture then return end

    local ItemName = Data.GUI.Picture.elem_value
    if GPrefix.isString( ItemName ) then return end

    if Data.Click and Data.Click.Selected then
        GPrefix.ToggleButton( Data.Click.Selected )
        Data.Click.Selected = nil
    end

    --- Limpiar los valores
    Data.GUI.Button.tooltip = ""
    Data.GUI.Textfield.text = ""
    Data.GUI.Slider.slider_value = 0

    --- Deshabilitar los elementos
    Data.GUI.Slider.enabled = false
    Data.GUI.Button.enabled = false
    Data.GUI.Textfield.enabled = false
end

--- Agregar los datos del nuevo objeto a
--- la lista del jugador
--- @param Data DataThisMOD
function Private.AddItem( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Button then return end
    if Data.Click and Data.Click.Selected then return end

    --- Guardar el objeto
    local Text = Data.GUI.Textfield.text
    local Count = tonumber( Text, 10 ) or 0
    table.insert( Data.MyListToGive, {
        name = Data.GUI.Picture.elem_value,
        count = Count > 0 and Count or nil,
    } )

    --- Establecer el valor
    Private.DisableSelection( Data )
end

--- Agregar los nuevos datos del objeto
--- seleccionado de la lista del jugador
--- @param Data DataThisMOD
function Private.UpdateItem( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Button then return end
    if not Data.Click or not Data.Click.Selected then return end

    --- Guardar el objeto
    local Text = Data.GUI.Textfield.text
    local Count = tonumber( Text, 10 ) or 0
    local ItemName = Data.GUI.Picture.elem_value
    for _, Item in pairs( Data.MyListToGive ) do
        if ItemName == Item.name then
            Item.count = Count > 0 and Count or nil
            Data.Click.Selected = nil break
        end
    end

    --- Establecer el valor
    Private.DisableSelection( Data )
end

--- Eliminar el nuevo objeto a de
--- la lista del jugador
--- @param Data DataThisMOD
function Private.RemoveItem( Data )

    --- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    --- Validación básica
    if not GPrefix.ClickRight( Data ) then return end

    --- Renombrar la variable
    local Tags = Data.Event.element.tags

    --- Validar botón
    if not( Tags and Tags.Enabled and Tags.Disabled ) then return end
    if not Tags.MOD and Tags.MOD ~= ThisMOD.Prefix_MOD then return end
    if Data.GUI.MessageFlow.visible then return end

    --- Renombrar la variable
    local NewButton = Data.Event.element

    --- Remover el objeto de la lista
    local ItemName = string.gsub( NewButton.sprite, "item/", "" )
    local Items = Data.MyListToGive
    for Key, Item in pairs( Items ) do
        if ItemName == Item.name then
            table.remove( Items, Key )
            Data.Click.Selected = nil break
        end
    end

    --- Establecer el valor
    Private.DisableSelection( Data )
end

--- Mostrar el mensaje de configuración para cambiar
--. la lista de objetos a dar
--- @param Data DataThisMOD
function Private.ApplyItems( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.GreenButton then return end
    if not Data.GUI.WindowSelectionFlow.visible then return end

    --- Habilitar los botones necesarios
    Private.UpdateTitleButton( Data )

    --- Desactivar el botón
    Data.GUI.GreenButton.enabled = false
    Data.GUI.GreenButton.tooltip = ""

    --- Actualizar el mensaje y el titulo
    Data.GUI.TitleLabel.caption = { ThisMOD.Local .. "apply" }
    Data.GUI.MessageLabel.caption = { ThisMOD.Local .. "apply-message" }

    --- Limpiar el objeto seleccionado
    Data.Event.element = Data.GUI.Picture
    Data.GUI.Picture.elem_value = nil
    Private.ClearItem( Data )

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = true
    Data.GUI.SelectFlow.visible = false
end

--- Cancelar el cambio de la lista en la confirmación
--- @param Data DataThisMOD
function Private.ApplyItemsCancel( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.NoButton then return end
    if Data.GUI.GreenButton.enabled then return end

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = false
    Data.GUI.SelectFlow.visible = true

    --- Establecer el valor
    Private.DisableSelection( Data )
end

--- Cambiar la lista de los objetos a dar
--- @param Data DataThisMOD
function Private.ApplyItemsConfirm( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.YesButton then return end
    if Data.GUI.GreenButton.enabled then return end

    --- Guardar el objeto
    Data.gItemsToGive = GPrefix.DeepCopy( Data.MyListToGive )
    Data.gMOD.ItemsToGive = Data.gItemsToGive

    --- Establecer el valor
    Private.DisableSelection( Data )

    --- Agregar los objetos selecionados
    Private.CheckAllPlayers = true

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = false
    Data.GUI.SelectFlow.visible = true

    --- Informar del cambio
    game.print( { "",
        "[color=default]",
        { ThisMOD.Local .. "setting-name" },
        ": [/color]",
        {
            ThisMOD.Local .. "status-change",
            {
                "",
                "[img=utility/character_mining_speed_modifier_icon][color=" ..
                Data.Player.color.r .. "," ..
                Data.Player.color.g .. "," ..
                Data.Player.color.b .. "]",
                Data.Player.name,
                "[/color]"
            },
        }
    } )
end

--- Mostrar el mensaje de configuración para eliminar
--. la lista de objetos que tiene el jugador
--- @param Data DataThisMOD
function Private.DiscardItems( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.RedButton then return end
    if not Data.GUI.WindowSelectionFlow.visible then return end

    --- Habilitar los botones necesarios
    Private.UpdateTitleButton( Data )

    --- Desactivar el botón
    Data.GUI.RedButton.enabled = false
    Data.GUI.RedButton.tooltip = ""

    --- Actualizar el mensaje y el titulo
    Data.GUI.TitleLabel.caption = { ThisMOD.Local .. "discard" }
    Data.GUI.MessageLabel.caption = { ThisMOD.Local .. "discard-message" }

    --- Limpiar el objeto seleccionado
    Data.Event.element = Data.GUI.Picture
    Data.GUI.Picture.elem_value = nil
    Private.ClearItem( Data )

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = true
    Data.GUI.SelectFlow.visible = false
end

--- Cancelar la eliminación de la lista en la confirmación
--- @param Data DataThisMOD
function Private.DiscardItemsCancel( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.NoButton then return end
    if Data.GUI.RedButton.enabled then return end

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = false
    Data.GUI.SelectFlow.visible = true

    --- Establecer el valor
    Private.DisableSelection( Data )
end

--- Eliminar la lista de los objetos a dar
--- @param Data DataThisMOD
function Private.DiscardItemsConfirm( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.YesButton then return end
    if Data.GUI.RedButton.enabled then return end

    --- Guardar el objeto
    Data.MyListToGive = GPrefix.DeepCopy( Data.gItemsToGive )
    Data.gPlayer.MyListToGive = Data.MyListToGive

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = false
    Data.GUI.SelectFlow.visible = true

    --- Establecer el valor
    Private.DisableSelection( Data )
end

--- Hacer visible la seccion para import una lista
--- @param Data DataThisMOD
function Private.ImportButton( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.ImportButton then return end

    --- Habilitar los botones necesarios
    Private.UpdateTitleButton( Data )

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = false
    Data.GUI.SelectFlow.visible = true

    --- Hacer visible la seccion de IO
    Data.GUI.TextBox.read_only = false
    Data.GUI.WindowIOFlow.visible = true
    Data.GUI.WindowSelectionFlow.visible = false

    --- Deshabilitar el botón
    Data.GUI.ImportButton.enabled = false
    Data.GUI.ImportButton.tooltip = ""

    Data.GUI.GreenButton.enabled = false
    Data.GUI.GreenButton.tooltip = ""

    --- Habilitar el botón
    Data.GUI.RedButton.enabled = true
    Data.GUI.RedButton.tooltip = { ThisMOD.Local .. "cancel" }

    --- Limipiar y enfocar
    Data.GUI.TextBox.text = ""
    Data.GUI.TextBox.focus( )
end

--- Toma el texto dado en la importación y lo Establece
--- como la nueva lista de objetos del jugador
---@param Data DataThisMOD
function Private.ImportProsses( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.GreenButton then return end
    if not Data.GUI.WindowIOFlow.visible then return end
    if Data.GUI.TextBox.read_only then return end

    --- Contenedor
    local Table = { }

    --- Guardar la nueva lista objeto
    Table.Text = Data.GUI.TextBox.text
    Table.JSON = game.decode_string( Table.Text )
    if not Table.JSON then goto JumpTrayAgain end
    Table.Items = game.json_to_table( Table.JSON ) or { }
    if #Table.Items < 1 then goto JumpTrayAgain end

    --- Acutualizar la lista
    Data.gPlayer.MyListToGive = Table.Items
    Data.MyListToGive = Table.Items
    Private.ShowItems( Data )

    --- Volver a la lista
    Data.Event.element = Data.GUI.RedButton
    Private.CloseWinowIO( Data )

    --- Todo salió bien
    if true then return end

    --- Recepción del salto
    :: JumpTrayAgain ::

    --- Volver al inicio
    Data.GUI.GreenButton.enabled = false
    Data.GUI.TextBox.text = ""
    Data.GUI.TextBox.focus( )
end

--- Convierte la lista actual de objetos del jugador
--- en una cadena de caracteres
--- @param Data DataThisMOD
function Private.ExportButton( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.ExportButton then return end

    --- Habilitar los botones necesarios
    Private.UpdateTitleButton( Data )

    --- Hacer visible la seccion
    Data.GUI.MessageFlow.visible = false
    Data.GUI.SelectFlow.visible = true

    --- Hacer visible la seccion de IO
    Data.GUI.TextBox.read_only = true
    Data.GUI.WindowIOFlow.visible = true
    Data.GUI.WindowSelectionFlow.visible = false

    --- Deshabilitar el botón
    Data.GUI.ExportButton.enabled = false
    Data.GUI.ExportButton.tooltip = ""

    Data.GUI.GreenButton.enabled = false
    Data.GUI.GreenButton.tooltip = ""

    --- Habilitar el botón
    Data.GUI.RedButton.enabled = true
    Data.GUI.RedButton.tooltip = { ThisMOD.Local .. "cancel" }

    --- Limipiar y enfocar
    Data.GUI.TextBox.text = game.table_to_json( Data.MyListToGive )
    Data.GUI.TextBox.text = game.encode_string( Data.GUI.TextBox.text )
    Data.GUI.TextBox.select_all( )
    Data.GUI.TextBox.focus( )
end

--- Ocultar la seccion para import una lista
--- @param Data DataThisMOD
function Private.CloseWinowIO( Data )

    --- Validación básica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.RedButton then return end
    if not Data.GUI.WindowIOFlow.visible then return end

    --- Cancelar la entrada de datos
    Data.GUI.ImportButton.enabled = true
    Data.GUI.WindowIOFlow.visible = false
    Data.GUI.WindowSelectionFlow.visible = true
    Private.UpdateTitleButton( Data )
end

--- Sección para los eventos
Private.Control( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- @class DataThisMOD : Data
--- @field MyListToGive table Lista de objetos a entregar al jugador
--- @field gItemsToGive table Lista de objetos a entregar al jugador
--- @field gItemsGiven table Lista de objetos entregados al jugador

---------------------------------------------------------------------------------------------------