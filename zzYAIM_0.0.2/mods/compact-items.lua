---------------------------------------------------------------------------------------------------

--> compact-items.lua <--

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
    SettingOption.type  = "int-setting"
    SettingOption.order = ThisMOD.Char
    SettingOption.setting_type  = "startup"
    SettingOption.default_value = 10
    SettingOption.minimum_value = 1
    SettingOption.maximum_value = 65000
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

-- Cargar las infomación
function ThisMOD.LoadCompact( )

    -- Crear el sub grupo
    data:extend( {
        {
            [ 'type' ] = 'item-subgroup',
            [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'compacts',
            [ 'group' ] = 'logistics',
            [ 'order' ] = 'b[belt]-c',
        },
        {
            [ 'type' ] = 'recipe-category',
            [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'compact',
        },
        {
            [ 'type' ] = 'recipe-category',
            [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'uncompact',
        }
    } )

    -- Inicializar el contenedor
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info
    Info.Table = { }

    ThisMOD.LoadEntities( Info )
    ThisMOD.LoadRecipes( Info )
    ThisMOD.LoadItems( Info )
    ThisMOD.doChange( Info )
end


-- Crear el prototipo
function ThisMOD.LoadEntities( Info )

    -- Crear los prototipos
    Info.Entities = {
        [ 'compact' ] = {
            [ 'type' ] = 'furnace',
            [ 'name' ] = 'compact',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-mask.png',
                    [ 'tint' ] = {
                        [ 'r' ] = 210,
                        [ 'g' ] = 180,
                        [ 'b' ] = 80,
                    },
                },
            },
            [ 'icon_size' ] = 64,
            [ 'icon_mipmaps' ] = 4,
            [ 'flags' ] = {
                [ 1 ] = 'placeable-neutral',
                [ 2 ] = 'placeable-player',
                [ 3 ] = 'player-creation',
            },
            [ 'animation' ] = {
                [ 'layers' ] = {
                    [ 1 ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-base.png',
                            [ 'animation_speed' ] = 1,
                            [ 'priority' ] = 'high',
                            [ 'frame_count' ] = 60,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 96,
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-base.png',
                        [ 'animation_speed' ] = 1,
                        [ 'priority' ] = 'high',
                        [ 'frame_count' ] = 60,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 48,
                    },
                    [ 2 ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-mask.png',
                            [ 'animation_speed' ] = 1,
                            [ 'priority' ] = 'high',
                            [ 'repeat_count' ] = 60,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 96,
                            [ 'tint' ] = {
                                [ 'r' ] = 210,
                                [ 'g' ] = 180,
                                [ 'b' ] = 80,
                            },
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-mask.png',
                        [ 'animation_speed' ] = 1,
                        [ 'priority' ] = 'high',
                        [ 'repeat_count' ] = 60,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 48,
                        [ 'tint' ] = {
                            [ 'r' ] = 210,
                            [ 'g' ] = 180,
                            [ 'b' ] = 80,
                        },
                    },
                    [ 3 ] = {
                        [ 'hr_version' ] = {
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-shadow.png',
                            [ 'animation_speed' ] = 1,
                            [ 'frame_count' ] = 60,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 144,
                        },
                        [ 'draw_as_shadow' ] = true,
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-shadow.png',
                        [ 'animation_speed' ] = 1,
                        [ 'frame_count' ] = 60,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0.5,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 72,
                    },
                },
            },
            [ 'working_visualisations' ] = {
                [ 1 ] = {
                    [ 'animation' ] = {
                        [ 'hr_version' ] = {
                            [ 'animation_speed' ] = 1,
                            [ 'blend_mode' ] = 'additive',
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-working.png',
                            [ 'frame_count' ] = 30,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'priority' ] = 'high',
                            [ 'scale' ] = 0.5,
                            [ 'tint' ] = {
                                [ 'r' ] = 225,
                                [ 'g' ] = 210,
                                [ 'b' ] = 160,
                            },
                            [ 'width' ] = 96,
                        },
                        [ 'animation_speed' ] = 1,
                        [ 'blend_mode' ] = 'additive',
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-working.png',
                        [ 'frame_count' ] = 30,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'priority' ] = 'high',
                        [ 'tint' ] = {
                            [ 'r' ] = 210,
                            [ 'g' ] = 180,
                            [ 'b' ] = 80,
                        },
                        [ 'width' ] = 48,
                    },
                    [ 'light' ] = {
                        [ 'color' ] = {
                            [ 'r' ] = 225,
                            [ 'g' ] = 210,
                            [ 'b' ] = 160,
                        },
                        [ 'intensity' ] = 0.4,
                        [ 'size' ] = 3,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0.25,
                        },
                    },
                },
            },
            [ 'dying_explosion' ] = 'explosion',
            [ 'corpse' ] = 'small-remnants',
            [ 'module_specification' ] = {
                [ 'module_slots' ] = 0,
                [ 'module_info_icon_shift' ] = {
                    [ 1 ] = 0,
                    [ 2 ] = 0.25,
                },
            },
            [ 'allowed_effects' ] = {
                [ 1 ] = 'consumption',
            },
            [ 'max_health' ] = 180,
            [ 'collision_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.2,
                    [ 2 ] = -0.2,
                },
                [ 2 ] = {
                    [ 1 ] = 0.2,
                    [ 2 ] = 0.2,
                },
            },
            [ 'selection_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.5,
                    [ 2 ] = -0.5,
                },
                [ 2 ] = {
                    [ 1 ] = 0.5,
                    [ 2 ] = 0.5,
                },
            },
            [ 'drawing_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.5,
                    [ 2 ] = -0.5,
                },
                [ 2 ] = {
                    [ 1 ] = 0.5,
                    [ 2 ] = 0.5,
                },
            },
            [ 'result_inventory_size' ] = 1,
            [ 'source_inventory_size' ] = 1,
            [ 'crafting_speed' ] = 1,
            [ 'energy_source' ] = {
                [ 'type' ] = 'electric',
                [ 'emissions_per_minute' ] = 3,
                [ 'usage_priority' ] = 'secondary-input',
                [ 'drain' ] = '15kW',
            },
            [ 'energy_usage' ] = '90kW',
            [ 'resistances' ] = {
                [ 1 ] = {
                    [ 'type' ] = 'fire',
                    [ 'percent' ] = 50,
                },
            },
            [ 'vehicle_impact_sound' ] = {
                [ 'filename' ] = '__base__/sound/car-metal-impact.ogg',
                [ 'volume' ] = 1,
            },
            [ 'working_sound' ] = {
                [ 'match_speed_to_activity' ] = true,
                [ 'idle_sound' ] = {
                    [ 'filename' ] = '__base__/sound/idle1.ogg',
                    [ 'volume' ] = 0.6,
                },
                [ 'sound' ] = {
                    [ 'filename' ] = ThisMOD.Patch .. 'sounds/fan.ogg',
                    [ 'volume' ] = 1,
                },
                [ 'max_sounds_per_type' ] = 3,
            },
            [ 'show_recipe_icon' ] = true,
            [ 'fast_replaceable_group' ] = 'transport-belt',
            [ 'next_upgrade' ] = 'fast-compact',
        },
        [ 'fast-compact' ] = {
            [ 'type' ] = 'furnace',
            [ 'name' ] = 'fast-compact',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-mask.png',
                    [ 'tint' ] = {
                        [ 'r' ] = 210,
                        [ 'g' ] = 60,
                        [ 'b' ] = 60,
                    },
                },
            },
            [ 'icon_size' ] = 64,
            [ 'icon_mipmaps' ] = 4,
            [ 'flags' ] = {
                [ 1 ] = 'placeable-neutral',
                [ 2 ] = 'placeable-player',
                [ 3 ] = 'player-creation',
            },
            [ 'animation' ] = {
                [ 'layers' ] = {
                    [ 1 ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-base.png',
                            [ 'animation_speed' ] = 0.5,
                            [ 'priority' ] = 'high',
                            [ 'frame_count' ] = 60,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 96,
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-base.png',
                        [ 'animation_speed' ] = 0.5,
                        [ 'priority' ] = 'high',
                        [ 'frame_count' ] = 60,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 48,
                    },
                    [ 2 ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-mask.png',
                            [ 'animation_speed' ] = 0.5,
                            [ 'priority' ] = 'high',
                            [ 'repeat_count' ] = 60,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 96,
                            [ 'tint' ] = {
                                [ 'r' ] = 210,
                                [ 'g' ] = 60,
                                [ 'b' ] = 60,
                            },
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-mask.png',
                        [ 'animation_speed' ] = 0.5,
                        [ 'priority' ] = 'high',
                        [ 'repeat_count' ] = 60,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 48,
                        [ 'tint' ] = {
                            [ 'r' ] = 210,
                            [ 'g' ] = 60,
                            [ 'b' ] = 60,
                        },
                    },
                    [ 3 ] = {
                        [ 'hr_version' ] = {
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-shadow.png',
                            [ 'animation_speed' ] = 0.5,
                            [ 'frame_count' ] = 60,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 144,
                        },
                        [ 'draw_as_shadow' ] = true,
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-shadow.png',
                        [ 'animation_speed' ] = 0.5,
                        [ 'frame_count' ] = 60,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0.5,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 72,
                    },
                },
            },
            [ 'working_visualisations' ] = {
                [ 1 ] = {
                    [ 'animation' ] = {
                        [ 'hr_version' ] = {
                            [ 'animation_speed' ] = 0.5,
                            [ 'blend_mode' ] = 'additive',
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-working.png',
                            [ 'frame_count' ] = 30,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'priority' ] = 'high',
                            [ 'scale' ] = 0.5,
                            [ 'tint' ] = {
                                [ 'r' ] = 225,
                                [ 'g' ] = 150,
                                [ 'b' ] = 150,
                            },
                            [ 'width' ] = 96,
                        },
                        [ 'animation_speed' ] = 0.5,
                        [ 'blend_mode' ] = 'additive',
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-working.png',
                        [ 'frame_count' ] = 30,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'priority' ] = 'high',
                        [ 'tint' ] = {
                            [ 'r' ] = 210,
                            [ 'g' ] = 60,
                            [ 'b' ] = 60,
                        },
                        [ 'width' ] = 48,
                    },
                    [ 'light' ] = {
                        [ 'color' ] = {
                            [ 'r' ] = 225,
                            [ 'g' ] = 150,
                            [ 'b' ] = 150,
                        },
                        [ 'intensity' ] = 0.4,
                        [ 'size' ] = 3,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0.25,
                        },
                    },
                },
            },
            [ 'dying_explosion' ] = 'explosion',
            [ 'corpse' ] = 'small-remnants',
            [ 'module_specification' ] = {
                [ 'module_slots' ] = 0,
                [ 'module_info_icon_shift' ] = {
                    [ 1 ] = 0,
                    [ 2 ] = 0.25,
                },
            },
            [ 'allowed_effects' ] = {
                [ 1 ] = 'consumption',
            },
            [ 'max_health' ] = 180,
            [ 'collision_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.2,
                    [ 2 ] = -0.2,
                },
                [ 2 ] = {
                    [ 1 ] = 0.2,
                    [ 2 ] = 0.2,
                },
            },
            [ 'selection_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.5,
                    [ 2 ] = -0.5,
                },
                [ 2 ] = {
                    [ 1 ] = 0.5,
                    [ 2 ] = 0.5,
                },
            },
            [ 'drawing_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.5,
                    [ 2 ] = -0.5,
                },
                [ 2 ] = {
                    [ 1 ] = 0.5,
                    [ 2 ] = 0.5,
                },
            },
            [ 'result_inventory_size' ] = 1,
            [ 'source_inventory_size' ] = 1,
            [ 'crafting_speed' ] = 2,
            [ 'energy_source' ] = {
                [ 'type' ] = 'electric',
                [ 'emissions_per_minute' ] = 1.5,
                [ 'usage_priority' ] = 'secondary-input',
                [ 'drain' ] = '15kW',
            },
            [ 'energy_usage' ] = '180kW',
            [ 'resistances' ] = {
                [ 1 ] = {
                    [ 'type' ] = 'fire',
                    [ 'percent' ] = 50,
                },
            },
            [ 'vehicle_impact_sound' ] = {
                [ 'filename' ] = '__base__/sound/car-metal-impact.ogg',
                [ 'volume' ] = 1,
            },
            [ 'working_sound' ] = {
                [ 'match_speed_to_activity' ] = true,
                [ 'idle_sound' ] = {
                    [ 'filename' ] = '__base__/sound/idle1.ogg',
                    [ 'volume' ] = 0.6,
                },
                [ 'sound' ] = {
                    [ 'filename' ] = ThisMOD.Patch .. 'sounds/fan.ogg',
                    [ 'volume' ] = 1,
                },
                [ 'max_sounds_per_type' ] = 3,
            },
            [ 'show_recipe_icon' ] = true,
            [ 'fast_replaceable_group' ] = 'transport-belt',
            [ 'next_upgrade' ] = 'express-compact',
        },
        [ 'express-compact' ] = {
            [ 'type' ] = 'furnace',
            [ 'name' ] = 'express-compact',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-mask.png',
                    [ 'tint' ] = {
                        [ 'r' ] = 80,
                        [ 'g' ] = 180,
                        [ 'b' ] = 210,
                    },
                },
            },
            [ 'icon_size' ] = 64,
            [ 'icon_mipmaps' ] = 4,
            [ 'flags' ] = {
                [ 1 ] = 'placeable-neutral',
                [ 2 ] = 'placeable-player',
                [ 3 ] = 'player-creation',
            },
            [ 'animation' ] = {
                [ 'layers' ] = {
                    [ 1 ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-base.png',
                            [ 'animation_speed' ] = 0.33333333333333,
                            [ 'priority' ] = 'high',
                            [ 'frame_count' ] = 60,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 96,
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-base.png',
                        [ 'animation_speed' ] = 0.33333333333333,
                        [ 'priority' ] = 'high',
                        [ 'frame_count' ] = 60,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 48,
                    },
                    [ 2 ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-mask.png',
                            [ 'animation_speed' ] = 0.33333333333333,
                            [ 'priority' ] = 'high',
                            [ 'repeat_count' ] = 60,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 96,
                            [ 'tint' ] = {
                                [ 'r' ] = 80,
                                [ 'g' ] = 180,
                                [ 'b' ] = 210,
                            },
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-mask.png',
                        [ 'animation_speed' ] = 0.33333333333333,
                        [ 'priority' ] = 'high',
                        [ 'repeat_count' ] = 60,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 48,
                        [ 'tint' ] = {
                            [ 'r' ] = 80,
                            [ 'g' ] = 180,
                            [ 'b' ] = 210,
                        },
                    },
                    [ 3 ] = {
                        [ 'hr_version' ] = {
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-shadow.png',
                            [ 'animation_speed' ] = 0.33333333333333,
                            [ 'frame_count' ] = 60,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                            [ 'width' ] = 144,
                        },
                        [ 'draw_as_shadow' ] = true,
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-shadow.png',
                        [ 'animation_speed' ] = 0.33333333333333,
                        [ 'frame_count' ] = 60,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0.5,
                            [ 2 ] = 0,
                        },
                        [ 'width' ] = 72,
                    },
                },
            },
            [ 'working_visualisations' ] = {
                [ 1 ] = {
                    [ 'animation' ] = {
                        [ 'hr_version' ] = {
                            [ 'animation_speed' ] = 0.33333333333333,
                            [ 'blend_mode' ] = 'additive',
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/beltbox-working.png',
                            [ 'frame_count' ] = 30,
                            [ 'line_length' ] = 10,
                            [ 'height' ] = 96,
                            [ 'priority' ] = 'high',
                            [ 'scale' ] = 0.5,
                            [ 'tint' ] = {
                                [ 'r' ] = 160,
                                [ 'g' ] = 210,
                                [ 'b' ] = 225,
                            },
                            [ 'width' ] = 96,
                        },
                        [ 'animation_speed' ] = 0.33333333333333,
                        [ 'blend_mode' ] = 'additive',
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/beltbox-working.png',
                        [ 'frame_count' ] = 30,
                        [ 'line_length' ] = 10,
                        [ 'height' ] = 48,
                        [ 'priority' ] = 'high',
                        [ 'tint' ] = {
                            [ 'r' ] = 80,
                            [ 'g' ] = 180,
                            [ 'b' ] = 210,
                        },
                        [ 'width' ] = 48,
                    },
                    [ 'light' ] = {
                        [ 'color' ] = {
                            [ 'r' ] = 160,
                            [ 'g' ] = 210,
                            [ 'b' ] = 225,
                        },
                        [ 'intensity' ] = 0.4,
                        [ 'size' ] = 3,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0.25,
                        },
                    },
                },
            },
            [ 'dying_explosion' ] = 'explosion',
            [ 'corpse' ] = 'small-remnants',
            [ 'module_specification' ] = {
                [ 'module_slots' ] = 0,
                [ 'module_info_icon_shift' ] = {
                    [ 1 ] = 0,
                    [ 2 ] = 0.25,
                },
            },
            [ 'allowed_effects' ] = {
                [ 1 ] = 'consumption',
            },
            [ 'max_health' ] = 180,
            [ 'collision_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.2,
                    [ 2 ] = -0.2,
                },
                [ 2 ] = {
                    [ 1 ] = 0.2,
                    [ 2 ] = 0.2,
                },
            },
            [ 'selection_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.5,
                    [ 2 ] = -0.5,
                },
                [ 2 ] = {
                    [ 1 ] = 0.5,
                    [ 2 ] = 0.5,
                },
            },
            [ 'drawing_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.5,
                    [ 2 ] = -0.5,
                },
                [ 2 ] = {
                    [ 1 ] = 0.5,
                    [ 2 ] = 0.5,
                },
            },
            [ 'result_inventory_size' ] = 1,
            [ 'source_inventory_size' ] = 1,
            [ 'crafting_speed' ] = 3,
            [ 'energy_source' ] = {
                [ 'type' ] = 'electric',
                [ 'emissions_per_minute' ] = 1,
                [ 'usage_priority' ] = 'secondary-input',
                [ 'drain' ] = '15kW',
            },
            [ 'energy_usage' ] = '270kW',
            [ 'resistances' ] = {
                [ 1 ] = {
                    [ 'type' ] = 'fire',
                    [ 'percent' ] = 50,
                },
            },
            [ 'vehicle_impact_sound' ] = {
                [ 'filename' ] = '__base__/sound/car-metal-impact.ogg',
                [ 'volume' ] = 1,
            },
            [ 'working_sound' ] = {
                [ 'match_speed_to_activity' ] = true,
                [ 'idle_sound' ] = {
                    [ 'filename' ] = '__base__/sound/idle1.ogg',
                    [ 'volume' ] = 0.6,
                },
                [ 'sound' ] = {
                    [ 'filename' ] = ThisMOD.Patch .. 'sounds/fan.ogg',
                    [ 'volume' ] = 1,
                },
                [ 'max_sounds_per_type' ] = 3,
            },
            [ 'show_recipe_icon' ] = true,
            [ 'fast_replaceable_group' ] = 'transport-belt',
        },
    }

    -- Modificar los prototipos
    for _, Entity in pairs( Info.Entities ) do
        Entity.minable = {
            [ 'mining_time' ] = 0.1,
            [ 'result' ] = Entity.name,
        }

        Entity.crafting_categories = {
            [ 1 ] = ThisMOD.Prefix_MOD_ .. "compact",
            [ 2 ] = ThisMOD.Prefix_MOD_ .. "uncompact",
        }

        if Entity.next_upgrade then
            Entity.next_upgrade = ThisMOD.Prefix_MOD_ .. Entity.next_upgrade
        end

        table.insert( Info.Table, Entity )
    end
end

-- Crear el prototipo
function ThisMOD.LoadItems( Info )

    -- Crear los prototipos
    Info.Items = {
        [ 'compact' ] = {
            [ 'type' ] = 'item',
            [ 'name' ] = 'compact',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-mask.png',
                    [ 'tint' ] = {
                        [ 'r' ] = 210,
                        [ 'g' ] = 180,
                        [ 'b' ] = 80,
                    },
                },
            },
            [ 'icon_size' ] = 64,
            [ 'icon_mipmaps' ] = 4,
            [ 'stack_size' ] = 50,
            [ 'place_result' ] = 'compact',
            [ 'group' ] = 'logistics',
            [ 'subgroup' ] = 'compacts',
            [ 'order' ] = 'ba',
        },
        [ 'fast-compact' ] = {
            [ 'type' ] = 'item',
            [ 'name' ] = 'fast-compact',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-mask.png',
                    [ 'tint' ] = {
                        [ 'r' ] = 210,
                        [ 'g' ] = 60,
                        [ 'b' ] = 60,
                    },
                },
            },
            [ 'icon_size' ] = 64,
            [ 'icon_mipmaps' ] = 4,
            [ 'stack_size' ] = 50,
            [ 'place_result' ] = 'fast-compact',
            [ 'group' ] = 'logistics',
            [ 'subgroup' ] = 'compacts',
            [ 'order' ] = 'bb',
        },
        [ 'express-compact' ] = {
            [ 'type' ] = 'item',
            [ 'name' ] = 'express-compact',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/beltbox-icon-mask.png',
                    [ 'tint' ] = {
                        [ 'r' ] = 80,
                        [ 'g' ] = 180,
                        [ 'b' ] = 210,
                    },
                },
            },
            [ 'icon_size' ] = 64,
            [ 'icon_mipmaps' ] = 4,
            [ 'stack_size' ] = 50,
            [ 'place_result' ] = 'express-compact',
            [ 'group' ] = 'logistics',
            [ 'subgroup' ] = 'compacts',
            [ 'order' ] = 'bc',
        },
    }

    -- Modificar los prototipos
    for _, Item in pairs( Info.Items ) do
        Item.subgroup = ThisMOD.Prefix_MOD_ .. Item.subgroup
        table.insert( Info.Table, Item )
    end
end

-- Crear el prototipo
function ThisMOD.LoadRecipes( Info )

    -- Crear los prototipos
    Info.Recipes = {
        [ 'compact' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'compact',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'compacts',
                [ 'order' ] = 'ba',
                [ 'enabled' ] = false,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = 'transport-belt',
                        [ 2 ] = 4,
                    },
                    [ 2 ] = {
                        [ 1 ] = 'iron-plate',
                        [ 2 ] = 10,
                    },
                    [ 3 ] = {
                        [ 1 ] = 'iron-gear-wheel',
                        [ 2 ] = 10,
                    },
                    [ 4 ] = {
                        [ 1 ] = 'electronic-circuit',
                        [ 2 ] = 4,
                    },
                },
                [ 'result' ] = 'compact',
                [ 'energy_required' ] = 3,
            },
        },
        [ 'fast-compact' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'fast-compact',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'compacts',
                [ 'order' ] = 'bb',
                [ 'enabled' ] = false,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = ThisMOD.Prefix_MOD_ .. 'compact',
                        [ 2 ] = 1,
                    },
                    [ 2 ] = {
                        [ 1 ] = 'iron-plate',
                        [ 2 ] = 20,
                    },
                    [ 3 ] = {
                        [ 1 ] = 'iron-gear-wheel',
                        [ 2 ] = 20,
                    },
                    [ 4 ] = {
                        [ 1 ] = 'advanced-circuit',
                        [ 2 ] = 2,
                    },
                },
                [ 'result' ] = 'fast-compact',
                [ 'energy_required' ] = 3,
            },
        },
        [ 'express-compact' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'express-compact',
                [ 'category' ] = 'crafting-with-fluid',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'compacts',
                [ 'order' ] = 'bc',
                [ 'enabled' ] = false,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = ThisMOD.Prefix_MOD_ .. 'fast-compact',
                        [ 2 ] = 1,
                    },
                    [ 2 ] = {
                        [ 1 ] = 'iron-plate',
                        [ 2 ] = 30,
                    },
                    [ 3 ] = {
                        [ 1 ] = 'iron-gear-wheel',
                        [ 2 ] = 30,
                    },
                    [ 4 ] = {
                        [ 'name' ] = 'lubricant',
                        [ 'type' ] = 'fluid',
                        [ 'amount' ] = 100,
                    },
                },
                [ 'result' ] = 'express-compact',
                [ 'energy_required' ] = 3,
            },
        },		
    }

    -- Modificar los prototipos
    for _, Array in pairs( Info.Recipes ) do
        for _, Recipe in pairs( Array ) do
            Recipe.subgroup = ThisMOD.Prefix_MOD_ .. Recipe.subgroup
            table.insert( Info.Table, Recipe )
        end
    end
end

-- Hacer el cabio en los prototipos
function ThisMOD.doChange( Info )
    local PrefixFind = ThisMOD.Prefix_MOD_
    PrefixFind = string.gsub( PrefixFind, "-", "%%-" )
    for _, Element in pairs( Info.Table ) do
        Element.localised_name = {
            ThisMOD.Local .. string.gsub( Element.name, PrefixFind, "" )
        }

        Element.localised_description = {
            ThisMOD.Local .. "entity-description"
        }
    end
end

-- Asignar las recetas a una tecnología
function ThisMOD.addTechnologie( )

    -- Inicializar el contenedor
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Table = { }
    table.insert( Table, { "underground-belt", "compact" } )
    table.insert( Table, { "fast-underground-belt", "fast-compact" } )
    table.insert( Table, { "express-underground-belt", "express-compact" } )

    -- Modificar los prototipos
    for _, Value in pairs( Table ) do
        GPrefix.addTechnology( Value[ 1 ], ThisMOD.Prefix_MOD_ .. Value[ 2 ] )
    end
end


-- Identificar los objetos a compactar
function ThisMOD.FindItem( )

    -- Contenedor de los items
    local Items = GPrefix.DeepCopy( GPrefix.Items )

    -- Crear los objetos compactados
    for _, Item in pairs( Items ) do
        ThisMOD.Compact( Item, ThisMOD )
    end
end

-- Crear un item compactado
function ThisMOD.Compact( OldItem, TheMOD )

    -- Tipos a evitar
    local AvoidTypes = { }
    table.insert( AvoidTypes, "car" )
    table.insert( AvoidTypes, "gun" )
    table.insert( AvoidTypes, "armor" )
    table.insert( AvoidTypes, "rail-planner" )
    table.insert( AvoidTypes, "selection-tool" )
    table.insert( AvoidTypes, "spider-vehicle" )
    table.insert( AvoidTypes, "belt-immunity-equipment" )

    -- Patrones a evitar
    local AvoidPatterns = { }
    table.insert( AvoidPatterns, "%-remote" )

    -- Evitar los rieles
    if OldItem.curved_rail then return end

    -- Evitar estos tipos
    if GPrefix.getKey( AvoidTypes, OldItem.type ) then return end

    -- Evitar lo inapilable
    if GPrefix.getKey( OldItem.flags, "hidden" ) then return end
    if GPrefix.getKey( OldItem.flags, "not-stackable" ) then return end

    -- Evitar estos patrones
    for _, Pattern in pairs( AvoidPatterns ) do
        if string.find( OldItem.name, Pattern ) then return end
    end

    -- Existe el subgrupo
    local SubGroup = ThisMOD.Prefix_MOD_ .. OldItem.subgroup
    local Table = data.raw[ "item-subgroup" ][ SubGroup ]
    if Table then goto JumpSubGroup end

    -- Crear el subgrupo
    SubGroup = OldItem.subgroup
    Table = data.raw[ "item-subgroup" ][ SubGroup ]
    Table = GPrefix.DeepCopy( Table )
    Table.name = ThisMOD.Prefix_MOD_ .. OldItem.subgroup
    Table.order = ThisMOD.Prefix_MOD_ .. OldItem.order
    data:extend( { Table } )

    -- Recepción del salto
    :: JumpSubGroup ::

    -- Crear los prototipos
    ThisMOD.CreateItem( OldItem, TheMOD )
    -- ThisMOD.CreateRecipe( Item, TheMOD )
end

-- Crear los objetos compactados
function ThisMOD.CreateItem( OldItem, TheMOD )

    -- Contenedor del nuevo objeto
    local NewItem = { }
    NewItem.type = "item"

    -- Duplicar las propiedades
    local Properties = { }
    table.insert( Properties, "name" )
    table.insert( Properties, "icon" )
    table.insert( Properties, "icons" )
    table.insert( Properties, "order" )
    table.insert( Properties, "subgroup" )
    table.insert( Properties, "icon_size" )
    table.insert( Properties, "stack_size" )
    table.insert( Properties, "icon_mipmaps" )
    table.insert( Properties, "localised_name" )
    for _, Property in pairs( Properties ) do
        NewItem[ Property ] = GPrefix.DeepCopy( OldItem[ Property ] )
    end NewItem.subgroup = ThisMOD.Prefix_MOD_ .. OldItem.subgroup

    -- Ya tiene un apodo
    if OldItem.localised_name then goto JumpLocalised end

    -- Preparar el apodo
    if OldItem.place_result then
        NewItem.localised_name = { "entity-name." .. OldItem.name }
    elseif OldItem.place_as_tile then
        NewItem.localised_name = { "item-name." .. OldItem.name }
    elseif OldItem.placed_as_equipment_result then
        NewItem.localised_name = { "equipment-name." .. OldItem.name }
    else
        NewItem.localised_name = { "item-name." .. OldItem.name }
    end

    -- Recepción del salto
    :: JumpLocalised ::

    -- Sobre escribir las descripciones
    local Array = GPrefix.DeepCopy( NewItem.localised_name )
    if Array[ 1 ] ~= "" then Array = { "", Array } end
    NewItem.localised_description = Array
    table.insert( Array, 2, { ThisMOD.Local .. "item-description" } )
    table.insert( Array, 3, " " .. ThisMOD.Value .. " " )
    table.insert( Array, 4, "[item=" .. NewItem.name .. "] " )

    -- Agregar el pez de referencia
    GPrefix.addIcon( OldItem, NewItem )

    ---> <---     ---> <---     ---> <---

    -- Inicializar y renombrar la variable
    local Info = TheMOD.Information or { }
    TheMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Guardar el nuevo objeto
    Items[ NewItem.name ] = NewItem
end

-- Crear las recetas de compactado
function ThisMOD.CreateRecipe( OldItem, TheMOD )

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Items = Info.Items or { }
    Info.Items = Items

    -- Guardar el nuevo objeto
    Items[ NewItem.name ] = NewItem

    -- Variable contenedora
    local NewItem = GPrefix.Items[ ThisMOD.Prefix_MOD_ .. OldItem.name ]

    -- Valdación básica
    if not NewItem then return end

    -- Valores para la receta
    local recipes      = { }
    recipes.compact    = { }
    recipes.uncompact  = { }

    -- Valores para la descompresion
    recipes.uncompact.name        = ThisMOD.Local .. "uncompact-" .. OldItem.name
    recipes.uncompact.results     = { { type = "item", amount = ThisMOD.Value, name = OldItem.name } }
    recipes.uncompact.ingredients = { { type = "item", amount = 1 , name = ThisMOD.Prefix_MOD_ .. OldItem.name } }
    recipes.uncompact.action      = true

    -- Valores para la compresion
    recipes.compact.name        = ThisMOD.Local .. "compact-" .. OldItem.name
    recipes.compact.results     = { { type = "item", amount = 1 , name = ThisMOD.Prefix_MOD_ .. OldItem.name } }
    recipes.compact.ingredients = { { type = "item", amount = ThisMOD.Value, name = OldItem.name  } }

    ---> <---     ---> <---     ---> <---

    for Category, Recipe in pairs( recipes ) do

        -- Copiar el objeto
        local recipeNew = { }

        -- Crear las recetas
        recipeNew.name = Recipe.name
        recipeNew.type = "recipe"

        recipeNew.order    = OldItem.order
        recipeNew.enabled  = false
        recipeNew.category = Category
        recipeNew.subgroup = ThisMOD.Prefix_MOD_ .. OldItem.subgroup

        recipeNew.results      = Recipe.results
        recipeNew.ingredients  = Recipe.ingredients
        recipeNew.main_product = ""

        recipeNew.energy_required     = 10
        recipeNew.allow_decomposition = true
        recipeNew.always_show_made_in = true

        recipeNew.hide_from_player_crafting = Recipe.action or false

        -- Sobre escribir los nombres
        local recipeName = { }
        recipeNew.localised_name = recipeName
        table.insert( recipeName, "" )
        table.insert( recipeName, { "recipe-name." .. ThisMOD.Prefix_MOD_ .. Category } )
        table.insert( recipeName, NewItem.localised_name )

        -- Añadir el pez
        GPrefix.addIcon( OldItem, recipeNew, Recipe.action )

        ---> <---     ---> <---     ---> <---

        -- Guardar la nueva receta
        data:extend( { recipeNew } )
        GPrefix.addTechnology( OldItem.name, recipeNew.name )
        local Result = recipeNew.results[ 1 ].name
        GPrefix.Recipes[ Result ] = GPrefix.Recipes[ Result ] or { }
        table.insert( GPrefix.Recipes[ Result ], recipeNew )
    end
end


-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadCompact( )   GPrefix.createInformation( ThisMOD )
    ThisMOD.addTechnologie( )

    ThisMOD.Information = { Break = true }
    ThisMOD.FindItem( )   GPrefix.createInformation( ThisMOD )
    GPrefix.Compact = function( OldItem, TheMOD ) ThisMOD.Compact( OldItem, TheMOD ) end
    GPrefix.Compact = ThisMOD
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------