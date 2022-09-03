---------------------------------------------------------------------------------------------------

--> miniloader.lua <--

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
end

-- Cargar la configuración
ThisMOD.Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Cargar las infomación
function ThisMOD.LoadInformation( )

    -- Crear el sub grupo
    data:extend( { {
        [ 'type' ] = 'item-subgroup',
        [ 'name' ] = ThisMOD.Prefix_MOD_ .. 'loaders',
        [ 'group' ] = 'logistics',
        [ 'order' ] = 'b[belt]-c',
    } } )

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
        [ 'loader' ] = {
            [ 'type' ] = 'loader-1x1',
            [ 'name' ] = 'loader',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-mask.png',
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
                [ 2 ] = 'player-creation',
                [ 3 ] = 'fast-replaceable-no-build-while-moving',
            },
            [ 'vehicle_impact_sound' ] = {
                [ 'filename' ] = '__base__/sound/car-metal-impact.ogg',
                [ 'volume' ] = 1,
            },
            [ 'open_sound' ] = {
                [ 'filename' ] = '__base__/sound/wooden-chest-open.ogg',
                [ 'volume' ] = 1,
            },
            [ 'close_sound' ] = {
                [ 'filename' ] = '__base__/sound/wooden-chest-close.ogg',
                [ 'volume' ] = 1,
            },
            [ 'corpse' ] = 'small-remnants',
            [ 'collision_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.26,
                    [ 2 ] = -0.26,
                },
                [ 2 ] = {
                    [ 1 ] = 0.26,
                    [ 2 ] = 0.26,
                },
            },
            [ 'collision_mask' ] = {
                [ 1 ] = 'item-layer',
                [ 2 ] = 'object-layer',
                [ 3 ] = 'player-layer',
                [ 4 ] = 'water-tile',
                [ 5 ] = 'transport-belt-layer',
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
            [ 'max_health' ] = 170,
            [ 'resistances' ] = {
                [ 1 ] = {
                    [ 'type' ] = 'fire',
                    [ 'percent' ] = 60,
                },
            },
            [ 'belt_distance' ] = 0.5,
            [ 'container_distance' ] = 1,
            [ 'belt_length' ] = 0.5,
            [ 'filter_count' ] = 5,
            [ 'animation_speed_coefficient' ] = 32,
            [ 'fast_replaceable_group' ] = 'transport-belt',
            [ 'speed' ] = 0.03125,
            [ 'structure' ] = {
                [ 'back_patch' ] = {
                    [ 'sheet' ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-back.png',
                            [ 'height' ] = 96,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-back.png',
                        [ 'height' ] = 48,
                        [ 'priority' ] = 'extra-high',
                        [ 'width' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                    },
                },
                [ 'direction_in' ] = {
                    [ 'sheets' ] = {
                        [ 1 ] = {
                            [ 'hr_version' ] = {
                                [ 'draw_as_shadow' ] = true,
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-shadow.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'medium',
                                [ 'width' ] = 144,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0.5,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-shadow.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'medium',
                            [ 'width' ] = 72,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                        },
                        [ 2 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-base.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-base.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                        },
                        [ 3 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-mask.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'tint' ] = {
                                    [ 'r' ] = 210,
                                    [ 'g' ] = 180,
                                    [ 'b' ] = 80,
                                },
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-mask.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'tint' ] = {
                                [ 'r' ] = 210,
                                [ 'g' ] = 180,
                                [ 'b' ] = 80,
                            },
                        },
                    },
                },
                [ 'direction_out' ] = {
                    [ 'sheets' ] = {
                        [ 1 ] = {
                            [ 'hr_version' ] = {
                                [ 'draw_as_shadow' ] = true,
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-shadow.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'medium',
                                [ 'width' ] = 144,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0.5,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-shadow.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'medium',
                            [ 'width' ] = 72,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                        },
                        [ 2 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-base.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                                [ 'y' ] = 96,
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-base.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'y' ] = 48,
                        },
                        [ 3 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-mask.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                                [ 'tint' ] = {
                                    [ 'r' ] = 210,
                                    [ 'g' ] = 180,
                                    [ 'b' ] = 80,
                                },
                                [ 'y' ] = 96,
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-mask.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'tint' ] = {
                                [ 'r' ] = 210,
                                [ 'g' ] = 180,
                                [ 'b' ] = 80,
                            },
                            [ 'y' ] = 48,
                        },
                    },
                },
            },
            [ 'belt_animation_set' ] = {
                [ 'animation_set' ] = {
                    [ 'filename' ] = '__base__/graphics/entity/transport-belt/transport-belt.png',
                    [ 'priority' ] = 'extra-high',
                    [ 'width' ] = 64,
                    [ 'height' ] = 64,
                    [ 'frame_count' ] = 16,
                    [ 'direction_count' ] = 20,
                    [ 'hr_version' ] = {
                        [ 'filename' ] = '__base__/graphics/entity/transport-belt/hr-transport-belt.png',
                        [ 'priority' ] = 'extra-high',
                        [ 'width' ] = 128,
                        [ 'height' ] = 128,
                        [ 'scale' ] = 0.5,
                        [ 'frame_count' ] = 16,
                        [ 'direction_count' ] = 20,
                    },
                },
            },
            [ 'structure_render_layer' ] = 'object',
            [ 'next_upgrade' ] = 'fast-loader',
            [ 'minable' ] = {
                [ 'mining_time' ] = 0.1,
                [ 'result' ] = 'loader',
            },
        },
        [ 'fast-loader' ] = {
            [ 'type' ] = 'loader-1x1',
            [ 'name' ] = 'fast-loader',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-mask.png',
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
                [ 2 ] = 'player-creation',
                [ 3 ] = 'fast-replaceable-no-build-while-moving',
            },
            [ 'vehicle_impact_sound' ] = {
                [ 'filename' ] = '__base__/sound/car-metal-impact.ogg',
                [ 'volume' ] = 1,
            },
            [ 'open_sound' ] = {
                [ 'filename' ] = '__base__/sound/wooden-chest-open.ogg',
                [ 'volume' ] = 1,
            },
            [ 'close_sound' ] = {
                [ 'filename' ] = '__base__/sound/wooden-chest-close.ogg',
                [ 'volume' ] = 1,
            },
            [ 'corpse' ] = 'small-remnants',
            [ 'collision_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.26,
                    [ 2 ] = -0.26,
                },
                [ 2 ] = {
                    [ 1 ] = 0.26,
                    [ 2 ] = 0.26,
                },
            },
            [ 'collision_mask' ] = {
                [ 1 ] = 'item-layer',
                [ 2 ] = 'object-layer',
                [ 3 ] = 'player-layer',
                [ 4 ] = 'water-tile',
                [ 5 ] = 'transport-belt-layer',
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
            [ 'max_health' ] = 170,
            [ 'resistances' ] = {
                [ 1 ] = {
                    [ 'type' ] = 'fire',
                    [ 'percent' ] = 60,
                },
            },
            [ 'belt_distance' ] = 0.5,
            [ 'container_distance' ] = 1,
            [ 'belt_length' ] = 0.5,
            [ 'filter_count' ] = 5,
            [ 'animation_speed_coefficient' ] = 32,
            [ 'fast_replaceable_group' ] = 'transport-belt',
            [ 'speed' ] = 0.0625,
            [ 'structure' ] = {
                [ 'back_patch' ] = {
                    [ 'sheet' ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-back.png',
                            [ 'height' ] = 96,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-back.png',
                        [ 'height' ] = 48,
                        [ 'priority' ] = 'extra-high',
                        [ 'width' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                    },
                },
                [ 'direction_in' ] = {
                    [ 'sheets' ] = {
                        [ 1 ] = {
                            [ 'hr_version' ] = {
                                [ 'draw_as_shadow' ] = true,
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-shadow.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'medium',
                                [ 'width' ] = 144,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0.5,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-shadow.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'medium',
                            [ 'width' ] = 72,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                        },
                        [ 2 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-base.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-base.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                        },
                        [ 3 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-mask.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'tint' ] = {
                                    [ 'r' ] = 210,
                                    [ 'g' ] = 60,
                                    [ 'b' ] = 60,
                                },
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-mask.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'tint' ] = {
                                [ 'r' ] = 210,
                                [ 'g' ] = 60,
                                [ 'b' ] = 60,
                            },
                        },
                    },
                },
                [ 'direction_out' ] = {
                    [ 'sheets' ] = {
                        [ 1 ] = {
                            [ 'hr_version' ] = {
                                [ 'draw_as_shadow' ] = true,
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-shadow.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'medium',
                                [ 'width' ] = 144,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0.5,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-shadow.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'medium',
                            [ 'width' ] = 72,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                        },
                        [ 2 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-base.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                                [ 'y' ] = 96,
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-base.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'y' ] = 48,
                        },
                        [ 3 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-mask.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                                [ 'tint' ] = {
                                    [ 'r' ] = 210,
                                    [ 'g' ] = 60,
                                    [ 'b' ] = 60,
                                },
                                [ 'y' ] = 96,
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-mask.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'tint' ] = {
                                [ 'r' ] = 210,
                                [ 'g' ] = 60,
                                [ 'b' ] = 60,
                            },
                            [ 'y' ] = 48,
                        },
                    },
                },
            },
            [ 'belt_animation_set' ] = {
                [ 'animation_set' ] = {
                    [ 'filename' ] = '__base__/graphics/entity/fast-transport-belt/fast-transport-belt.png',
                    [ 'priority' ] = 'extra-high',
                    [ 'width' ] = 64,
                    [ 'height' ] = 64,
                    [ 'frame_count' ] = 32,
                    [ 'direction_count' ] = 20,
                    [ 'hr_version' ] = {
                        [ 'filename' ] = '__base__/graphics/entity/fast-transport-belt/hr-fast-transport-belt.png',
                        [ 'priority' ] = 'extra-high',
                        [ 'width' ] = 128,
                        [ 'height' ] = 128,
                        [ 'scale' ] = 0.5,
                        [ 'frame_count' ] = 32,
                        [ 'direction_count' ] = 20,
                    },
                },
            },
            [ 'structure_render_layer' ] = 'object',
            [ 'next_upgrade' ] = 'express-loader',
        },
        [ 'express-loader' ] = {
            [ 'type' ] = 'loader-1x1',
            [ 'name' ] = 'express-loader',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-mask.png',
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
                [ 2 ] = 'player-creation',
                [ 3 ] = 'fast-replaceable-no-build-while-moving',
            },
            [ 'vehicle_impact_sound' ] = {
                [ 'filename' ] = '__base__/sound/car-metal-impact.ogg',
                [ 'volume' ] = 1,
            },
            [ 'open_sound' ] = {
                [ 'filename' ] = '__base__/sound/wooden-chest-open.ogg',
                [ 'volume' ] = 1,
            },
            [ 'close_sound' ] = {
                [ 'filename' ] = '__base__/sound/wooden-chest-close.ogg',
                [ 'volume' ] = 1,
            },
            [ 'corpse' ] = 'small-remnants',
            [ 'collision_box' ] = {
                [ 1 ] = {
                    [ 1 ] = -0.26,
                    [ 2 ] = -0.26,
                },
                [ 2 ] = {
                    [ 1 ] = 0.26,
                    [ 2 ] = 0.26,
                },
            },
            [ 'collision_mask' ] = {
                [ 1 ] = 'item-layer',
                [ 2 ] = 'object-layer',
                [ 3 ] = 'player-layer',
                [ 4 ] = 'water-tile',
                [ 5 ] = 'transport-belt-layer',
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
            [ 'max_health' ] = 170,
            [ 'resistances' ] = {
                [ 1 ] = {
                    [ 'type' ] = 'fire',
                    [ 'percent' ] = 60,
                },
            },
            [ 'belt_distance' ] = 0.5,
            [ 'container_distance' ] = 1,
            [ 'belt_length' ] = 0.5,
            [ 'filter_count' ] = 5,
            [ 'animation_speed_coefficient' ] = 32,
            [ 'fast_replaceable_group' ] = 'transport-belt',
            [ 'speed' ] = 0.09375,
            [ 'structure' ] = {
                [ 'back_patch' ] = {
                    [ 'sheet' ] = {
                        [ 'hr_version' ] = {
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-back.png',
                            [ 'height' ] = 96,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 96,
                            [ 'scale' ] = 0.5,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                        },
                        [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-back.png',
                        [ 'height' ] = 48,
                        [ 'priority' ] = 'extra-high',
                        [ 'width' ] = 48,
                        [ 'scale' ] = 1,
                        [ 'shift' ] = {
                            [ 1 ] = 0,
                            [ 2 ] = 0,
                        },
                    },
                },
                [ 'direction_in' ] = {
                    [ 'sheets' ] = {
                        [ 1 ] = {
                            [ 'hr_version' ] = {
                                [ 'draw_as_shadow' ] = true,
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-shadow.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'medium',
                                [ 'width' ] = 144,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0.5,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-shadow.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'medium',
                            [ 'width' ] = 72,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                        },
                        [ 2 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-base.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-base.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                        },
                        [ 3 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-mask.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'tint' ] = {
                                    [ 'r' ] = 80,
                                    [ 'g' ] = 180,
                                    [ 'b' ] = 210,
                                },
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-mask.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'tint' ] = {
                                [ 'r' ] = 80,
                                [ 'g' ] = 180,
                                [ 'b' ] = 210,
                            },
                        },
                    },
                },
                [ 'direction_out' ] = {
                    [ 'sheets' ] = {
                        [ 1 ] = {
                            [ 'hr_version' ] = {
                                [ 'draw_as_shadow' ] = true,
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-shadow.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'medium',
                                [ 'width' ] = 144,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0.5,
                                    [ 2 ] = 0,
                                },
                            },
                            [ 'draw_as_shadow' ] = true,
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-shadow.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'medium',
                            [ 'width' ] = 72,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0.5,
                                [ 2 ] = 0,
                            },
                        },
                        [ 2 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-base.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                                [ 'y' ] = 96,
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-base.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'y' ] = 48,
                        },
                        [ 3 ] = {
                            [ 'hr_version' ] = {
                                [ 'filename' ] = ThisMOD.Patch .. 'entity/high/loader-mask.png',
                                [ 'height' ] = 96,
                                [ 'priority' ] = 'extra-high',
                                [ 'width' ] = 96,
                                [ 'scale' ] = 0.5,
                                [ 'shift' ] = {
                                    [ 1 ] = 0,
                                    [ 2 ] = 0,
                                },
                                [ 'tint' ] = {
                                    [ 'r' ] = 80,
                                    [ 'g' ] = 180,
                                    [ 'b' ] = 210,
                                },
                                [ 'y' ] = 96,
                            },
                            [ 'filename' ] = ThisMOD.Patch .. 'entity/low/loader-mask.png',
                            [ 'height' ] = 48,
                            [ 'priority' ] = 'extra-high',
                            [ 'width' ] = 48,
                            [ 'scale' ] = 1,
                            [ 'shift' ] = {
                                [ 1 ] = 0,
                                [ 2 ] = 0,
                            },
                            [ 'tint' ] = {
                                [ 'r' ] = 80,
                                [ 'g' ] = 180,
                                [ 'b' ] = 210,
                            },
                            [ 'y' ] = 48,
                        },
                    },
                },
            },
            [ 'belt_animation_set' ] = {
                [ 'animation_set' ] = {
                    [ 'filename' ] = '__base__/graphics/entity/express-transport-belt/express-transport-belt.png',
                    [ 'priority' ] = 'extra-high',
                    [ 'width' ] = 64,
                    [ 'height' ] = 64,
                    [ 'frame_count' ] = 32,
                    [ 'direction_count' ] = 20,
                    [ 'hr_version' ] = {
                        [ 'filename' ] = '__base__/graphics/entity/express-transport-belt/hr-express-transport-belt.png',
                        [ 'priority' ] = 'extra-high',
                        [ 'width' ] = 128,
                        [ 'height' ] = 128,
                        [ 'scale' ] = 0.5,
                        [ 'frame_count' ] = 32,
                        [ 'direction_count' ] = 20,
                    },
                },
            },
            [ 'structure_render_layer' ] = 'object',
        },
    }

    -- Modificar los prototipos
    for _, Entity in pairs( Info.Entities ) do
        Entity.minable = {
            [ 'mining_time' ] = 0.1,
            [ 'result' ] = Entity.name,
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
        [ 'loader' ] = {
            [ 'type' ] = 'item',
            [ 'name' ] = 'loader',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-mask.png',
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
            [ 'place_result' ] = 'loader',
            [ 'group' ] = 'logistics',
            [ 'subgroup' ] = 'loaders',
            [ 'order' ] = 'aa',
        },
        [ 'fast-loader' ] = {
            [ 'type' ] = 'item',
            [ 'name' ] = 'fast-loader',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-mask.png',
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
            [ 'place_result' ] = 'fast-loader',
            [ 'group' ] = 'logistics',
            [ 'subgroup' ] = 'loaders',
            [ 'order' ] = 'ab',
        },
        [ 'express-loader' ] = {
            [ 'type' ] = 'item',
            [ 'name' ] = 'express-loader',
            [ 'icons' ] = {
                [ 1 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-base.png',
                },
                [ 2 ] = {
                    [ 'icon' ] = ThisMOD.Patch .. 'icons/loader-icon-mask.png',
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
            [ 'place_result' ] = 'express-loader',
            [ 'group' ] = 'logistics',
            [ 'subgroup' ] = 'loaders',
            [ 'order' ] = 'ac',
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
        [ 'underground-belt' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'loader',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'loaders',
                [ 'order' ] = 'aa',
                [ 'enabled' ] = true,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = 'iron-plate',
                        [ 2 ] = 5,
                    },
                    [ 2 ] = {
                        [ 1 ] = 'transport-belt',
                        [ 2 ] = 1,
                    },
                },
                [ 'result' ] = 'loader',
                [ 'energy_required' ] = 2,
            },
        },
        [ 'fast-underground-belt' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'fast-loader',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'loaders',
                [ 'order' ] = 'ab',
                [ 'enabled' ] = true,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = ThisMOD.Prefix_MOD_ .. 'loader',
                        [ 2 ] = 1,
                    },
                    [ 2 ] = {
                        [ 1 ] = 'iron-gear-wheel',
                        [ 2 ] = 20,
                    },
                },
                [ 'result' ] = 'fast-loader',
                [ 'energy_required' ] = 2,
            },
        },
        [ 'express-underground-belt' ] = {
            [ 1 ] = {
                [ 'type' ] = 'recipe',
                [ 'name' ] = 'express-loader',
                [ 'category' ] = 'crafting-with-fluid',
                [ 'group' ] = 'logistics',
                [ 'subgroup' ] = 'loaders',
                [ 'order' ] = 'ac',
                [ 'enabled' ] = true,
                [ 'ingredients' ] = {
                    [ 1 ] = {
                        [ 1 ] = ThisMOD.Prefix_MOD_ .. 'fast-loader',
                        [ 2 ] = 1,
                    },
                    [ 2 ] = {
                        [ 1 ] = 'iron-gear-wheel',
                        [ 2 ] = 40,
                    },
                    [ 3 ] = {
                        [ 'name' ] = 'lubricant',
                        [ 'type' ] = 'fluid',
                        [ 'amount' ] = 20,
                    },
                },
                [ 'result' ] = 'express-loader',
                [ 'energy_required' ] = 2,
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

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------