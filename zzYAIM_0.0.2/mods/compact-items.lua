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
    SettingOption.default_value = 1000
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
    data:extend( { {
        [ 'type' ] = 'item-subgroup',
        [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'compacts',
        [ 'group' ] = 'logistics',
        [ 'order' ] = 'b[belt]-c',
    } } )

    -- Existen las categorias
    local RecipeCategory = data.raw[ 'recipe-category' ]
    RecipeCategory = RecipeCategory[ ThisMOD.Prefix_MOD_ .. 'compact' ]
    if RecipeCategory then goto JumpRecipeCategory end

    -- Crear la categoria
    data:extend( { {
        [ 'type' ] = 'recipe-category',
        [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'compact',
    } } )

    data:extend( { {
        [ 'type' ] = 'recipe-category',
        [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'uncompact',
    } } )

    -- Recepción del salto
    :: JumpRecipeCategory ::

    -- Inicializar el contenedor
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    ThisMOD.LoadEntities( Info )
    ThisMOD.LoadRecipes( Info )
    ThisMOD.LoadItems( Info )
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

        Entity.localised_name = {
            ThisMOD.Local .. Entity.name
        }

        Entity.localised_description = {
            ThisMOD.Local .. "entity-description"
        }
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

        Item.localised_name = { ThisMOD.Local .. Item.name }
        Item.localised_description = {
            ThisMOD.Local .. "entity-description"
        }
    end
end

-- Crear el prototipo
function ThisMOD.LoadRecipes( Info )

    -- Crear los prototipos
    Info.Recipes = {
        [ 'underground-belt' ] = {
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
        [ 'fast-underground-belt' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'fast-compact',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'compacts',
                [ 'order' ] = 'bb',
                [ 'enabled' ] = false,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = 'compact',
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
        [ 'express-underground-belt' ] = {
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
                        [ 1 ] = 'fast-compact',
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

    -- Renombrar la variable
    local Prefix = ThisMOD.Prefix_MOD_

    -- Modificar los prototipos
    for _, Array in pairs( Info.Recipes ) do
        for _, Recipe in pairs( Array ) do
            Recipe.subgroup = ThisMOD.Prefix_MOD_ .. Recipe.subgroup

            Recipe.localised_name = { ThisMOD.Local .. Recipe.name }
            Recipe.localised_description = ""

            for _, Value in pairs( Recipe.ingredients ) do
                if Value[ 1 ] then Value[ 1 ] = Prefix .. Value[ 1 ] end
            end
        end
    end
end


-- Identificar los objetos a compactar
function ThisMOD.StartItems( )

    -- Existen las categorias
    local RecipeCategory = data.raw[ 'recipe-category' ]
    RecipeCategory = RecipeCategory[ ThisMOD.Prefix_MOD_ .. 'compact' ]
    if RecipeCategory then goto JumpRecipeCategory end

    -- Crear la categoria
    data:extend( {
        {
            [ 'type' ] = 'recipe-category',
            [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'compact',
        },
        {
            [ 'type' ] = 'recipe-category',
            [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'uncompact',
        }
    } )

    -- Recepción del salto
    :: JumpRecipeCategory ::

    -- Contenedor de los items
    local Items = GPrefix.DeepCopy( GPrefix.Items )

    -- Crear los objetos compactados
    ThisMOD.Information = { Break = true }
    for _, Item in pairs( Items ) do
        ThisMOD.Compact( Item, ThisMOD )
    end GPrefix.createInformation( ThisMOD )

    ThisMOD.Information = { Break = true }
    for _, Item in pairs( Items ) do
        ThisMOD.CreateRecipe( Item )
    end GPrefix.createInformation( ThisMOD )
end

-- Crear un item compactado
function ThisMOD.Compact( OldItem, TheMOD )

    -- Tipos a evitar
    local AvoidTypes = { }
    table.insert( AvoidTypes, "car" )
    table.insert( AvoidTypes, "gun" )
    table.insert( AvoidTypes, "armor" )
    table.insert( AvoidTypes, "selection-tool" )
    table.insert( AvoidTypes, "spider-vehicle" )
    table.insert( AvoidTypes, "belt-immunity-equipment" )

    -- Patrones a evitar
    local AvoidPatterns = { }
    table.insert( AvoidPatterns, "%-remote" )

    -- Evitar estos tipos
    if GPrefix.getKey( AvoidTypes, OldItem.type ) then return end

    -- Evitar lo inapilable
    if GPrefix.getKey( OldItem.flags, "hidden" ) then return end
    if GPrefix.getKey( OldItem.flags, "not-stackable" ) then return end

    -- Evitar estos patrones
    for _, Pattern in pairs( AvoidPatterns ) do
        if string.find( OldItem.name, Pattern ) then return end
    end

    -- Crear el nuevo subgrupo
    GPrefix.newItemSubgroup( OldItem, ThisMOD )

    -- Crear los prototipos
    ThisMOD.CreateItem( OldItem, TheMOD )
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
    end

    NewItem.subgroup = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    NewItem.subgroup = string.gsub( OldItem.subgroup, NewItem.subgroup, "" )
    NewItem.subgroup = ThisMOD.Prefix_MOD_ .. NewItem.subgroup

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
    ThisMOD.addDescription( NewItem )
    local Icon = { icon = "" }
    Icon.icon = Icon.icon .. ThisMOD.Patch
    Icon.icon = Icon.icon .. "icons/status.png"
    Icon.icon_size = 32

    -- Agregar el pez de referencia
    GPrefix.addIcon( OldItem, NewItem, Icon )

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
function ThisMOD.CreateRecipe( OldItem )

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Es compactable??
    local NameWithOutPrefix = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    NameWithOutPrefix = string.gsub( OldItem.name, NameWithOutPrefix, "" )
    local NewName = ThisMOD.Prefix_MOD_ .. NameWithOutPrefix
    local Item = GPrefix.Items[ NewName ]
    if not Item then return end

    ---> <---     ---> <---     ---> <---

    -- Valores para la receta
    local Table      = { }
    Table.compact    = { }
    Table.uncompact  = { }

    -- Valores para la descompresion
    Table.uncompact.name        = GPrefix.Prefix_ .. "uncompact-" .. NameWithOutPrefix
    Table.uncompact.results     = { { type = "item", amount = ThisMOD.Value, name = OldItem.name } }
    Table.uncompact.ingredients = { { type = "item", amount = 1 , name = Item.name } }
    Table.uncompact.action      = true

    -- Valores para la compresion
    Table.compact.name        = GPrefix.Prefix_ .. "compact-" .. NameWithOutPrefix
    Table.compact.results     = { { type = "item", amount = 1 , name = Item.name } }
    Table.compact.ingredients = { { type = "item", amount = ThisMOD.Value, name = OldItem.name } }

    for Category, Recipe in pairs( Table ) do

        -- Copiar el objeto
        local NewRecipe = { }

        -- Crear las recetas
        NewRecipe.name = Recipe.name
        NewRecipe.type = "recipe"

        NewRecipe.order    = Item.order
        NewRecipe.enabled  = false
        NewRecipe.category = ThisMOD.Prefix_MOD_ .. Category
        local PrefixFind = string.gsub( GPrefix.Prefix_, "-", "%%-" )
        NewRecipe.subgroup = string.gsub( Item.subgroup, PrefixFind, "" )
        NewRecipe.subgroup = GPrefix.Prefix_ .. NewRecipe.subgroup

        NewRecipe.results      = Recipe.results
        NewRecipe.ingredients  = Recipe.ingredients
        NewRecipe.main_product = ""

        NewRecipe.energy_required = 10
        NewRecipe.allow_decomposition = false
        NewRecipe.hide_from_player_crafting = not Recipe.action
        NewRecipe.localised_name = GPrefix.DeepCopy( Item.localised_name )
        table.insert( NewRecipe.localised_name, 2, { ThisMOD.Local .. Category .. "-process" } )
        table.insert( NewRecipe.localised_name, 3, " " )

        -- Variable contenedora
        local Icon = { }

        -- Agregar el brillo
        Icon = { icon = "" }
        Icon.icon = Icon.icon .. ThisMOD.Patch
        Icon.icon = Icon.icon .. "icons/status.png"
        Icon.icon_size = 32

        GPrefix.addIcon( OldItem, NewRecipe, Icon )

        -- Agregar la flecha
        Icon = { icon = "" }
        Icon.icon = Icon.icon .. ThisMOD.Patch
        Icon.icon = Icon.icon .. "icons/stacking-arrow-"
        Icon.icon = Icon.icon .. ( Recipe.action and "u" or "d" )
        Icon.icon = Icon.icon .. ".png"

        Icon.scale = 0.3
        Icon.icon_size = 64
        Icon.icon_mipmaps = 1

        GPrefix.addIcon( NewRecipe, NewRecipe, Icon )

        ---> <---     ---> <---     ---> <---

        -- Guardar la nueva recera
        Recipes[ OldItem.name ] = Recipes[ OldItem.name ] or { }
        table.insert( Recipes[ OldItem.name ], NewRecipe )
    end
end


-- Establecer la descricción
function ThisMOD.addDescription( Table )
    local Array = GPrefix.DeepCopy( Table.localised_name )
    if Array[ 1 ] ~= "" then Array = { "", Array } end
    Table.localised_description = Array
    table.insert( Array, 2, { ThisMOD.Local .. "item-description" } )
    table.insert( Array, 3, " " .. ThisMOD.Value .. " " )
    table.insert( Array, 4, "[" .. Table.type .. "=" .. Table.name .. "] " )
end

-- Verificar si el objeto o la receta esta compactado
function ThisMOD.UpdateDescription( Table, TheMOD )

    -- La descripción puede ser la que se busca
    local Array = Table.localised_description
    if not Array then return end
    if not GPrefix.isTable( Array ) then return end
    if #Array < 2 then return end
    if Array[ 1 ] ~= "" then return end

    -- La descripción es la que se busca
    if not GPrefix.isTable( Array[ 2 ] ) then return end
    local PrefixFind = ThisMOD.Prefix_MOD .. ".item-description"
    if Array[ 2 ][ 1 ] ~= PrefixFind then return end

    -- Se actualiza el cambio
    Array = { localised_name = Array }
    GPrefix.addLetter( Array, TheMOD.Char )
end

function ThisMOD.KeySequence( )
    local Table = { }
    Table.type = "custom-input"
    Table.localised_name = { ThisMOD.Local .. "setting-name"}
    Table.name = ThisMOD.Prefix_MOD
    Table.key_sequence = "CONTROL + M"
    data:extend( { Table } )
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end
ThisMOD.KeySequence( )
    ThisMOD.LoadCompact( )   GPrefix.createInformation( ThisMOD )
    ThisMOD.StartItems( )   GPrefix.Compact = ThisMOD

    local CharacterCategories = data.raw[ 'character' ][ 'character' ]
    CharacterCategories = CharacterCategories[ 'crafting_categories' ]
    table.insert( CharacterCategories, ThisMOD.Prefix_MOD_ .. 'uncompact' )

    local GodCategories = data.raw[ 'god-controller' ][ 'default' ]
    GodCategories = GodCategories[ 'crafting_categories' ]
    table.insert( GodCategories, ThisMOD.Prefix_MOD_ .. 'uncompact' )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Contenedor de los jugadores a inicializar
ThisMOD.Players = { }

-- Lista de objetos a agregar
ThisMOD.Items = { }
table.insert( ThisMOD.Items, { count = 1, name = "compact" } )
table.insert( ThisMOD.Items, { count = 1, name = "iron-plate" } )
table.insert( ThisMOD.Items, { count = 1, name = "copper-plate" } )
table.insert( ThisMOD.Items, { count = 1, name = "stone" } )
table.insert( ThisMOD.Items, { count = 1, name = "coal" } )

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
    if #ThisMOD.Players < 1 then return end

    -- Inicializar el contenedor
    local StrItems = GPrefix.toString( ThisMOD.Items )

    -- Verificar cada jugador
    for _, Data in pairs( ThisMOD.Players ) do

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
        ThisMOD.Players[ IDPlayer ] = nil return
    end

    -- No hacer nada en los escesarios especificos
    if script.level.campaign_name then
        ThisMOD.Players[ IDPlayer ] = nil return
    end

    -- Esperar que esté en el destino final
    local Flag = false
    Flag = Level == "wave-defense" and true or false
    Flag = Flag and Data.Player.surface.index < 2
    if Flag then return end

    Flag = Level == "team-production" and true or false
    Flag = Flag and Data.Player.force.index < 2
    if Flag then return end

    ---> <---     ---> <---     ---> <---

    -- El jugador no tiene un cuerpo
    if not Data.Player.character then
        for _, Item in pairs( Data.GMOD.Items ) do
            Item.name = Data.GMOD.Prefix_MOD_ .. Item.name
            Data.Player.insert( Item )
        end
    end

    -- El jugador tiene un cuerpo
    if Data.Player.character then
        local Inventory = Data.Player.character
        local IDInvertory = defines.inventory.character_main
        Inventory = Inventory.get_inventory( IDInvertory )
        for _, Item in pairs( Data.GMOD.Items ) do
            Item.name = Data.GMOD.Prefix_MOD_ .. Item.name
            Inventory.insert( Item )
        end
    end

    ---> <---     ---> <---     ---> <---

    -- Marcar cómo hecho
    Data.gForce[ IDPlayer ] = GPrefix.DeepCopy( ThisMOD.Items )
    ThisMOD.Players[ IDPlayer ] = nil
end

-- Agregar los jugadores a la cola
function ThisMOD.addPlayer( Event )
    local Data = GPrefix.CreateData( Event, ThisMOD )
    ThisMOD.Players[ Data.Player.index ] = Data
end

-- Hacer antes de borrar a un jugador
function ThisMOD.BeforeDelete( Data )
    local IDPlayer = Data.Player.index
    local IDForce = Data.Player.force.index
    Data.gForce[ IDForce ][ IDPlayer ] = nil
end

-- Hacer antes e salir de la partida
function ThisMOD.BeforeLogout( Data )
    ThisMOD.Players[ Data.Player.index ] = nil
end

function ThisMOD.Control( )
    if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    GPrefix.addEvent( {

        -- Al crear la partida
        [ "on_init" ] = ThisMOD.Initialize,

        -- Al cargar la partida
        [ "on_load" ] = ThisMOD.Initialize,

        -- Antes de eliminar un jugador
        [ { "on_event", defines.events.on_pre_player_removed } ] = function( Event )
            ThisMOD.BeforeDelete( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- Antes de salir del juego
        [ { "on_event", defines.events.on_pre_player_left_game } ] = function( Event )
            ThisMOD.BeforeLogout( GPrefix.CreateData( Event, ThisMOD ) )
        end,

        -- Jugadores a inicializar
        [ { "on_event", defines.events.on_player_created } ] = ThisMOD.addPlayer,
    } )
end

-- Cargar los eventos
ThisMOD.Control( )

---------------------------------------------------------------------------------------------------