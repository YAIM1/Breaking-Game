---------------------------------------------------------------------------------------------------

--> queue-to-research.lua <--

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

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Configuración del MOD
function ThisMOD.Settings( )
    if not GPrefix.getKey( { "settings" }, GPrefix.File ) then return end

    local SettingOption =  { }
    SettingOption.name  = ThisMOD.Prefix_MOD
    SettingOption.type  = "bool-setting"
    SettingOption.order = ThisMOD.Index
    SettingOption.setting_type   = "startup"
    SettingOption.default_value  = true
    SettingOption.allowed_values = { "true", "false" }
    SettingOption.localised_description = { ThisMOD.Local .. "setting-description" }

    local List = { }
    table.insert( List, "" )
    table.insert( List, "[font=default-bold][ " .. ThisMOD.Char .. " ][/font] " )
    table.insert( List, { ThisMOD.Local .. "setting-name" } )
    SettingOption.localised_name = List

    data:extend( { SettingOption } )
end

-- Cargar la configuración
ThisMOD.Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Conbinaciones de teclas
function ThisMOD.KeySequence( )
    local Table = { }
    Table.type = "custom-input"
    Table.localised_name = { ThisMOD.Local .. "setting-name"}
    Table.name = ThisMOD.Prefix_MOD
    Table.key_sequence = "CONTROL + T"
    data:extend( { Table } )
end

-- Crear el botón en la barra de acceso rapido
function ThisMOD.Shortcut( )
    local Patch = ThisMOD.Patch .. "graphics/icons/technology-[+].png"

    local Table = { }
    Table.type = "shortcut"
    Table.name = ThisMOD.Prefix_MOD
    Table.localised_name = { ThisMOD.Local .. "setting-name"}

    Table.icon = { }
    Table.icon.filename = string.gsub( Patch, "%[%+%]", "black" )
    Table.icon.size = 32
    Table.icon.flags = { }
    table.insert( Table.icon.flags, "gui-icon" )

    Table.disabled_icon = { }
    Table.disabled_icon.filename = string.gsub( Patch, "%[%+%]", "white" )
    Table.disabled_icon.size = 32
    Table.disabled_icon.flags = { }
    table.insert( Table.disabled_icon.flags, "gui-icon" )

    Table.associated_control_input = ThisMOD.Prefix_MOD
    Table.toggleable = true
    Table.action = "lua"
    data:extend( { Table } )
end

-- Efectos de las tecnologías
function ThisMOD.CreateSprite( )

    -- Inicializar la variables
    local Patch = data.raw[ "utility-sprites" ][ "default" ]
    local Effects = { }
    local Items = { }
    local Array = { }

    ---> <---     ---> <---     ---> <---

    -- Crear una copia de la imagen
    local function DuplicateIcon( Image )
        if not Image then return nil end

        local Icon = { }
        Icon.width = Image.width
        Icon.height = Image.height
        Icon.icon_mipmaps = Image.icon_mipmaps

        Icon.filename = Image.icon or Image.filename
        Icon.size = Image.size or Image.icon_size
        Icon.tint = Image.tint
        return Icon
    end

    -- Preparar los datos para crear la nueva imagen
    local function CreateIcon( Effect, Sources, Key )
        local ThisEffect = Effects[ Effect ] or { }
        Effects[ Effect ] = ThisEffect

        local Name = string.gsub( Effect, "-", "_" )
        local Constant = Patch[ Name .. "_modifier_constant" ]

        if #Sources < 1 then
            local Icon = Patch[ Name .. "_modifier_icon" ]

            local Image = { }
            table.insert( ThisEffect, Image )

            table.insert( Image, DuplicateIcon( Icon ) )
            table.insert( Image, DuplicateIcon( Constant ) )
        end

        if #Sources > 0 then
            for _, Source in pairs( Sources ) do
                local Image = { }

                if not Key then table.insert( ThisEffect, Image )
                else
                    ThisEffect[ Key ] = ThisEffect[ Key ] or { }
                    table.insert( ThisEffect[ Key ], Image )
                end

                if Source.icons then
                    for _, Icon in pairs( Source.icons ) do
                        local NewIcon = DuplicateIcon( Icon )
                        if not( Icon.icon_size or Icon.size ) then
                            NewIcon.size = Source.icon_size
                        end table.insert( Image, NewIcon )
                    end
                end

                if Source.icon or Source.filename then
                    table.insert( Image, DuplicateIcon( Source ) )
                end

                table.insert( Image, DuplicateIcon( Constant ) )
            end
        end


















        -- local ThisEffect = Effects[ Effect ] or { }
        -- Effects[ Effect ] = ThisEffect

        -- local URL = "__core__/graphics/bonus-icon.png"
        -- local Name = string.gsub( Effect, "-", "_" )
        -- local ModifierIcon = Patch[ Name .. "_modifier_icon" ]
        -- local ModifierConstant = Patch[ Name .. "_modifier_constant" ]

        -- if ModifierIcon and ModifierIcon.filename ~= URL then
        --     local Image = { }
        --     table.insert( ThisEffect, Image )

        --     table.insert( Image, DuplicateIcon( ModifierIcon ) )
        --     table.insert( Image, DuplicateIcon( ModifierConstant ) )
        -- end

        -- if not ModifierIcon or ModifierIcon.filename == URL then
        --     for _, Source in pairs( Sources or { } ) do
        --         local Image = { }

        --         if Key then
        --             ThisEffect[ Key ] = ThisEffect[ Key ] or { }
        --             table.insert( ThisEffect[ Key ], Image )
        --         else table.insert( ThisEffect, Image ) end

        --         if Source.icons then
        --             for _, Icon in pairs( Source.icons ) do
        --                 local NewIcon = DuplicateIcon( Icon )
        --                 if not( Icon.icon_size or Icon.size ) then
        --                     NewIcon.size = Source.icon_size
        --                 end table.insert( Image, NewIcon )
        --             end
        --         end

        --         if Source.icon or Source.filename then
        --             table.insert( Image, DuplicateIcon( Source ) )
        --         end

        --         table.insert( Image, DuplicateIcon( ModifierConstant ) )
        --     end
        -- end
    end

    ---> <---     ---> <---     ---> <---

    Array = { }

    -- Otros
    table.insert( Array, "ghost-time-to-live" )
    table.insert( Array, "deconstruction-time-to-live" )

    -- Cagar el zoom
    table.insert( Array, "zoom-to-world-enabled" )
    table.insert( Array, "zoom-to-world-blueprint-enabled" )
    table.insert( Array, "zoom-to-world-selection-tool-enabled" )
    table.insert( Array, "zoom-to-world-ghost-building-enabled" )
    table.insert( Array, "zoom-to-world-upgrade-planner-enabled" )
    table.insert( Array, "zoom-to-world-deconstruction-planner-enabled" )

    -- Cagar el personaje
    Array = { }
    table.insert( Array, "character-health-bonus" )
    table.insert( Array, "character-mining-speed" )
    table.insert( Array, "character-running-speed" )
    table.insert( Array, "character-build-distance" )
    table.insert( Array, "character-reach-distance" )
    table.insert( Array, "character-crafting-speed" )
    table.insert( Array, "character-logistic-requests" )
    table.insert( Array, "character-item-drop-distance" )
    table.insert( Array, "character-logistic-trash-slots" )
    table.insert( Array, "character-item-pickup-distance" )
    table.insert( Array, "character-loot-pickup-distance" )
    table.insert( Array, "character-inventory-slots-bonus" )
    table.insert( Array, "character-resource-reach-distance" )

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    Array = { }
    table.insert( Array, "character-additional-mining-categories" )

    Items = { }
    table.insert( Items, Patch[ "character_health_bonus_modifier_icon" ] )

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cargar los laboratorios
    Array = { }
    table.insert( Array, "laboratory-speed" )
    table.insert( Array, "laboratory-productivity" )

    Items = { }
    for _, Item in pairs( data.raw[ "lab" ] ) do
        Item = GPrefix.Items[ Item.name ]
        table.insert( Items, Item )
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar las robots de combate
    Array = { }
    table.insert( Array, "follower-robot-lifetime" )
    table.insert( Array, "maximum-following-robots-count" )

    Items = { }
    for _, Item in pairs( data.raw[ "combat-robot" ] ) do
        if Item.follows_player then
            Item = GPrefix.Items[ Item.name ]
            table.insert( Items, Item )
        end
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar el incerador
    Array = { }
    table.insert( Array, "inserter-stack-size-bonus" )

    Items = { }
    for _, Item in pairs( data.raw[ "inserter" ] ) do
        if not Item.stack then
            Item = GPrefix.Items[ Item.name ]
            table.insert( Items, Item )
        end
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar el incerador apilable
    Array = { }
    table.insert( Array, "stack-inserter-capacity-bonus" )

    Items = { }
    for _, Item in pairs( data.raw[ "inserter" ] ) do
        if Item.stack then table.insert( Items, Item ) end
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar la munición de artilleria
    Array = { }
    table.insert( Array, "artillery-range" )

    Items = { }
    for _, Item in pairs( data.raw[ "artillery-wagon" ] ) do
        Item = GPrefix.Items[ Item.name ]
        table.insert( Items, Item )
    end
    for _, Item in pairs( data.raw[ "artillery-turret" ] ) do
        Item = GPrefix.Items[ Item.name ]
        table.insert( Items, Item )
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar las robots logisticos y de construcción
    Array = { }
    table.insert( Array, "worker-robot-speed" )
    table.insert( Array, "worker-robot-storage" )
    table.insert( Array, "worker-robot-battery" )

    Items = { }
    for _, Item in pairs( data.raw[ "construction-robot" ] ) do
        table.insert( Items, GPrefix.Items[ Item.name ] )
    end
    for _, Item in pairs( data.raw[ "logistic-robot" ] ) do
        table.insert( Items, GPrefix.Items[ Item.name ] )
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar el robot de construcción
    Array = { }
    table.insert( Array, "max-failed-attempts-per-tick-per-construction-queue" )
    table.insert( Array, "max-successful-attempts-per-tick-per-construction-queue" )

    Items = { }
    for _, Item in pairs( data.raw[ "construction-robot" ] ) do
        Item = GPrefix.Items[ Item.name ]
        table.insert( Items, Item )
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar los trenes
    Array = { }
    table.insert( Array, "train-braking-force-bonus" )

    Items = { }
    for _, Item in pairs( data.raw[ "locomotive" ] ) do
        Item = GPrefix.Items[ Item.name ]
        table.insert( Items, Item )
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar los mineros
    Array = { }
    table.insert( Array, "mining-drill-productivity-bonus" )

    Items = { }
    for _, Item in pairs( data.raw[ "mining-drill" ] ) do
        Item = GPrefix.Items[ Item.name ]
        table.insert( Items, Item )
    end

    for _, Effect in pairs( Array ) do
        CreateIcon( Effect, Items )
    end

    ---> <---     ---> <---     ---> <---

    for Type, Effect in pairs( Effects ) do
        for Name, Images in pairs( Effect ) do

            local NewSprite = { }
            NewSprite.type = "sprite"
            NewSprite.name = Type .. "-" .. Name
            NewSprite.layers = Images
            NewSprite.flags = { "gui-icon" }

            data:extend( { NewSprite } )
        end
    end

    ---> <---     ---> <---     ---> <---





    ---> <---     ---> <---     ---> <---

    -- Inicializar los contenedores
    local TurretAttack = { }
    local AmmoDamage = { }
    local GunSpeed = { }
    Effects = { }

    -- Buscar los afectados
    for _, Tchnology in pairs( data.raw[ "technology" ] ) do
        if Tchnology.effects then
            for _, Effect in pairs( Tchnology.effects ) do
                repeat
                    if Effect.type ~= "ammo-damage" then break end
                    if GPrefix.getKey( AmmoDamage, Effect.ammo_category ) then break end
                    table.insert( AmmoDamage, Effect.ammo_category )
                until true

                repeat
                    if Effect.type ~= "turret-attack" then break end
                    if GPrefix.getKey( TurretAttack, Effect.turret_id ) then break end
                    table.insert( TurretAttack, Effect.turret_id )
                until true

                repeat
                    if Effect.type ~= "gun-speed" then break end
                    if GPrefix.getKey( GunSpeed, Effect.ammo_category ) then break end
                    table.insert( GunSpeed, Effect.ammo_category )
                until true
            end
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar las turres de ataque
    Array = { }
    table.insert( Array, "turret-attack" )

    Items = { }
    for _, ItemName in pairs( TurretAttack ) do
        Item = GPrefix.Items[ ItemName ]
        table.insert( Items, Item )
    end

    for _, Effect in pairs( Array ) do
        for _, Item in pairs( Items ) do
            CreateIcon( Effect, { Item }, Item.name .. "-attack-bonus" )
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar los afectados por la velocidad
    Array = { }
    table.insert( Array, GPrefix.Items )
    table.insert( Array, GPrefix.Entities )
    table.insert( Array, GPrefix.Equipaments )
    table.insert( Array, data.raw[ "combat-robot" ] )

    Items = { }
    for _, Many in pairs( Array ) do
        for _, One in pairs( Many ) do
            repeat
                local Alias = false
                if One.ammo_type then Alias = One.ammo_type end
                if One.attack_parameters and One.attack_parameters.ammo_type then
                    Alias = One.attack_parameters.ammo_type
                end if not Alias then break end

                local AmmoTypes = { }
                if Alias[ 1 ] then AmmoTypes = Alias end
                if not Alias[ 1 ] then AmmoTypes = { Alias } end
                for _, AmmoType in pairs( AmmoTypes ) do
                    if GPrefix.getKey( GunSpeed, AmmoType.category ) then
                        Items[ AmmoType.category ] = Items[ AmmoType.category ] or { }
                        local Item = GPrefix.Items[ One.name ]
                        if not Item then Item = One end
                        table.insert( Items[ AmmoType.category ], Item )
                        break
                    end
                end
            until true
        end
    end

    Array = { }
    table.insert( Array, "gun-speed" )

    for _, Effect in pairs( Array ) do
        for Type, Item in pairs( Items ) do
            CreateIcon( Effect, Item, Type .. "-shooting-speed-bonus" )
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Cagar las municiones
    Array = { }
    table.insert( Array, GPrefix.Items )
    table.insert( Array, GPrefix.Entities )
    table.insert( Array, GPrefix.Equipaments )
    table.insert( Array, data.raw[ "combat-robot" ] )

    Items = { }
    for _, Many in pairs( Array ) do
        for _, One in pairs( Many ) do
            repeat
                local Alias = { }

                -- Equipo
                if One.ammo_type then Alias = One.ammo_type end

                -- Beam
                if One.attack_parameters and One.attack_parameters.ammo_type then
                    if not data.raw[ 'fluid-turret' ][ One.name ] then
                        Alias = One.attack_parameters.ammo_type
                    end
                end

                -- Minas de tierra
                if One.ammo_category then
                    Alias = { { category = One.ammo_category } }
                end

                -- Capsulas
                if not Alias then
                    local Parameters = { }
                    table.insert( Parameters, "capsule_action" )
                    table.insert( Parameters, "attack_parameters" )
                    table.insert( Parameters, "ammo_type" )

                    local Flag = One
                    for _, Parameter in pairs( Parameters ) do
                        if not Flag then break end
                        Flag = Flag[ Parameter ]
                    end

                    if Flag then Alias = Flag end
                end

                -- No se ha identificado algún item
                if not Alias then break end

                local AmmoTypes = { }
                if Alias[ 1 ] then AmmoTypes = Alias end
                if not Alias[ 1 ] then AmmoTypes = { Alias } end
                for _, AmmoType in pairs( AmmoTypes ) do
                    if GPrefix.getKey( AmmoDamage, AmmoType.category ) then
                        Items[ AmmoType.category ] = Items[ AmmoType.category ] or { }
                        local Item = GPrefix.Items[ One.name ]
                        if not Item then Item = One end
                        table.insert( Items[ AmmoType.category ], Item )
                        break
                    end
                end
            until true
        end
    end

    Array = { }
    table.insert( Array, "ammo-damage" )

    for _, Effect in pairs( Array ) do
        for Type, Item in pairs( Items ) do
            CreateIcon( Effect, Item, Type .. "-damage-bonus" )
        end
    end

    ---> <---     ---> <---     ---> <---

    for _, Effect in pairs( Effects ) do
        for Name, Images in pairs( Effect ) do
            for Key, Image in pairs( Images ) do
                local NewSprite = { }
                NewSprite.type = "sprite"
                NewSprite.name = Name .. "-" .. Key
                NewSprite.layers = Image
                NewSprite.flags = { "gui-icon" }

                data:extend( { NewSprite } )
            end
        end
    end
end

-- Prototipos del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.CreateSprite( )   ThisMOD.KeySequence( )   ThisMOD.Shortcut( )
end

-- Cargar los prototipos
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Prototipo de la ventana principal

function ThisMOD.BuildWindowMain( Data )

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

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.WindowFrame = WindowFrame
    Data.GUI.Main.WindowFlow = WindowFlow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildWindowMainTitle( Data )
    ThisMOD.BuildWindowMainBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.WindowFlow = nil
end

function ThisMOD.BuildWindowMainTitle( Data )

    -- Barra de titulo
    local TitleBar = { }
    TitleBar.type = "flow"
    TitleBar = Data.GUI.Main.WindowFlow.add( TitleBar )
    TitleBar.style = "horizontal_flow"
    TitleBar.style.horizontal_spacing = 9
    TitleBar.style.height = 24



    -- Indicador para mover la ventana
    local LeftEmptyWidget = { }
    LeftEmptyWidget.type = "empty-widget"
    LeftEmptyWidget = TitleBar.add( LeftEmptyWidget )
    LeftEmptyWidget.style = "draggable_space_header"
    LeftEmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    LeftEmptyWidget.style.horizontally_stretchable = true
    LeftEmptyWidget.style.vertically_stretchable = true
    LeftEmptyWidget.style.margin = 0
    LeftEmptyWidget.style.top_margin = 3



    -- Contenedor de titulo y status
    local Flow = { }
    Flow.type = "flow"
    Flow = TitleBar.add( Flow )
    Flow.style = "horizontal_flow"
    Flow.style.horizontal_spacing = 1
    Flow.style.vertically_stretchable = true
    Flow.style.vertical_align = "top"

    -- Contenedor de titulo
    local TitleFlow = { }
    TitleFlow.type = "flow"
    TitleFlow = Flow.add( TitleFlow )
    TitleFlow.style = "horizontal_flow"
    TitleFlow.style.vertically_stretchable = true
    TitleFlow.style.vertical_align = "top"

    -- Etiqueta con el titulo
    local TitleLable = { }
    TitleLable.type = "label"
    TitleLable.caption = { Data.GMOD.Local .. "setting-name"}
    TitleLable = TitleFlow.add( TitleLable )
    TitleLable.style = "frame_title"

    -- Contenedor del status
    local StatusFlow = { }
    StatusFlow.type = "flow"
    StatusFlow = Flow.add( StatusFlow )
    StatusFlow.style = "horizontal_flow"
    StatusFlow.style.vertically_stretchable = true
    StatusFlow.style.vertical_align = "bottom"

    -- Renombrar la variable
    local StatusMOD = Data.gForce.Status

    -- Etiqueta con el valor
    local StatusLabel = { }
    StatusLabel.type = "label"
    StatusLabel.caption = { Data.GMOD.Local .. ( StatusMOD and "ON" or "OFF" ) }
    StatusLabel = StatusFlow.add( StatusLabel )
    StatusLabel.style = "bold_" .. ( StatusMOD and "green" or "red" ) .. "_label"
    if Data.Player.admin then
        local List = { "" }
        table.insert( List, "[font=default-bold]" )
        table.insert( List, {Data.GMOD.Local .. "turn" } )
        table.insert( List, " [color=" .. ( not StatusMOD and "green" or "red" ) .. "]" )
        table.insert( List, { Data.GMOD.Local .. ( not StatusMOD and "ON" or "OFF" ) } )
        table.insert( List, "[/color][/font]" )
        StatusLabel.tooltip = List
    else
        local List = { "" }
        table.insert( List, "[font=default-bold]" )
        table.insert( List, {Data.GMOD.Local .. "status" } )
        table.insert( List, " [color=" .. ( StatusMOD and "green" or "red" ) .. "]" )
        table.insert( List, { Data.GMOD.Local .. ( StatusMOD and "ON" or "OFF" ) } )
        table.insert( List, "[/color][/font]" )
        StatusLabel.tooltip = List
    end



    -- Indicador para mover la ventana
    local RightEmptyWidget = { }
    RightEmptyWidget.type = "empty-widget"
    RightEmptyWidget = TitleBar.add( RightEmptyWidget )
    RightEmptyWidget.style = "draggable_space_header"
    RightEmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    RightEmptyWidget.style.horizontally_stretchable = true
    RightEmptyWidget.style.vertically_stretchable = true
    RightEmptyWidget.style.margin = 0
    RightEmptyWidget.style.top_margin = 3

    -- Botón de busqueda
    local SearchTextfield = { }
    SearchTextfield.type = "textfield"
    SearchTextfield = TitleBar.add( SearchTextfield )
    SearchTextfield.style = "console_input_textfield"
    SearchTextfield.style.height = 24
    SearchTextfield.visible = false

    -- Paramatros de selección
    local TagsSearchSpriteButton = { }
    TagsSearchSpriteButton.Size = 24
    TagsSearchSpriteButton.Enabled = "frame_action_button"
    TagsSearchSpriteButton.Disabled = "image_tab_selected_slot"
    TagsSearchSpriteButton.White = "utility/search_white"
    TagsSearchSpriteButton.Black = "utility/search_black"

    -- Botón de busqueda
    local SearchSpriteButton = { }
    SearchSpriteButton.tags = TagsSearchSpriteButton
    SearchSpriteButton.type = "sprite-button"
    SearchSpriteButton.sprite = TagsSearchSpriteButton.White
    SearchSpriteButton.hovered_sprite = TagsSearchSpriteButton.Black
    SearchSpriteButton.clicked_sprite = TagsSearchSpriteButton.Black
    SearchSpriteButton.tooltip = { Data.GMOD.Local .. "search" }
    SearchSpriteButton = TitleBar.add( SearchSpriteButton )
    SearchSpriteButton.style = TagsSearchSpriteButton.Enabled
    SearchSpriteButton.style.padding = 0
    SearchSpriteButton.style.margin = 0

    -- Renombrar la variable
    local StatusWindow = not Data.GUI.Status.WindowFrame

    -- Paramatros de selección
    local TagsStatusButton = { }
    TagsStatusButton.Size = 24
    TagsStatusButton.Disabled = "image_tab_selected_slot"
    TagsStatusButton.Enabled = "frame_action_button"
    TagsStatusButton.White = "utility/logistic_network_panel_white"
    TagsStatusButton.Black = "utility/logistic_network_panel_black"

    -- Botón de la status
    local StatusButton = { }
    StatusButton.tags = TagsStatusButton
    StatusButton.type = "sprite-button"
    StatusButton.sprite = TagsStatusButton.White
    StatusButton.hovered_sprite = TagsStatusButton.Black
    StatusButton.clicked_sprite = TagsStatusButton.Black
    StatusButton.tooltip = { Data.GMOD.Local .. "window-status" }
    StatusButton = TitleBar.add( StatusButton )
    StatusButton.style = StatusWindow and TagsStatusButton.Enabled or TagsStatusButton.Disabled
    StatusButton.style.size = TagsStatusButton.Size
    StatusButton.style.padding = 0
    StatusButton.style.margin = 0

    -- Botón de cierre
    local CloseButton = { }
    CloseButton.type = "sprite-button"
    CloseButton.sprite = "utility/close_white"
    CloseButton.hovered_sprite = "utility/close_black"
    CloseButton.clicked_sprite = "utility/close_black"
    CloseButton.tooltip = { Data.GMOD.Local .. "close" }
    CloseButton = TitleBar.add( CloseButton )
    CloseButton.style = "frame_action_button"
    CloseButton.style.padding = 0
    CloseButton.style.margin = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.StatusLabel = StatusLabel
    Data.GUI.Main.CloseWindowButton = CloseButton
    Data.GUI.Main.SearchTechnologyButton = SearchSpriteButton
    Data.GUI.Main.ToggleStatusWindowButton = StatusButton
    Data.GUI.Main.SearchTechnologyTextfield = SearchTextfield
end

function ThisMOD.BuildWindowMainBody( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.WindowFlow.add( Flow )
    Flow.style.horizontal_spacing = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.WindowMainBodyFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildQueueSection( Data )
    ThisMOD.BuildMainDetailSection( Data )
    ThisMOD.BuildTecnologySection( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.WindowMainBodyFlow = nil
end



function ThisMOD.BuildQueueSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.WindowMainBodyFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.width = 100

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.QueueSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildQueueTitle( Data )
    ThisMOD.BuildQueueBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.QueueSectionFlow = nil
end

function ThisMOD.BuildQueueTitle( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.QueueSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.height = 24

    -- Titulo
    local Label = { }
    Label.type = "label"
    Label.caption = { Data.GMOD.Local .. "queue" }
    Label = Flow.add( Label )
    Label.style = "heading_2_label"
    Label.style.padding = 0
    Label.style.margin = 0

    -- Abrir el parentesis
    local OpenParentheses = { }
    OpenParentheses.type = "label"
    OpenParentheses.caption = " ( "
    OpenParentheses = Flow.add( OpenParentheses )
    OpenParentheses.style = "heading_2_label"
    OpenParentheses.style.padding = 0
    OpenParentheses.style.margin = 0

    -- Cantidad de tecnología sin investigar
    local Count = { }
    Count.type = "label"
    Count = Flow.add( Count )
    Count.style = "heading_2_label"
    Count.style.padding = 0
    Count.style.margin = 0

    -- Cerrar el parentesis
    local CloseParentheses = { }
    CloseParentheses.type = "label"
    CloseParentheses.caption = " )"
    CloseParentheses = Flow.add( CloseParentheses )
    CloseParentheses.style = "heading_2_label"
    CloseParentheses.style.padding = 0
    CloseParentheses.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.QueueCountLabel = Count
end

function ThisMOD.BuildQueueBody( Data )

    -- Fondo de la cola
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.QueueSectionFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"

    -- Contenedor de la cola
    local Flow = { }
    Flow.type = "flow"
    Flow.name = "Queue"
    Flow.direction = "vertical"
    Flow = ScrollPane.add( Flow )
    Flow.style.horizontally_stretchable = true
    Flow.style.horizontal_align = "center"
    Flow.style.vertical_align = "top"
    Flow.style.vertical_spacing = 0
    Flow.style.padding = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.QueueFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Mostrar las tecnologías en la cola
    ThisMOD.ShowQueue( Data )

    ---> <---     ---> <---     ---> <---

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = ScrollPane.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
end



function ThisMOD.BuildMainDetailSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.WindowMainBodyFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.width = 573

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.DetailSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildSingleSection( Data )
    ThisMOD.BuildAccumulatedSection( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.DetailSectionFlow = nil
end

function ThisMOD.BuildSingleSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.DetailSectionFlow.add( Flow )
    Flow.style.vertical_spacing = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildSingleTitle( Data )
    ThisMOD.BuildSingleBody( Data )
end

function ThisMOD.BuildSingleTitle( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.SingleSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.height = 24

    -- Titulo
    local Label = { }
    Label.type = "label"
    Label.caption = { "item-name.space-science-pack" }
    Label = Flow.add( Label )
    Label.style = "heading_2_label"
    Label.style.padding = 0
    Label.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.DetailTitleLabel = Label
end

function ThisMOD.BuildSingleBody( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.SingleSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleBodyFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildSinglePicture( Data )
    ThisMOD.BuildSingleDetail( Data )
end

function ThisMOD.BuildSinglePicture( Data )

    -- Fondo de la imagen
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.SingleBodyFlow.add( Frame )
    Frame.style = "shortcut_selection_row"

    -- Marco de la imagen
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "auto-and-reserve-space"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style.vertically_stretchable = true
    ScrollPane.style = "blurry_scroll_pane"

    -- Contenedor de la imagen
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = ScrollPane.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertically_stretchable = true
    Flow.style.vertical_align = "center"
    Flow.style.padding = 9
    Flow.style.right_padding = 0

    -- Imagen de la tecnología
    local Picture = { }
    Picture.type = "sprite-button"
    Picture.resize_to_sprite = true
    Picture = Flow.add( Picture )
    Picture.style = "transparent_slot"
    Picture.style.size = 145
    Picture.style.margin = 0
    Picture.style.padding = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SinglePictureSprite = Picture
end


function ThisMOD.BuildSingleDetail( Data )

    -- Fondo de la sección
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.SingleBodyFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    -- Marco de la sección
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "auto-and-reserve-space"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"

    -- Contenedor de la sección
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = ScrollPane.add( Flow )
    Flow.style.vertical_spacing = 9
    Flow.style.padding = 0
    Flow.style.bottom_padding = 16
    Flow.style.left_padding = 13
    Flow.style.top_padding = 10

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleDetailFlow = Flow
    Data.GUI.Main.SingleDetailScrollPane = ScrollPane

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildSingleCostSection( Data )
    ThisMOD.BuildSingleEffectsSection( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.SingleDetailFlow = nil
end


function ThisMOD.BuildSingleCostSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.SingleDetailFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.padding = 0
    Flow.style.width = 341

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleCostSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildSingleCostTitle( Data )
    ThisMOD.BuildSingleCostBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.SingleCostSectionFlow = nil
end

function ThisMOD.BuildSingleCostTitle( Data )

    -- Contenedor del titulo
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.SingleCostSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "cost" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de costo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 13
    Frame.style.left_padding = 9
    Frame.style.top_margin = 4

    -- Etiqueta del costo
    local CostLabel = { }
    CostLabel.type = "label"
    CostLabel.caption = { Data.GMOD.Local .. "quantity" }
    CostLabel = Frame.add( CostLabel )
    CostLabel.style = "caption_label"
    CostLabel.style.padding = 0
    CostLabel.style.margin = 0

    -- Valor del costo
    local CostValue = { }
    CostValue.type = "label"
    CostValue.caption = ""
    CostValue = Frame.add( CostValue )
    CostValue.style = "achievement_unlocked_title_label"
    CostValue.style.padding = 0
    CostValue.style.margin = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleCostLabel = CostValue
end

function ThisMOD.BuildSingleCostBody( Data )

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Data.GUI.Main.SingleCostSectionFlow.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true

    -- Tabla contenedora
    local Table = { }
    Table.type = "table"
    Table.column_count = 10
    Table = ScrollPane.add( Table )
    Table.style = "research_queue_table"
    Table.style.horizontal_spacing = 0
    Table.style.horizontally_stretchable = true

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleIngredientsTable = Table
    Data.GUI.Main.SingleIngredientsScrollPane = ScrollPane
end


function ThisMOD.BuildSingleEffectsSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.SingleDetailFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.padding = 0
    Flow.style.width = 341

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleEffectsSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildSingleEffectsTitle( Data )
    ThisMOD.BuildSingleEffectsBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.SingleEffectsSectionFlow = nil
end

function ThisMOD.BuildSingleEffectsTitle( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.SingleEffectsSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "effects" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.height = 24

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 13
    Frame.style.left_padding = 9
    Frame.style.top_margin = 4

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleTimeFrame = Frame
end

function ThisMOD.BuildSingleEffectsBody( Data )

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Data.GUI.Main.SingleEffectsSectionFlow.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true

    -- Tabla contenedora
    local Table = { }
    Table.type = "table"
    Table.column_count = 10
    Table = ScrollPane.add( Table )
    Table.style = "research_queue_table"
    Table.style.horizontally_stretchable = true
    Table.style.horizontal_spacing = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.SingleEffectsTable = Table
    Data.GUI.Main.SingleEffectsScrollPane = ScrollPane
end


function ThisMOD.BuildAccumulatedSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.DetailSectionFlow.add( Flow )
    Flow.style.vertical_spacing = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildAccumulatedTitle( Data )
    ThisMOD.BuildAccumulatedDetail( Data )
end

function ThisMOD.BuildAccumulatedTitle( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.AccumulatedSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.height = 24

    -- Titulo
    local Label = { }
    Label.type = "label"
    Label.caption = { Data.GMOD.Local .. "accumulated" }
    Label = Flow.add( Label )
    Label.style = "heading_2_label"
    Label.style.padding = 0
    Label.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
end

function ThisMOD.BuildAccumulatedDetail( Data )

    -- Fondo de la sección
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.AccumulatedSectionFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    -- Marco de la sección
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "auto-and-reserve-space"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"

    -- Contenedor de la sección
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = ScrollPane.add( Flow )
    Flow.style.vertical_spacing = 9
    Flow.style.padding = 0
    Flow.style.bottom_padding = 16
    Flow.style.left_padding = 13
    Flow.style.top_padding = 10

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedDetailFlow = Flow
    Data.GUI.Main.AccumulatedDetailScrollPane = ScrollPane

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildAccumulatedCostSection( Data )
    ThisMOD.BuildAccumulatedPrerequisitesSection( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.AccumulatedDetailFlow = nil
end


function ThisMOD.BuildAccumulatedCostSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.AccumulatedDetailFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.padding = 0
    Flow.style.width = 532

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedCostSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildAccumulatedCostTitle( Data )
    ThisMOD.BuildAccumulatedCostBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.AccumulatedCostSectionFlow = nil
end

function ThisMOD.BuildAccumulatedCostTitle( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.AccumulatedCostSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "cost" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
end

function ThisMOD.BuildAccumulatedCostBody( Data )

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Data.GUI.Main.AccumulatedCostSectionFlow.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true

    -- Tabla contenedora
    local Table = { }
    Table.type = "table"
    Table.column_count = 16
    Table = ScrollPane.add( Table )
    Table.style = "research_queue_table"
    Table.style.horizontal_spacing = 0
    Table.style.horizontally_stretchable = true

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedIngredientsTable = Table
    Data.GUI.Main.AccumulatedIngredientsScrollPane = ScrollPane
end


function ThisMOD.BuildAccumulatedPrerequisitesSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.AccumulatedDetailFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.padding = 0
    Flow.style.width = 532

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedPrerequisitesSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildAccumulatedPrerequisitesTitle( Data )
    ThisMOD.BuildAccumulatedPrerequisitesBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.AccumulatedPrerequisitesSectionFlow = nil
end

function ThisMOD.BuildAccumulatedPrerequisitesTitle( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.AccumulatedPrerequisitesSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "prerequisites" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 13
    Frame.style.left_padding = 9
    Frame.style.top_margin = 4

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedTimeFrame = Frame
end

function ThisMOD.BuildAccumulatedPrerequisitesBody( Data )

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Data.GUI.Main.AccumulatedPrerequisitesSectionFlow.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true

    -- Tabla contenedora
    local Table = { }
    Table.type = "table"
    Table.column_count = 16
    Table = ScrollPane.add( Table )
    Table.style = "research_queue_table"
    Table.style.horizontally_stretchable = true
    Table.style.horizontal_spacing = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.AccumulatedPrerequisitesTable = Table
    Data.GUI.Main.AccumulatedPrerequisitesScrollPane = ScrollPane
end



function ThisMOD.BuildTecnologySection( Data )

    -- Contenedor de los detalles
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.WindowMainBodyFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.width = 350

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.TecnologySectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    ThisMOD.BuildTecnologyTitle( Data )
    ThisMOD.BuildTecnologyBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.TecnologySectionFlow = nil
end

function ThisMOD.BuildTecnologyTitle( Data )

    -- Contenedor del titulo
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Main.TecnologySectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.height = 24

    -- Etiqueta con el titulo
    local Label = { }
    Label.type = "label"
    Label.caption = { Data.GMOD.Local .. "tecnologies" }
    Label = Flow.add( Label )
    Label.style = "heading_2_label"
    Label.style.padding = 0
    Label.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
end

function ThisMOD.BuildTecnologyBody( Data )

    -- Fondo de la sección
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.TecnologySectionFlow.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0

    -- Contenedor de la sección
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Frame.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.padding = 0
    Flow.style.vertical_align = "top"

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.TecnologyBodyFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildTecnologyUnresearchedSection( Data )
    ThisMOD.BuildTecnologyResearchedSection( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.TecnologyBodyFlow = nil
end


function ThisMOD.BuildTecnologyUnresearchedSection( Data )

    -- Contenedor de los detalles
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.TecnologyBodyFlow.add( Flow )
    Flow.style.horizontally_stretchable = true
    Flow.style.vertical_spacing = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.TecnologyUnresearchedSection = Flow

    ---> <---     ---> <---     ---> <---

    ThisMOD.BuildTecnologyUnresearchedTitle( Data )
    ThisMOD.BuildTecnologyUnresearchedBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.TecnologyUnresearchedSection = nil
end

function ThisMOD.BuildTecnologyUnresearchedTitle( Data )

    -- Apariencia del titulo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.TecnologyUnresearchedSection.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.left_padding = 4
    Frame.style.height = 34
    Frame.style.vertical_align = "center"

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Frame.add( Flow )
    Flow.style.horizontal_spacing = 0

    -- Titulo
    local Label = { }
    Label.type = "label"
    Label.caption = { Data.GMOD.Local .. "unresearched" }
    Label = Flow.add( Label )
    Label.style = "heading_2_label"
    Label.style.padding = 0
    Label.style.margin = 0

    -- Abrir el parentesis
    local OpenParentheses = { }
    OpenParentheses.type = "label"
    OpenParentheses.caption = " ( "
    OpenParentheses = Flow.add( OpenParentheses )
    OpenParentheses.style = "heading_2_label"
    OpenParentheses.style.padding = 0
    OpenParentheses.style.margin = 0

    -- Cantidad de tecnología sin investigar
    local Count = { }
    Count.type = "label"
    Count.caption = ""
    Count = Flow.add( Count )
    Count.style = "heading_2_label"
    Count.style.padding = 0
    Count.style.margin = 0

    -- Cerrar el parentesis
    local CloseParentheses = { }
    CloseParentheses.type = "label"
    CloseParentheses.caption = " )"
    CloseParentheses = Flow.add( CloseParentheses )
    CloseParentheses.style = "heading_2_label"
    CloseParentheses.style.padding = 0
    CloseParentheses.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Botón de contracción
    local ExpandButton = { }
    ExpandButton.type = "sprite-button"
    ExpandButton.sprite = "utility/collapse"
    ExpandButton.hovered_sprite = "utility/collapse_dark"
    ExpandButton.clicked_sprite = "utility/collapse_dark"
    ExpandButton = Flow.add( ExpandButton )
    ExpandButton.style = "frame_action_button"
    ExpandButton.style.padding = 0
    ExpandButton.style.margin = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.UnresearchedCountLabel = Count
    Data.GUI.Main.UnresearchedExpandButton = ExpandButton
end

function ThisMOD.BuildTecnologyUnresearchedBody( Data )

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Data.GUI.Main.TecnologyUnresearchedSection.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true
    ScrollPane.style.maximal_height = 0

    -- Contenedor del nivel
    local Flow = { }
    Flow.type = "flow"
    Flow.name = "Unresearched"
    Flow.direction = "vertical"
    Flow = ScrollPane.add( Flow )
    Flow.style.vertical_spacing = 9
    Flow.style.padding = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.UnresearchedFlow = Flow
    Data.GUI.Main.UnresearchedScrollPane = ScrollPane

    ---> <---     ---> <---     ---> <---

    -- Cargar las tecnologías
    ThisMOD.ShowTechnologiesUnresearched( Data )
end


function ThisMOD.BuildTecnologyResearchedSection( Data )

    -- Contenedor de los detalles
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Main.TecnologyBodyFlow.add( Flow )
    Flow.style.horizontally_stretchable = true
    Flow.style.vertical_spacing = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.TecnologyResearchedSection = Flow

    ---> <---     ---> <---     ---> <---

    ThisMOD.BuildTecnologyResearchedTitle( Data )
    ThisMOD.BuildTecnologyResearchedBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Main.TecnologyResearchedSection = nil
end

function ThisMOD.BuildTecnologyResearchedTitle( Data )

    -- Apariencia del titulo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Main.TecnologyResearchedSection.add( Frame )
    Frame.style = "shortcut_selection_row"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.left_padding = 4
    Frame.style.height = 34
    Frame.style.vertical_align = "center"

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Frame.add( Flow )
    Flow.style.horizontal_spacing = 0

    -- Titulo
    local Label = { }
    Label.type = "label"
    Label.caption = { Data.GMOD.Local .. "researched" }
    Label = Flow.add( Label )
    Label.style = "heading_2_label"
    Label.style.padding = 0
    Label.style.margin = 0

    -- Abrir el parentesis
    local OpenParentheses = { }
    OpenParentheses.type = "label"
    OpenParentheses.caption = " ( "
    OpenParentheses = Flow.add( OpenParentheses )
    OpenParentheses.style = "heading_2_label"
    OpenParentheses.style.padding = 0
    OpenParentheses.style.margin = 0

    -- Cantidad de tecnología investigadas
    local Count = { }
    Count.type = "label"
    Count.caption = ""
    Count = Flow.add( Count )
    Count.style = "heading_2_label"
    Count.style.padding = 0
    Count.style.margin = 0

    -- Cerrar el parentesis
    local CloseParentheses = { }
    CloseParentheses.type = "label"
    CloseParentheses.caption = " )"
    CloseParentheses = Flow.add( CloseParentheses )
    CloseParentheses.style = "heading_2_label"
    CloseParentheses.style.padding = 0
    CloseParentheses.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Botón de contracción
    local ExpandButton = { }
    ExpandButton.type = "sprite-button"
    ExpandButton.sprite = "utility/collapse"
    ExpandButton.hovered_sprite = "utility/collapse_dark"
    ExpandButton.clicked_sprite = "utility/collapse_dark"
    ExpandButton = Flow.add( ExpandButton )
    ExpandButton.style = "frame_action_button"
    ExpandButton.style.padding = 0
    ExpandButton.style.margin = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.ResearchedCountLabel = Count
    Data.GUI.Main.ResearchedExpandButton = ExpandButton
end

function ThisMOD.BuildTecnologyResearchedBody( Data )

    -- Contenedor con scroll
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "always"
    ScrollPane = Data.GUI.Main.TecnologyResearchedSection.add( ScrollPane )
    ScrollPane.style = "blurry_scroll_pane"
    ScrollPane.style.horizontally_stretchable = true
    ScrollPane.style.maximal_height = 0

    -- Contenedor del nivel
    local Flow = { }
    Flow.type = "flow"
    Flow.name = "Researched"
    Flow.direction = "vertical"
    Flow = ScrollPane.add( Flow )
    Flow.style.vertical_spacing = 9
    Flow.style.padding = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Main.ResearchedFlow = Flow
    Data.GUI.Main.ResearchedScrollPane = ScrollPane

    ---> <---     ---> <---     ---> <---

    -- Cargar las tecnologías
    ThisMOD.ShowTechnologiesResearched( Data )
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Crear ventanas de estado

function ThisMOD.BuildWindowStatus( Data )

    -- Ventana principal
    local WindowFrame =  { }
    WindowFrame.type = "frame"
    WindowFrame.name = Data.GMOD.Prefix_MOD_ .. "status"
    WindowFrame.direction = "vertical"

    -- Mostra la ventana
    local Screen = Data.Player.gui.screen
    WindowFrame = Screen.add( WindowFrame )

    -- Ubicar la ventana
    local Location = GPrefix.DeepCopy( Data.gPlayer.WindowStatusLocation )
    if not Location then WindowFrame.auto_center = true end
    if Location then WindowFrame.location = Location end

    -- Contenedor principal
    local WindowFlow = { }
    WindowFlow.type = "flow"
    WindowFlow.direction = "vertical"
    WindowFlow = WindowFrame.add( WindowFlow )
    WindowFlow.style.vertical_spacing = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.WindowFrame = WindowFrame
    Data.GUI.Status.WindowFlow = WindowFlow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildWindowStatusTitle( Data )
    ThisMOD.BuildWindowStatusBody( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Status.WindowFlow = nil
end

function ThisMOD.BuildWindowStatusTitle( Data )

    -- Barra de titulo
    local TitleBar = { }
    TitleBar.type = "flow"
    TitleBar = Data.GUI.Status.WindowFlow.add( TitleBar )
    TitleBar.style = "horizontal_flow"
    TitleBar.style.horizontal_spacing = 9
    TitleBar.style.height = 24

    -- Etiqueta con el titulo
    local TitleLable = { }
    TitleLable.type = "label"
    TitleLable.caption = { Data.GMOD.Local .. "setting-name"}
    TitleLable = TitleBar.add( TitleLable )
    TitleLable.style = "heading_2_label"

    -- Indicador para mover la ventana
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = TitleBar.add( EmptyWidget )
    EmptyWidget.style = "draggable_space_header"
    EmptyWidget.drag_target = Data.GUI.Status.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
    EmptyWidget.style.margin = 0
    EmptyWidget.style.top_margin = 3

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.WindowStatusTitleLable = TitleLable
end

function ThisMOD.BuildWindowStatusBody( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Status.WindowFlow.add( Flow )
    Flow.style.horizontal_spacing = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.WindowStatusBodyFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildStatusPicture( Data )
    ThisMOD.BuildStatusDetailSection( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Status.WindowStatusBodyFlow = nil
end



function ThisMOD.BuildStatusPicture( Data )

    -- Fondo de la imagen
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "vertical"
    Frame = Data.GUI.Status.WindowStatusBodyFlow.add( Frame )
    Frame.style = "shortcut_selection_row"

    -- Marco de la imagen
    local ScrollPane = { }
    ScrollPane.type = "scroll-pane"
    ScrollPane.vertical_scroll_policy = "auto-and-reserve-space"
    ScrollPane = Frame.add( ScrollPane )
    ScrollPane.style.vertically_stretchable = true
    ScrollPane.style = "blurry_scroll_pane"

    -- Contenedor de la imagen
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = ScrollPane.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertically_stretchable = true
    Flow.style.vertical_align = "center"
    Flow.style.padding = 9
    Flow.style.right_padding = 0

    -- Imagen de la tecnología
    local Picture = { }
    Picture.type = "sprite-button"
    Picture.resize_to_sprite = true
    Picture = Flow.add( Picture )
    Picture.style = "transparent_slot"
    Picture.style.size = 90
    Picture.style.margin = 0
    Picture.style.padding = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusPictureSprite = Picture
end


function ThisMOD.BuildStatusDetailSection( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "vertical"
    Flow = Data.GUI.Status.WindowStatusBodyFlow.add( Flow )
    Flow.style.vertical_spacing = 0
    Flow.style.width = 200

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusDetailSectionFlow = Flow

    ---> <---     ---> <---     ---> <---

    -- Cotruir la interfaz
    ThisMOD.BuildStatusTimeBase( Data )
    ThisMOD.BuildStatusTimeExpected( Data )
    ThisMOD.BuildStatusTimeElapsed( Data )
    ThisMOD.BuildStatusTimeLeft( Data )
    ThisMOD.BuildStatusQueue( Data )

    ---> <---     ---> <---     ---> <---

    -- Eliminar la referencia
    Data.GUI.Status.StatusDetailSectionFlow = nil
end


function ThisMOD.BuildStatusTimeBase( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Status.StatusDetailSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = "Base"
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Status.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 9
    Frame.style.left_padding = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusTimeBaseFrame = Frame
end

function ThisMOD.BuildStatusTimeExpected( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Status.StatusDetailSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "expected" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Status.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 9
    Frame.style.left_padding = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusTimeExpectedFrame = Frame
end

function ThisMOD.BuildStatusTimeElapsed( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Status.StatusDetailSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "elapsed" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Status.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 9
    Frame.style.left_padding = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusTimeElapsedFrame = Frame
end

function ThisMOD.BuildStatusTimeLeft( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Status.StatusDetailSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "left" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Status.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 9
    Frame.style.left_padding = 9

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusTimeLeftFrame = Frame
end

function ThisMOD.BuildStatusQueue( Data )

    -- Contenedor
    local Flow = { }
    Flow.type = "flow"
    Flow.direction = "horizontal"
    Flow = Data.GUI.Status.StatusDetailSectionFlow.add( Flow )
    Flow.style.horizontal_spacing = 0
    Flow.style.vertical_align = "bottom"
    Flow.style.height = 24

    -- Titulo
    local Title = { }
    Title.type = "label"
    Title.caption = { Data.GMOD.Local .. "queue" }
    Title = Flow.add( Title )
    Title.style = "heading_2_label"
    Title.style.padding = 0
    Title.style.margin = 0

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Status.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true

    -- Contenedor de tiempo
    local Frame = { }
    Frame.type = "frame"
    Frame.direction = "horizontal"
    Frame = Flow.add( Frame )
    Frame.style = "blurry_frame"
    Frame.style.margin = 0
    Frame.style.padding = 0
    Frame.style.right_padding = 9
    Frame.style.left_padding = 9

    -- Valor del tiempo
    local QueueLabel = { }
    QueueLabel.type = "label"
    QueueLabel = Frame.add( QueueLabel )
    QueueLabel.style = "achievement_unlocked_title_label"
    QueueLabel.style.padding = 0
    QueueLabel.style.margin = 0

    ---> <---     ---> <---     ---> <---

    -- Guardar instancia
    Data.GUI.Status.StatusQueueLabel = QueueLabel
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Acciones del jugador en la ventana principal

function ThisMOD.ToggleMOD( Data )

    -- Validación básica
    if not Data.Player.admin then return end
    if not Data.Event.element or not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Main.StatusLabel then return end
    if not GPrefix.ClickLeft( Data ) then return end

    ---> <---     ---> <---     ---> <---

    -- Hacer el cambio
    Data.gForce.Status = not Data.gForce.Status
    local Status = Data.gForce.Status

    -- Guardar la configuración inicial
    if Status and GPrefix.isNil( Data.gForce.research_queue_enabled ) then
        Data.gForce.research_queue_enabled = Data.Force.research_queue_enabled
    end

    -- Cargar la configuración inicial
    Data.Force.research_queue_enabled = not Status and Data.gForce.research_queue_enabled or false

    -- Mostrar el cambio
    for PlayerName, _ in pairs( Data.Force.players ) do
        repeat

            -- Datos a usar
            local Event = { Player = game.get_player( PlayerName ) }
            local PlayerData = ThisMOD.CreateData( Event )

            -- La ventana no esta abierta
            if not PlayerData.GUI.Main.WindowFrame then break end

            -- Renombrar la variable
            local StatusLabel = PlayerData.GUI.Main.StatusLabel

            -- Mostrar el cambio
            StatusLabel.caption = { Data.GMOD.Local .. ( Status and "ON" or "OFF" ) }
            StatusLabel.style = "bold_" .. ( Status and "green" or "red" ) .. "_label"

            -- Crear el tooltip
            if Data.Player.admin then
                local List = { "" }
                table.insert( List, "[font=default-bold]" )
                table.insert( List, { Data.GMOD.Local .. "turn" } )
                table.insert( List, " [color=" .. ( not Status and "green" or "red" ) .. "]" )
                table.insert( List, { Data.GMOD.Local .. ( not Status and "ON" or "OFF" ) } )
                table.insert( List, "[/color][/font]" )
                StatusLabel.tooltip = List
            else
                local List = { "" }
                table.insert( List, "[font=default-bold]" )
                table.insert( List, { Data.GMOD.Local .. "status" } )
                table.insert( List, " [color=" .. ( Status and "green" or "red" ) .. "]" )
                table.insert( List, { Data.GMOD.Local .. ( Status and "ON" or "OFF" ) } )
                table.insert( List, "[/color][/font]" )
                StatusLabel.tooltip = List
            end
        until true
    end

    -- Informar del cambio
    Data.Force.print( { "",
        "[color=default]",
        { Data.GMOD.Local .. "setting-name" },
        ": [/color]",
        {
            Data.GMOD.Local .. "status-change",
            {
                "",
                "[img=utility/character_mining_speed_modifier_icon][color=" ..
                Data.Player.color.r .. "," ..
                Data.Player.color.g .. "," ..
                Data.Player.color.b .. "]",
                Data.Player.name,
                "[/color]"
            },
            {
                "",
                "[color=" .. ( Status and "green" or "red" ) .. "]",
                { Data.GMOD.Local .. ( Status and "ON" or "OFF" ) },
                "[/color]"
            },
        }
    } )

    -- Validar la tecnología en investigación
    ThisMOD.UpdateReseach( Data )
end


function ThisMOD.ToggleWindowMain( Data )

    -- Validar evento
    if not ThisMOD.ValidateToggleWindow( Data ) then return end

    -- Validar que existan las tecnologías
    if not Data.Technologies then return end

    -- El MOD esta desactivado
    if not Data.GMOD.Active then return end

    ---> <---     ---> <---     ---> <---

    -- Des/habilitar botón shortcut
    local Button = Data.GMOD.Prefix_MOD
    local Toggled = Data.GUI.Main.WindowFrame and true or false
    Data.Player.set_shortcut_toggled( Button, not Toggled )

    -- Inicializar las variables
    local Ciclo = Data.gForce.Ciclo or { }
    Data.gForce.Ciclo = Ciclo
    if Ciclo.Count == 10 then
        Data.Queue = Ciclo.Queue
        ThisMOD.ValidateQueue( Data )
    end

    -- Acción a ejecutar
    if Data.GUI.Main.WindowFrame then
        ThisMOD.DestroyWindowMain( Data )
    else
        ThisMOD.CreateWindowMain( Data )
    end
end

function ThisMOD.ToggleTextfield( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validación básica
    if not GPrefix.ClickLeft( Data ) then return end

    -- Renombrar la variable
    local Button = Data.Event.element

    -- Validar botón
    if Button ~= Data.GUI.Main.SearchTechnologyButton then return end

    ---> <---     ---> <---     ---> <---

    -- Hacer el cambio
    GPrefix.ToggleButton( Button )

    -- Ocultar o mostrar el texto
    local Textfield = Data.GUI.Main.SearchTechnologyTextfield
    Textfield.visible = not Textfield.visible
    Textfield.text = ""

    ---> <---     ---> <---     ---> <---

    -- Borrar los efectos de la busqueda
    if not Textfield.visible then
        Data.Event.element = Textfield
        ThisMOD.SearchText( Data )
    end

    ---> <---     ---> <---     ---> <---

    -- Preparar para la busqueda
    if Textfield.visible then Textfield.focus( ) end
end

function ThisMOD.ToggleTechnology( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validación básica
    local OldButton = Data.Click and Data.Click.Selected or nil
    if not GPrefix.ClickLeft( Data ) then return end

    -- Renombrar la variable
    local NewButton = Data.Event.element
    local Tags = Data.Event.element.tags

    -- Validar botón
    if not( Tags and Tags.Enabled and Tags.Disabled and Tags.Technology ) then return end
    if not Tags.MOD and Tags.MOD ~= Data.GMOD.Prefix_MOD then return end
    if OldButton and OldButton == NewButton then return end

    -- Hacer el cambio
    Data.Click.Selected = NewButton
    for _, Button in pairs( { NewButton, OldButton } ) do
        GPrefix.ToggleButton( Button )
    end

    -- Mostrar la información
    ThisMOD.PrepareInformation( Data )
    ThisMOD.ShowInformation( Data )
    ThisMOD.ResizeElements( Data )
    ThisMOD.FocusButton( Data )
end

function ThisMOD.ToggleTechnologies( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validación básica
    if not GPrefix.ClickLeft( Data ) then return end

    -- Renombrar la variable
    local Button = Data.Event.element
    local ResearchedButton = Data.GUI.Main.ResearchedExpandButton
    local UnresearchedButton = Data.GUI.Main.UnresearchedExpandButton
    local ResearchedScrollPane = Data.GUI.Main.ResearchedScrollPane
    local UnresearchedScrollPane = Data.GUI.Main.UnresearchedScrollPane

    -- Validar botón
    local Flag = true
    Flag = Flag and Button ~= ResearchedButton
    Flag = Flag and Button ~= UnresearchedButton
    if Flag then return end

    ---> <---     ---> <---     ---> <---

    -- Limpiar el boton de las tecnologías investigadas
    ResearchedButton.tooltip = ""
    ResearchedButton.enabled = false
    ResearchedButton.sprite  = "utility/collapse_dark"

    -- Limpiar el boton de las tecnologías sin investigadas
    UnresearchedButton.tooltip = ""
    UnresearchedButton.enabled = false
    UnresearchedButton.sprite  = "utility/collapse_dark"

    -- Ocultar las tecnologías
    ResearchedScrollPane.visible = false
    UnresearchedScrollPane.visible = false

    -- Redicor el alto del contenedor
    ResearchedScrollPane.parent.style.vertically_stretchable = false
    UnresearchedScrollPane.parent.style.vertically_stretchable = false

    ---> <---     ---> <---     ---> <---

    -- Expandir las tecnologías investigadas
    if Button == ResearchedButton then
        UnresearchedButton.tooltip = { Data.GMOD.Local .. "expand-unresearched" }
        UnresearchedButton.enabled = true
        UnresearchedButton.sprite  = "utility/collapse"

        ResearchedScrollPane.visible = true
    end

    -- Expandir las tecnologías sin investigar
    if Button == UnresearchedButton then
        ResearchedButton.tooltip = { Data.GMOD.Local .. "expand-researched" }
        ResearchedButton.enabled = true
        ResearchedButton.sprite  = "utility/collapse"

        UnresearchedScrollPane.visible = true
    end
end

function ThisMOD.ToggleWindowStatus( Data )

    -- Renombrar la variable
    local Button = Data.Event.element

    -- Validar botón activado
    if not Button then return end
    if not Button.valid then return end

    -- Validar botón
    if Button ~= Data.GUI.Main.ToggleStatusWindowButton then return end

    -- Cambiar de estado el botón
    GPrefix.ToggleButton( Button )

    -- Destruir la ventana
    if Data.GUI.Status.WindowFrame then
        Data.GUI.Status.WindowFrame.destroy( )
        Data.GUI.Status = nil   return
    end

    -- Contruir la ventana
    ThisMOD.BuildWindowStatus( Data )
    ThisMOD.UpdateWindowStatus( Data )
end


function ThisMOD.SearchText( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Renombrar la variable
    local Textfield = Data.Event.element

    -- Validar caja de texto
    if Textfield ~= Data.GUI.Main.SearchTechnologyTextfield then return end

    -- Liberar el espacio
    Data.Search = nil
    Data.GPlayer.Search = nil

    ---> <---     ---> <---     ---> <---

    -- Separar el texto por los espacios
    local function Split( String )

        -- Inicializar las variables
        local Output = { }
        local Start = 0
        local Flag = false
        local End = 0

        -- Partir en partes el texto
        repeat
            Start = End + 1
            End = string.find( String, " ", Start )
            if not End then Flag = true end
            if not End then End = string.len( String ) + 1 end
            table.insert( Output, string.sub( String, Start, End - 1 ) )
            print( string.sub( String, Start, End - 1 ) )
        until Flag

        -- Devolver las partes
        return Output
    end

    -- Seleccionar la tecnología por defecto
    local function RestaureClick( )

        -- Restaurar el botón seleccionado
        if GPrefix.isString( Data.Click.Selected ) then
            local Technology = Data.Click.Selected
            table.insert( Data.Temporal, { Technology = Technology } )
            Data.Event.element = ThisMOD.getButton( Data )
            Data.Click.Selected = nil
        end

        -- Restaurar el botón cliqueado
        if GPrefix.isString( Data.Click.Element ) then
            local Technology = Data.Click.Element
            table.insert( Data.Temporal, { Technology = Technology } )
            Data.Click.Element = ThisMOD.getButton( Data )
            local Tags = Data.Click.Element
            if Tags.Technology ~= Technology then
                Data.Click.Element = nil
                Data.Click.Tick = nil
            end
        end

        -- Mostrar la información de la tecnología seleccionada
        Data.Event.button = defines.mouse_button_type.left
        ThisMOD.ToggleTechnology( Data )
    end

    -- Buscar el texto en las tecnologias enlistadas
    local function FindText( )
        local function FindTextAndSave( Up )

            -- Cargar la traducción
            if GPrefix.isString( Up.JSON ) then Up.JSON = { Up.JSON } end
            Up.JSON = game.table_to_json( Up.JSON )
            local Localised = string.lower( Data.Language[ Up.JSON ] or "" )
            Localised = string.gsub( Localised, "__%d__", " " )
            Localised = string.trim( Localised )

            -- Buscar el texto en la traducción
            local Found = string.find( Localised, Up.Text, 1, true )

            -- Se encontró el texto en la traducción
            if Found and not GPrefix.getKey( Up.Result, Up.TechnologyName ) then
                table.insert( Up.Result, Up.TechnologyName )
            end
        end

        -- Cargar espacio de respuesta
        local Up = Data.Temporal[ #Data.Temporal ]
        Up.List = { }

        -- Identificar la sección en la cual buscar
        local Queue = Up.Flow == Data.GUI.Main.QueueFlow
        local Researched = Up.Flow == Data.GUI.Main.ResearchedFlow
        local Unresearched = Up.Flow == Data.GUI.Main.UnresearchedFlow

        ---> <---     ---> <---     ---> <---

        -- Buscar en la cola
        if Queue then
            for _, TechnologyName in pairs( Data.Queue ) do
                table.insert( Up.List, TechnologyName )
            end
        end

        -- Buscar en las tecnologías investigadas y sin investigar
        if Unresearched or Researched then
            for _, Value in pairs( Up.Flow.children ) do
                if #Value.children > 1 then
                    Value = Value.children[ 2 ]
                    for _, Technology in pairs( Value.children ) do
                        if Technology.type == "choose-elem-button" then
                            table.insert( Up.List, Technology.tags.Technology )
                        end
                    end
                end
            end
        end

        ---> <---     ---> <---     ---> <---

        -- Buscar en las tecnologías enlistada
        for _, TechnologyName in pairs( Up.List ) do

            -- Identificar la tecnología
            local Technology = Data.Technologies.All[ TechnologyName ]
            Up.TechnologyName = TechnologyName
            Up.JSON = Technology.Localised
            FindTextAndSave( Up )

            -- Buscar en los effectos
            for _, Effect in pairs( Technology.Effects ) do
                Up.TechnologyName = TechnologyName
                Up.JSON = Effect.Localised
                FindTextAndSave( Up )
            end
        end

        ---> <---     ---> <---     ---> <---

        -- No se encontro resultado alguno
        if #Up.Result < 1 then return end

        -- Guardar el resultado
        if Queue then Data.Search.Queue = Up.Result end

        -- Guardar el resultado
        if Unresearched or Researched then   local List = { }
            if Researched then List = Data.Search.Researched end
            if Unresearched then List = Data.Search.Unresearched end
            for Level, Technologies in pairs( Data.Technologies.Levels ) do
                for _, Technology in pairs( Technologies ) do
                    local Flag = not GPrefix.getKey( List[ Level ] or { }, Technology )
                    Flag = Flag and GPrefix.isNumber( GPrefix.getKey( Up.Result, Technology.Name ) )
                    if Flag then List[ Level ] = List[ Level ] or { }
                        table.insert( List[ Level ], Technology )
                    end
                end
            end
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Guardar la tecnolgia seleccionada
    local Flag = not GPrefix.isString( Data.Click.Selected )
    if Data.Click and Data.Click.Selected and Flag then
        Data.Click.Selected = Data.Click.Selected.tags.Technology
    end

    -- Guardar la tecnolgia cliqueada
    Flag = not GPrefix.isString( Data.Click.Element )
    if Data.Click and Data.Click.Element and Flag then
        Data.Click.Element = Data.Click.Element.tags.Technology
    end

    -- Cargar los valores por defecto
    ThisMOD.ShowQueue( Data )
    ThisMOD.ShowTechnologiesResearched( Data )
    ThisMOD.ShowTechnologiesUnresearched( Data )

    -- Restaurar los valores iniciales
    local TextToFind = string.trim( Textfield.text )
    TextToFind = string.lower( TextToFind )
    if TextToFind == "" then RestaureClick( ) return end

    ---> <---     ---> <---     ---> <---

    -- Inicializar las variables
    local Here = { }
    table.insert( Data.Temporal, Here )

    local Array = { }
    Array.Flows = { }
    table.insert( Array.Flows, Data.GUI.Main.QueueFlow )
    table.insert( Array.Flows, Data.GUI.Main.ResearchedFlow )
    table.insert( Array.Flows, Data.GUI.Main.UnresearchedFlow )

    Data.Search = { }
    Data.Search.Text = TextToFind
    Data.Search.Queue = { }
    Data.Search.Researched = { }
    Data.Search.Unresearched = { }
    Data.GPlayer.Search = Data.Search

    -- Buscar las palabra completa
    Array.Text = { TextToFind }
    for _, Flow in pairs( Array.Flows ) do   Here.Result = { }
        for _, Text in pairs( Array.Text ) do
            Here.Text = Text   Here.Flow = Flow   FindText( )
        end
    end

    -- Validar si se encontró algo
    local Divisible = string.find( TextToFind, " " )
    local InQueue = GPrefix.getLength( Data.Search.Queue ) > 0 and true or false
    local InReached = GPrefix.getLength( Data.Search.Researched ) > 0 and true or false
    local InUnreached =  GPrefix.getLength( Data.Search.Unresearched ) > 0 and true or false
    if InQueue or InReached or InUnreached then goto JumpSearch end

    -- El texto es indivisible
    if not Divisible then RestaureClick( ) return end

    -- Buscar las palabra por partes
    Array.Text = Split( TextToFind )
    for _, Flow in pairs( Array.Flows ) do   Here.Result = { }
        for _, Text in pairs( Array.Text ) do
            Here.Text = Text   Here.Flow = Flow   FindText( )
        end
    end

    -- Validar si se encontró algo
    InQueue = GPrefix.getLength( Data.Search.Queue ) > 0 and true or false
    InReached = GPrefix.getLength( Data.Search.Researched ) > 0 and true or false
    InUnreached =  GPrefix.getLength( Data.Search.Unresearched ) > 0 and true or false
    if InQueue or InReached or InUnreached then goto JumpSearch end

    -- Sin coincidencias
    Data.Search = nil   Data.GPlayer.Search = nil

    -- Recepción del salto
    :: JumpSearch ::

    -- Cargar los valores resultantes
    ThisMOD.ShowQueue( Data )
    ThisMOD.ShowTechnologiesResearched( Data )
    ThisMOD.ShowTechnologiesUnresearched( Data )
    RestaureClick( )
end

function ThisMOD.AddResearch( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validar el double clic
    if not GPrefix.ClickDouble( Data ) then return end

    -- Renombrar la variable
    local Tags = Data.Event.element.tags

    -- Validar botón
    if not( Tags and Tags.MOD and Tags.Location ) then return end
    if Tags.MOD ~= Data.GMOD.Prefix_MOD then return end
    if Tags.Location ~= Data.GUI.Main.UnresearchedFlow.name then return end

    ---> <---     ---> <---     ---> <---

    -- Agregar tecnología a la cola
    local Count = ThisMOD.AddTechnologyAndPrerequisites( Data, Tags.Technology )

    -- Acutalizar la información en pantalla
    ThisMOD.UpdateQueueAndTechnologies( Data )

    ---> <---     ---> <---     ---> <---

    -- Informar del cambio
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Technology = Tags.Technology
    Here.Action = "added"
    Here.Color = "green"
    Here.Count = Count
    Here.Level = Tags.Level
    ThisMOD.PrintEventQueue( Data )

    -- Validar la tecnología en investigación
    ThisMOD.UpdateReseach( Data )
end

function ThisMOD.CancelResearch( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validar el clic derecho
    if not GPrefix.ClickRight( Data ) then return end

    -- Renombrar la variable
    local Tags = Data.Event.element.tags

    -- Validar botón
    if not( Tags and Tags.MOD and Tags.Location ) then return end
    if Tags.MOD ~= Data.GMOD.Prefix_MOD then return end
    if Tags.Location ~= Data.GUI.Main.QueueFlow.name then return end

    ---> <---     ---> <---     ---> <---

    -- Remover tecnología de la cola
    local Count = ThisMOD.RemoveTechnologyAndDependence( Data, Tags.Technology )

    -- Acutalizar la información en pantalla
    ThisMOD.UpdateQueueAndTechnologies( Data )

    ---> <---     ---> <---     ---> <---

    -- Informar del cambio
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Technology = Tags.Technology
    Here.Action = "removed"
    Here.Color = "red"
    Here.Count = Count
    Here.Level = Tags.Level
    ThisMOD.PrintEventQueue( Data )

    -- Validar la tecnología en investigación
    ThisMOD.UpdateReseach( Data )
end

function ThisMOD.PrioritizeResearch( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validar el double clic
    if not GPrefix.ClickDouble( Data ) then return end

    -- Renombrar la variable
    local Tags = Data.Event.element.tags

    -- Validar botón
    if not( Tags and Tags.MOD and Tags.Location ) then return end
    if Tags.MOD ~= Data.GMOD.Prefix_MOD then return end
    if Tags.Location ~= Data.GUI.Main.QueueFlow.name then return end

    ---> <---     ---> <---     ---> <---

    -- Priorizar tecnología de la cola
    local Count = ThisMOD.PrioritizeTechnologyAndPrerequisites( Data, Tags.Technology )
    if not Count then return end

    -- Acutalizar la información en pantalla
    ThisMOD.UpdateQueueAndTechnologies( Data )

    ---> <---     ---> <---     ---> <---

    -- Informar del cambio
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Technology = Tags.Technology
    Here.Action = "prioritized"
    Here.Color = "yellow"
    Here.Count = Count
    Here.Level = Tags.Level
    ThisMOD.PrintEventQueue( Data )

    -- Validar la tecnología en investigación
    ThisMOD.UpdateReseach( Data )
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Funciones de soporte

function ThisMOD.CreateData( Event )
    local Data = GPrefix.CreateData( Event, ThisMOD )

    -- Validar que existan las tecnologías
    local Length = GPrefix.getLength( Data.Force.technologies )
    if not( Length and Length > 0 ) then goto JumpTechnology end

    -- Crear el acceso rápido a la cola
    if Data.gForce.Queue then Data.Queue = Data.gForce.Queue end

    -- Crear el acceso rápido a las tecnologías existentes
    if Data.GMOD.Technologies then
        local Table = { }
        Table.All = Data.GMOD.Technologies.All
        Table.Levels = Data.GMOD.Technologies.Levels
        Data.Technologies = Table
    end

    -- Crear el acceso rápido a las tecnologías investigadas
    if Data.Technologies and Data.GForce.Researched then
        Data.Technologies.Researched = Data.GForce.Researched
    end

    -- Recepción del salto
    :: JumpTechnology ::

    -- Crear el acceso rápido a los valores de busqueda
    if Data.GPlayer and Data.GPlayer.Search then
        Data.Search = Data.GPlayer.Search
    end

    -- Crear el espacio para guardar la interfaz
    if Data.GUI then
        Data.GUI.Main = Data.GUI.Main or { }
        Data.GUI.Status = Data.GUI.Status or { }
    end

    -- Devolver la información
    return Data
end


function ThisMOD.FormatTime( Data )

    -- Validar el valor
    local Seconds = math.ceil( tonumber( Data ) or 0 )

    -- Inicializar las variables
    local Time = { }
    local Times = { { 24, "d" }, { 60, "h" }, { 60, "m" }, { 1, "s" } }

    -- Dividie el tiempo en sus unidades
    for i = 1, #Times, 1 do
        local Total = 1

        for j = i, #Times, 1 do
            Total = Total * Times[ j ][ 1 ]
        end

        local Value = math.floor( Seconds / Total )
        if Value > 0 or #Time > 0 or i == #Times then   Seconds = Seconds % Total
            table.insert( Time, { value = Value, unit = Times[ i ][ 2 ] } )
        end
    end

    -- Agregar los ceros
    for i = 1, #Time, 1 do
        local Caption = ""
        if i > 1 and Time[ i ].value < 10 then Caption = "0" end
        Time[ i ].value = Caption .. Time[ i ].value
    end

    return Time
end

function ThisMOD.FormatFormula( Formula )

    -- Validación básica
    if not GPrefix.isString( Formula ) then return end

    -- Esterilizar la ecuación
    Formula = "(" .. Formula .. ")"
    Formula = string.gsub( string.upper( Formula ), " ", "" )

    -- Iniciar las variables
    local Signs = { "-", "+", "*", "/", "^", "(", ")", "L" }
    local Number = 0
    local Exponent = 0
    local Ecuacion = { }

    -- Invertir valores e indices
    while Signs[ 1 ] do
        local Symbol = Signs[ 1 ]
        Signs[ Symbol ] = true
        table.remove( Signs, 1 )
    end

    -- Recorrer la ecuación simbolo a simbolo
    for Symbol, _ in string.gmatch( Formula, "." ) do

        -- Idicador para cargar un decimal
        if Symbol == "." then Exponent = -1 end

        -- Cargar un simbolo
        if Signs[ Symbol ] then

            -- Hay un número antes
            if Number ~= 0 then
                table.insert( Ecuacion, Number )
                Exponent = 0
                Number = 0
            end

            -- Agregar el simbolo a la ecución
            table.insert( Ecuacion, Symbol )
        end

        -- Cargar un numero
        if tonumber( Symbol ) then

            -- Cargar un entero
            if Exponent == 0 or Exponent == 1 then
                Number = 10 ^ Exponent * Number + tonumber( Symbol )
                if Exponent == 0 then Exponent = Exponent + 1 end
            end

            -- Cargar un decimal
            if Exponent < 0 then
                Number = Number + 10 ^ Exponent * tonumber( Symbol )
                Exponent = Exponent - 1
            end
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Buscar las multiplicaciones implicitas
    local Add = { }
    local Flag = true
    for i = 2, #Ecuacion, 1 do

        -- Caso: )(
        Flag = true and Ecuacion[ i ] == "("
        Flag = Flag and Ecuacion[ i - 1 ] == ")"
        if Flag then table.insert( Add, i ) end

        -- Caso: 100( or L(
        Flag = true and Ecuacion[ i ] == "("
        Flag = Flag and ( GPrefix.isNumber( Ecuacion[ i - 1 ] ) or Ecuacion[ i - 1 ] == "L" )
        if Flag then table.insert( Add, i ) end

        -- Caso: )100 or )L
        Flag = true and ( GPrefix.isNumber( Ecuacion[ i ] ) or Ecuacion[ i ] == "L" )
        Flag = Flag and Ecuacion[ i - 1 ] == ")"
        if Flag then table.insert( Add, i ) end
    end

    -- Agregar el simbolo de multiplicación
    for i = #Add, 1, -1 do table.insert( Ecuacion, Add[ i ], "*" ) end

    ---> <---     ---> <---     ---> <---

    -- Devolver la información
    return Ecuacion
end

function ThisMOD.EvaluateFormula( Formula, Level )
    local function Operate( Value1, Operator, Value2 )
        if Operator == "-" then return Value1 - Value2 end
        if Operator == "+" then return Value1 + Value2 end
        if Operator == "*" then return Value1 * Value2 end
        if Operator == "/" then return Value1 / Value2 end
        if Operator == "^" then return Value1 ^ Value2 end
    end

    -- Duplicar la formula
    Formula = GPrefix.DeepCopy( Formula )

    -- Remplazar el indicador por el nivel
    for Key, Value in pairs( Formula ) do
        if Value == "L" then
            Formula[ Key ] = Level
        end
    end

    -- Inicializar la variable
    local Index = 0

    -- Recorrer la formula
    while #Formula > 3 do

        -- Inicializar la variable
        Index = Index + 1
        local Section = { }

        -- Sección a calcular
        if Formula[ Index ] == ")" then
            table.remove( Formula, Index )
            Index = Index - 1
            while Formula[ Index ] ~= "(" do
                table.insert( Section, 1, Formula[ Index ] )
                table.remove( Formula, Index )
                Index = Index - 1
            end
        end

        -- Hcar el calculo de la sección
        while #Section > 2 do   local _Index = 0

            -- La operación ha sido identificada
            if _Index > 0 then goto JumpOperador end

            -- Buscar la opreación
            for i = #Section, 2, -1 do
                if Section[ i ] == "^" then
                    _Index = i   break
                end
            end

            ---> <---     ---> <---     ---> <---

            -- La operación ha sido identificada
            if _Index > 0 then goto JumpOperador end

            -- Buscar la opreación
            for i = 2, #Section, 2 do
                if Section[ i ] == "/" then
                    _Index = i   break
                elseif Section[ i ] == "*" then
                    _Index = i   break
                end
            end

            ---> <---     ---> <---     ---> <---

            -- La operación ha sido identificada
            if _Index > 0 then goto JumpOperador end

            -- Buscar la opreación
            for i = 2, #Section, 2 do
                if Section[ i ] == "+" then
                    _Index = i   break
                elseif Section[ i ] == "-" then
                    _Index = i   break
                end
            end

            ---> <---     ---> <---     ---> <---

            -- Ecuación invalida
            if _Index < 1 then return end

            -- Recepción del salto
            :: JumpOperador ::

            -- Realizar la operación
            local Value2   = table.remove( Section, _Index + 1 )
            local Operator = table.remove( Section, _Index + 0 )
            local Value1   = table.remove( Section, _Index - 1 )
            local Result   = Operate( Value1, Operator, Value2 )
            table.insert( Section, _Index - 1, Result )
        end

        -- Asignar el resultado a la ubicación correspondiente
        if #Section > 0 then Formula[ Index ] = Section[ 1 ] end
    end

    -- Devolver el resultado
    return Formula[ 1 ]
end


function ThisMOD.FillTable( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Rellenar los espacios
    while true do
        local Children = #Up.Table.children % Up.Table.column_count
        if #Up.Table.children > 0 and Children < 1 then break end
        local EmptyWidget = { }
        EmptyWidget.type = "empty-widget"
        EmptyWidget = Up.Table.add( EmptyWidget )
        EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
        EmptyWidget.style.size = Up.Size
    end
end

function ThisMOD.getButton( Data )
    local function getButtonTechnology( )

        -- Cargar espacio de respuesta
        local Up = Data.Temporal[ #Data.Temporal ]

        -- Buscar la tecnlogía en la lista de tecnologías
        for _, Level in pairs( Up.Flow.children ) do
            if #Level.children > 0 then
                for _, Button in pairs( Level.children[ 2 ].children ) do
                    local Flag = true
                    if Up.Technology.Level then
                        Flag = Up.Technology.Level == Button.tags.Level
                    end Flag = Flag and Up.Technology.Name == Button.tags.Technology
                    if Flag then Up.Result = Button return Button end
                end
            end
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]
    Up.Result = nil

    -- Validando formato de entrada
    if GPrefix.isString( Up.Technology ) then
        local LuaTechnologyName = Up.Technology
        Up.Technology = { }
        Up.Technology.Name = LuaTechnologyName
    end

    ---> <---     ---> <---     ---> <---

    -- Devolver el botón de la cola
    if GPrefix.getKey( Data.Queue, Up.Technology.Name ) then
        Up.Flow = Data.GUI.Main.QueueFlow
        for _, Button in pairs( Up.Flow.children ) do
            local Flag = true
            if Up.Technology.Level then
                Flag = Up.Technology.Level == Button.tags.Level
            end Flag = Flag and Up.Technology.Name == Button.tags.Technology
            if Flag then Up.Result = Button return Button end
        end
    end

    -- Devolver el botón de la tecnología investigada
    if Data.Technologies.Researched[ Up.Technology.Name ] then
        Up.Flow = Data.GUI.Main.ResearchedFlow
        if getButtonTechnology( ) then
            return Up.Result
        end
    end

    -- Devolver el botón de la tecnología sin investigar
    if Data.Technologies.All[ Up.Technology.Name ] then
        Up.Flow = Data.GUI.Main.UnresearchedFlow
        if getButtonTechnology( ) then
            return Up.Result
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Seleccionar la primera tecnología de la cola
    if #Data.GUI.Main.QueueFlow.children > 0 then
        return Data.GUI.Main.QueueFlow.children[ 1 ]
    end

    -- Seleccionar la primera tecnología sin investigar
    if #Data.GUI.Main.UnresearchedFlow.children > 0 then
        local Technology = Data.GUI.Main.UnresearchedFlow.children[ 1 ]
        Technology = Technology.children[ 2 ].children[ 1 ]
        return Technology
    end

    -- Seleccionar la primera tecnología investigadas
    if #Data.GUI.Main.ResearchedFlow.children > 0 then
        local Technology = Data.GUI.Main.ResearchedFlow.children[ 1 ]
        Technology = Technology.children[ 2 ].children[ 1 ]
        return Technology
    end
end

function ThisMOD.ClearScreen( Data )

    -- Recorrer el los jugadores
    for _, Player in pairs( game.players ) do

        -- Consolidado de datos
        local PlayerData = ThisMOD.CreateData( { Player = Player } )

        -- Cerrar la ventana principal
        if PlayerData.GUI.Main and PlayerData.GUI.Main.WindowFrame then
            PlayerData.Event = { }
            PlayerData.Event.input_name = PlayerData.GMOD.Prefix_MOD
            ThisMOD.ToggleWindowMain( PlayerData )
        end

        -- Descativar el MOD
        if PlayerData.gForce.Status then PlayerData.gForce.Status = nil end

        -- Cerrar la ventana de estado
        if PlayerData.GUI.Status and PlayerData.GUI.Status.WindowFrame then
            PlayerData.GUI.Status.WindowFrame.destroy( )
            PlayerData.GUI.Status = nil
        end
    end
end

function ThisMOD.ShowTimeStatus( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    ---> <---     ---> <---     ---> <---

    -- Inicializar las variables
    local Tooltip = { "" }
    local Part = ""

    -- No hay un tooltip
    if not Up.Factor then goto JumpTooltip end

    Part = ""
    Part = Part .. "[font=default-bold]"
    Part = Part .. "[color=254,222,169]"
    table.insert( Tooltip, Part )

    Part = { Data.GMOD.Local .. "factor"}
    table.insert( Tooltip, Part )

    Part = ""
    Part = Part .. ":[/color] "
    Part = Part .. "[color=123,201,98]" .. ( Up.Factor or 100 ) .. "[/color]"
    Part = Part .. "[color=254,222,169]%[/color]"
    Part = Part .. "[/font]"
    table.insert( Tooltip, Part )

    -- Recepción del salto
    :: JumpTooltip ::

    ---> <---     ---> <---     ---> <---

    -- Tiempo en pantalla
    Up.Frame.clear( )
    for _, Time in pairs( ThisMOD.FormatTime( Up.Time ) ) do

        -- Contenedot del tiempo
        local TimeFlow = { }
        TimeFlow.type = "flow"
        TimeFlow.direction = "horizontal"
        TimeFlow.tooltip = Tooltip
        TimeFlow = Up.Frame.add( TimeFlow )
        TimeFlow.style.horizontal_spacing = 0

        -- Valor del tiempo
        local TiempoValue = { }
        TiempoValue.type = "label"
        TiempoValue.caption = Time.value
        TiempoValue.tooltip = Tooltip
        TiempoValue = TimeFlow.add( TiempoValue )
        TiempoValue.style = "achievement_unlocked_title_label"
        TiempoValue.style.padding = 0
        TiempoValue.style.margin = 0

        -- Etiqueta del tiempo
        local TiempoLabel = { }
        TiempoLabel.type = "label"
        TiempoLabel.caption = Time.unit
        TiempoLabel.tooltip = Tooltip
        TiempoLabel = TimeFlow.add( TiempoLabel )
        TiempoLabel.style = "caption_label"
        TiempoLabel.style.padding = 0
        TiempoLabel.style.margin = 0
    end
end

function ThisMOD.PrintEventQueue( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Identificar la tecnología
    local Technology = Data.Technologies.All[ Up.Technology ]

    ---> <---     ---> <---     ---> <---

    -- Mensaje para una tecnología
    local Location = { "",
        "[color=default]",
        { Data.GMOD.Local .. "setting-name" },
        ": [/color]",
        {
            Data.GMOD.Local .. "action-" .. Up.Action,
            {
                "",
                "[img=utility/character_mining_speed_modifier_icon][color=" ..
                Data.Player.color.r .. "," ..
                Data.Player.color.g .. "," ..
                Data.Player.color.b .. "]",
                Data.Player.name,
                "[/color]"
            },
            {
                "",
                "[color=" .. Up.Color .. "]",
                { Data.GMOD.Local .. Up.Action },
                "[/color]"
            },
            {
                "",
                "[img=technology/" .. Technology.Name .. "][color=" .. Up.Color .. "]",
                Technology.Localised_name,
                Technology.Infinite and " " .. Up.Level or nil,
                "[/color]"
            },
        }
    }

    -- Mensaje para varias tecnologías
    if Up.Count > 0 then
        table.insert( Location, {
            Data.GMOD.Local .. "and-other",
            "[color=" .. Up.Color .. "]" .. Up.Count .. "[/color]",
            Up.Count
        } )
    end

    -- Informar del cambio
    Data.Force.print( Location )
end

function ThisMOD.CreateTechButton( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]
    local Technology = Data.Technologies.All[ Up.Technology ]

    -- Paramatros de selección
    local Tags = { }
    Tags.Size = 64
    Tags.Location = Up.Location
    Tags.MOD = Data.GMOD.Prefix_MOD
    Tags.Enabled = "omitted_technology_slot"
    Tags.Disabled = "image_tab_selected_slot"
    Tags.Technology = Up.Technology

    -- Identificar los casos especiales
    local Flag = Technology.Infinite and Data.GUI.Main.UnresearchedFlow and Up.Location == Data.GUI.Main.UnresearchedFlow.name
    Flag = Flag or ( Technology.Infinite and Data.GUI.Main.QueueFlow and Up.Location == Data.GUI.Main.QueueFlow.name )
    if Flag then Tags.Level = 0
        for _, Button in pairs( Data.GUI.Main.QueueFlow.children ) do
            if Button.tags.Technology == Up.Technology then
                Tags.Level = Tags.Level + 1
            end
        end
        Tags.Level = Technology.Level + Tags.Level
    end

    -- Propiedades del botón
    local Picture = { }
    Picture.tags = Tags
    Picture.type = "choose-elem-button"
    Picture.elem_type = "technology"
    Picture = Up.Flow.add( Picture )
    Picture.locked = true
    Picture.style = Tags.Enabled
    Picture.style.size = Tags.Size
    Picture.elem_value = Up.Technology
    Picture.style.margin = 0
    Picture.style.padding = 0
end



-- Mostrar la información de la tecnología selecionada

function ThisMOD.PrepareInformation( Data )

    -- Inicializar las variables
    local Info = { }
    local Accumulated = { }
    Data.Information = Info

    -- Cargar la tecnología
    Info.Technology = Data.Event.element.tags.Technology
    Info.Technology = Data.Technologies.All[ Info.Technology ]

    -- Asiganar el costo para el nivel
    if Info.Technology.Infinite then
        local Level = Data.Event.element.tags.Level
        Info.Technology.Amount = ThisMOD.EvaluateFormula( Info.Technology.Formula, Level )
        Info.Technology.Cost = Info.Technology.Time * Info.Technology.Amount
    end

    -- Cargar los prerquisitos
    Info.Queue = { }
    for _, Technology in pairs( Info.Technology.Prerequisites ) do
        table.insert( Info.Queue, Technology )
    end table.insert( Info.Queue, Info.Technology )

    -- Colocal el nivel a las tecnologías infinitas
    Info.Name = Info.Technology.Localised_name or { "technology-name." .. Data.Technology.Name }
    if Info.Technology.Infinite then
        local Level = Data.Event.element.tags.Level
        if Info.Name[ 1 ] == "" then table.insert( Info.Name, " " .. Level ) end
        if Info.Name[ 1 ] ~= "" then Info.Name = { "", Info.Name, " " .. Level } end
    end

    ---> <---     ---> <---     ---> <---

    -- Calcular el factor de investigación en tiempo
    Info.Factor = { }
    Data.gForce.Factor = Data.gForce.Factor or 1
    Info.Factor.Porcentage = math.floor( Data.gForce.Factor * 100 )

    ---> <---     ---> <---     ---> <---

    -- Costo de la tecnología individual
    Info.Researched = Data.Technologies.Researched
    Info.Researched = Info.Researched[ Info.Technology.Name ]
    Info.Technology.Calculated = Info.Technology.Cost / Data.gForce.Factor
    Info.Technology.Calculated = math.ceil( Info.Technology.Calculated )

    ---> <---     ---> <---     ---> <---

    -- Calcular el timepo acomulado
    Info.Accumulated = Info.Accumulated or { }
    Info.Accumulated.Cost = { }
    Info.Accumulated.Cost.Total = 0
    Info.Accumulated.Cost.Researched = 0
    Info.Accumulated.Cost.Unresearched = 0

    Accumulated = Info.Accumulated.Cost
    for _, Technology in pairs( Info.Queue ) do
        Accumulated.Total = Accumulated.Total + Technology.Cost
        local Researched = Data.Technologies.Researched[ Technology.Name ]
        if Researched then Accumulated.Researched = Accumulated.Researched + Technology.Cost end
        if not Researched then Accumulated.Unresearched = Accumulated.Unresearched + Technology.Cost end
    end

    Info.Accumulated.Cost.Remaining = Info.Accumulated.Cost.Unresearched / Data.gForce.Factor
    Info.Accumulated.Cost.Remaining = math.ceil( Info.Accumulated.Cost.Remaining )

    -- Agragar ingredientes a la lista
    local function AddIngredient( Table, Ingredient, Amount )
        local Unit = Table[ Ingredient ]
        if Unit then Unit.amount = Unit.amount + Amount end
        if not Unit then
            Unit = { }
            Unit.name = Ingredient
            Unit.amount = Amount
            Table[ Unit.name ] = Unit
        end
    end

    -- Cargar los ingredientes
    Info.Accumulated = Info.Accumulated or { }
    Info.Accumulated.Ingredients = { }
    Info.Accumulated.Ingredients.Total = { }
    Info.Accumulated.Ingredients.Researched = { }
    Info.Accumulated.Ingredients.Unresearched = { }

    Accumulated = Info.Accumulated.Ingredients
    for _, Technology in pairs( Info.Queue ) do
        local Amount = Technology.Amount
        for _, Ingredient in pairs( Technology.Ingredients ) do
            AddIngredient( Accumulated.Total, Ingredient, Amount )
            local Researched = Data.Technologies.Researched[ Technology.Name ]
            if Researched then AddIngredient( Accumulated.Researched, Ingredient, Amount ) end
            if not Researched then AddIngredient( Accumulated.Unresearched, Ingredient, Amount ) end
        end
    end

    -- Cargar las tecnologías previas
    Info.Accumulated = Info.Accumulated or { }
    Info.Accumulated.Prerequisites = { }

    Accumulated = Info.Accumulated.Prerequisites
    for _, Technology in pairs( Info.Technology.Prerequisites ) do
        table.insert( Accumulated, Technology.Name )
    end
end

function ThisMOD.ShowInformation( Data )

    -- Inicializar las variables
    local Info = Data.Information
    local Here = { }

    ---> <---     ---> <---     ---> <---

    -- Cargar el Costo, el Nombre y la Imagen de la tecnología
    Data.GUI.Main.SingleCostLabel.caption = Info.Technology.Amount
    Data.GUI.Main.DetailTitleLabel.caption = Info.Name
    Data.GUI.Main.SinglePictureSprite.sprite = "technology/" .. Info.Technology.Name

    ---> <---     ---> <---     ---> <---

    -- Cargar los ingredientes individuales
    Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Data.GUI.Main.SingleIngredientsTable
    Here.Technology = Info.Technology
    ThisMOD.ShowCostSingle( Data )

    -- Tiempo individual
    Here = { }
    table.insert( Data.Temporal, Here )
    Here.Frame = Data.GUI.Main.SingleTimeFrame
    Here.Default = Info.Technology.Cost
    Here.Calculated = Info.Technology.Calculated
    Here.Porcentage = Info.Factor.Porcentage
    ThisMOD.FrameTimeSingle( Data )

    -- Cargar los efectos
    Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Data.GUI.Main.SingleEffectsTable
    Here.Technology = Info.Technology
    ThisMOD.ShowEffects( Data )

    ---> <---     ---> <---     ---> <---

    -- Mostrar los ingredientes acomulados
    Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Data.GUI.Main.AccumulatedIngredientsTable
    Here.Total = Info.Accumulated.Ingredients.Total
    Here.Researched = Info.Accumulated.Ingredients.Researched
    Here.Unresearched = Info.Accumulated.Ingredients.Unresearched
    ThisMOD.ShowCostAccumulated( Data )

    -- Tiempo acomulado
    Here = { }
    table.insert( Data.Temporal, Here )
    Here.Frame = Data.GUI.Main.AccumulatedTimeFrame
    Here.Total = Info.Accumulated.Cost.Total
    Here.Factor = Info.Factor.Porcentage
    Here.Remaining = Info.Accumulated.Cost.Remaining
    Here.Porcentage = Info.Factor.Porcentage
    Here.Researched = Info.Accumulated.Cost.Researched
    Here.Unresearched = Info.Accumulated.Cost.Unresearched
    ThisMOD.FrameTimeAccumulated( Data )

    -- Mostrar los prerequisitos
    Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Data.GUI.Main.AccumulatedPrerequisitesTable
    Here.Prerequisites = Info.Accumulated.Prerequisites
    ThisMOD.ShowPrerequisites( Data )
end

function ThisMOD.ResizeElements( Data )

    -- Valores para los calculos
    local HeightScrollPane = 173 -- Alto del ScrollPane inicial
    local HeightTitle = 24 -- Altura de los titulos
    local HeightFrame = 8 -- Espacio entre los ScrollPane y los Frame
    local HeightLine = 35 -- Alto del ScrollPane que se le suma al valir inicial
    local Height = 0 -- Contenedor temporal del alto

    -- Altura de los ScrollPane importates
    local HeightOneLine = 41 -- Alto del ScrollPane con una linea
    local HeightMoreLine = 76 -- Alto del ScrollPane con varias lineas



    -- Ajuntar el alto de ser necerario
    local Elements = { }
    local Element  = { }

    Element = { }
    Element.Table = Data.GUI.Main.SingleEffectsTable
    Element.ScrollPane = Data.GUI.Main.SingleEffectsScrollPane
    table.insert( Elements, Element)

    Element = { }
    Element.Table = Data.GUI.Main.SingleIngredientsTable
    Element.ScrollPane = Data.GUI.Main.SingleIngredientsScrollPane
    table.insert( Elements, Element)

    Element = { }
    Element.Table = Data.GUI.Main.AccumulatedIngredientsTable
    Element.ScrollPane = Data.GUI.Main.AccumulatedIngredientsScrollPane
    table.insert( Elements, Element)

    Element = { }
    Element.Table = Data.GUI.Main.AccumulatedPrerequisitesTable
    Element.ScrollPane = Data.GUI.Main.AccumulatedPrerequisitesScrollPane
    table.insert( Elements, Element)

    for i = 1, #Elements, 1 do   Element = Elements[ i ]
        local Line = #Element.Table.children > Element.Table.column_count
        Element.ScrollPane.style.height = Line and HeightMoreLine or HeightOneLine
    end



    -- Calcular el alto de la sección
    local HeightSingle = HeightScrollPane
    local TableSingle = Data.GUI.Main.SingleEffectsTable
    if #TableSingle.children > TableSingle.column_count then
        HeightSingle = HeightSingle + HeightLine
    end

    TableSingle = Data.GUI.Main.SingleIngredientsTable
    if #TableSingle.children > TableSingle.column_count then
        HeightSingle = HeightSingle + HeightLine
    end

    -- Ajustar el alto de la sección individual
    Data.GUI.Main.SingleDetailScrollPane.style.height = HeightSingle
    Data.GUI.Main.SingleSectionFlow.style.height = HeightTitle + HeightFrame + HeightSingle
    Data.GUI.Main.SingleBodyFlow.style.height = HeightFrame + HeightSingle



    -- Calcular el alto de la sección
    local HeightAccumulated = HeightScrollPane
    local TableAccumulated = Data.GUI.Main.AccumulatedIngredientsTable
    if #TableAccumulated.children > TableAccumulated.column_count then
        HeightAccumulated = HeightAccumulated + HeightLine
    end

    TableAccumulated = Data.GUI.Main.AccumulatedPrerequisitesTable
    if #TableAccumulated.children > TableAccumulated.column_count then
        HeightAccumulated = HeightAccumulated + HeightLine
    end

    -- Ajustar el alto de la sección
    Data.GUI.Main.AccumulatedDetailScrollPane.style.height = HeightAccumulated
    Data.GUI.Main.AccumulatedSectionFlow.style.height = HeightTitle + HeightFrame + HeightAccumulated



    -- Calcular el alto de las secciones
    Height = 0
    Height = Height + HeightSingle
    Height = Height + HeightFrame
    Height = Height + HeightTitle
    Height = Height + HeightAccumulated
    Data.GUI.Main.QueueFlow.parent.style.height = Height
    Data.GUI.Main.SingleSectionFlow.parent.style.height = Height + HeightFrame * 4
    Data.GUI.Main.UnresearchedScrollPane.parent.parent.style.height = Height



    -- Calcular el alto del cuerpo de las technologías
    HeightTitle = 34
    Height = Height - ( HeightTitle * 2 )
    Data.GUI.Main.ResearchedScrollPane.style.height = Height
    Data.GUI.Main.UnresearchedScrollPane.style.height = Height



    -- Alto de los espacios "vacios" en las tecnologías
    for Value, EmptyWidget in pairs( { Data.GUI.Main.ResearchedFlow, Data.GUI.Main.UnresearchedFlow } ) do
        EmptyWidget = EmptyWidget.children[ #EmptyWidget.children ]
        Value = Height - ( EmptyWidget.tags.Height + 4 + 9 + 4 )
        if Value > 0 then EmptyWidget.style.height = Value end
        if Value < 1 then EmptyWidget.visible = false end
    end
end

function ThisMOD.FocusButton( Data )

    -- Renombrar la variable
    local Tags = Data.Event.element.tags
    local Button = Data.Event.element

    -- Calas secciones
    local Sections = { }
    Sections[ Data.GUI.Main.QueueFlow.name ]        = Data.GUI.Main.QueueFlow.parent
    Sections[ Data.GUI.Main.ResearchedFlow.name ]   = Data.GUI.Main.ResearchedScrollPane
    Sections[ Data.GUI.Main.UnresearchedFlow.name ] = Data.GUI.Main.UnresearchedScrollPane

    -- Enfocar el botón
    local ScrollPane = Sections[ Tags.Location ]
    ScrollPane.scroll_to_element( Button, "top-third" )
end


function ThisMOD.ShowEffects( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Limpiar el contenedor
    Up.Table.clear( )

    -- No son porcentuales
    Up.Number = { }
    table.insert( Up.Number, "character-inventory-slots-bonus" )
    table.insert( Up.Number, "maximum-following-robots-count" )
    table.insert( Up.Number, "character-logistic-trash-slots" )
    table.insert( Up.Number, "stack-inserter-capacity-bonus" )
    table.insert( Up.Number, "inserter-stack-size-bonus" )
    table.insert( Up.Number, "worker-robot-storage" )

    -- Cargar los efectos
    for _, Effect in pairs( Up.Technology.Effects ) do
        if Effect.type == "unlock-recipe" then
            local Picture = { }
            Picture.type = "choose-elem-button"
            Picture.style = "transparent_slot"
            Picture.elem_type = "recipe"
            Picture = Up.Table.add( Picture )
            Picture.locked = true
            Picture.elem_value = Effect.recipe
            Picture.style.margin = 0
            Picture.style.padding = 0
        end

        if Effect.type  ~= "unlock-recipe" then
            local Information = { }
            local Temporal = { }
            local Count = 0

            repeat

                -- Inicializar las variables
                Count = Count + 1
                local Name = Effect.Name .. "-" .. Count

                -- Efecto no encontrado
                if not game.is_valid_sprite_path( Name ) then break end

                -- Crear la descripción a mostrar
                local Tooltip = { "", "[font=default-bold]" }
                local Description = { Effect.Localised }
                table.insert( Tooltip, Description )

                -- Guardar la información
                local Array = { }
                Array.Name = Name
                Array.Tooltip = Tooltip
                table.insert( Information, Array )

                -- El modificador es un boolean
                if GPrefix.isBoolean( Effect.modifier ) then
                    goto JumpEffect
                end

                -- El efecto es numerico
                if GPrefix.getKey( Up.Number, Effect.type ) then
                    table.insert( Description, Effect.modifier )
                    goto JumpEffect
                end

                -- El efecto esta en tics / seg
                if Effect.type == "ghost-time-to-live" then
                    table.insert( Description, Effect.modifier / ( 60 * 60 * 60 ) )
                    table.insert( Tooltip, "h" )
                    goto JumpEffect
                end

                -- Valor del Space Exploration
                Temporal = { }
                table.insert( Temporal, "tesla" )
                table.insert( Temporal, "cryogun" )
                table.insert( Temporal, "railgun" )
                if GPrefix.getKey( Temporal, Effect.ammo_category ) then
                    table.insert( Description, Effect.modifier * 100 )
                    table.insert( Tooltip, "%" )
                    goto JumpEffect
                end

                -- Valor de muestra
                if false then
                    goto JumpEffect
                end

                -- Valor porcentual en Vanilla
                if true then
                    table.insert( Description, Effect.modifier * 100 )
                    table.insert( Tooltip, "%" )
                    goto JumpEffect
                end

                -- Recepción del salto
                :: JumpEffect ::

                -- Cerrar el resaltado
                table.insert( Tooltip, "[/font]" )
            until false

            -- Tecnología descripción
            if Effect.type == "nothing" then
                local Array = { }
                table.insert( Information, Array )
                Array.Name = "technology/" .. Up.Technology.Name
                Array.Tooltip = { "", "[font=default-bold]" }
                table.insert( Array.Tooltip, Effect.effect_description )
                table.insert( Array.Tooltip, "[/font]" )
            end

            -- Cargar la imagen
            for _, Table in pairs( Information ) do
                local Picture = { }
                Picture.type = "sprite-button"
                Picture.sprite = Table.Name
                Picture.tooltip = Table.Tooltip
                Picture = Up.Table.add( Picture )
                Picture.style = "transparent_slot"
                Picture.style.padding = 0
                Picture.style.margin = 0
            end
        end
    end

    -- Rellenar los espacios
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Up.Table
    Here.Size  = 32
    ThisMOD.FillTable( Data )
end

function ThisMOD.ShowCostSingle( Data )

    -- Inicializar la variable
    local Picture = { }

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Renombrar la variable
    local Recipes = Data.Force.recipes

    -- Limpiar el contenedor
    Up.Table.clear( )

    -- Cargar los ingredientes
    for _, Ingredient in pairs( Up.Technology.Ingredients ) do

        -- Ingrediente con recetas
        if Recipes[ Ingredient ] then
            Picture = { }
            Picture.type = "choose-elem-button"
            Picture.style = "transparent_slot"
            Picture.elem_type = "recipe"
            Picture = Up.Table.add( Picture )
            Picture.locked = true
            Picture.elem_value = Ingredient
            Picture.style.padding = 0
            Picture.style.margin  = 0
        end

        -- Ingrediente sin recetas
        if not Recipes[ Ingredient ] then
            local Tooltip = { }
            table.insert( Tooltip, "" )
            table.insert( Tooltip, "[font=default-bold][color=254,222,169]" )
            table.insert( Tooltip, { "item-name." .. Ingredient } )
            table.insert( Tooltip, "[/color][/font]" )

            Picture = { }
            Picture.type = "sprite-button"
            Picture.sprite = "item/" .. Ingredient
            Picture.tooltip = Tooltip
            Picture = Up.Table.add( Picture )
            Picture.style = "transparent_slot"
            Picture.style.padding = 0
            Picture.style.margin  = 0
        end
    end

    -- Cargar el icono del tiempo
    Picture = { }
    Picture.type = "sprite-button"
    Picture.sprite = "quantity-time"
    Picture.number = Up.Technology.Time
    Picture = Up.Table.add( Picture )
    Picture.style = "transparent_slot"
    Picture.style.padding = 0
    Picture.style.margin  = 0

    -- Rellenar los espacios
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Up.Table
    Here.Size  = 32
    ThisMOD.FillTable( Data )
end

function ThisMOD.FrameTimeSingle( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Inicializar las variables
    local Tooltip = { "" }
    local Part = ""

    Part = ""
    Part = Part .. "[font=default-bold]"
    Part = Part .. "[color=254,222,169]"
    table.insert( Tooltip, Part )

    Part = { Data.GMOD.Local .. "factor"}
    table.insert( Tooltip, Part )

    Part = ""
    Part = Part .. ":[/color] "
    Part = Part .. "[color=123,201,98]" .. ( Up.Porcentage or 100 ) .. "[/color]"
    Part = Part .. "[color=254,222,169]%[/color]"
    Part = Part .. "[/font]"
    table.insert( Tooltip, Part )

    -- Tiempo del tooltip
    if Up.Calculated ~= Up.Default then
        Part = "\n"
        Part = Part .. "[font=default-bold]"
        Part = Part .. "[color=254,222,169]"
        table.insert( Tooltip, Part )

        Part = { Data.GMOD.Local .. "tooltip-default"}
        table.insert( Tooltip, Part )

        Part = ":[/color] "
        local Times = ThisMOD.FormatTime( Up.Default )
        for _, Time in pairs( Times ) do
            Part = Part .. "[color=123,201,98]" .. Time.value .. "[/color]"
            Part = Part .. "[color=254,222,169]" .. Time.unit .. "[/color]"
            if Time ~= Times[ #Times ] then Part = Part .. " " end
        end
        Part = Part .. "[/font]"
        table.insert( Tooltip, Part )
    end

    -- Tiempo en pantalla
    Up.Frame.clear( )
    for _, Time in pairs( ThisMOD.FormatTime( Up.Calculated ) ) do

        -- Contenedot del tiempo
        local TimeFlow = { }
        TimeFlow.type = "flow"
        TimeFlow.direction = "horizontal"
        TimeFlow.tooltip = Tooltip
        TimeFlow = Up.Frame.add( TimeFlow )
        TimeFlow.style.horizontal_spacing = 0

        -- Valor del tiempo
        local TiempoValue = { }
        TiempoValue.type = "label"
        TiempoValue.caption = Time.value
        TiempoValue.tooltip = Tooltip
        TiempoValue = TimeFlow.add( TiempoValue )
        TiempoValue.style = "achievement_unlocked_title_label"
        TiempoValue.style.padding = 0
        TiempoValue.style.margin = 0

        -- Etiqueta del tiempo
        local TiempoLabel = { }
        TiempoLabel.type = "label"
        TiempoLabel.caption = Time.unit
        TiempoLabel.tooltip = Tooltip
        TiempoLabel = TimeFlow.add( TiempoLabel )
        TiempoLabel.style = "caption_label"
        TiempoLabel.style.padding = 0
        TiempoLabel.style.margin = 0
    end
end


function ThisMOD.ShowPrerequisites( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Limpiar el contenedor
    Up.Table.clear( )

    -- Cargar las tecnologías
    for _, Prerequisite in pairs( Up.Prerequisites ) do
        local Picture = { }
        Picture.tags = { }
        Picture.tags.MOD = Data.GMOD.Prefix_MOD
        Picture.tags.SearchPrerequisites = Prerequisite

        if Data.Technologies.Researched[ Prerequisite ] then
            Picture.style = "green_slot"
        elseif GPrefix.getKey( Data.Queue, Prerequisite ) then
            Picture.style = "yellow_slot"
        else
            Picture.style = "omitted_technology_slot"
        end

        Picture.type = "choose-elem-button"
        Picture.elem_type = "technology"
        Picture = Up.Table.add( Picture )
        Picture.locked = true
        Picture.elem_value = Prerequisite
        Picture.style.size = 32
        Picture.style.margin = 0
        Picture.style.padding = 0
    end

    -- Rellenar los espacios
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Up.Table
    Here.Size  = 32
    ThisMOD.FillTable( Data )
end

function ThisMOD.ShowCostAccumulated( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Limpiar el contenedor
    Up.Table.clear( )

    -- Cargar los ingredientes
    for _, Total in pairs( Up.Total ) do
        local Unresearched = Up.Unresearched[ Total.name ]
        local Researched = Up.Researched[ Total.name ]

        local Tooltip = { }
        table.insert( Tooltip, "" )
        table.insert( Tooltip, "[font=default-bold]" )
        table.insert( Tooltip, { "item-name." .. Total.name } )
        table.insert( Tooltip, "[/font]" )

        if Unresearched then
            table.insert( Tooltip, "\n" )
            table.insert( Tooltip, "[font=default-bold][color=254,222,169]" )
            table.insert( Tooltip, { Data.GMOD.Local .. "tooltip-unresearched" } )
            table.insert( Tooltip, ":[/color][/font]" )
            table.insert( Tooltip, " [font=default-bold][color=123,201,98]" .. Unresearched.amount .. "[/color][/font]" )
        end

        if Researched then
            table.insert( Tooltip, "\n" )
            table.insert( Tooltip, "[font=default-bold][color=254,222,169]" )
            table.insert( Tooltip, { Data.GMOD.Local .. "tooltip-researched" } )
            table.insert( Tooltip, ":[/color][/font]" )
            table.insert( Tooltip, " [font=default-bold][color=123,201,98]" .. Researched.amount .. "[/color][/font]" )
        end

        local Picture   = { }
        Picture.type    = "sprite-button"
        Picture.sprite  = "item/" .. Total.name
        Picture.number  = Unresearched and Unresearched.amount or 0
        Picture.tooltip = Tooltip
        Picture = Up.Table.add( Picture )
        Picture.style = "transparent_slot"
        Picture.style.padding = 0
        Picture.style.margin = 0
    end

    -- Rellenar los espacios
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Table = Up.Table
    Here.Size  = 32
    ThisMOD.FillTable( Data )
end

function ThisMOD.FrameTimeAccumulated( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Inicializar las variables
    local Tooltip = { "" }
    local Part = ""

    Part = ""
    Part = Part .. "[font=default-bold]"
    Part = Part .. "[color=254,222,169]"
    table.insert( Tooltip, Part )

    Part = { Data.GMOD.Local .. "factor"}
    table.insert( Tooltip, Part )

    Part = ""
    Part = Part .. ":[/color] "
    Part = Part .. "[color=123,201,98]" .. ( Up.Porcentage or 100 ) .. "[/color]"
    Part = Part .. "[color=254,222,169]%[/color]"
    Part = Part .. "[/font]"
    table.insert( Tooltip, Part )

    -- Tiempo del tooltip
    local Tables = { }
    if Up.Researched > 0 then
        table.insert( Tables, { Cost = Up.Researched, Local = "tooltip-researched" } )
    end
    if Up.Remaining ~= Up.Total then
        table.insert( Tables, { Cost = Up.Unresearched, Local = "tooltip-unresearched" } )
    end
    if Up.Researched > 0 then
        table.insert( Tables, { Cost = Up.Total, Local = "tooltip-total" } )
    end

    for _, Table in pairs( Tables ) do

        Part = "\n"
        Part = Part .. "[font=default-bold]"
        Part = Part .. "[color=254,222,169]"
        table.insert( Tooltip, Part )

        Part = { Data.GMOD.Local .. Table.Local }
        table.insert( Tooltip, Part )

        Part = ":[/color] "
        local Times = ThisMOD.FormatTime( Table.Cost )
        for _, Time in pairs( Times ) do
            Part = Part .. "[color=123,201,98]" .. Time.value .. "[/color]"
            Part = Part .. "[color=254,222,169]" .. Time.unit .. "[/color]"
            if Time ~= Times[ #Times ] then Part = Part .. " " end
        end
        Part = Part .. "[/font]"
        table.insert( Tooltip, Part )
    end

    -- Tiempo en pantalla
    Up.Frame.clear( )
    for _, Time in pairs( ThisMOD.FormatTime( Up.Remaining ) ) do

        -- Contenedot del tiempo
        local TimeFlow = { }
        TimeFlow.type = "flow"
        TimeFlow.direction = "horizontal"
        TimeFlow.tooltip = Tooltip
        TimeFlow = Up.Frame.add( TimeFlow )
        TimeFlow.style.horizontal_spacing = 0

        -- Valor del tiempo
        local TiempoValue = { }
        TiempoValue.type = "label"
        TiempoValue.caption = Time.value
        TiempoValue.tooltip = Tooltip
        TiempoValue = TimeFlow.add( TiempoValue )
        TiempoValue.style = "achievement_unlocked_title_label"
        TiempoValue.style.padding = 0
        TiempoValue.style.margin = 0

        -- Etiqueta del tiempo
        local TiempoLabel = { }
        TiempoLabel.type = "label"
        TiempoLabel.caption = Time.unit
        TiempoLabel.tooltip = Tooltip
        TiempoLabel = TimeFlow.add( TiempoLabel )
        TiempoLabel.style = "caption_label"
        TiempoLabel.style.padding = 0
        TiempoLabel.style.margin = 0
    end
end



-- Actualizar la ubicación de las tecnologías

function ThisMOD.UpdateQueueAndTechnologies( Data )

    -- Acutalizar la información en pantalla
    for _, Player in pairs( Data.Force.players ) do

        -- Datos a usar
        local PlayerData = { Player = Player }
        PlayerData = ThisMOD.CreateData( PlayerData )

        -- Validación básica
        if not PlayerData.GUI.Main.WindowFrame then goto JumpPlayer end

        -- Guardar la tecnolgia seleccionada
        if PlayerData.Click and PlayerData.Click.Selected then
            local Tags = PlayerData.Click.Selected.tags
            PlayerData.Click.Selected = { }
            PlayerData.Click.Selected.Level = Tags.Level
            PlayerData.Click.Selected.Name = Tags.Technology
        end

        -- Guardar la tecnolgia cliqueada
        if PlayerData.Click and PlayerData.Click.Element then
            local Tags = PlayerData.Click.Element.tags
            PlayerData.Click.Element = { }
            PlayerData.Click.Element.Level = Tags.Level
            PlayerData.Click.Element.Name = Tags.Technology
        end

        -- Actualizar con la busqueda
        if PlayerData.Search then
            PlayerData.Event.element = PlayerData.GUI.Main.SearchTechnologyTextfield
            PlayerData.Event.element.text = PlayerData.Search.Text
            ThisMOD.SearchText( PlayerData )
        end

        -- Actualizar sin la busqueda
        if not PlayerData.Search then
            ThisMOD.ShowQueue( PlayerData )
            ThisMOD.ShowTechnologiesResearched( PlayerData )
            ThisMOD.ShowTechnologiesUnresearched( PlayerData )
        end

        -- Restaurar el botón seleccionado
        if GPrefix.isTable( PlayerData.Click.Selected ) then
            table.insert( PlayerData.Temporal, { Technology = PlayerData.Click.Selected } )
            PlayerData.Event.element = ThisMOD.getButton( PlayerData )
            PlayerData.Click.Selected = nil
        end

        -- Restaurar el botón cliqueado
        if GPrefix.isTable( PlayerData.Click.Element ) then
            PlayerData.Element = PlayerData.Click.Element.Name
            table.insert( PlayerData.Temporal, { Technology = PlayerData.Click.Element } )
            PlayerData.Click.Element = ThisMOD.getButton( PlayerData )
            if PlayerData.Element ~= PlayerData.Click.Element then
                PlayerData.Click.Element = nil
            end
        end

        -- Seleccionar una technología
        PlayerData.Event.button = defines.mouse_button_type.left
        ThisMOD.ToggleTechnology( PlayerData )

        -- Recepción del salto
        :: JumpPlayer ::
    end
end


function ThisMOD.ShowQueue( Data )

    -- Inicializar las variables
    local Here = { }
    table.insert( Data.Temporal, Here )
    Here.Location = Data.GUI.Main.QueueFlow.name
    Here.Queue = Data.Search and Data.Search.Queue or Data.Queue
    Here.Flow = Data.GUI.Main.QueueFlow

    -- Actualizar cantidad en cola
    Data.GUI.Main.QueueCountLabel.caption = #Here.Queue

    -- Elimnar los botones existentes
    Here.Flow.clear( )

    -- Crear los botones de la cola
    for _, TechnologyName in pairs( Here.Queue ) do
        Here.Technology = TechnologyName
        ThisMOD.CreateTechButton( Data )
    end

    -- Ocultar contenedor de la cola si esta vacia
    Here.Flow.visible = #Here.Flow.children > 0
end

function ThisMOD.ShowTechnologies( Data )

    -- Cargar espacio de respuesta
    local Up = Data.Temporal[ #Data.Temporal ]

    -- Elimnar los botones existentes
    Up.Flow.clear( )

    -- Inicializar la variable
    local Here = { }   Up.Height = 0

    -- Cargar los niveles
    for Level, Technologies in pairs( Up.Levels ) do

        -- Contenedor principal del nivel
        local LevelFlow = { }
        LevelFlow.type = "flow"
        LevelFlow.direction = "vertical"
        LevelFlow = Up.Flow.add( LevelFlow )
        LevelFlow.style.vertical_spacing = 0



        -- Contenedor del titulo del nivel
        local TitleFlow = { }
        TitleFlow.type = "flow"
        TitleFlow.direction = "horizontal"
        TitleFlow = LevelFlow.add( TitleFlow )
        TitleFlow.style.horizontal_spacing = 0
        TitleFlow.style.height = 24

        -- Indicador para mover la ventana
        local LeftEmptyWidget = { }
        LeftEmptyWidget.type = "empty-widget"
        LeftEmptyWidget.caption = "Effects"
        LeftEmptyWidget = TitleFlow.add( LeftEmptyWidget )
        LeftEmptyWidget.drag_target = Data.GUI.Main.WindowFrame
        LeftEmptyWidget.style.horizontally_stretchable = true
        LeftEmptyWidget.style.vertically_stretchable = true
        LeftEmptyWidget.style.margin = 0

        -- Titulo del nivel
        local LevelLabel = { }
        LevelLabel.type = "label"
        LevelLabel.caption = { "", { Data.GMOD.Local .. "level" }, " " .. Level }
        LevelLabel = TitleFlow.add( LevelLabel )
        LevelLabel.style = "heading_2_label"
        LevelLabel.style.padding = 0
        LevelLabel.style.margin = 0

        -- Indicador para mover la ventana
        local RightEmptyWidget = { }
        RightEmptyWidget.type = "empty-widget"
        RightEmptyWidget.caption = "Effects"
        RightEmptyWidget = TitleFlow.add( RightEmptyWidget )
        RightEmptyWidget.drag_target = Data.GUI.Main.WindowFrame
        RightEmptyWidget.style.horizontally_stretchable = true
        RightEmptyWidget.style.vertically_stretchable = true
        RightEmptyWidget.style.margin = 0



        -- Tabla contenedora
        local Table = { }
        Table.type = "table"
        Table.name = "Unresearched"
        Table.column_count = 5
        Table = LevelFlow.add( Table )
        Table.style = "research_queue_table"
        Table.style.horizontally_stretchable = true
        Table.style.horizontal_spacing = 0
        Table.style.vertical_spacing = 9

        -- Cargar las tecnologías investigadas
        Here = { }
        Here.Flow = Table
        Here.Location = Up.Flow.name
        table.insert( Data.Temporal, Here )
        for _, Technology in pairs( Technologies ) do
            Here.Technology = Technology.Name
            ThisMOD.CreateTechButton( Data )
        end

        -- Rellenar los espacios
        Here = { }
        table.insert( Data.Temporal, Here )
        Here.Table = Table
        Here.Size  = 64
        ThisMOD.FillTable( Data )

        -- Establecer el alto del contenedor del nivel
        local Line = #Table.children / Table.column_count
        local Height = 24 + ( 64 * Line ) + ( 9 * ( Line - 1 ) )
        LevelFlow.style.height = Height
        Up.Height = Up.Height + Height

        -- Crear linea
        Here.Line = { }
        Here.Line.type = "line"
        Here.Line.direction = "horizontal"
        Here.Line = Up.Flow.add( Here.Line )
    end

    -- Eliminar la última línea
    if Here.Line then Here.Line.destroy( ) end

    -- Calcular el alto total del contenedor
    Up.Height = Up.Height + ( ( #Up.Flow.children - 1 ) / 2 ) * ( 9 * 2 )

    -- Espacio "vacio"
    local EmptyWidget = { }
    EmptyWidget.tags = { }
    EmptyWidget.tags.Height = Up.Height
    EmptyWidget.type = "empty-widget"
    EmptyWidget = Up.Flow.add( EmptyWidget )
    EmptyWidget.drag_target = Data.GUI.Main.WindowFrame
    EmptyWidget.style.horizontally_stretchable = true
    EmptyWidget.style.vertically_stretchable = true
end

function ThisMOD.ShowTechnologiesResearched( Data )

    -- Cargar espacio de respuesta
    local Here = { }
    table.insert( Data.Temporal, Here )

    -- Inicializar las variables
    Here.Levels = Data.Search and Data.Search.Researched or { }
    Here.Flow = Data.GUI.Main.ResearchedFlow

    -- Evitar el filtrado
    if Data.Search then goto JumpFilter end

    -- Filtrar los niveles a mostrar
    for Level, Technologies in pairs( Data.Technologies.Levels ) do
        if GPrefix.getLength( Technologies ) > 0 then
            for _, Technology in pairs( Technologies ) do
                if Data.Technologies.Researched[ Technology.Name ] then
                    Here.Levels[ Level ] = Here.Levels[ Level ] or { }
                    table.insert( Here.Levels[ Level ], Technology )
                end
            end
        end
    end

    -- Recepción del salto
    :: JumpFilter ::

    -- Contar las tecnologías investigadas
    local Count = 0
    for _, Technologies in pairs( Here.Levels ) do
        for _, _ in pairs( Technologies ) do
            Count = Count + 1
        end
    end

    -- Mostrar el conteo
    Data.GUI.Main.ResearchedCountLabel.caption = Count

    -- Cargar las tecnologías filtradas
    ThisMOD.ShowTechnologies( Data )
end

function ThisMOD.ShowTechnologiesUnresearched( Data )

    -- Cargar espacio de respuesta
    local Here = { }
    table.insert( Data.Temporal, Here )

    -- Inicializar las variables
    Here.Levels = Data.Search and Data.Search.Unresearched or { }
    Here.Flow = Data.GUI.Main.UnresearchedFlow

    -- Evitar el filtrado
    if Data.Search then goto JumpFilter end

    -- Filtrar los niveles a mostrar
    for Level, Technologies in pairs( Data.Technologies.Levels ) do
        if GPrefix.getLength( Technologies ) > 0 then
            for _, Technology in pairs( Technologies ) do
                local InQueue = GPrefix.getKey( Data.Queue, Technology.Name ) and true or nil
                local Researched = Data.Technologies.Researched[ Technology.Name ]
                if InQueue and Technology.Infinite then
                    InQueue = false
                end
                if not( InQueue or Researched ) then
                    Here.Levels[ Level ] = Here.Levels[ Level ] or { }
                    table.insert( Here.Levels[ Level ], Technology )
                end
            end
        end
    end

    -- Recepción del salto
    :: JumpFilter ::

    -- Contar las tecnologías sin investigar
    local Count = 0
    for _, Technologies in pairs( Here.Levels ) do
        for _, _ in pairs( Technologies ) do
            Count = Count + 1
        end
    end

    -- Mostrar el conteo
    Data.GUI.Main.UnresearchedCountLabel.caption = Count

    -- Cargar las tecnologías filtradas
    ThisMOD.ShowTechnologies( Data )
end



-- Funciones que se ejecuta al iniciar o al cargar la partida

function ThisMOD.Initialize( )

    -- Variable contenedora
    local Data = { Temporal = { }, Player = { index = 0 } }
    local Here = { }

    -- Reconstruir la ventana de estado
    Here.Table = { }
    Here.Table.Name = ThisMOD.Prefix_MOD_ .. "StartInitialize"
    Here.Table.Function = ThisMOD.StartInitialize
    table.insert( Data.Temporal, Here.Table )
    GPrefix.AddOnTick( Data )

    -- Hacer cada tick que se esta investigando
    Here.Table = { }
    Here.Table.Name = ThisMOD.Prefix_MOD_ .. "OnForcesResearchTick"
    Here.Table.Function = ThisMOD.OnForcesResearchTick
    table.insert( Data.Temporal, Here.Table )
    GPrefix.AddOnTick( Data )
end


function ThisMOD.StartInitialize( )

    -- Renombrar la variable
    local Level = script.level

    -- Modos de juego
    local level_name = {

        -- Disable
        [ 'wave-defense' ] = true,
        [ 'team-production' ] = true,

        -- Enable
        [ 'pvp' ] = nil,
        [ 'supply' ] = nil,
        [ 'sandbox' ] = nil,
        [ 'freeplay' ] = nil,
        [ 'rocket-rush' ] = nil,
    }

    ---> <---     ---> <---     ---> <---

    -- Desactivar el MOD en campaña
    if Level.campaign_name then ThisMOD.Active = false end

    -- Desactivar el MOD de ser necesario
    if level_name[ Level.level_name ] then ThisMOD.Active = false end

    -- Desactivar esta función
    if not ThisMOD.Active then return true end

    ---> <---     ---> <---     ---> <---

    -- Inicializar el contenedor
    local Initialized = ThisMOD.Initialized or { }
    ThisMOD.Initialized = Initialized

    -- Agrupar los nombres de los jugadores en línea ahora
    local ListConnected = { }
    for _, Player in pairs( game.connected_players ) do
        ListConnected[ Player.index ] = Player.name
    end

    -- Validar si hay jugadores para inicializar
    local OldConnected = GPrefix.toString( Initialized )
    local NowConnected = GPrefix.toString( ListConnected )
    if NowConnected == OldConnected then return end

    -- Inicializar el contenedor
    local NewConnected = { }
    local NewDisconnected = { }

    -- Burcar el cambio de estado
    for _, Player in pairs( game.players ) do
        if Player.connected and not Initialized[ Player.index ] then
            NewConnected[ Player.index ] = Player
        end
        if not Player.connected and Initialized[ Player.index ] then
            NewDisconnected[ Player.index ] = Player
        end
    end

    -- Eliminar de la lista de los inicializados los que se desconectaron
    for _, Player in pairs( NewDisconnected ) do
        Initialized[ Player.index ] = nil
    end

    -- Inicializar los jugadores recien conectados
    for _, Player in pairs( NewConnected ) do

        -- Consolidar las variables
        local Data = ThisMOD.CreateData( { Player = Player } )

        -- Desahabilitar el botón
        Player.set_shortcut_available( ThisMOD.Prefix_MOD, false )

        -- Destruir la ventana principal de estar abierta
        if Data.GUI.Main and Data.GUI.Main.WindowFrame then
            Data.GUI.Main.WindowFrame.destroy( )
        end

        -- Destruir la ventana estado que este abierta
        for _, Element in pairs( Player.gui.screen.children ) do
            if Element.name == ThisMOD.Prefix_MOD_ .. "status" then
                Element.destroy( ) ThisMOD.StatusOpened = true break
            end
        end

        -- Validar si exiten tecnologías disponibles
        if not Data.Force.technologies then goto JumpEnd end

        -- Cargar las tecnologías en la RAM
        ThisMOD.LoadTechnologies( Data )

        -- Agregar texto a traducir
        ThisMOD.LoadTranslation( Data )

        -- Validar la cola de las tecnologias
        ThisMOD.ValidateQueue( Data )

        -- Habilitar el botón
        Player.set_shortcut_available( ThisMOD.Prefix_MOD, true )

        -- Reconstruir la ventana de estado
        if ThisMOD.StatusOpened then
            ThisMOD.BuildWindowStatus( Data )
            ThisMOD.UpdateWindowStatus( Data )
            ThisMOD.StatusOpened = nil
        end

        -- Guardar el jugador como inicializado
        Initialized[ Player.index ] = Player.name

        -- Recepción del salto
        :: JumpEnd ::
    end
end

function ThisMOD.LoadTechnologies( Data )

    -- El listado ya existe
    if Data.Technologies and Data.Technologies.Researched then return end

    -- Inicializar las variable
    local Table = Data.GMOD.Technologies or { }
    local All = Table.All or { }
    local Levels = Table.Levels or { }
    local Researched = Data.GForce.Researched or { }

    -- Crear accesos rapidos
    Data.Technologies = { }
    Data.Technologies.All = All
    Data.Technologies.Levels = Levels
    Data.Technologies.Researched = Researched

    -- Guardar la información
    Table.All = All
    Table.Levels = Levels
    Data.GMOD.Technologies = Table
    Data.GForce.Researched = Researched

    ---> <---     ---> <---     ---> <---

    -- Cargar todas las tecnologias
    for _, Technology in pairs( Data.Force.technologies ) do
        ThisMOD.LoadTechnology( Data, Technology.name )
    end

    ---> <---     ---> <---     ---> <---

    -- Cargar los niveles
    while true do

        -- Variable contenedora
        local newLevel = { }

        -- Recorrer todas las tecnologías
        for _, OldTechnology in pairs( All ) do

            -- Cargar el primer nivel
            if GPrefix.getLength( Levels ) < 1 then
                if GPrefix.getLength( OldTechnology.Prerequisites ) < 1 then
                    newLevel[ OldTechnology.Name ] = OldTechnology
                end
            end

            -- Cargar los niveles restantes
            if GPrefix.getLength( Levels ) > 0 then

                -- Recorrer el último nivel
                for Technology, _ in pairs( Levels[ tostring( GPrefix.getLength( Levels ) ) ] ) do

                    -- Buscar las tecnologías que se desbloquearan
                    local Flag = OldTechnology.Prerequisites
                    Flag = Flag[ Technology ]
                    if not Flag then goto JumpTechnology end

                    -- Guardar el nombre de la tecnología a desbloquear
                    newLevel[ OldTechnology.Name ] = OldTechnology

                    -- Recepción del salto
                    :: JumpTechnology ::
                end
            end
        end

        -- Verificar si existe un nuevo nivel
        if GPrefix.getLength( newLevel ) < 1 then break end

        -- Guardar nivel en la cola
        Levels[ tostring( GPrefix.getLength( Levels ) + 1 ) ] = newLevel
    end

    -- Eliminar las redundancias
    for i = GPrefix.getLength( Levels ), 3, -1 do
        for Technology, _ in pairs( Levels[ tostring( i ) ] ) do
            for j = i - 1, 2, -1 do
                Levels[ tostring( j ) ][ Technology ] = nil
            end
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Cargar los prerequisitos acomulados
    for _, Technology in pairs( All ) do

        -- Inicicalizar los contenedores
        local Prerequisites = { }
        local Patch = Technology.Prerequisites
        local Keys = { }

        -- Cargar los nombres de las tecnologías iniciales
        for Key, _ in pairs( Patch ) do table.insert( Keys, Key ) end

        -- Cargar los prerquisitos adicionales
        local Index = 1
        while Keys[ Index ] do
            for Key, Value in pairs( All[ Keys[ Index ] ].Prerequisites ) do
                if GPrefix.getKey( Keys, Key ) then goto JumpAddPrerequisite end
                table.insert( Keys, Key ) Patch[ Key ] = Value
                :: JumpAddPrerequisite ::
            end Index = Index + 1
        end 

        -- Cargar los prerequisitos en orden
        for _, Level in pairs( Levels ) do
            for Name, Details in pairs( Level ) do
                if Technology.Prerequisites[ Name ] then
                    Prerequisites[ Name ] = Details
                end
            end
        end

        -- Asignar los prerequisitos
        Technology.Prerequisites = Prerequisites
    end
end

function ThisMOD.LoadTechnology( Data, TechnologyName )

    -- Inicializar las variables
    local All = Data.Technologies.All
    All[ TechnologyName ] = All[ TechnologyName ] or { }
    local Researched = Data.GForce.Researched
    local Technology = Data.Force.technologies[ TechnologyName ]
    local NewTechnology = All[ TechnologyName ]
    if NewTechnology.Name then goto JumpTechnology end

    -- Datos moleculares
    NewTechnology.Name = Technology.name
    NewTechnology.Time = Technology.research_unit_energy / 60
    NewTechnology.Cost = NewTechnology.Time * Technology.research_unit_count
    NewTechnology.Level = Technology.level
    NewTechnology.Amount = Technology.research_unit_count
    NewTechnology.Localised = Technology.localised_name
    NewTechnology.Localised_name = Technology.localised_name
    NewTechnology.Localised_description = Technology.localised_description

    -- Darle el formato deseado a la formula
    NewTechnology.Formula = Technology.research_unit_count_formula
    NewTechnology.Formula = ThisMOD.FormatFormula( NewTechnology.Formula )

    -- Determinar si la tecnología es infinita
    NewTechnology.Infinite = true
    NewTechnology.Infinite = NewTechnology.Infinite and NewTechnology.Formula
    NewTechnology.Infinite = NewTechnology.Infinite and Technology.prototype.max_level > 10 ^ 3
    NewTechnology.Infinite = NewTechnology.Infinite and true or nil

    -- Validar el nombre de las tecnologías infinitas
    if NewTechnology.Infinite and #NewTechnology.Localised_name > 1 then
        NewTechnology.Localised_name = NewTechnology.Localised_name[ 2 ]
    end

    -- Cargar los efectos
    NewTechnology.Effects = { }

    if #Technology.effects < 1 then
        local NewEffect = { }
        table.insert( NewTechnology.Effects, NewEffect )
        NewEffect.effect_description = NewTechnology.Localised_description
        NewEffect.Localised = NewTechnology.Localised_description
        NewEffect.type = "nothing"
        NewEffect.Name = ""
    end

    for _, Effect in pairs( Technology.effects ) do
        local NewEffect = { }
        table.insert( NewTechnology.Effects, NewEffect )
        for Key, Value in pairs( Effect ) do
            NewEffect[ Key ] = Value
        end

        -- Identificar la traducción
        local Name = Effect.type
        local Localised = "modifier-description."
        if Effect.type == "turret-attack" then
            Name = Effect.turret_id .. "-attack-bonus"
            Localised = Localised .. Name
        elseif Effect.type == "ammo-damage" then
            Name = Effect.ammo_category .. "-damage-bonus"
            Localised = Localised .. Name
        elseif Effect.type == "gun-speed" then
            Name = Effect.ammo_category .. "-shooting-speed-bonus"
            Localised = Localised .. Name
        elseif Effect.type == "unlock-recipe" then
            Localised = Data.Force.recipes[ Effect.recipe ].localised_name
            Name = Effect.recipe
        elseif Effect.type == "nothing" then
            Localised = Effect.effect_description
        else
            Localised = Localised .. Effect.type
        end

        -- Guardar la información
        NewEffect.Name = Name
        NewEffect.Localised = Localised
    end

    -- Cargar los ingredientes
    NewTechnology.Ingredients = { }
    for _, Ingredient in pairs( Technology.research_unit_ingredients ) do
        table.insert( NewTechnology.Ingredients, Ingredient.name )
    end

    -- Cargar los prerequisitos
    NewTechnology.Prerequisites = { }
    for _, Effect in pairs( Technology.prerequisites ) do
        All[ Effect.name ] = All[ Effect.name ] or { }
        NewTechnology.Prerequisites[ Effect.name ] = All[ Effect.name ]
    end

    -- Recepción del salto
    :: JumpTechnology ::

    -- Agregar a la lista de investigados
    if Technology.researched then
        Researched[ TechnologyName ] = NewTechnology
    end
end

function ThisMOD.LoadTranslation( Data )

    -- Inicializar la variable
    local Down = { }
    table.insert( Data.Temporal, Down )

    -- Crear los textos a traducir
    Down.Localised = { "locale-identifier" }
    GPrefix.AddLocalised( Data )
    for _, Technology in pairs( Data.Technologies.All ) do
        Down.Localised = Technology.Localised_name
        GPrefix.AddLocalised( Data )
        for _, Effect in pairs( Technology.Effects ) do
            Down.Localised = Effect.Localised
            GPrefix.AddLocalised( Data )
        end
    end
end

function ThisMOD.ValidateQueue( Data )
    local function AddQueue( Queue, Technology )
        if Technology.Infinite or not GPrefix.getKey( Queue, Technology.Name ) then
            table.insert( Queue, Technology.Name )
        end
    end

    -- La cola ya ha sido validada
    if Data.GForce.ValidateQueue then return end

    -- Crear la cola si no existe
    Data.gForce.Queue = Data.gForce.Queue or { }
    Data.Queue = Data.gForce.Queue

    -- Inicializar
    local Queue = { }

    -- Recorrer la cola actual
    for _, Technology in pairs( Data.Queue ) do

        -- Validar que las tecnologías existan
        Technology = Data.Technologies.All[ Technology ]
        if not Technology then goto JumpTechnology end

        -- Agregar las tecnologías de prerequisitos no investigadas
        for _, Prerequisite in pairs( Technology.Prerequisites ) do
            local Researched = Data.Technologies.Researched[ Prerequisite.Name ]
            if not Researched then AddQueue( Queue, Prerequisite ) end
        end

        local Researched = Data.Technologies.Researched[ Technology.Name ]
        if Technology.Infinite or not Researched then AddQueue( Queue, Technology ) end
        :: JumpTechnology ::
    end

    -- Valores de salida
    Data.Queue = Queue
    Data.gForce.Queue = Queue
    Data.GForce.ValidateQueue = true
end


function ThisMOD.OnForcesResearchTick( )
    for _, force in pairs( game.forces ) do
        local ForceData = ThisMOD.CreateData( { force = force } )
        ThisMOD.OnResearchTick( ForceData )
    end
end

function ThisMOD.OnResearchTick( Data )

    -- Crear el espacio para la función
    Data.gForce.Researchs = Data.gForce.Researchs or { }
    local Research = Data.gForce.Researchs

    -- Validación básica
    if Data.GMOD.Name ~= ThisMOD.Name then return end

    -- Renombrar la variable y validar la investigación
    local Technology = Data.Force.current_research
    if not Technology then return end

    -- Crear el espacio para la tecnología
    Research[ Technology.name ] = Research[ Technology.name ] or { }
    Research = Research[ Technology.name ]

    -- Validar el contador de tick
    Research.UpdateTick = Research.UpdateTick or 0
    Research.Seconds = Research.Seconds or 0

    -- Progreso por tick
    Research.NowProgress = Data.Force.research_progress
    Research.BeforeProgress = Research.BeforeProgress or 0
    local Speed = Research.NowProgress - Research.BeforeProgress
    if Speed > 0 then Research.BeforeProgress = Research.NowProgress end

    -- Validar el tick
    if Speed == 0 then
        for _, Player in pairs( Data.Force.players ) do
            local PlayerData = ThisMOD.CreateData( { Player = Player } )
            ThisMOD.UpdateWindowStatus( PlayerData )
        end return
    end

    if Research.UpdateTick < 60 then
        Research.UpdateTick = Research.UpdateTick + 1
        return
    end

    -- Inicializar el contador de tick
    Research.UpdateTick = 1

    -- Guardar el segundo transcurrido
    Research.Seconds = Research.Seconds + 1

    -- Guardar el progreso
    Research.LastProgress = Research.ActualProgress
    Research.ActualProgress = Data.Force.research_progress

    -- Actulizar la ventana flotante
    for _, Player in pairs( Data.Force.players ) do
        local PlayerData = ThisMOD.CreateData( { Player = Player } )
        ThisMOD.UpdateWindowStatus( PlayerData )
    end
end

function ThisMOD.UpdateWindowStatus( Data )

    -- Validación basica
    if not Data.GUI.Status then return end
    if not Data.GUI.Status.WindowFrame then return end

    -- Datos para inicializar la ventana
    local Here = { }
    Here.Progress = Data.Force.research_progress
    Here.QueueLabel = Data.GUI.Status.StatusQueueLabel
    Here.ResearchName = Data.Force.current_research
    if Here.ResearchName then Here.ResearchName = Here.ResearchName.name end

    Here.TitleLable = Data.GUI.Status.WindowStatusTitleLable
    Here.PictureSprite = Data.GUI.Status.StatusPictureSprite

    Here.BaseFrame = Data.GUI.Status.StatusTimeBaseFrame
    Here.LeftFrame = Data.GUI.Status.StatusTimeLeftFrame
    Here.ElapsedFrame = Data.GUI.Status.StatusTimeElapsedFrame
    Here.ExpectedFrame = Data.GUI.Status.StatusTimeExpectedFrame

    table.insert( Data.Temporal, Here )

    ---> <---     ---> <---     ---> <---

    local function Next( Label, Index )

        -- Inicializar las variables
        local Tooltip = { "" }
        local Part = ""

        -- Validar la siguiente tecnología
        if not Data.Queue[ Index ] then
            Label.tooltip = Tooltip
            return
        end

        -- Nombre de la siguiente tecnología
        local Technology = Data.Technologies.All[ Data.Queue[ Index ] ]
        local Name = Technology.Localised_name or { "technology-name." .. Technology.Name }
        if Technology.Infinite then
            local Level = Technology.Level
            local Flag = Here.ResearchName
            Flag = Flag and Data.Queue[ Index ] == Here.ResearchName
            if Flag then Level = Level + 1 end

            if Name[ 1 ] == "" then table.insert( Name, " " .. Level ) end
            if Name[ 1 ] ~= "" then Name = { "", Name, " " .. Level } end
        end

        -- Partes del tooltip
        Part = ""
        Part = Part .. "[font=default-bold]"
        Part = Part .. "[color=254,222,169]"
        table.insert( Tooltip, Part )

        Part = { Data.GMOD.Local .. "next"}
        table.insert( Tooltip, Part )

        Part = ""
        Part = Part .. ":[/color] "
        Part = Part .. "[color=123,201,98]"
        table.insert( Tooltip, Part )

        table.insert( Tooltip, Name )

        Part = ""
        Part = Part .. "[/color]"
        Part = Part .. "[color=254,222,169]%[/color]"
        Part = Part .. "[/font]"
        table.insert( Tooltip, Part )

        -- Asignar el letrero
        Label.tooltip = Tooltip
    end

    -- Cantidad de tecnología en cola
    Data.Queue = Data.gForce.Queue or { }
    if Here.ResearchName and #Data.Queue > 0 then
        Here.QueueLabel.caption = #Data.Queue - 1
        Next( Here.QueueLabel, 2 )
    end
    if not Here.ResearchName and #Data.Queue > 0 then
        Here.QueueLabel.caption = #Data.Queue
        Next( Here.QueueLabel, 1 )
    end
    if not Here.ResearchName and #Data.Queue < 1 then
        Here.QueueLabel.caption = 0
    end
    if Here.ResearchName and #Data.Queue < 1 then
        Here.QueueLabel.caption = 0
    end

    ---> <---     ---> <---     ---> <---

    -- No hay información a mostrar
    if Here.ResearchName then goto JumpUpdateWindowStatus end

    -- Lipiar la imagen
    Here.PictureSprite.sprite = nil

    -- Establecer en nombre
    Here.TitleLable.caption = { Data.GMOD.Local .. "setting-name"}

    -- Tiempo base
    Here.Frame = Here.BaseFrame
    ThisMOD.ShowTimeStatus( Data )

    -- Tiempo transcurrido
    Here.Frame = Here.ElapsedFrame
    ThisMOD.ShowTimeStatus( Data )

    -- Tiempo restante
    Here.Frame = Here.LeftFrame
    ThisMOD.ShowTimeStatus( Data )

    -- Tiempo esperado
    Here.Factor = math.ceil( ( Data.gForce.Factor or 1 ) * 100 )
    Here.Frame = Here.ExpectedFrame
    ThisMOD.ShowTimeStatus( Data )

    -- Finalizar codigo
    if true then return end

    -- Recepción del salto
    :: JumpUpdateWindowStatus ::

    ---> <---     ---> <---     ---> <---

    -- Inicializar las variables
    local Technology = Data.Technologies.All[ Here.ResearchName ]

    Data.gForce.Researchs = Data.gForce.Researchs or { }
    local Research = Data.gForce.Researchs or { }
    Research = Research[ Technology.Name ] or { }

    Research.ActualProgress = Research.ActualProgress or Here.Progress
    Research.LastProgress = Research.LastProgress or 0

    local TimeLeft = -1
    local ResearchSpeed = Research.ActualProgress - Research.LastProgress
    if ResearchSpeed > 0 then TimeLeft = ( 1 - Research.ActualProgress ) / ResearchSpeed end

    local Factor = 0
    if Research.Seconds and Research.Seconds > 0 then
        local Down = 100 / Technology.Cost * Research.Seconds
        Factor = ( Here.Progress * 100 ) / Down
    end

    local Name = Technology.Localised_name or { "technology-name." .. Technology.Name }
    if Technology.Infinite then   local Level = Technology.Level
        if Name[ 1 ] == "" then table.insert( Name, " " .. Level ) end
        if Name[ 1 ] ~= "" then Name = { "", Name, " " .. Level } end
    end

    ---> <---     ---> <---     ---> <---

    -- la imagen de la tecnología
    Here.PictureSprite.sprite = "technology/" .. Technology.Name

    -- Establecer en nombre
    Here.TitleLable.caption = Name

    -- Tiempo base
    Here.Frame = Here.BaseFrame
    Here.Time = Technology.Cost
    ThisMOD.ShowTimeStatus( Data )

    -- Tiempo esperado
    Here.Factor = math.ceil( ( Data.gForce.Factor or 1 ) * 100 )
    Here.Frame = Here.ExpectedFrame
    Here.Time = Technology.Cost / ( Data.gForce.Factor or 1 )
    ThisMOD.ShowTimeStatus( Data )

    -- Tiempo restante
    if TimeLeft >= 0 then
        Here.Factor = math.ceil( Factor * 100 )
        Here.Frame = Here.LeftFrame
        Here.Time = math.floor( TimeLeft )
        ThisMOD.ShowTimeStatus( Data )
    end

    -- No se esta invesitigando
    if TimeLeft < 0 then

        -- Contenedor destino
        local Frame = Here.LeftFrame

        -- Eliminar lo existente
        Frame.clear( )

        -- Valor del tiempo
        local Tiempo = { }
        Tiempo.type = "label"
        Tiempo.caption = "∞"
        Tiempo = Frame.add( Tiempo )
        Tiempo.style = "achievement_unlocked_title_label"
        Tiempo.style.padding = 0
        Tiempo.style.margin = 0
    end

    -- Tiempo transcurrido
    Here.Factor = math.ceil( Factor * 100 )
    Here.Frame = Here.ElapsedFrame
    Here.Time = Research.Seconds or 0
    ThisMOD.ShowTimeStatus( Data )
end



-- Codigo separado de sus funciones

function ThisMOD.BraekLoop( Data )

    -- Inicializar las variables
    local Ciclo = Data.gForce.Ciclo or { }
    Data.gForce.Ciclo = Ciclo

    -- Validar deteción del MOD
    if Ciclo.Tick ~= Data.Event.tick then
        Ciclo.Tick = Data.Event.tick
        Ciclo.Queue = Data.Queue
        Ciclo.Count = 0
        return
    end

    -- Contar el ciclo
    if Ciclo.Count < 10 then
        Ciclo.Count = Ciclo.Count + 1
        return
    end

    -- El ciclo no es posible
    if not Data.gForce.Status then return end

    -- Cerrar la interfaz del MOD
    for _, Player in pairs( Data.Force.players ) do
        local PlayerData = ThisMOD.CreateData( { Player = Player } )
        if PlayerData.GUI.Main.WindowFrame then
            PlayerData.Event.name = defines.events.on_gui_click
            PlayerData.Event.element = PlayerData.GUI.Main.CloseWindowButton
            PlayerData.Event.button = defines.mouse_button_type.left
            ThisMOD.ToggleWindowMain( PlayerData )
        end
    end

    -- Desactivar el MOD sin la interfaz
    local Status = false
    Data.gForce.Status = Status

    -- Informar del cambio
    Data.Force.print( { "",
        "[color=default]",
        { Data.GMOD.Local .. "setting-name" },
        ": [/color]",
        {
            Data.GMOD.Local .. "status-change",
            {
                "",
                "[color=default]",
                { Data.GMOD.Local .. "setting-name" },
                "[/color]",
            },
            {
                "",
                "[color=red]",
                { Data.GMOD.Local .. "OFF" },
                "[/color]"
            },
        }
    } )

    -- Reiniciar la bandera
    Ciclo.Tick = 0
end


function ThisMOD.SaveLocationWindowStatus( Data )

    -- Validación básica
    if not Data.Event.element.valid then return end
    if Data.Event.element ~= Data.GUI.Status.WindowFrame then return end

    -- Guardar nueva posición
    Data.gPlayer.WindowStatusLocation = GPrefix.DeepCopy( Data.Event.element.location )
end


function ThisMOD.CreateWindowMain( Data )
    ThisMOD.BuildWindowMain( Data )

    -- Cargar la sección de tecnología inicial
    Data.Event.element = Data.GUI.Main.UnresearchedExpandButton
    Data.Event.button = defines.mouse_button_type.left
    ThisMOD.ToggleTechnologies( Data )

    -- Selecionar la tecnología inicial
    if #Data.GUI.Main.QueueFlow.children > 0 then
        Data.Event.element = Data.GUI.Main.QueueFlow.children[ 1 ]
    else
        Data.Event.element = Data.GUI.Main.UnresearchedFlow.children[ 1 ]
        Data.Event.element = Data.Event.element.children[ 2 ].children[ 1 ]
    end

    -- Información de la tecnología inicial
    Data.Event.button = defines.mouse_button_type.left
    ThisMOD.ToggleTechnology( Data )
end

function ThisMOD.DestroyWindowMain( Data )
    Data.GUI.Main.WindowFrame.destroy( )
    Data.GPlayer.GUI.Main = nil
    Data.GPlayer.Search = nil
    GPrefix.Click.Players[ Data.Player.index ] = nil
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

    ---> <---     ---> <---     ---> <---

    -- Abriendo otra ventana
    local OpenOtherWindow = false

    OpenOtherWindow = Data.GUI.Main.WindowFrame
    if not OpenOtherWindow then goto JumpOpenOtherWindow end

    OpenOtherWindow = defines.events.on_gui_closed
    OpenOtherWindow = Data.Event.name == OpenOtherWindow
    if not OpenOtherWindow then goto JumpOpenOtherWindow end

    -- Evento identificado
    if true then return true end

    -- Recepción del salto
    :: JumpOpenOtherWindow ::

    ---> <---     ---> <---     ---> <---

    -- Cerrando con el boton de la ventana
    local CloseWindowButton = false

    CloseWindowButton = defines.events.on_gui_click
    CloseWindowButton = Data.Event.name == CloseWindowButton
    if not CloseWindowButton then goto JumpCloseWindowButton end

    CloseWindowButton = Data.GUI.Main.CloseWindowButton
    CloseWindowButton = Data.Event.element == CloseWindowButton
    if not CloseWindowButton then goto JumpCloseWindowButton end

    -- Evento identificado
    if true then return true end

    -- Recepción del salto
    :: JumpCloseWindowButton ::

    ---> <---     ---> <---     ---> <---

    -- Usando el botón de acceso rapido
    local ButtonShortcut = false

    ButtonShortcut = Data.Event.prototype_name
    if not ButtonShortcut then goto JumpButtonShortcut end

    ButtonShortcut = ButtonShortcut == Data.GMOD.Prefix_MOD
    if not ButtonShortcut then goto JumpButtonShortcut end

    ButtonShortcut = defines.events.on_lua_shortcut
    ButtonShortcut = Data.Event.name == ButtonShortcut
    if not ButtonShortcut then goto JumpButtonShortcut end

    -- Evento identificado
    if true then return true end

    -- Recepción del salto
    :: JumpButtonShortcut ::

    ---> <---     ---> <---     ---> <---

    return false
end


function ThisMOD.UpdateReseach( Data )
    local Update = false
    local function SubFunction( )

        -- No hay tecnologías en cola
        if #Data.Queue < 1 then
            Data.gForce.Research = nil
            Data.Force.research_queue = { }
            return
        end

        -- Inicializar las variables
        local Here = { }
        Here.Technology = Data.Technologies.All[ Data.Queue[ 1 ] ]
        Here.technology = Data.Force.technologies[ Here.Technology.Name ]
        Here.Research = Data.Force.current_research

        -- Informar de la nueva tecnología
        Here.Flag = not Here.Research
        Here.Flag = Here.Flag or Here.Research.name ~= Here.Technology.Name
        if Here.Flag then Data.gForce.Research = nil end

        -- Validar tecnología habilitada
        if Here.technology.enabled then goto JumpTechnology end

        -- Retirar la tecnología de la cola
        Data.Event.element = Data.GUI.Main.QueueFlow.children[ 1 ]
        Here.Count = ThisMOD.RemoveTechnologyAndDependence( Data, Here.Technology.Name )

        -- Mensaje para una tecnología
        Here.Location = { "",
            "[color=default]",
            { Data.GMOD.Local .. "setting-name" },
            ": [/color]",
            {
                Data.GMOD.Local .. "event",
                {
                    "",
                    "[img=technology/" .. Here.Technology.Name .. "][color=red]",
                    Here.Technology.Localised_name,
                    Here.Technology.Infinite and " " .. Here.Technology.Level or nil,
                    "[/color]"
                },
                {
                    "",
                    "[color=red]",
                    { Data.GMOD.Local .. "removed" },
                    "[/color]"
                },
            }
        }

        -- Mensaje para varias tecnologías
        if Here.Count > 0 then
            table.insert( Here.Location, {
                Data.GMOD.Local .. "and-other",
                "[color=red]" .. Here.Count .. "[/color]",
                Here.Count
            } )
        end

        -- Informar del cambio
        Data.Force.print( Here.Location )
        Update = true

        -- Finalizar codigo
        if true then return true end

        -- Recepción del salto
        :: JumpTechnology ::

        -- Iniciar la investigación de la tecnología
        Data.Force.research_queue = { Here.technology }
    end

    -- Actulizar la ventana flotante
    for _, Player in pairs( Data.Force.players ) do
        local PlayerData = ThisMOD.CreateData( { Player = Player } )
        ThisMOD.UpdateWindowStatus( PlayerData )
    end

    -- Validar si el MOD esta activo
    if not Data.gForce.Status then return end

    -- Hacer la actualización
    while SubFunction( ) do end

    -- Actulizar la ventana flotante
    for _, Player in pairs( Data.Force.players ) do
        local PlayerData = ThisMOD.CreateData( { Player = Player } )
        ThisMOD.UpdateWindowStatus( PlayerData )
    end

    -- Actualizar la interfaz
    if not Update then return end
    ThisMOD.UpdateQueueAndTechnologies( Data )
end

function ThisMOD.SearchPrerequisite( Data )

    -- Validar botón activado
    if not Data.Event.element then return end
    if not Data.Event.element.valid then return end

    -- Validación básica
    if not GPrefix.ClickLeft( Data ) then return end

    -- Renombrar la variable
    local Tags = Data.Event.element.tags

    -- Validar botón
    if not( Tags and Tags.SearchPrerequisites ) then return end
    if not Tags.MOD and Tags.MOD ~= Data.GMOD.Prefix_MOD then return end

    ---> <---     ---> <---     ---> <---

    -- Buscar la tecnología
    table.insert( Data.Temporal, { Technology = Tags.SearchPrerequisites } )
    Data.Event.element = ThisMOD.getButton( Data )

    -- Cargar la tecnología selecionada
    ThisMOD.ToggleTechnology( Data )
end


function ThisMOD.AddTechnologyAndPrerequisites( Data, TechnologyName )

    -- Inicializar las variables
    local Count = 0
    local Technology = Data.Technologies.All[ TechnologyName ]

    -- Cargar los prerequisitos
    for Prerequisite, _ in pairs( Technology.Prerequisites ) do
        local InQueue = GPrefix.getKey( Data.Queue, Prerequisite )
        local Researched = Data.Technologies.Researched[ Prerequisite ]
        if not( InQueue or Researched ) then
            table.insert( Data.Queue, Prerequisite )
            Count = Count + 1
        end
    end

    -- Agregar la tecnología
    table.insert( Data.Queue, TechnologyName )

    -- Devolver la información
    return Count
end

function ThisMOD.RemoveTechnologyAndDependence( Data, TechnologyName )

    -- Inicializar las variables
    local Count = 0

    -- Enlistar las tecnologías afectadas
    local Technologies = { }
    for _, Technology in pairs( Data.Queue ) do
        Technology = Data.Technologies.All[ Technology ]
        if Technology.Prerequisites[ TechnologyName ] then
            table.insert( Technologies, Technology.Name )
            Count = Count + 1
        end
    end

    -- Agregar la tecnología
    table.insert( Technologies, TechnologyName )

    -- Identificar la posición del botón
    local Buttons = { }
    for _, Button in pairs( Data.GUI.Main.QueueFlow.children ) do
        if Button.tags.Technology == TechnologyName then
            table.insert( Buttons, Button )
        end
    end

    -- Identificar el botón a eliminar
    local Index = 1
    if #Buttons > 1 then
        local LevelA = Data.Event.element.tags.Level
        for Key, Button in pairs( Buttons ) do
            local LevelB = Button.tags.Level
            if LevelA == LevelB then
                Index = Key   break
            end
        end
    end

    -- Retirar las tecnologías de la cola
    for _, Technology in pairs( Technologies ) do
        local Key = GPrefix.getKey( Data.Queue, Technology ) or { }

        -- Cuaquier tecnología
        if not GPrefix.isTable( Key ) then
            local Position = tonumber( Key, 10 )
            table.remove( Data.Queue, Position )
        end

        -- Tecnología infinita
        if GPrefix.isTable( Key ) then
            for i = #Key, Index, -1 do
                table.remove( Data.Queue, Key[ i ] )
                Count = Count + 1
            end
        end
    end

    -- Devolver la información
    return Count
end

function ThisMOD.PrioritizeTechnologyAndPrerequisites( Data, TechnologyName )

    -- Inicializar las variables
    local Count = 0
    local Queue = { }
    local Technologies = { }
    local _Technology = Data.Technologies.All[ TechnologyName ]

    -- Identificar la posición del botón
    local Buttons = { }
    for _, Button in pairs( Data.GUI.Main.QueueFlow.children ) do
        if Button.tags.Technology == TechnologyName then
            table.insert( Buttons, Button )
        end
    end

    -- Identificar el botón a eliminar
    local Index = 0
    if #Buttons > 1 then
        local LevelA = Data.Event.element.tags.Level
        for Key, Button in pairs( Buttons ) do
            local LevelB = Button.tags.Level
            if LevelA == LevelB then
                Index = Key   break
            end
        end
    end

    -- Cargar la lista de prerequisitos
    for Prerequisite, _ in pairs( _Technology.Prerequisites ) do
        table.insert( Technologies, Prerequisite )
    end table.insert( Technologies, TechnologyName )

    -- Colocar en el orden existente
    for _, Technology in pairs( Data.Queue ) do
        if GPrefix.getKey( Technologies, Technology ) then
            table.insert( Queue, Technology )
        end
    end

    -- Corrección a la tecnologías infinitas
    repeat
        if Index < 1 then break end
        local Keys = GPrefix.getKey( Queue, TechnologyName ) or { }
        if Index + 1 > #Keys then break end
        for i = Keys[ Index + 1 ], #Queue, 1 do
            table.remove( Queue )
        end
    until true

    -- Contar las tecnologías a mover
    for i = 1, #Queue, 1 do
        local Flag = Queue[ i ] == Data.Queue[ i ]
        if not Flag then Count = Count + 1 end
    end if Count < 1 then return end

    -- Sacar las tecnologías de la cola
    for _, Technology in pairs( Queue ) do
        local Key = GPrefix.getKey( Data.Queue, Technology ) or { }

        -- Tecnología finita
        if not GPrefix.isTable( Key ) then
            local Position = tonumber( Key, 10 )
            table.remove( Data.Queue, Position )
        end

        -- Tecnología infinita
        if GPrefix.isTable( Key ) then
            table.remove( Data.Queue, Key[ 1 ] )
        end
    end

    -- Agregar las tecnologías al inicio de la cola
    for i = 1, #Queue, 1 do
        local Technology = Queue[ i ]
        table.insert( Data.Queue, i, Technology )
    end

    -- Devolver la información
    return Count - 1
end



-- Eventos de la investigación en curso

function ThisMOD.ResearchStarted( Event )

    -- Inicializar las variables
    Event.force = Event.force or Event.research.force
    local Data = ThisMOD.CreateData( Event )

    -- Validar si el MOD está activo
    if not Data.gForce.Status then
        if Data.Force.current_research then return end
        for _, Player in pairs( Data.Force.players ) do
            local PlayerData = ThisMOD.CreateData( { Player = Player } )
            ThisMOD.UpdateWindowStatus( PlayerData )
        end return
    end

    -- Validar e inicializar la tecnología
    if not GPrefix.isUserData( Event.research[ "__self" ] ) then
        local TechnologyName, _ = next( Event.research )
        Event.research = Data.Force.technologies[ TechnologyName ]
    end

    -- Seleccionar la tecnología en RAM
    local Technology = Event.research.name
    Technology = Data.Technologies.All[ Technology ]

    -- Validar si se informa del cambio
    if #Event.force.players < 1 then return end

    ---> <---     ---> <---     ---> <---

    -- Validar si se informa o no del cambio
    if Data.gForce.Research then goto JumpTechnology end

    -- Se esta investigando sin permiso
    if #Data.Queue < 1 then Data.Force.research_queue = { } return end

    -- Guardar el nombre de la tecnología actual
    Data.gForce.Research = Technology.Name

    -- Informar del cambio
    Data.Force.print( { "",
        "[color=default]",
        { Data.GMOD.Local .. "setting-name" },
        ": [/color]",
        {
            Data.GMOD.Local .. "event",
            {
                "",
                "[img=technology/" .. Technology.Name .. "][color=blue]",
                Technology.Localised_name,
                Technology.Infinite and " " .. Technology.Level or nil,
                "[/color]"
            },
            {
                "",
                "[color=blue]",
                { Data.GMOD.Local .. "started" },
                "[/color]"
            },
        }
    } )

    -- Finalizar codigo
    if true then return end

    -- Recepción del salto
    :: JumpTechnology ::

    ---> <---     ---> <---     ---> <---

    -- Inicializar las variables
    local ActualResearch = Data.Force.current_research
    local Flag = true

    -- Se esta investigando la tecnología esperada
    Flag = true
    Flag = Flag and ActualResearch
    Flag = Flag and #Data.Queue > 0
    Flag = Flag and Data.gForce.Research
    Flag = Flag and ActualResearch.name == Data.Queue[ 1 ]
    Flag = Flag and ActualResearch.name == Data.gForce.Research
    if Flag then return end

    -- No se debe estar investigando
    Flag = true
    Flag = Flag and #Data.Queue < 1
    Flag = Flag and not ActualResearch
    Flag = Flag and not Data.gForce.Research
    if Flag then return end

    ---> <---     ---> <---     ---> <---

    -- Actulizar la ventana flotante
    for _, Player in pairs( Data.Force.players ) do
        local PlayerData = ThisMOD.CreateData( { Player = Player } )
        ThisMOD.UpdateWindowStatus( PlayerData )
    end

    -- Detectar y romper bucles
    ThisMOD.BraekLoop( Data )

    -- No hay tecnologías en cola
    if #Data.Queue < 1 then
        Data.gForce.Research = nil
        Data.Force.research_queue = { }
        return
    end

    -- Restaurar la investigación en curso
    Technology = Data.Queue[ 1 ]
    Data.gForce.Research = Technology
    Technology = Data.Force.technologies[ Technology ]
    Data.Force.research_queue = { Technology }
end

function ThisMOD.ResearchCancelled( Event )
    ThisMOD.ResearchStarted( Event )
end

function ThisMOD.ResearchFinished( Event )

    -- Inicializar las variables
    Event.force = Event.force or Event.research.force
    local Data = ThisMOD.CreateData( Event )
    if not Data.Technologies then return end

    -- Inicializar la tecnología en RAM
    local Technology = Event.research.name
    Technology = Data.Technologies.All[ Technology ]

    -- Validar si se informa del cambio
    if #Event.force.players < 1 then return end

    ---> <---     ---> <---     ---> <---

    -- Actulizar la ventana flotante
    if not Data.gForce.Status then
        for _, Player in pairs( Data.Force.players ) do
            local PlayerData = ThisMOD.CreateData( { Player = Player } )
            ThisMOD.UpdateWindowStatus( PlayerData )
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Validar si el MOD está activo
    if not Data.gForce.Status then goto JumpInfo end

    -- Informar del cambio
    Data.Force.print( { "",
        "[color=default]",
        { Data.GMOD.Local .. "setting-name" },
        ": [/color]",
        {
            Data.GMOD.Local .. "event",
            {
                "",
                "[img=technology/" .. Technology.Name .. "][color=green]",
                Technology.Localised_name,
                Technology.Infinite and " " .. Technology.Level or nil,
                "[/color]"
            },
            {
                "",
                "[color=green]",
                { Data.GMOD.Local .. "finished" },
                "[/color]"
            },
        }
    } )

    -- Recepción del salto
    :: JumpInfo ::

    -- Remover la tecnología de la cola
    local Key = GPrefix.getKey( Data.Queue, Technology.Name ) or { }
    if GPrefix.isTable( Key ) then Key = Key[ 1 ] end
    table.remove( Data.Queue, tonumber( Key or "", 10 ) )

    -- Marcar la tecnología como investigada
    if not Technology.Infinite then
        Data.Technologies.Researched[ Technology.Name ] = Event.research
    end

    if Technology.Infinite then
        Technology.Level = Event.research.level
    end

    -- Cargar los datos de la tecnología
    if Event.by_script then Data.gForce.Researchs = nil end
    local Research = Data.gForce.Researchs or { }
    if not Research[ Technology.Name ] then goto JumpResech end

    -- Calcular el nuevo factor de investigación
    Research = Research[ Technology.Name ]
    if Research.UpdateTick > 1 then Research.Seconds = Research.Seconds + 1 end
    Data.gForce.Factor = Technology.Time * Technology.Amount / ( Research.Seconds or 1 )

    -- Liberar el esapcio
    Data.gForce.Researchs[ Technology.Name ] = nil

    -- Recepción del salto
    :: JumpResech ::

    -- Actualizar la información visible
    ThisMOD.UpdateQueueAndTechnologies( Data )

    -- Guardar el nombre de la tecnología actual
    Data.gForce.Research = nil

    -- Actualizar la tecnología en curso
    ThisMOD.UpdateReseach( Data )
end

function ThisMOD.ResearchReversed( Event )

    -- Inicializar las variables
    Event.force = Event.force or Event.research.force
    local Data = ThisMOD.CreateData( Event )

    -- Inicializar la tecnología en RAM
    local Technology = Event.research.name
    Technology = Data.Technologies.All[ Technology ]

    -- Validar si se informa del cambio
    if #Event.force.players < 1 then return end

    ---> <---     ---> <---     ---> <---

    -- Validar si el MOD está activo
    if not Data.gForce.Status then goto JumpInfo end

    -- Informar del cambio
    Data.Force.print( { "",
        "[color=default]",
        { Data.GMOD.Local .. "setting-name" },
        ": [/color]",
        {
            Data.GMOD.Local .. "event",
            {
                "",
                "[img=technology/" .. Technology.Name .. "][color=purple]",
                Technology.Localised_name,
                Technology.Infinite and " " .. Technology.Level or nil,
                "[/color]"
            },
            {
                "",
                "[color=purple]",
                { Data.GMOD.Local .. "reversed" },
                "[/color]"
            },
        }
    } )

    -- Recepción del salto
    :: JumpInfo ::

    -- Marcar la tecnología como investigada
    if not Technology.Infinite then
        Data.Technologies.Researched[ Technology.Name ] = nil
    end

    if Technology.Infinite then
        Technology.Level = Event.research.level
    end

    -- Actualizar la información visible
    ThisMOD.UpdateQueueAndTechnologies( Data )

    -- Actualizar la tecnología en curso
    ThisMOD.UpdateReseach( Data )
end



function ThisMOD.Control( )
    if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    GPrefix.addEvent( {

        -- Al crear la partida
        [ "on_init" ] = ThisMOD.Initialize,

        -- Al cargar la partida
        [ "on_load" ] = ThisMOD.Initialize,

        -- Al cambiarce de grupo
        [ { "on_event", defines.events.on_player_changed_force } ] = function( Event )
            ThisMOD.Initialized[ Event.player_index ] = nil
        end,

        ---> <---     ---> <---     ---> <---

        -- Al usar la combinación de teclas
        [ { "on_event", ThisMOD.Prefix_MOD } ] = function( Event )
            ThisMOD.ToggleWindowMain( ThisMOD.CreateData( Event ) )
        end,

        -- Al cerrar la interfaz cuando se abre otra
        [ { "on_event", defines.events.on_gui_closed } ] = function( Event )
            ThisMOD.ToggleWindowMain( ThisMOD.CreateData( Event ) )
        end,

        -- Al hacer click en el botón del acceso rapido
        [ { "on_event", defines.events.on_lua_shortcut } ] = function( Event )
            ThisMOD.ToggleWindowMain( ThisMOD.CreateData( Event ) )
        end,

        ---> <---     ---> <---     ---> <---

        -- Al presionar confirmar en la interfaz
        [ { "on_event", defines.events.on_gui_confirmed } ] = function( Event )
            ThisMOD.SearchText( ThisMOD.CreateData( Event ) )
        end,

        -- Al hacer click en un elemento
        [ { "on_event", defines.events.on_gui_click } ] = function( Event )

            -- Cargar la información en una estructura
            local Data = ThisMOD.CreateData( Event )

            -- Acciones del jugador
            ThisMOD.PrioritizeResearch( Data )
            ThisMOD.SearchPrerequisite( Data )
            ThisMOD.CancelResearch( Data )
            ThisMOD.AddResearch( Data )

            ThisMOD.ToggleWindowStatus( Data )
            ThisMOD.ToggleTechnologies( Data )
            ThisMOD.ToggleTechnology( Data )
            ThisMOD.ToggleWindowMain( Data )
            ThisMOD.ToggleTextfield( Data )
            ThisMOD.ToggleMOD( Data )
        end,

        ---> <---     ---> <---     ---> <---

        -- Eventos de la investigación en curso
        [ { "on_event", defines.events.on_research_started } ] = ThisMOD.ResearchStarted,
        [ { "on_event", defines.events.on_research_cancelled } ] = ThisMOD.ResearchCancelled,
        [ { "on_event", defines.events.on_research_finished } ] = ThisMOD.ResearchFinished,
        [ { "on_event", defines.events.on_research_reversed } ] = ThisMOD.ResearchReversed,

        -- Guardar la nueva posición de la ventana flotante
        [ { "on_event", defines.events.on_gui_location_changed } ] = function( Event )
            ThisMOD.SaveLocationWindowStatus( ThisMOD.CreateData( Event ) )
        end,

        -- Eliminar todas las ventana
        [ { "on_event", defines.events.on_surface_deleted } ] = ThisMOD.ClearScreen,

    } )
end

-- Cargar los eventos
ThisMOD.Control( )

---------------------------------------------------------------------------------------------------