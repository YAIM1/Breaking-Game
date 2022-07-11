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
function ThisMOD.LoadInformation( )
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.createInformation( ThisMOD )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Insertador ( Origen + 1 -> Origen )
-- Cargador ( Origen -> Origen + 1 )
-- Caja ( Origen )
---------------------------------------------------------------------------------------------------




local _xXx_ = {
	[ 'Entities' ] = {
		[ 'transport-belt-loader' ] = {
			[ 'type' ] = 'loader-1x1',
			[ 'name' ] = 'transport-belt-loader',
			[ 'localised_description' ] = {
				[ 1 ] = 'entity-description.deadlock-loader',
			},
			[ 'icons' ] = {
				[ 1 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-base.png',
				},
				[ 2 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-mask.png',
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
			[ 'minable' ] = {
				[ 'hardness' ] = 0.2,
				[ 'mining_time' ] = 0.5,
				[ 'result' ] = 'transport-belt-loader',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-back.png',
							[ 'height' ] = 96,
							[ 'priority' ] = 'extra-high',
							[ 'width' ] = 96,
							[ 'scale' ] = 0.5,
							[ 'shift' ] = {
								[ 1 ] = 0,
								[ 2 ] = 0,
							},
						},
						[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-back.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-shadow.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-shadow.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-base.png',
								[ 'height' ] = 96,
								[ 'priority' ] = 'extra-high',
								[ 'width' ] = 96,
								[ 'scale' ] = 0.5,
								[ 'shift' ] = {
									[ 1 ] = 0,
									[ 2 ] = 0,
								},
							},
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-base.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-mask.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-mask.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-shadow.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-shadow.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-base.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-base.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-mask.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-mask.png',
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
			[ 'next_upgrade' ] = 'fast-transport-belt-loader',
			[ 'localised_name' ] = {
				[ 1 ] = '',
				[ 2 ] = {
					[ 1 ] = 'entity-name.transport-belt-loader',
				},
				[ 3 ] = ' [',
				[ 4 ] = ' B',
				[ 5 ] = ' ]',
			},
		},
		[ 'fast-transport-belt-loader' ] = {
			[ 'type' ] = 'loader-1x1',
			[ 'name' ] = 'fast-transport-belt-loader',
			[ 'localised_description' ] = {
				[ 1 ] = 'entity-description.deadlock-loader',
			},
			[ 'icons' ] = {
				[ 1 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-base.png',
				},
				[ 2 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-mask.png',
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
			[ 'minable' ] = {
				[ 'hardness' ] = 0.2,
				[ 'mining_time' ] = 0.5,
				[ 'result' ] = 'fast-transport-belt-loader',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-back.png',
							[ 'height' ] = 96,
							[ 'priority' ] = 'extra-high',
							[ 'width' ] = 96,
							[ 'scale' ] = 0.5,
							[ 'shift' ] = {
								[ 1 ] = 0,
								[ 2 ] = 0,
							},
						},
						[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-back.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-shadow.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-shadow.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-base.png',
								[ 'height' ] = 96,
								[ 'priority' ] = 'extra-high',
								[ 'width' ] = 96,
								[ 'scale' ] = 0.5,
								[ 'shift' ] = {
									[ 1 ] = 0,
									[ 2 ] = 0,
								},
							},
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-base.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-mask.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-mask.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-shadow.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-shadow.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-base.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-base.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-mask.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-mask.png',
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
			[ 'next_upgrade' ] = 'express-transport-belt-loader',
			[ 'localised_name' ] = {
				[ 1 ] = '',
				[ 2 ] = {
					[ 1 ] = 'entity-name.fast-transport-belt-loader',
				},
				[ 3 ] = ' [',
				[ 4 ] = ' B',
				[ 5 ] = ' ]',
			},
		},
		[ 'express-transport-belt-loader' ] = {
			[ 'type' ] = 'loader-1x1',
			[ 'name' ] = 'express-transport-belt-loader',
			[ 'localised_description' ] = {
				[ 1 ] = 'entity-description.deadlock-loader',
			},
			[ 'icons' ] = {
				[ 1 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-base.png',
				},
				[ 2 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-mask.png',
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
			[ 'minable' ] = {
				[ 'hardness' ] = 0.2,
				[ 'mining_time' ] = 0.5,
				[ 'result' ] = 'express-transport-belt-loader',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-back.png',
							[ 'height' ] = 96,
							[ 'priority' ] = 'extra-high',
							[ 'width' ] = 96,
							[ 'scale' ] = 0.5,
							[ 'shift' ] = {
								[ 1 ] = 0,
								[ 2 ] = 0,
							},
						},
						[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-back.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-shadow.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-shadow.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-base.png',
								[ 'height' ] = 96,
								[ 'priority' ] = 'extra-high',
								[ 'width' ] = 96,
								[ 'scale' ] = 0.5,
								[ 'shift' ] = {
									[ 1 ] = 0,
									[ 2 ] = 0,
								},
							},
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-base.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-mask.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-mask.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-shadow.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-shadow.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-base.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-base.png',
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
								[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/high/loader-mask.png',
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
							[ 'filename' ] = '__deadlock-beltboxes-loaders__/graphics/entities/low/loader-mask.png',
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
			[ 'localised_name' ] = {
				[ 1 ] = '',
				[ 2 ] = {
					[ 1 ] = 'entity-name.express-transport-belt-loader',
				},
				[ 3 ] = ' [',
				[ 4 ] = ' B',
				[ 5 ] = ' ]',
			},
		},
	},
	[ 'Recipes' ] = {
		[ 'transport-belt-loader' ] = {
			[ 1 ] = {
				[ 'type' ] = 'recipe',
				[ 'name' ] = 'transport-belt-loader',
				[ 'localised_description' ] = {
					[ 1 ] = 'entity-description.deadlock-loader',
				},
				[ 'group' ] = 'logistics',
				[ 'subgroup' ] = 'loaders',
				[ 'order' ] = 'aa-deadlock-loader',
				[ 'enabled' ] = false,
				[ 'ingredients' ] = {
					[ 1 ] = {
						[ 1 ] = 'transport-belt',
						[ 2 ] = 1,
					},
					[ 2 ] = {
						[ 1 ] = 'iron-plate',
						[ 2 ] = 5,
					},
				},
				[ 'result' ] = 'transport-belt-loader',
				[ 'energy_required' ] = 2,
				[ 'localised_name' ] = {
					[ 1 ] = '',
					[ 2 ] = {
						[ 1 ] = 'entity-name.transport-belt-loader',
					},
					[ 3 ] = ' [',
					[ 4 ] = ' B',
					[ 5 ] = ' ]',
				},
			},
		},
		[ 'fast-transport-belt-loader' ] = {
			[ 1 ] = {
				[ 'type' ] = 'recipe',
				[ 'name' ] = 'fast-transport-belt-loader',
				[ 'localised_description' ] = {
					[ 1 ] = 'entity-description.deadlock-loader',
				},
				[ 'group' ] = 'logistics',
				[ 'subgroup' ] = 'loaders',
				[ 'order' ] = 'ab-deadlock-loader',
				[ 'enabled' ] = false,
				[ 'ingredients' ] = {
					[ 1 ] = {
						[ 1 ] = 'transport-belt-loader',
						[ 2 ] = 1,
					},
					[ 2 ] = {
						[ 1 ] = 'iron-gear-wheel',
						[ 2 ] = 20,
					},
				},
				[ 'result' ] = 'fast-transport-belt-loader',
				[ 'energy_required' ] = 2,
				[ 'localised_name' ] = {
					[ 1 ] = '',
					[ 2 ] = {
						[ 1 ] = 'entity-name.fast-transport-belt-loader',
					},
					[ 3 ] = ' [',
					[ 4 ] = ' B',
					[ 5 ] = ' ]',
				},
			},
		},
		[ 'express-transport-belt-loader' ] = {
			[ 1 ] = {
				[ 'type' ] = 'recipe',
				[ 'name' ] = 'express-transport-belt-loader',
				[ 'localised_description' ] = {
					[ 1 ] = 'entity-description.deadlock-loader',
				},
				[ 'category' ] = 'crafting-with-fluid',
				[ 'group' ] = 'logistics',
				[ 'subgroup' ] = 'loaders',
				[ 'order' ] = 'ac-deadlock-loader',
				[ 'enabled' ] = false,
				[ 'ingredients' ] = {
					[ 1 ] = {
						[ 1 ] = 'fast-transport-belt-loader',
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
				[ 'result' ] = 'express-transport-belt-loader',
				[ 'energy_required' ] = 2,
				[ 'localised_name' ] = {
					[ 1 ] = '',
					[ 2 ] = {
						[ 1 ] = 'entity-name.express-transport-belt-loader',
					},
					[ 3 ] = ' [',
					[ 4 ] = ' B',
					[ 5 ] = ' ]',
				},
			},
		},
	},
	[ 'Items' ] = {
		[ 'transport-belt-loader' ] = {
			[ 'type' ] = 'item',
			[ 'name' ] = 'transport-belt-loader',
			[ 'localised_description' ] = {
				[ 1 ] = 'entity-description.deadlock-loader',
			},
			[ 'icons' ] = {
				[ 1 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-base.png',
				},
				[ 2 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-mask.png',
					[ 'tint' ] = {
						[ 'r' ] = 210,
						[ 'g' ] = 180,
						[ 'b' ] = 80,
					},
				},
			},
			[ 'icon_size' ] = 64,
			[ 'icon_mipmaps' ] = 4,
			[ 'stack_size' ] = 1000,
			[ 'flags' ] = { },
			[ 'place_result' ] = 'transport-belt-loader',
			[ 'group' ] = 'logistics',
			[ 'subgroup' ] = 'loaders',
			[ 'order' ] = 'aa-deadlock-loader',
			[ 'localised_name' ] = {
				[ 1 ] = '',
				[ 2 ] = {
					[ 1 ] = 'entity-name.transport-belt-loader',
				},
				[ 3 ] = ' [',
				[ 4 ] = ' B',
				[ 5 ] = ' ]',
			},
		},
		[ 'fast-transport-belt-loader' ] = {
			[ 'type' ] = 'item',
			[ 'name' ] = 'fast-transport-belt-loader',
			[ 'localised_description' ] = {
				[ 1 ] = 'entity-description.deadlock-loader',
			},
			[ 'icons' ] = {
				[ 1 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-base.png',
				},
				[ 2 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-mask.png',
					[ 'tint' ] = {
						[ 'r' ] = 210,
						[ 'g' ] = 60,
						[ 'b' ] = 60,
					},
				},
			},
			[ 'icon_size' ] = 64,
			[ 'icon_mipmaps' ] = 4,
			[ 'stack_size' ] = 1000,
			[ 'flags' ] = { },
			[ 'place_result' ] = 'fast-transport-belt-loader',
			[ 'group' ] = 'logistics',
			[ 'subgroup' ] = 'loaders',
			[ 'order' ] = 'ab-deadlock-loader',
			[ 'localised_name' ] = {
				[ 1 ] = '',
				[ 2 ] = {
					[ 1 ] = 'entity-name.fast-transport-belt-loader',
				},
				[ 3 ] = ' [',
				[ 4 ] = ' B',
				[ 5 ] = ' ]',
			},
		},
		[ 'express-transport-belt-loader' ] = {
			[ 'type' ] = 'item',
			[ 'name' ] = 'express-transport-belt-loader',
			[ 'localised_description' ] = {
				[ 1 ] = 'entity-description.deadlock-loader',
			},
			[ 'icons' ] = {
				[ 1 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-base.png',
				},
				[ 2 ] = {
					[ 'icon' ] = '__deadlock-beltboxes-loaders__/graphics/icons/mipmaps/loader-icon-mask.png',
					[ 'tint' ] = {
						[ 'r' ] = 80,
						[ 'g' ] = 180,
						[ 'b' ] = 210,
					},
				},
			},
			[ 'icon_size' ] = 64,
			[ 'icon_mipmaps' ] = 4,
			[ 'stack_size' ] = 1000,
			[ 'flags' ] = { },
			[ 'place_result' ] = 'express-transport-belt-loader',
			[ 'group' ] = 'logistics',
			[ 'subgroup' ] = 'loaders',
			[ 'order' ] = 'ac-deadlock-loader',
			[ 'localised_name' ] = {
				[ 1 ] = '',
				[ 2 ] = {
					[ 1 ] = 'entity-name.express-transport-belt-loader',
				},
				[ 3 ] = ' [',
				[ 4 ] = ' B',
				[ 5 ] = ' ]',
			},
		},
	},
}
