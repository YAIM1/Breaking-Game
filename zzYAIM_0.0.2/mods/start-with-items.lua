---------------------------------------------------------------------------------------------------

--> start-with-items.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Contenedor de este MOD
local ThisMOD = { }

-- Cargar información de este MOD
if true then

    -- Identifica el mod que se está usando
    local NameMOD = GPrefix.getFile( debug.getinfo( 1 ).short_src )

    -- Crear la vareble si no existe
    GPrefix.MODs[ NameMOD ] = GPrefix.MODs[ NameMOD ] or { }

    -- Guardar en el acceso rapido
    ThisMOD = GPrefix.MODs[ NameMOD ]
end

-- Configuración del MOD
local function Settings( )
    if not GPrefix.getKey( { "settings" }, GPrefix.File ) then return end

    local SettingOption =  { }
    SettingOption.name  = ThisMOD.Prefix_MOD
    SettingOption.type  = "bool-setting"
	SettingOption.order = ThisMOD.Char
    SettingOption.setting_type   = "startup"
    SettingOption.default_value  = true
    SettingOption.allowed_values = { "true", "false" }

	local Name = { }
    table.insert( Name, "" )
    table.insert( Name, { GPrefix.Local .. "setting-char", ThisMOD.Char } )
    table.insert( Name, { ThisMOD.Local .. "setting-name" } )
	if ThisMOD.Requires then
		Name = { GPrefix.Local .. "setting-require-name", Name, ThisMOD.Requires.Char }
	end SettingOption.localised_name = Name

	local Description = { ThisMOD.Local .. "setting-description" }
	if ThisMOD.Requires then
		Description = { GPrefix.Local .. "setting-require-description", { ThisMOD.Requires.Local .. "setting-name" }, Description }
	end SettingOption.localised_description = Description

    data:extend( { SettingOption } )
    if true then return end
end

-- Cargar la configuración
Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Conbinaciones de teclas
function ThisMOD.KeySequence( )
    local Table = { }
    Table.type = "custom-input"
    Table.localised_name = { ThisMOD.Local .. "setting-name"}
    Table.name = ThisMOD.Prefix_MOD
    Table.key_sequence = "CONTROL + I"
    data:extend( { Table } )
end

-- Prototipos del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.KeySequence( )
end

-- Cargar los prototipos
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Prototipo de la ventana principal

function ThisMOD.BuildWindow( Data )

    -- Ventana principal
    local WindowFrame =  { }
    WindowFrame.type = "frame"
    WindowFrame.direction = "vertical"

    -- Mostra la ventana
    local Screen = Data.Player.gui.screen
    WindowFrame = Screen.add( WindowFrame )
    WindowFrame.auto_center = true

    -- Indicar que la ventana esta abierta
    -- Cerrar la ventana al abrir otra ventana, presionar E o Esc
    Data.Player.opened = WindowFrame

    -- Contenedor principal
    local WindowFlow = { }
    WindowFlow.type = "flow"
    WindowFlow.direction = "vertical"
    WindowFlow = WindowFrame.add( WindowFlow )
    WindowFlow.style.vertical_spacing = 9

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Guardar instancia
    Data.GUI.WindowFrame = WindowFrame
    Data.GUI.WindowFlow = WindowFlow

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Cotruir la interfaz
    ThisMOD.BuildWindowTitle( Data )
    ThisMOD.BuildWindowBody( Data )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Eliminar la referencia
    Data.GUI.WindowFlow = nil
end

function ThisMOD.BuildWindowTitle( Data )

    -- Contenedor
    local TitleBar = { }
    TitleBar.type = "flow"
    TitleBar.direction = "horizontal"
    TitleBar = Data.GUI.WindowFlow.add( TitleBar )
    TitleBar.style.horizontal_spacing = 9
    TitleBar.style.height = 24

    -- Etiqueta con el titulo
    local Lable = { }
    Lable.type = "label"
    Lable.caption = { Data.GMOD.Local .. "setting-name"}
    Lable = TitleBar.add( Lable )
    Lable.style = "frame_title"

    -- Indicador para mover la ventana
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = TitleBar.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.WindowFrame
    EmptyWidget.style = "draggable_space_header"
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
    EmptyWidget.style.margin = 0


    -- Contenedor
    local Flow = { }


    -- Contenedor
    Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = TitleBar.add( Flow )
    Flow.style.horizontal_spacing = 3

    -- Botón para importar
    local ImportButton = { }
    ImportButton.type = "sprite-button"
    ImportButton.sprite = "utility/import"
    ImportButton.tooltip = { ThisMOD.Local .. "import"}
    ImportButton = Flow.add( ImportButton )
    ImportButton.style = "tool_button_blue"
    ImportButton.style.padding = 0
    ImportButton.style.margin = 0
    ImportButton.style.size = 24

    -- Botón para exportar
    local ExportButton = { }
    ExportButton.type = "sprite-button"
    ExportButton.sprite = "utility/export"
    ExportButton.tooltip = { ThisMOD.Local .. "import"}
    ExportButton = Flow.add( ExportButton )
    ExportButton.style = "tool_button_blue"
    ExportButton.style.padding = 0
    ExportButton.style.margin = 0
    ExportButton.style.size = 24


    -- Contenedor
    Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = TitleBar.add( Flow )
    Flow.style.horizontal_spacing = 3

    -- Botón para cancel los cambios
    local DiscardButton = { }
    DiscardButton.type = "sprite-button"
    DiscardButton.sprite = "utility/close_fat"
    DiscardButton.tooltip = { ThisMOD.Local .. "discard"}
    DiscardButton = Flow.add( DiscardButton )
    DiscardButton.style = "tool_button_red"
    DiscardButton.style.padding = 0
    DiscardButton.style.margin = 0
    DiscardButton.style.size = 24

    -- Botón para aplicar los cambios
    local ApplyButton = { }
    ApplyButton.type = "sprite-button"
    ApplyButton.sprite = "utility/play"
    ApplyButton.tooltip = { ThisMOD.Local .. "apply"}
    ApplyButton = Flow.add( ApplyButton )
    ApplyButton.style = "tool_button_green"
    ApplyButton.style.padding = 0
    ApplyButton.style.margin = 0
    ApplyButton.style.size = 24


    -- Contenedor
    Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = TitleBar.add( Flow )
    Flow.style.horizontal_spacing = 3

    -- Botón de cierre
    local CloseButton = { }
    CloseButton.type = "sprite-button"
    CloseButton.sprite = "utility/close_white"
    CloseButton.hovered_sprite = "utility/close_black"
    CloseButton.clicked_sprite = "utility/close_black"
    CloseButton.tooltip = { Data.GMOD.Local .. "close" }
    CloseButton = Flow.add( CloseButton )
    CloseButton.style = "frame_action_button"
    CloseButton.style.padding = 0
    CloseButton.style.margin = 0
    CloseButton.style.size = 24

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Guardar instancia
    Data.GUI.ExportButton = ExportButton
    Data.GUI.ImportButton = ImportButton

    Data.GUI.ApplyButton = ApplyButton
    Data.GUI.DiscardButton = DiscardButton

    Data.GUI.CloseWindowButton = CloseButton
end

function ThisMOD.BuildWindowBody( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.WindowFlow.add( Flow )
    Flow.style.vertical_spacing = 3

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Guardar instancia
    Data.GUI.WindowBodyFlow = Flow

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Cotruir la interfaz
    ThisMOD.BuildItemListSection( Data )
    ThisMOD.BuildSelectItemSection( Data )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Eliminar la referencia
    Data.GUI.WindowBodyFlow = nil
end


function ThisMOD.BuildItemListSection( Data )

    -- Fondo de la lLista
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.WindowBodyFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.width = 420
    ScrollPane.style.height = 168

    -- Tabla contenedora
    local Table = { }
    Table.type = "table"
    Table.column_count = 10
    Table = ScrollPane.add( Table )
    Table.style.vertically_stretchable = true
    Table.style.horizontally_stretchable = true
    Table.style.horizontal_spacing = 0
    Table.style.vertical_spacing = 0

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Guardar instancia
    Data.GUI.ItemsTable = Table

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Cargar los objetos
    ThisMOD.ShowItems( Data )
end

function ThisMOD.BuildSelectItemSection( Data )

    -- Fondo de la lLista
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Data.GUI.WindowBodyFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true
    -- ScrollPane.style.height = 75

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = ScrollPane.add( Flow )
    Flow.style.horizontal_spacing = 9
    Flow.style.vertical_align = "center"
    Flow.style.margin = { 10, 20 }

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Guardar instancia
    Data.GUI.Flow = Flow

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Cotruir la interfaz
    ThisMOD.BuildSelectItem( Data )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Eliminar la referencia
    Data.GUI.Flow = nil
end

function ThisMOD.BuildSelectItem( Data )

    -- Inicializa la vareble y renombrar
    local Flow = Data.GUI.Flow

    -- Crear la imagen de selección
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

    -- Slider
    local Slider = { }
    Slider.type = "slider"
    Slider.minimum_value = 1
    Slider.maximum_value = 10
    Slider.value_step = 1
    Slider = Flow.add( Slider )
    Slider.style = "notched_slider"
    Slider.style.horizontally_stretchable = true
    Slider.enabled = false

    -- Valor del slider
    local Textfield = { }
    Textfield.type = "textfield"
    Textfield.text = ""
    Textfield = Flow.add( Textfield )
    Textfield.style = "slider_value_textfield"
    Textfield.enabled = false

    -- Botón de confirmación
    local Button = { }
    Button.type = "sprite-button"
    Button.sprite = "utility/check_mark_white"
    Button.tooltip = { ThisMOD.Local .. "add"}
    Button = Flow.add( Button )
    Button.style = "tool_button_green"
    Button.style.padding = 0
    Button.style.margin = 0
    Button.style.size = 28
    Button.enabled = false

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Guardar instancia
    Data.GUI.Slider = Slider
    Data.GUI.Picture = Picture
    Data.GUI.AddButton = Button
    Data.GUI.Textfield = Textfield
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Acciones del jugador en la ventana principal

function ThisMOD.ToggleWindow( Data )

    -- Validación básico
    if not Data.Player.connected then return end
    if not Data.Player.admin then return end

    -- Validar evento
    if not ThisMOD.ValidateToggleWindow( Data ) then return end

    -- Acción a ejecutar
    if Data.GUI.WindowFrame then
        ThisMOD.DestroyWindow( Data )
    else
        ThisMOD.CreateWindow( Data )
    end
end


function ThisMOD.CreateWindow( Data )
    ThisMOD.BuildWindow( Data )
end

function ThisMOD.DestroyWindow( Data )
    Data.GUI.WindowFrame.destroy( )
    Data.GPlayer.GUI = nil
    if GPrefix.Click then
        GPrefix.Click.Players[ Data.Player.index ] = nil
    end
end

function ThisMOD.ValidateToggleWindow( Data )

    -- Conbinación de teclas
    local PressKeySequence = false

    PressKeySequence = Data.Event.input_name
    if not PressKeySequence then goto JumpPressKeySequence end

    PressKeySequence = PressKeySequence == Data.GMOD.Prefix_MOD
    if not PressKeySequence then goto JumpPressKeySequence end

    -- Evento identificado
    if true then return true end

    -- Recepción del salto
    :: JumpPressKeySequence ::

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Abriendo otra ventana
    local OpenOtherWindow = false

    OpenOtherWindow = Data.GUI.WindowFrame
    if not OpenOtherWindow then goto JumpOpenOtherWindow end

    OpenOtherWindow = defines.events.on_gui_closed
    OpenOtherWindow = Data.Event.name == OpenOtherWindow
    if not OpenOtherWindow then goto JumpOpenOtherWindow end

    -- Evento identificado
    if true then return true end

    -- Recepción del salto
    :: JumpOpenOtherWindow ::

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Cerrando con el boton de la ventana
    local CloseWindowButton = false

    CloseWindowButton = defines.events.on_gui_click
    CloseWindowButton = Data.Event.name == CloseWindowButton
    if not CloseWindowButton then goto JumpCloseWindowButton end

    CloseWindowButton = Data.GUI.CloseWindowButton
    CloseWindowButton = Data.Event.element == CloseWindowButton
    if not CloseWindowButton then goto JumpCloseWindowButton end

    -- Evento identificado
    if true then return true end

    -- Recepción del salto
    :: JumpCloseWindowButton ::

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return false
end

-- Selecionar un objeto
function ThisMOD.NewSelection( Data )

    -- Validación basica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Picture then return end

    local ItemName = Data.Event.element.elem_value
    if not GPrefix.isString( ItemName ) then return end

    -- Habilitar los elementos
    Data.GUI.Slider.enabled = true
    Data.GUI.AddButton.enabled = true
    Data.GUI.Textfield.enabled = true

    -- Establecer los valores
    local StackSize = game.item_prototypes[ ItemName ].stack_size
    Data.GUI.Slider.set_slider_minimum_maximum( 0, 10 * StackSize )
    Data.GUI.Slider.set_slider_value_step( StackSize )

    Data.GUI.Textfield.text = tostring( StackSize )
    Data.GUI.Slider.slider_value = StackSize
end

-- Borrar el objeto selecionado
function ThisMOD.ClearSelection( Data )

    -- Validación basica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Picture then return end

    local ItemName = Data.Event.element.elem_value
    if GPrefix.isString( ItemName ) then return end

    -- Limpiar los valores
    Data.GUI.Textfield.text = ""
    Data.GUI.Slider.slider_value = 0

    -- Deshabilitar los elementos
    Data.GUI.Slider.enabled = false
    Data.GUI.AddButton.enabled = false
    Data.GUI.Textfield.enabled = false
end

-- Establecer la cantidad del objeto
function ThisMOD.setCount( Data )

    -- Validación basica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Slider then return end

    -- Establecer el valor
    local Value = Data.Event.element.slider_value
    Data.GUI.Textfield.text = tostring( Value )
end

function ThisMOD.setValue( Data )

    -- Validación basica
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Textfield then return end

    -- Establecer el valor
    local Text = Data.Event.element.text
    local Value = tonumber( Text, 10 ) or 0
    if Value > Data.GUI.Slider.get_slider_maximum( ) then
        Value = Data.GUI.Slider.get_slider_maximum( )
    end Data.GUI.Slider.slider_value = Value
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Funciones de soporte

function ThisMOD.ShowItems( Data )

    -- Inicializa la vareble y renombrar
    local Table = Data.GUI.ItemsTable

    Data.gMOD.Items = Data.gMOD.Items or { }
    local Items = Data.gMOD.Items

    -- Valores temporales
    table.insert( Items, { count = 1, name = "wooden-chest" } )
    table.insert( Items, { count = 1, name = "iron-chest" } )
    table.insert( Items, { count = 1, name = "steel-chest" } )
    table.insert( Items, { count = 1, name = "wood" } )
    table.insert( Items, { count = 1, name = "coal" } )
    table.insert( Items, { count = 1, name = "stone" } )
    table.insert( Items, { count = 1, name = "iron-ore" } )
    table.insert( Items, { count = 1, name = "copper-ore" } )
    table.insert( Items, { count = 1, name = "iron-plate" } )
    table.insert( Items, { count = 1, name = "copper-plate" } )
    table.insert( Items, { count = 1, name = "copper-cable" } )
    table.insert( Items, { count = 1, name = "iron-stick" } )
    table.insert( Items, { count = 1, name = "electronic-circuit" } )

    -- Valores predeterminados
    local Tags = { }
    Tags.enabled = "inventory_slot"
    Tags.selected = "filter_inventory_slot"
    Tags.size = 40

    -- Agregar los objetos
    Table.clear( )
    ThisMOD.SortItems( Data )
    for _, Item in pairs( Items ) do
        local Picture = { }
        Picture.type = "sprite-button"
        Picture.sprite = "item/" .. Item.name
        Picture.number = Item.count
        Picture = Table.add( Picture )
        Picture.style = Tags.enabled
        Picture.style.padding = 0
        Picture.style.margin  = 0
        Picture.style.size = Tags.size
    end

    -- Calcular los espacio vacios
    local Count = math.ceil( #Items / Table.column_count )
    if Count < 4 then Count = 3 end
    Count = ( Count + 1 ) * 10
    Count = Count - #Items

    -- Agregar espacios vacios
    for _ = 1, Count, 1 do
        local Picture = { }
        Picture.type = "sprite-button"
        Picture = Table.add( Picture )
        Picture.style = Tags.enabled
        Picture.style.padding = 0
        Picture.style.margin  = 0
        Picture.style.size = Tags.size
    end
end

function ThisMOD.SortItems( Data )

    -- Inicializa la vareble y renombrar
    local Array = { }
    Data.gMOD.Items = Data.gMOD.Items or { }
    local Items = Data.gMOD.Items

    -- Eliminar las redundancias
    local i = 1
    while i < #Items do
        local j = #Items
        while j > i do
            local iItem = Items[ i ]
            local jItem = Items[ j ]
            if iItem.name == jItem.name then
                iItem.count = iItem.count + jItem.count
                table.remove( Items, j )
            end j = j - 1
        end i = i + 1
    end

    -- Cargar los objetos
    for _, Item in pairs( Items ) do
        table.insert( Array, Item.name )
    end

    -- Ordenar los objetos
    table.sort( Array )

    -- Duplicar los detalles del objeto
    for Pos, Name in pairs( Array ) do
        for _, Item in pairs( Items ) do
            if Item.name == Name then
                Array[ Pos ] = Item
            end
        end
    end

    -- Eliminar el orden actual
    while #Items > 0 do
        table.remove( Items, 1 )
    end

    -- Establecer el nuevo orden
    for _, Item in pairs( Array ) do
        table.insert( Items, Item )
    end
end






local function TemporalAction( Data )

    local Element = Data.Event.element
    if not Element then return end
    if not Element.valid then return end

    local Tags = Data.Event.element.tags
    if not( Tags and Tags.Temporal ) then return end

    Data.GPrefix.TMP = Data.GPrefix.TMP or { }

    -- Estilo
    if Tags.Temporal == "style" then

        local xButton = {
            [ 1 ] = 'button',
            [ 2 ] = 'green_button',
            [ 3 ] = 'rounded_button',
            [ 4 ] = 'back_button',
            [ 5 ] = 'red_back_button',
            [ 6 ] = 'forward_button',
            [ 7 ] = 'confirm_button',
            [ 8 ] = 'confirm_button_without_tooltip',
            [ 9 ] = 'confirm_double_arrow_button',
            [ 10 ] = 'map_generator_preview_button',
            [ 11 ] = 'map_generator_close_preview_button',
            [ 12 ] = 'map_generator_confirm_button',
            [ 13 ] = 'confirm_in_load_game_button',
            [ 14 ] = 'red_confirm_button',
            [ 15 ] = 'red_button',
            [ 16 ] = 'tool_button_red',
            [ 17 ] = 'tool_button',
            [ 18 ] = 'tool_button_green',
            [ 19 ] = 'tool_button_blue',
            [ 20 ] = 'mini_button',
            [ 21 ] = 'mini_button_aligned_to_text_vertically',
            [ 22 ] = 'mini_button_aligned_to_text_vertically_when_centered',
            [ 23 ] = 'highlighted_tool_button',
            [ 24 ] = 'tip_notice_button',
            [ 25 ] = 'dialog_button',
            [ 26 ] = 'menu_button',
            [ 27 ] = 'menu_button_continue',
            [ 28 ] = 'side_menu_button',
            [ 29 ] = 'map_view_options_button',
            [ 30 ] = 'map_view_add_button',
            [ 31 ] = 'mod_gui_button',
            [ 32 ] = 'image_tab_slot',
            [ 33 ] = 'image_tab_selected_slot',
            [ 34 ] = 'logistic_slot_button',
            [ 35 ] = 'yellow_logistic_slot_button',
            [ 36 ] = 'red_logistic_slot_button',
            [ 37 ] = 'red_circuit_network_content_slot',
            [ 38 ] = 'green_circuit_network_content_slot',
            [ 39 ] = 'compact_slot',
            [ 40 ] = 'slot',
            [ 41 ] = 'red_slot',
            [ 42 ] = 'yellow_slot',
            [ 43 ] = 'green_slot',
            [ 44 ] = 'blue_slot',
            [ 45 ] = 'tool_equip_virtual_slot',
            [ 46 ] = 'working_tool_equip_virtual_slot',
            [ 47 ] = 'not_working_tool_equip_virtual_slot',
            [ 48 ] = 'tool_equip_ammo_slot',
            [ 49 ] = 'inventory_slot',
            [ 50 ] = 'filter_inventory_slot',
            [ 51 ] = 'closed_inventory_slot',
            [ 52 ] = 'recipe_slot_button',
            [ 53 ] = 'tracking_off_button',
            [ 54 ] = 'tracking_on_button',
            [ 55 ] = 'research_queue_cancel_button',
            [ 56 ] = 'transparent_slot',
            [ 57 ] = 'frame_button',
            [ 58 ] = 'frame_action_button',
            [ 59 ] = 'tip_notice_close_button',
            [ 60 ] = 'blueprint_record_slot_button',
            [ 61 ] = 'blueprint_record_selection_button',
            [ 62 ] = 'drop_target_button',
            [ 63 ] = 'compact_red_slot',
            [ 64 ] = 'inventory_limit_slot_button',
            [ 65 ] = 'working_weapon_button',
            [ 66 ] = 'not_working_weapon_button',
            [ 67 ] = 'omitted_technology_slot',
            [ 68 ] = 'crafting_queue_slot',
            [ 69 ] = 'promised_crafting_queue_slot',
            [ 70 ] = 'control_settings_button',
            [ 71 ] = 'control_settings_section_button',
            [ 72 ] = 'dropdown_button',
            [ 73 ] = 'not_accessible_station_in_station_selection',
            [ 74 ] = 'partially_accessible_station_in_station_selection',
            [ 75 ] = 'new_game_header_list_box_item',
            [ 76 ] = 'list_box_item',
            [ 77 ] = 'train_status_button',
            [ 78 ] = 'station_train_status_button',
            [ 79 ] = 'title_tip_item',
            [ 80 ] = 'item_and_count_select_confirm',
            [ 81 ] = 'filter_group_button_tab',
            [ 82 ] = 'filter_group_button_tab_slightly_larger',
            [ 83 ] = 'button_with_shadow',
            [ 84 ] = 'train_schedule_add_wait_condition_button',
            [ 85 ] = 'train_schedule_add_station_button',
            [ 86 ] = 'train_schedule_action_button',
            [ 87 ] = 'train_schedule_comparison_type_button',
            [ 88 ] = 'locomotive_minimap_button',
            [ 89 ] = 'target_station_in_schedule_in_train_view_list_box_item',
            [ 90 ] = 'no_path_station_in_schedule_in_train_view_list_box_item',
            [ 91 ] = 'default_permission_group_list_box_item',
            [ 92 ] = 'browse_games_gui_toggle_favorite_on_button',
            [ 93 ] = 'browse_games_gui_toggle_favorite_off_button',
            [ 94 ] = 'cancel_close_button',
            [ 95 ] = 'close_button',
            [ 96 ] = 'current_research_info_button',
            [ 97 ] = 'open_armor_button',
            [ 98 ] = 'quick_bar_page_button',
            [ 99 ] = 'tool_bar_open_button',
            [ 100 ] = 'dark_rounded_button',
            [ 101 ] = 'train_schedule_item_select_button',
            [ 102 ] = 'train_schedule_fulfilled_item_select_button',
            [ 103 ] = 'slot_button',
            [ 104 ] = 'big_slot_button',
            [ 105 ] = 'slot_button_in_shallow_frame',
            [ 106 ] = 'statistics_slot_button',
            [ 107 ] = 'yellow_slot_button',
            [ 108 ] = 'red_slot_button',
            [ 109 ] = 'quick_bar_slot_button',
            [ 110 ] = 'slot_sized_button',
            [ 111 ] = 'compact_slot_sized_button',
            [ 112 ] = 'slot_button_that_fits_textline',
            [ 113 ] = 'slot_sized_button_pressed',
            [ 114 ] = 'slot_sized_button_blue',
            [ 115 ] = 'slot_sized_button_red',
            [ 116 ] = 'slot_sized_button_green',
            [ 117 ] = 'shortcut_bar_button',
            [ 118 ] = 'shortcut_bar_button_blue',
            [ 119 ] = 'shortcut_bar_button_red',
            [ 120 ] = 'shortcut_bar_button_green',
            [ 121 ] = 'shortcut_bar_button_small',
            [ 122 ] = 'shortcut_bar_button_small_green',
            [ 123 ] = 'shortcut_bar_button_small_red',
            [ 124 ] = 'shortcut_bar_button_small_blue',
            [ 125 ] = 'slider_button',
            [ 126 ] = 'left_slider_button',
            [ 127 ] = 'right_slider_button',
            [ 128 ] = 'entity_variation_button',
            [ 129 ] = 'tile_variation_button',
            [ 130 ] = 'train_schedule_fulfilled_delete_button',
            [ 131 ] = 'train_schedule_temporary_station_delete_button',
            [ 132 ] = 'other_settings_gui_button',
            [ 133 ] = 'dark_button',
            [ 134 ] = 'train_schedule_delete_button',
            [ 135 ] = 'train_schedule_condition_time_selection_button',
            [ 136 ] = 'shortcut_bar_expand_button',
            [ 137 ] = 'choose_chat_icon_button',
            [ 138 ] = 'choose_chat_icon_in_textbox_button',
        } local wWw = xButton

        local xXx = { }
        local vVv = { }

        if #vVv == 0 then
            for i = 1, #wWw, 1 do
                table.insert( vVv, i )
            end
        end

        for _, value in pairs( vVv ) do
            table.insert( xXx, { value, wWw[ value ] } )
        end

        local Style = Data.GPrefix.TMP.Style
        Style = Style or 0
        Style = Style < #xXx and Style + 1 or 1
        Data.GPrefix.TMP.Style = Style

        Element.style = xXx[ Style ][ 2 ]
        Element.tooltip =  "[ " .. xXx[ Style ][ 1 ] .. " ] = " .. xXx[ Style ][ 2 ]
        Element.style.size = 28
        -- Element.style.horizontally_stretchable = true
    end

    -- Alto
    if Tags.Temporal == "height" then

        local Height = Data.GPrefix.TMP.Height
        Height = Height or 0
        Height = Height < Tags.height and Height + 1 or 1
        Data.GPrefix.TMP.Height = Height

        Element.style.height = Tags.height + Height
    end

    -- Ancho
    if Tags.Temporal == "width" then

        local Width = Data.GPrefix.TMP.Width
        Width = Width or 0
        Width = Width < Tags.Width and Width + 1 or 1
        Data.GPrefix.TMP.Width = Width

        Element.style.width = Tags.Width + Width
    end

    -- Tamaño
    if Tags.Temporal == "size" then

        local Size = Data.GPrefix.TMP.Size
        Size = Size or 0
        Size = Size < Tags.Size and Size + 1 or 1
        Data.GPrefix.TMP.Size = Size

        Element.style.size = Tags.Size + Size
    end

    -- Espacio horizontal
    if Tags.Temporal == "horizontal_spacing" then

        local Horizontal = Data.GPrefix.TMP.Horizontal
        Horizontal = Horizontal or 0
        Horizontal = Horizontal < Tags.Horizontal and Horizontal + 1 or 1
        Data.GPrefix.TMP.Horizontal = Horizontal

        Element.horizontal_spacing = Tags.Horizontal + Horizontal
    end

    -- Espacio vertical
    if Tags.Temporal == "vertical_spacing" then

        local Vertical = Data.GPrefix.TMP.Vertical
        Vertical = Vertical or 0
        Vertical = Vertical < Tags.Vertical and Vertical + 1 or 1
        Data.GPrefix.TMP.Vertical = Vertical

        Element.vertical_spacing = Tags.Vertical + Vertical
    end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Contenedor de los jugadores a inicializar
ThisMOD.PlayersToInit = { }

-- Lista de objetos a agregar
ThisMOD.ItemsToAdd = { }
table.insert( ThisMOD.ItemsToAdd, { count = 1, name = "iron-chest" } )
table.insert( ThisMOD.ItemsToAdd, { count = 1, name = "steel-chest" } )
table.insert( ThisMOD.ItemsToAdd, { count = 1, name = "wooden-chest" } )

-- Inicializa el evento
function ThisMOD.Initialize( )
    -- Variable contenedora
    local Data = { Temporal = { }, Player = { index = 0 } }
    local Here = { }

    -- Reconstruir la ventana de estado
    Here.Table = { }
    Here.Table.Name = ThisMOD.Prefix_MOD_ .. "StartInitialize"
    Here.Table.Function = ThisMOD.StartInitialize
    table.insert( Data.Temporal, Here.Table )
    GPrefix.addOnTick( Data )

    -- Revizar que todos los jugadores esten inicializados
    GPrefix.CheckAllPlayers = true
end

-- Validación basica
function ThisMOD.StartInitialize( )

    -- Se añadé a todos los jugadores al cargar la partida y
    -- verificar que a todos se les entregó los objetos
    ThisMOD.addAllPlayers( )

    -- Validación básica
    if #ThisMOD.PlayersToInit < 1 then return end

    -- Inicializar el contenedor
    local StrItems = GPrefix.toString( ThisMOD.ItemsToAdd )

    -- Verificar cada jugador
    for _, Data in pairs( ThisMOD.PlayersToInit ) do

        -- Renombrear la variable
        local ItemGiven = Data.gForce[ Data.Player.index ]

        -- Validar si se le ha dado estos objetos
        if not ItemGiven or GPrefix.toString( ItemGiven ) ~= StrItems then
            ThisMOD.addItems( Data )
        end
    end
end

-- Agregar todos los jugadores para una validación
function ThisMOD.addAllPlayers( )

    -- Validación básica
    if not GPrefix.CheckAllPlayers then return end

    -- Agregar los jugadores
    for _, Player in pairs( game.players ) do
        ThisMOD.addPlayer( { Player = Player } )
    end

    -- Eliminar varible bandera
    GPrefix.CheckAllPlayers = nil
end

-- Agregar los objetos al jugador
function ThisMOD.addItems( Data )

    -- Validar el modo del jugador
    local Controller = Data.Player.controller_type
    local isCharacter = Controller ~= defines.controllers.character
    local isGod = Controller ~= defines.controllers.god
    if isGod and isCharacter then return end

    -- Renombrar las variables
    local IDPlayer = Data.Player.index
    local Level = script.level.level_name

    -- El jugador se desconectó
    if not Data.Player.connected then
        ThisMOD.PlayersToInit[ IDPlayer ] = nil return
    end

    -- No hacer nada en los escesarios especificos
    if script.level.campaign_name then
        ThisMOD.PlayersToInit[ IDPlayer ] = nil return
    end

    -- Esperar que esté en el destino final
    local Flag = false
    Flag = Level == "wave-defense" and true or false
    Flag = Flag and Data.Player.surface.index < 2
    if Flag then return end

    Flag = Level == "team-production" and true or false
    Flag = Flag and Data.Player.force.index < 2
    if Flag then return end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- El jugador no tiene un cuerpo
    if not Data.Player.character then
        for _, Item in pairs( ThisMOD.ItemsToAdd ) do
            Data.Player.insert( Item )
        end
    end

    -- El jugador tiene un cuerpo
    if Data.Player.character then
        local Inventory = Data.Player.character
        local IDInvertory = defines.inventory.character_main
        Inventory = Inventory.get_inventory( IDInvertory )
        for _, Item in pairs( ThisMOD.ItemsToAdd ) do
            Inventory.insert( Item )
        end
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Marcar cómo hecho
    Data.gForce[ IDPlayer ] = GPrefix.DeepCopy( ThisMOD.ItemsToAdd )
    ThisMOD.PlayersToInit[ IDPlayer ] = nil
end

-- Agregar los jugadores a la cola
function ThisMOD.addPlayer( Event )
    local Data = GPrefix.CreateData( Event, ThisMOD )
    ThisMOD.PlayersToInit[ Data.Player.index ] = Data
end

-- Hacer antes de borrar a un jugador
function ThisMOD.BeforeDelete( Data )
    local IDPlayer = Data.Player.index
    local IDForce = Data.Player.force.index
    Data.gForce[ IDForce ][ IDPlayer ] = nil
end

-- Hacer antes e salir de la partida
function ThisMOD.BeforeLogout( Data )
    ThisMOD.PlayersToInit[ Data.Player.index ] = nil
end

-- Configuración del MOD
function ThisMOD.Control( )
    if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    GPrefix.addEvent( {

        -- Al crear la partida
        [ "on_init" ] = ThisMOD.Initialize,

        -- Al cargar la partida
        [ "on_load" ] = ThisMOD.Initialize,

        -- Jugadores a inicializar
        [ { "on_event", defines.events.on_player_created } ] = ThisMOD.addPlayer,

        -- Antes de eliminar un jugador
        [ { "on_event", defines.events.on_pre_player_removed } ] = function( Event )
            ThisMOD.BeforeDelete( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- Al usar la combinación de teclas
        [ { "on_event", ThisMOD.Prefix_MOD } ] = function( Event )
            ThisMOD.ToggleWindow( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- -- -- -- -- -- -- -- -- -- -- -- -- --

        -- Antes de salir del juego
        [ { "on_event", defines.events.on_pre_player_left_game } ] = function( Event )
            ThisMOD.BeforeLogout( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- Al cerrar la interfaz cuando se abre otra
        [ { "on_event", defines.events.on_gui_closed } ] = function( Event )
            ThisMOD.ToggleWindow( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- -- -- -- -- -- -- -- -- -- -- -- -- --

        -- Al cambiar el texto a buscar
        [ { "on_event", defines.events.on_gui_text_changed } ] = function( Event )
            ThisMOD.setValue( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- Se cambia el valor del Slider
        [ { "on_event", defines.events.on_gui_value_changed } ] = function( Event )
            ThisMOD.setCount( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- Se cambió el objeto selecionado
        [ { "on_event", defines.events.on_gui_elem_changed } ] = function( Event )

            -- Cargar la información en una estructura
            local Data = GPrefix.CreateData( Event, ThisMOD )

            -- Acciones del jugador
            ThisMOD.NewSelection( Data )
            ThisMOD.ClearSelection( Data )
        end,

        -- Al hacer click en un elemento
        [ { "on_event", defines.events.on_gui_click } ] = function( Event )

            -- Cargar la información en una estructura
            local Data = GPrefix.CreateData( Event, ThisMOD )

            -- Acciones del jugador
            -- ThisMOD.PrioritizeResearch( Data )
            -- ThisMOD.SearchPrerequisite( Data )
            -- ThisMOD.CancelResearch( Data )
            -- ThisMOD.AddResearch( Data )

            -- ThisMOD.ToggleWindowStatus( Data )
            -- ThisMOD.ToggleTechnologies( Data )
            -- ThisMOD.ToggleTechnology( Data )
            ThisMOD.ToggleWindow( Data )
            -- ThisMOD.ToggleTextfield( Data )
            -- ThisMOD.ToggleMOD( Data )


            TemporalAction( Data )
        end,

    } )
end

-- Cargar los eventos
ThisMOD.Control( )

---------------------------------------------------------------------------------------------------