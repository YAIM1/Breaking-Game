--------------------------------------

-- compact.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está llamando
local modName = getFile( debug.getinfo( 1 ).short_src )

--------------------------------------
--------------------------------------

local Files = { "settings" }
if table.getKey( Files, __FILE__ ) then

    -- Preparar la configuración de este mod
    local _settings =  {
        type          = "int-setting",
        setting_type  = "startup",
        default_value = 50,
        minimum_value = 1,
        maximum_value = 65000
    }

    -- Construir valores
    local Description = "mod-setting-description."
    Description = Description .. "zzYAIM-short-setting"
    _settings.name  = Prefix .. modName
    _settings.order = SettingOrder[ _settings.type ]
    _settings.localised_description = { Description }

    -- Cargar configuración del mod al juego
    data:extend( { _settings } )
end

--------------------------------------
--------------------------------------

Files = { "data-final-fixes" }

-- Es necesario ejecutar este codigo??
if not table.getKey( Files, __FILE__ ) then
    return false
end

-- MOD Activado
if not Active then
    local MOD = Setting[ modName ]
    if not MOD then return false end
    if MOD.value == 1 then return false end
end

-- Validar que los objtos existan
if not ExistItem then
	local ValidItem = { }
	table.insert( ValidItem, "splitter" )
	table.insert( ValidItem, "lubricant" )
	table.insert( ValidItem, "iron-plate" )
	table.insert( ValidItem, "fast-splitter" )
	table.insert( ValidItem, "transport-belt" )
	table.insert( ValidItem, "iron-gear-wheel" )
	table.insert( ValidItem, "advanced-circuit" )
	table.insert( ValidItem, "express-splitter" )
	table.insert( ValidItem, "electronic-circuit" )
	table.insert( ValidItem, "fast-transport-belt" )
	table.insert( ValidItem, "assembling-machine-1" )
	table.insert( ValidItem, "assembling-machine-2" )
	table.insert( ValidItem, "assembling-machine-3" )
	table.insert( ValidItem, "express-transport-belt" )

	for _, value in pairs( ValidItem ) do
		local Flag = Items[ value ]
		Flag = Flag or Fluids[ value ]
		if not Flag then return false end
	end
end

--------------------------------------
--------------------------------------

-- Renombrar la variable
local _Prefix = Prefix .. modName .. "-"
local _Setting = Setting[ modName ]

-- Variable contenedora
local Compacts = { }

--------------------------------------
--------------------------------------

---> <---     ---> <---     ---> <---

--------------------------------------
--------------------------------------

local function BrighterColour( Colour )
    local function sub( RGB )
        return math.floor( ( RGB + 240 ) / 2 )
    end

	local ColourNew = { }
	ColourNew.r = sub( Colour.r )
	ColourNew.g = sub( Colour.g )
	ColourNew.b = sub( Colour.b )

	return ColourNew
end

local function CompactEntity( List )

	-- Variable contenedora con los valores referenciales
	local AssemblingMachine = Entitys[ List.Compact.Base ]

	---> <---     ---> <---     ---> <---

	-- Variable contenedora
    local Entity = { }
    Entity.type = "furnace"
    Entity.name = List.Compact.Name
    Entity.energy_usage   = AssemblingMachine.energy_usage
    Entity.crafting_speed = AssemblingMachine.crafting_speed
    Entity.crafting_categories   = { "compact", "uncompact" }
    Entity.localised_description = { "entity-description." .. _Prefix .. "compact" }

    Entity.corpse = "small-remnants"
    Entity.max_health = AssemblingMachine.max_health
	Entity.next_upgrade = List.Compact.Next
    Entity.allowed_effects = AssemblingMachine.allowed_effects
    Entity.dying_explosion = "explosion"
    Entity.show_recipe_icon = true
    Entity.result_inventory_size = 1
    Entity.source_inventory_size = 1
	Entity.fast_replaceable_group =  _Prefix .. "compact"

	Entity.drawing_box   = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    Entity.collision_box = { { -0.35, -0.35 }, { 0.35, 0.35 } }
    Entity.selection_box = { { -0.5 , -0.5  }, { 0.5 , 0.5  } }

    ---> <---     ---> <---     ---> <---

    Entity.minable = { }
    Entity.minable.result = Entity.name
    Entity.minable.mining_time = AssemblingMachine.minable.mining_time

    Entity.energy_source = { }
    Entity.energy_source.drain = AssemblingMachine.energy_source.drain
    Entity.energy_source.type = AssemblingMachine.energy_source.type
    Entity.energy_source.usage_priority = AssemblingMachine.energy_source.usage_priority
    Entity.energy_source.emissions_per_minute = AssemblingMachine.energy_source.emissions_per_minute

    Entity.working_sound = { }
    Entity.working_sound.match_speed_to_activity = true
    Entity.working_sound.idle_sound = { }
    Entity.working_sound.idle_sound.filename = "__base__/sound/idle1.ogg"
    Entity.working_sound.idle_sound.volume = 0.6
    Entity.working_sound.sound = { }
    Entity.working_sound.sound.filename = "__zzYAIM__/mods/sounds/fan.ogg"
    Entity.working_sound.sound.volume = 1.0
    Entity.working_sound.max_sounds_per_type = 3

    Entity.vehicle_impact_sound = { }
    Entity.vehicle_impact_sound.filename = "__base__/sound/car-metal-impact.ogg"
    Entity.vehicle_impact_sound.volume = 1.0

    Entity.module_specification = AssemblingMachine.module_specification

    Entity.flags = { }
    table.insert( Entity.flags, "player-creation" )
    table.insert( Entity.flags, "placeable-player" )
    table.insert( Entity.flags, "placeable-neutral" )

    ---> <---     ---> <---     ---> <---

    Entity.icons = { }
    Entity.icon_size = 64
    Entity.icon_mipmaps = 4

    local icon = { }

    icon = { }
    icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/beltbox-icon-base.png"
    table.insert( Entity.icons, icon )

    icon = { }
    icon.tint = List.Colour
    icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/beltbox-icon-mask.png"
    table.insert( Entity.icons, icon )

    ---> <---     ---> <---     ---> <---

    Entity.animation = { }
    Entity.animation.layers = { }

    local Layer = { }
    local HR_Version = { }

	HR_Version = { }
    HR_Version.frame_count = 60
    HR_Version.line_length = 10
    HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/beltbox-base.png"
    HR_Version.priority = "high"
    HR_Version.height = 96
    HR_Version.scale  = 0.5
    HR_Version.shift  = { 0, 0 }
    HR_Version.width  = 96

    Layer = { }
    Layer.frame_count = 60
    Layer.line_length = 10
    Layer.filename = "__zzYAIM__/mods/graphics/entities/low/beltbox-base.png"
    Layer.priority = "high"
    Layer.height = 48
    Layer.scale  = 1
    Layer.shift  = { 0, 0 }
    Layer.width  = 48

    Layer.hr_version = HR_Version
    table.insert( Entity.animation.layers, Layer )

    HR_Version = { }
    HR_Version.repeat_count = 60
    HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/beltbox-mask.png"
    HR_Version.priority = "high"
    HR_Version.height = 96
    HR_Version.scale = 0.5
    HR_Version.shift = { 0, 0 }
    HR_Version.width = 96
    HR_Version.tint  = List.Colour

    Layer = { }
    Layer.repeat_count = 60
    Layer.filename = "__zzYAIM__/mods/graphics/entities/low/beltbox-mask.png"
    Layer.priority = "high"
    Layer.height = 48
    Layer.scale  = 1
    Layer.shift  = { 0, 0 }
    Layer.width  = 48
    Layer.tint   = List.Colour

    Layer.hr_version = HR_Version
    table.insert( Entity.animation.layers, Layer )

    HR_Version = { }
    HR_Version.draw_as_shadow  = true
    HR_Version.frame_count = 60
    HR_Version.line_length = 10
    HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/beltbox-shadow.png"
    HR_Version.height = 96
    HR_Version.scale = 0.5
    HR_Version.shift = { 0.5, 0 }
    HR_Version.width = 144

    Layer = { }
    Layer.draw_as_shadow  = true
    Layer.frame_count = 60
    Layer.line_length = 10
    Layer.filename = "__zzYAIM__/mods/graphics/entities/low/beltbox-shadow.png"
    Layer.height = 48
    Layer.scale  = 1
    Layer.shift  = { 0.5, 0 }
    Layer.width  = 72

    Layer.hr_version = HR_Version
    table.insert( Entity.animation.layers, Layer )

    ---> <---     ---> <---     ---> <---

    local Light = { }
    Light.color = BrighterColour( List.Colour )
    Light.shift = { 0, 0.25 }
    Light.intensity = 0.4
    Light.size = 3

    HR_Version = { }
    HR_Version.frame_count = 30
    HR_Version.line_length = 10
    HR_Version.blend_mode  = "additive"
    HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/beltbox-working.png"
    HR_Version.priority = "high"
    HR_Version.height = 96
    HR_Version.scale  = 0.5
    HR_Version.width  = 96
    HR_Version.tint = BrighterColour( List.Colour )

    local Animation = { }
    Animation.frame_count = 30
    Animation.line_length = 10
    Animation.blend_mode = "additive"
    Animation.hr_version = HR_Version
    Animation.filename = "__zzYAIM__/mods/graphics/entities/low/beltbox-working.png"
    Animation.priority = "high"
    Animation.height = 48
    Animation.width  = 48
    Animation.tint = List.Colour

    local Working = { }
    Working.light = Light
    Working.animation = Animation
    Entity.working_visualisations = { Working }

    local Resistances = { }
    Resistances.type = "fire"
    Resistances.percent = 50
    Entity.resistances  = { Resistances }

    ---> <---     ---> <---     ---> <---

	-- Guardar la entidad
	data:extend( { Entity } )
	Entitys[ Entity.name ] = Entity
end

local function CompactRecipe( List )

	-- Variable contenedora
	local Recipe = { }
    Recipe.type = "recipe"

	-- Establecer el nombre de la nueva receta
    Recipe.name = List.Compact.Name

	-- Establecer el apodo del nombre y de la descripcion
	Recipe.localised_name = { "entity-name." .. Recipe.name }
	Recipe.localised_description = { "entity-description." .. _Prefix .. "compact" }

	-- Establece la categoria y el subgrupo
    Recipe.category = List.Category
    Recipe.subgroup = _Prefix .. "compact"

	-- Establecer el orden de la receta
    Recipe.order = Items[ List.Compact.Base ].order

	-- Establecer los valores de fabricación
    Recipe.result = Recipe.name
    Recipe.enabled = false
    Recipe.energy_required = 3

	-- Crear la receta con cada ingredientes
	for Index, Ingredients in pairs( List.Compact.Ingredients ) do

		-- Copiar la recera base
		local recipe = table.deepcopy( Recipe )

		-- Establece el nombre de esta receta
		recipe.name = recipe.name .. "-" .. Index

		-- Establecer los ingredientes
		recipe.ingredients = Ingredients

		-- Guardar la receta
		data:extend( { recipe } )

		-- Guardar la receta
		Recipes[ recipe.result ] = Recipes[ recipe.result ] or { }
		table.insert( Recipes[ recipe.result ], recipe )

		-- Agregar a la tecnologia
		addTechnology( List.Technology, recipe.name )
	end
end

local function CompactItem( List )

	-- Variable contenedora
	local Item = { }
    Item.type = "item"
    Item.name =  List.Compact.Name
    Item.localised_description = { "entity-description." .. _Prefix .. "compact" }

    Item.icons = { }
    Item.icon_size = 64
    Item.icon_mipmaps = 4

	local icon = { }

	icon = { }
	icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/beltbox-icon-base.png"
	table.insert( Item.icons, icon )

	icon = { }
	icon.tint = List.Colour
	icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/beltbox-icon-mask.png"
	table.insert( Item.icons, icon )

	Item.flags = { }
    Item.subgroup = _Prefix .. "compact"
	Item.stack_size = 50
    Item.place_result = Item.name

    Item.order = Items[ List.Compact.Base ].order

	-- Guardar el objeto
	data:extend( { Item } )
	Items[ Item.name ] = Item
end

--------------------------------------
--------------------------------------

local function LoaderEntity( List )

	-- Variable contenedora con los valores referenciales
	local Belt = Entitys[ List.Loader.Base ]

    ---> <---     ---> <---     ---> <---

	-- Variable contenedora
	local Entity = { }
	Entity.type = "loader-1x1"
	Entity.name = List.Loader.Name
	Entity.speed = Belt.speed * _Setting.value
	Entity.localised_description = { "entity-description." .. _Prefix .. "loader" }

	Entity.corpse = "small-remnants"
	Entity.max_health = 170
	Entity.belt_length = 0.5
	Entity.filter_count = 5
	Entity.next_upgrade = List.Loader.Next
	Entity.belt_distance = 0.5
	Entity.container_distance = 1
	Entity.belt_animation_set = Belt.belt_animation_set
	Entity.fast_replaceable_group =  _Prefix .. "loader"
	Entity.structure_render_layer = "object"
	Entity.animation_speed_coefficient = 32

	Entity.collision_box = { { -0.35, -0.35 }, { 0.35, 0.35 } }
	Entity.selection_box = { { -0.5 , -0.5  }, { 0.5 , 0.5  } }

    ---> <---     ---> <---     ---> <---

    Entity.minable = { }
    Entity.minable.result = Entity.name
    Entity.minable.mining_time = 0.1

	Entity.icons = { }
	Entity.icon_size = 64
	Entity.icon_mipmaps = 4

	local icon = { }

	icon = { }
	icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/loader-icon-base.png"
	table.insert( Entity.icons, icon )

	icon = { }
	icon.tint = List.Colour
	icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/loader-icon-mask.png"
	table.insert( Entity.icons, icon )

    ---> <---     ---> <---     ---> <---

	Entity.vehicle_impact_sound = { }
	Entity.vehicle_impact_sound.filename = "__base__/sound/car-metal-impact.ogg"
	Entity.vehicle_impact_sound.volume = 1

	Entity.open_sound = { }
	Entity.open_sound.filename = "__base__/sound/wooden-chest-open.ogg"
	Entity.open_sound.volume = 1

	Entity.close_sound = { }
	Entity.close_sound.filename = "__base__/sound/wooden-chest-close.ogg"
	Entity.close_sound.volume = 1

	Entity.flags = { }
    table.insert( Entity.flags, "player-creation" )
    table.insert( Entity.flags, "placeable-neutral" )
    table.insert( Entity.flags, "fast-replaceable-no-build-while-moving" )

	Entity.collision_mask = { }
    table.insert( Entity.collision_mask, "item-layer" )
    table.insert( Entity.collision_mask, "water-tile" )
    table.insert( Entity.collision_mask, "object-layer" )
    table.insert( Entity.collision_mask, "player-layer" )
    table.insert( Entity.collision_mask, "transport-belt-layer" )

	---> <---     ---> <---     ---> <---

    local Resistances = { }
    Resistances.type = "fire"
    Resistances.percent = 60
    Entity.resistances  = { Resistances }

    ---> <---     ---> <---     ---> <---

	local Sheet = { }
	local Sheets = { }
	local HR_Version = { }



	HR_Version = { }
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-back.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }

	Sheet = { }
	Sheet.hr_version = HR_Version
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-back.png"
	Sheet.priority = "extra-high"
	Sheet.height = 48
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }

	Entity.structure = { }
	Entity.structure.back_patch = { }
	Entity.structure.back_patch.sheet = Sheet



	Sheets = { }
	HR_Version = { }
	HR_Version.draw_as_shadow = true
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-shadow.png"
	HR_Version.priority = "medium"
	HR_Version.height = 96
	HR_Version.width = 144
	HR_Version.scale = 0.5
	HR_Version.shift = { 0.5, 0 }

	Sheet = { }
	Sheet.draw_as_shadow = true
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-shadow.png"
	Sheet.priority = "medium"
	Sheet.height = 48
	Sheet.width = 72
	Sheet.scale = 1
	Sheet.shift = { 0.5, 0 }

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-base.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }

	Sheet = { }
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-base.png"
	Sheet.priority = "extra-high"
	Sheet.height = 48
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-mask.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }
	HR_Version.tint = List.Colour

	Sheet = { }
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-mask.png"
	Sheet.priority = "extra-high"
	Sheet.height = 48
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }
	Sheet.tint = List.Colour

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	Entity.structure.direction_in = { }
	Entity.structure.direction_in.sheets = Sheets



	Sheets = { }
	HR_Version = { }
	HR_Version.draw_as_shadow = true
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-shadow.png"
	HR_Version.priority = "medium"
	HR_Version.height = 96
	HR_Version.width = 144
	HR_Version.scale = 0.5
	HR_Version.shift = { 0.5, 0 }

	Sheet = { }
	Sheet.draw_as_shadow = true
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-shadow.png"
	Sheet.priority = "medium"
	Sheet.height = 48
	Sheet.width = 72
	Sheet.scale = 1
	Sheet.shift = { 0.5, 0 }

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-base.png"
	HR_Version.height = 96
	HR_Version.priority = "extra-high"
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }
	HR_Version.y = 96

	Sheet = { }
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-base.png"
	Sheet.height = 48
	Sheet.priority = "extra-high"
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }
	Sheet.y = 48

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = "__zzYAIM__/mods/graphics/entities/high/loader-mask.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }
	HR_Version.tint = List.Colour
	HR_Version.y = 96

	Sheet = { }
	Sheet.filename = "__zzYAIM__/mods/graphics/entities/low/loader-mask.png"
	Sheet.priority = "extra-high"
	Sheet.height = 48
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }
	Sheet.tint = List.Colour
	Sheet.y = 48

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	Entity.structure.direction_out = { }
	Entity.structure.direction_out.sheets = Sheets

    ---> <---     ---> <---     ---> <---

	-- Guardar la entidad
	data:extend( { Entity } )
	Entitys[ Entity.name ] = Entity
end

local function LoaderRecipe( List )

	-- Variable contenedora
	local Recipe = { }
	Recipe.type = "recipe"

	-- Establecer el nombre de la nueva receta
	Recipe.name = List.Loader.Name

	-- Establecer el apodo del nombre y de la descripcion
	Recipe.localised_name = { "entity-name." .. Recipe.name }
	Recipe.localised_description = { "entity-description." .. _Prefix .. "loader" }

	-- Establece la categoria y el subgrupo
	Recipe.category = List.Category
    Recipe.subgroup = _Prefix .. "loader"

	-- Establecer el orden de la receta
	Recipe.order = Items[ List.Loader.Base ].order

	-- Establecer los valores de fabricación
	Recipe.result = List.Loader.Name
	Recipe.enabled = false
	Recipe.energy_required = 2

	-- Crear la receta con cada ingredientes
	for Index, Ingredients in pairs( List.Loader.Ingredients ) do

		-- Copiar la recera base
		local recipe = table.deepcopy( Recipe )

		-- Establece el nombre de esta receta
		recipe.name = recipe.name .. "-" .. Index

		-- Establecer los ingredientes
		recipe.ingredients = Ingredients

		-- Guardar la receta
		data:extend( { recipe } )

		-- Guardar la receta
		Recipes[ recipe.result ] = Recipes[ recipe.result ] or { }
		table.insert( Recipes[ recipe.result ], recipe )

		-- Agregar a la tecnologia
		addTechnology( List.Technology, recipe.name )
	end
end

local function LoaderItem( List )

	-- Variable contenedora
	local Item = { }
	Item.type = "item"
	Item.name = List.Loader.Name
	Item.localised_description = { "entity-description." .. _Prefix .. "loader" }

	Item.icon_size = 64
	Item.icon_mipmaps = 4
	Item.icons = { }

	local icon = { }

	icon = { }
	icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/loader-icon-base.png"
	table.insert( Item.icons, icon )

	icon = { }
	icon.tint = List.Colour
	icon.icon = "__zzYAIM__/mods/graphics/icons/mipmaps/loader-icon-mask.png"
	table.insert( Item.icons, icon )

    Item.subgroup = _Prefix .. "loader"
	Item.stack_size = 50
	Item.place_result = Item.name

	Item.order = Items[ List.Loader.Base ].order

	-- Guardar el objeto
	data:extend( { Item } )
	Items[ Item.name ] = Item
end

--------------------------------------
--------------------------------------

-- Datos para el compactador y
-- el cargador amarillo
if not Yellow then

	-- Color de los objetos
	local Compact = { }
	Compact.Colour   = { }
	Compact.Colour.r = 210
	Compact.Colour.g = 180
	Compact.Colour.b =  80

	-- Datos generales
	Compact.Tier = "-1"
	Compact.Next = "fast-"
	Compact.Prefix = ""
	Compact.Category = "crafting"
	Compact.Technology = Compact.Prefix .. "splitter"



	-- Valores de los cargadores
	Compact.Loader = { }
	Compact.Loader.Name = _Prefix .. Compact.Prefix .. "loader"
	Compact.Loader.Next = _Prefix .. Compact.Next .. "loader"
	Compact.Loader.Base = Compact.Prefix .. "transport-belt"

	-- Ingredientes de la recetas
	Compact.Loader.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = "iron-plate"    , amount = 5, type = "item" } )
	table.insert( Compact.Ingredient, { name = "transport-belt", amount = 1, type = "item" } )
	table.insert( Compact.Loader.Ingredients, Compact.Ingredient )



	-- Valores de los compactadores
	Compact.Compact = { }
	Compact.Compact.Name = _Prefix .. Compact.Prefix .. "compact"
	Compact.Compact.Next = _Prefix .. Compact.Next .. "compact"
	Compact.Compact.Base = "assembling-machine" .. Compact.Tier

	-- Ingredientes de la recetas
	Compact.Compact.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = "iron-plate"        , amount = 10, type = "item" } )
	table.insert( Compact.Ingredient, { name = "transport-belt"    , amount =  4, type = "item" } )
	table.insert( Compact.Ingredient, { name = "iron-gear-wheel"   , amount = 10, type = "item" } )
	table.insert( Compact.Ingredient, { name = "electronic-circuit", amount =  4, type = "item" } )
	table.insert( Compact.Compact.Ingredients, Compact.Ingredient )



	-- Eliminar la variable
	table.insert( Compacts, Compact )
end

-- Datos para el compactador y
-- el cargador rojo
if not Red then

	-- Color de los objetos
	local Compact = { }
	Compact.Colour   = { }
	Compact.Colour.r = 210
	Compact.Colour.g =  60
	Compact.Colour.b =  60

	-- Datos generales
	Compact.Tier = "-2"
	Compact.Next = "express-"
	Compact.Prefix = "fast-"
	Compact.Category = "crafting"
	Compact.Technology = Compact.Prefix .. "splitter"



	-- Valores de los cargadores
	Compact.Loader = { }
	Compact.Loader.Name = _Prefix .. Compact.Prefix .. "loader"
	Compact.Loader.Next = _Prefix .. Compact.Next .. "loader"
	Compact.Loader.Base = Compact.Prefix .. "transport-belt"

	-- Ingredientes de la recetas
	Compact.Loader.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = _Prefix .. "loader", amount =  1, type = "item" } )
	table.insert( Compact.Ingredient, { name = "iron-gear-wheel"  , amount = 20, type = "item" } )
	table.insert( Compact.Loader.Ingredients, Compact.Ingredient )



	-- Valores de los compactadores
	Compact.Compact = { }
	Compact.Compact.Name = _Prefix .. Compact.Prefix .. "compact"
	Compact.Compact.Base = "assembling-machine" .. Compact.Tier

	-- Ingredientes de la recetas
	Compact.Compact.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = _Prefix .. "compact", amount =  1, type = "item" } )
	table.insert( Compact.Ingredient, { name = "iron-plate"        , amount = 20, type = "item" } )
	table.insert( Compact.Ingredient, { name = "iron-gear-wheel"   , amount = 20, type = "item" } )
	table.insert( Compact.Ingredient, { name = "advanced-circuit"  , amount =  2, type = "item" } )
	table.insert( Compact.Compact.Ingredients, Compact.Ingredient )



	-- Eliminar la variable
	table.insert( Compacts, Compact )
end

-- Datos para el compactador y
-- el cargador azul
if not Blue then

	-- Color de los objetos
	local Compact = { }
	Compact.Colour   = { }
	Compact.Colour.r =  80
	Compact.Colour.g = 180
	Compact.Colour.b = 210

	-- Datos generales
	Compact.Tier = "-3"
	Compact.Prefix = "express-"
	Compact.Category = "crafting-with-fluid"
	Compact.Technology = Compact.Prefix .. "splitter"



	-- Valores de los cargadores
	Compact.Loader = { }
	Compact.Loader.Name = _Prefix .. Compact.Prefix .. "loader"
	Compact.Loader.Base = Compact.Prefix .. "transport-belt"

	-- Ingredientes de la recetas
	Compact.Loader.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = _Prefix .. "fast-loader", type = "item" , amount =  1 } )
	table.insert( Compact.Ingredient, { name = "iron-gear-wheel"       , type = "item" , amount = 40 } )
	table.insert( Compact.Ingredient, { name = "lubricant"             , type = "fluid", amount = 20 } )
	table.insert( Compact.Loader.Ingredients, Compact.Ingredient )



	-- Valores de los compactadores
	Compact.Compact = { }
	Compact.Compact.Name = _Prefix .. Compact.Prefix .. "compact"
	Compact.Compact.Base = "assembling-machine" .. Compact.Tier

	-- Ingredientes de la recetas
	Compact.Compact.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = _Prefix .. "fast-compact", type = "item" , amount =   1 } )
	table.insert( Compact.Ingredient, { name = "iron-plate"             , type = "item" , amount =  30 } )
	table.insert( Compact.Ingredient, { name = "iron-gear-wheel"        , type = "item" , amount =  30 } )
	table.insert( Compact.Ingredient, { name = "lubricant"              , type = "fluid", amount = 100 } )
	table.insert( Compact.Compact.Ingredients, Compact.Ingredient )



	-- Eliminar la variable
	table.insert( Compacts, Compact )
end

--------------------------------------
--------------------------------------

-- Agregar el subgrupo en los objetos
if not subGroup then

	addSubGroup( modName, data.raw[ "item-subgroup" ] )
	local subGroup = { }

	subGroup = { }
	subGroup.type  = "item-subgroup"
	subGroup.name  = _Prefix .. "loader"
	subGroup.group = "logistics"
	subGroup.order = _Prefix .. "a00"
	data:extend( { subGroup } )

	subGroup = { }
	subGroup.type  = "item-subgroup"
	subGroup.name  = _Prefix .. "compact"
	subGroup.group = "logistics"
	subGroup.order = _Prefix .. "a01"
	data:extend( { subGroup } )
end

-- Agregar el subgrupo en las recetas
if not recipeCategory then
	local Category = { }

	Category = { }
	Category.type = "recipe-category"
	Category.name = "compact"
	data:extend( { Category } )

	Category = { }
	Category.type = "recipe-category"
	Category.name = "uncompact"
	data:extend( { Category } )
end

-- Crear el compactador y el cargador
for _, List in pairs( Compacts ) do
	CompactEntity( List )
	CompactRecipe( List )
	CompactItem( List )

	LoaderEntity( List )
	LoaderRecipe( List )
	LoaderItem( List )
end

--------------------------------------
--------------------------------------

---> <---     ---> <---     ---> <---

--------------------------------------
--------------------------------------

local function ReCalculate( ValueOld )

	-- ValueOld = 10kW

	-- Convertir el valor en un número
	local ValueNew = getNumber( ValueOld ) -- 10000 <- 10kW

	-- Potenciar el valor
	ValueNew = ValueNew * _Setting.value -- 500000 <- 10000 * 50

	-- Convertir el numero en cadena
	ValueNew = shortNumber( ValueNew ) -- 500K <- 500000

	-- Agregarle la unidad de medición
	ValueNew = ValueNew .. getUnit( ValueOld ) -- 500KW <- 500K .. 10kW

	-- Devolver el resultado
	return ValueNew -- 500KW
end

-- Mejoras en los objetos

local function BetterClusterGrenade( itemNew, List )

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"

	-- Variable contenedora
	local Grenade = data.raw.projectile

	-- Selecionar el efecto
	Grenade = Grenade[ List.projectile ]

	-- Copiar el efecto
	Grenade = table.deepcopy( Grenade )

	-- Renombrar el efecto
	Grenade.name = _Prefix .. Grenade.name

	-- Renombrar la variable
	local Actions = Grenade.action

	-- Validación de datos
	Actions = Actions[ 1 ] and  Actions or { Actions }

	-- Buscar la acción deseada
	for _, Action in pairs( Actions ) do
		if Action.cluster_count then

			-- Potenciar el valor
			Action.cluster_count = Action.cluster_count * _Setting.value

			-- Guardar el nuevo efecto
			data:extend( { Grenade } )
			List.projectile = Grenade.name
			return true
		end
	end
end

local function BetterGrenade( itemNew, List )

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"

	-- Variable contenedora
	local Grenade = data.raw.projectile

	-- Selecionar el efecto
	Grenade = Grenade[ List.projectile ]

	-- Copiar el efecto
	Grenade = table.deepcopy( Grenade )

	-- Renombrar el efecto
	Grenade.name = _Prefix .. Grenade.name

	-- Renombrar la variable
	local Actions = Grenade.action

	-- Validación de datos
	Actions = Actions[ 1 ] and  Actions or { Actions }

	-- Buscar la acción deseada
	for _, Action in pairs( Actions ) do
		if Action.action_delivery then

			-- Renombrar la variable
			local ActionDelivery = Action.action_delivery
			local TargetEffects = ActionDelivery.target_effects

			-- Validación de datos
			TargetEffects = TargetEffects[ 1 ] and TargetEffects or { TargetEffects }

			-- Buscar la acción deseada
			for _, TargetEffect in pairs( TargetEffects ) do
				if TargetEffect.damage then

					-- Renombrar la variable
					local Damage = TargetEffect.damage

					-- Potenciar el valor
					Damage.amount = Damage.amount * _Setting.value

					-- Guardar el nuevo efecto
					data:extend( { Grenade } )
					List.projectile = Grenade.name
					return true
				end
			end
		end
	end
end

local function BetterCapsule( itemNew )

    -- Valdación básica
	if not itemNew.capsule_action then return false end
	if itemNew.name == _Prefix .. "cliff-explosives" then return false end

	-- Variable contenedora
	local Propietys = { }
	table.insert( Propietys, "capsule_action" )
	table.insert( Propietys, "attack_parameters" )
	table.insert( Propietys, "ammo_type" )

	-- Buscar el efecto deseado
	local Propiety = itemNew
	for _, value in pairs( Propietys ) do
		Propiety = Propiety[ value ]
		if not Propiety then return false end
	end

	-- Buscar la acción deseada
	if not Propiety.action then return false end

	-- Renombrar la variable
	local Actions = Propiety.action

	-- Validación de datos
	Actions = Actions[ 1 ] and Actions or { Actions }

	-- Buscar la acción deseada
	for _, Action in pairs( Actions ) do
		repeat

			-- Renombrar la variable
			local ActionDelivery = Action.action_delivery

			-- Acción no encontrada
			if not ActionDelivery then break end

			-- Daño instantaneo o cura instantanea
			if ActionDelivery.target_effects then

				-- Renombrar la variable
				local TargetEffects = ActionDelivery.target_effects

				-- Validación de datos
				if not TargetEffects[ 1 ] then TargetEffects = { TargetEffects } end

				-- Buscar el efecto deseado
				for _, TargetEffect in pairs( TargetEffects ) do
					if TargetEffect.damage then

						-- Renombrar la variable
						local Damage = TargetEffect.damage

						-- Potenciar el valor
						Damage.amount = Damage.amount * _Setting.value

						-- Marcar el objeto
						itemNew.localised_name[ 3 ] = " [ + ]"

						-- Dejar de buscar
						Action = nil
					end
				end
			end

			-- Daño por efecto
			if ActionDelivery.projectile then

				-- Renombrar la variable
				local Projectile = ActionDelivery.projectile

				-- Modificar el efecto de las granadas
				if Projectile == "grenade" then
					BetterGrenade( itemNew, ActionDelivery )
				end

				-- Modificar el efecto de las granadas agrupadas
				if Projectile == "cluster-grenade" then
					BetterClusterGrenade( itemNew, ActionDelivery )
				end

				-- Dejar de buscar
				Action = nil
			end

		until true

		-- Dejar de buscar
		if not Action then break end
	end
end



local function BetterAmmo( itemNew )

	-- Valdación básica
	if not itemNew.ammo_type then return false end

	-- Validación de datos
	itemNew.magazine_size = itemNew.magazine_size or 1

	-- Potenciar el valor
	itemNew.magazine_size = itemNew.magazine_size * _Setting.value

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

local function BetterFuel( itemNew )

	-- Valdación básica
    if not itemNew.fuel_value then return false end

	-- Potenciar el valor
	itemNew.fuel_value = ReCalculate( itemNew.fuel_value )

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

local function BetterModule( itemNew )

	-- Valdación básica
	if not itemNew.effect then return false end

	-- Variable contenedora
	local Effects = { }
	table.insert( Effects, "productivity" )
	table.insert( Effects, "consumption" )
	table.insert( Effects, "pollution" )
	table.insert( Effects, "speed" )

	-- Buscar el efecto deseado
	for _, Effect in ipairs( Effects ) do
		if itemNew.effect[ Effect ] then

			-- Renombrar la variable
			Effect = itemNew.effect[ Effect ]

			-- Variable contenedora
			local Bonus = Effect.bonus * _Setting.value

			-- Validación de datos
			if Bonus > 300 then Bonus = 300 end

			-- Establecer el valor
			Effect.bonus = Bonus
		end
	end

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

local function BetterRepairTool( itemNew )

	-- Valdación básica
	if not itemNew.durability then return false end
	if not itemNew.speed then return false end

	-- Establecer el suelo en el nuevo objeto
	itemNew.speed = _Setting.value

	-- Validación de datos
	if _Setting.value > itemNew.durability then
		itemNew.durability = _Setting.value
	end

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

-- Mejoras en los equipos

local function BetterEquipament( itemNew )

	-- Valdación básica
    if not itemNew.placed_as_equipment_result then return false end

	-- Variable contenedora
	local Equipment = itemNew
	Equipment = Equipment.placed_as_equipment_result
	Equipment = Equipments[ Equipment ]
	Equipment = table.deepcopy( Equipment )

	-- Validación de datos
	if not Equipment.localised_name then
		Equipment.localised_name =  { "equipment-name." .. Equipment.name }
	end

	-- Renombrar el equipo
	Equipment.name = _Prefix .. Equipment.name

	-- Establecer el podo
	Equipment.localised_name =  { "", Equipment.localised_name, " [ = ]"}

	-- Buffer e IO
	if Equipment.energy_source then

		-- Renombrar la variable
		local Propiety = Equipment.energy_source

		-- Validación de datos
		if Propiety.buffer_capacity then

			-- Potenciar el valor
			Propiety.buffer_capacity = ReCalculate( Propiety.buffer_capacity )

			-- Marcar el objeto y el equipo
			Equipment.localised_name[ 3 ] = " [ + ]"
			itemNew.localised_name[ 3 ] = " [ + ]"
		end

		-- Validación de datos
		if Propiety.input_flow_limit then

			-- Potenciar el valor
			Propiety.input_flow_limit = ReCalculate( Propiety.input_flow_limit )

			-- Marcar el objeto y el equipo
			Equipment.localised_name[ 3 ] = " [ + ]"
			itemNew.localised_name[ 3 ] = " [ + ]"
		end

		-- Validación de datos
		if Propiety.output_flow_limit then

			-- Potenciar el valor
			Propiety.output_flow_limit = ReCalculate( Propiety.output_flow_limit )

			-- Marcar el objeto y el equipo
			Equipment.localised_name[ 3 ] = " [ + ]"
			itemNew.localised_name[ 3 ] = " [ + ]"
		end
	end

	-- Armas
	if Equipment.attack_parameters then

		-- Renombrar la variable
		local Propiety = Equipment.attack_parameters

		-- Validación de datos
		if Propiety.damage_modifier then

			-- Potenciar el valor
			Propiety.damage_modifier = Propiety.damage_modifier * _Setting.value

			-- Marcar el objeto y el equipo
			Equipment.localised_name[ 3 ] = " [ + ]"
			itemNew.localised_name[ 3 ] = " [ + ]"
		end
	end

	-- Escudos
	if Equipment.max_shield_value then

		-- Potenciar el valor
		Equipment.max_shield_value = Equipment.max_shield_value * _Setting.value

		-- Marcar el objeto y el equipo
		Equipment.localised_name[ 3 ] = " [ + ]"
		itemNew.localised_name[ 3 ] = " [ + ]"
	end

	-- Generadores
	if Equipment.power then

		-- Potenciar el valor
		Equipment.power = ReCalculate( Equipment.power )

		-- Marcar el objeto y el equipo
		Equipment.localised_name[ 3 ] = " [ + ]"
		itemNew.localised_name[ 3 ] = " [ + ]"
	end

	-- Recargas de los robopurtos
	if Equipment.charging_energy then

		-- Potenciar el valor
		Equipment.charging_energy = ReCalculate( Equipment.charging_energy )

		-- Marcar el objeto y el equipo
		Equipment.localised_name[ 3 ] = " [ + ]"
		itemNew.localised_name[ 3 ] = " [ + ]"
	end

	-- Regresar el objeto usado
	if Equipment.take_result then
		Equipment.take_result = nil
	end

	-- Guardar el nuevo suelo
	data:extend( { Equipment } )
	Equipments[ Equipment.name ] = Equipment

	-- Establecer el equipamento en el nuevo objeto
	itemNew.placed_as_equipment_result = Equipment.name
end

-- Mejoras en los suelos

local function BetterTile( itemNew )

	-- Valdación básica
    if not itemNew.place_as_tile then return false end

	-- Buscar el suelo deseado
	local Index = false
	for key, _ in pairs( Tiles ) do
		if _Prefix .. key == itemNew.name then
			Index = key break
		end
	end

	-- Suelo no encontrado
	if not Index then return false end

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"

	-- Recorrer todos los suelos
	for key, Tile in pairs( Tiles[ Index ] ) do

		-- Hacer una copia del suelo
		Tile = table.deepcopy( Tile )

		-- Validación de datos
		if not Tile.localised_name then
			Tile.localised_name = { "item-name." .. Tile.name }
		end

		if Tile.next_direction then
			Tile.next_direction = _Prefix .. Tile.next_direction
		end

		if Tile.minable and Tile.minable.result then
			Tile.minable.result = itemNew.name
		end

		-- Renombrar el suelo
		Tile.name = _Prefix .. Tile.name

		-- Beneficion del suelo
		Tile.pollution_absorption_per_second = _Setting.value

		-- Establecer el podo y marcar el suelo
		Tile.localised_name = { "", Tile.localised_name, " [ + ]" }

		-- Guardar el nuevo suelo
		data:extend( { Tile } )
		Tiles[ Tile.name ] = Tile

		-- Establecer el suelo en el nuevo objeto
		if key == 1 then itemNew.place_as_tile.result = Tile.name end
	end
end

-- Mejoras en las entidades

local function BetterLab( itemNew, Lab )

	-- Valdación básica
	if not Lab.researching_speed then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Lab.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Lab.researching_speed = Lab.researching_speed * _Setting.value
end

local function BetterGate( itemNew, Gate )

	-- Valdación básica
	if not Gate.opening_speed then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Gate.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Gate.max_health = Gate.max_health * _Setting.value
end

local function BetterTree( itemNew, Tree )

	-- Valdación básica
	if not Tree.emissions_per_second then return false end
	if Tree.emissions_per_second >= 0 then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Tree.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Tree.emissions_per_second = Tree.emissions_per_second * _Setting.value
end

local function BetterWall( itemNew, Wall )

	-- Valdación básica
	if not Wall.wall_diode_red then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Wall.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Wall.max_health = Wall.max_health * _Setting.value
end

local function BetterBeacon( itemNew, Beacon )

	-- Valdación básica
	if not Beacon.distribution_effectivity then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Beacon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Beacon.distribution_effectivity = Beacon.distribution_effectivity * _Setting.value
end

local function BetterContainer( itemNew, Container )

	-- Valdación básica
	if Container.energy_usage then return false end
	if Container.energy_source then return false end
	if not Container.inventory_size then return false end
	if Container.inventory_size > _Setting.value then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Container.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Container.inventory_size = _Setting.value
end

local function BetterCircuitWire( itemNew, Entity )

	-- Valdación básica
	if not Entity.circuit_wire_max_distance then return false end
	if Entity.circuit_wire_max_distance == 0 then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Entity.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Entity.circuit_wire_max_distance = _Setting.value
end

local function BetterMiningDrill( itemNew, MiningDrill )

	-- Valdación básica
	if not MiningDrill.mining_speed then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	MiningDrill.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	MiningDrill.mining_speed = MiningDrill.mining_speed * _Setting.value
end

local function BetterElectricPole( itemNew, ElectricPole )

	-- Valdación básica
	if not ElectricPole.maximum_wire_distance then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	ElectricPole.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	if 	_Setting.value > ElectricPole.maximum_wire_distance then
		local Value = _Setting.value
		if Value > 64 then Value = 64 end
		ElectricPole.maximum_wire_distance = Value
	end
end

local function BetterRailwayEntity( itemNew, Entity )

	-- Entidades a modificar
	local types = { }
	table.insert( types, "locomotive" )
	table.insert( types, "cargo-wagon" )
	table.insert( types, "fluid-wagon" )
	table.insert( types, "artillery-wagon" )

	-- Valdación básica
	if not table.getKey( types, Entity.type ) then return false end

	-- Potenciar la velocidad
	Entity.max_speed = Entity.max_speed * _Setting.value
    Entity.air_resistance = 0

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Entity.localised_name[ 3 ] = " [ + ]"
end

local function BetterCraftingMachine( itemNew, Machine )

	-- Valdación básica
	if not Machine.crafting_speed then return false end

	-- Potenciar la absorción de la contaminación
	if Machine.energy_source then
		local EnergySource = Machine.energy_source
		local Pollution = EnergySource.emissions_per_minute
		if Pollution and Pollution < 0 then
			Pollution = Pollution  * _Setting.value
			EnergySource.emissions_per_minute = Pollution

			-- Marcar el objeto y la entidad
			itemNew.localised_name[ 3 ] = " [ + ]"
			Machine.localised_name[ 3 ] = " [ + ]"

			return true
		end
	end

	local Ingredient = Machine.source_inventory_size
	local Result = Machine.result_inventory_size
	if Result and Ingredient then
		if Result == 0 and Ingredient == 0 then
			return false
		end
	end

	-- Potenciar la velocidad de creación
	local Speed = Machine.crafting_speed
	Speed = Speed * _Setting.value
	Machine.crafting_speed = Speed

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Machine.localised_name[ 3 ] = " [ + ]"
end



local function BetterRobot( itemNew, Robot )

	-- Valdación básica
	if not Robot.energy_per_move then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Robot.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Robot.speed = Robot.speed * _Setting.value
end

local function BetterRoboport( itemNew, Roboport )

	-- Valdación básica
	if not Roboport.charging_energy then return false end
	if not Roboport.charging_offsets then return false end
	if #Roboport.charging_offsets <= 0 then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Roboport.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Roboport.charging_energy = ReCalculate( Roboport.charging_energy )
end



local function BetterGenerator( itemNew, Generator )

	-- Valdación básica
	if not Generator.max_power_output then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Generator.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Generator.max_power_output = ReCalculate( Generator.max_power_output )
end

local function BetterSolarPanel( itemNew, Generator )

	-- Valdación básica
	if not Generator.production then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Generator.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Generator.production = ReCalculate( Generator.production )
end

local function BetterAccumulator( itemNew, Accumulator )

	-- Valdación básica
	if not Accumulator.charge_animation then return false end

	-- Renombrar la variable
	local EnergySource = Accumulator.energy_source

	-- Valdación básica
	if not EnergySource then return false end

	local Output = EnergySource.output_flow_limit
	if getNumber( Output ) == 0 then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Accumulator.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	EnergySource.output_flow_limit = ReCalculate( EnergySource.output_flow_limit )
	EnergySource.input_flow_limit = ReCalculate( EnergySource.input_flow_limit )
	EnergySource.buffer_capacity = ReCalculate( EnergySource.buffer_capacity )
end



local function BetterFluidWeapon( itemNew, Weapon )

	-- Variable contenedora
	local Value = Weapon.attack_parameters

	-- Valdación básica
	if not Value then return false end
	if not Value.fluids then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Weapon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	for _, fluid in pairs( Value.fluids ) do
		if fluid.damage_modifier then
			fluid.damage_modifier = fluid.damage_modifier * _Setting.value
		end
	end
end

local function BetterWeaponAmmoless( itemNew, Weapon )

	-- Variable contenedora
	local Value = Weapon.attack_parameters

	-- Valdación básica
	if not Value then return false end
	if not Value.damage_modifier then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Weapon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Value.damage_modifier = Value.damage_modifier * _Setting.value
end



local function BetterPump( itemNew, Pump )

	-- Valdación básica
	if not Pump.pumping_speed then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Pump.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Pump.pumping_speed
	Value = Value * _Setting.value
	Pump.pumping_speed = Value
end

local function BetterFluidWagon( itemNew, Wagon )

	-- Valdación básica
	if not Wagon.capacity then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Wagon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Wagon.capacity = Wagon.capacity * _Setting.value
end

local function BetterInputFluidBox( itemNew, Container )

	-- Variable contenedora
	local Value = Container.fluid_box

	-- Valdación básica
	if not Value then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Container.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	if Value.height then
		Value.height = Value.height * _Setting.value
	end

	if Value.base_area then
		Value.base_area = Value.base_area * _Setting.value
	end

	for _, value in pairs( Value.pipe_connections or { } ) do
		if value.max_underground_distance then
			local Distance = value.max_underground_distance
			if _Setting.value > Distance then Distance = _Setting.value end
			if Distance > 250 then Distance = 250 end
			value.max_underground_distance = Distance
		end
	end
end

local function BetterOutputFluidBox( itemNew, Container )

	-- Variable contenedora
	local Value = Container.output_fluid_box

	-- Valdación básica
	if not Value then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Container.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	if Value.height then
		Value.height = Value.height * _Setting.value
	end

	if Value.base_area then
		Value.base_area = Value.base_area * _Setting.value
	end
end



local function BetterBelt( itemNew, Belt )

	-- Valdación básica
	if not Belt.related_underground_belt then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Belt.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Belt.speed
	Value = Value * _Setting.value
	Belt.speed = Value
end

local function BetterLoader( itemNew, Loader )

	-- Valdación básica
	if not Loader.container_distance then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Loader.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Loader.speed
	Value = Value * _Setting.value
	Loader.speed = Value
end

local function BetterInserter( itemNew, Inserter )

	-- Valdación básica
	if not Inserter.extension_speed then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Inserter.localised_name[ 3 ] = " [ + ]"

	-- Variable contenedora
	local Speed = 0

	-- Potenciar el valor
	Speed = Inserter.extension_speed
	Speed = Speed * _Setting.value
	if Speed > 0.2 then Speed = 0.2 end
	Inserter.extension_speed = Speed

	Speed = Inserter.rotation_speed
	Speed = Speed * _Setting.value
	if Speed > 0.2 then Speed = 0.2 end
	Inserter.rotation_speed = Speed
end

local function BetterSplitter( itemNew, Splitter )

	-- Valdación básica
	if not Splitter.structure_patch then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Splitter.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Splitter.speed
	Value = Value * _Setting.value
	Splitter.speed = Value
end

local function BetterUndergroundBelt( itemNew, Belt )

	-- Valdación básica
	if not Belt.max_distance then return false end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Belt.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = 0

	Value = Belt.max_distance
	Value = Value * _Setting.value
	if Value > 250 then Value = 250 end
	Belt.max_distance = Value

	Value = Belt.speed
	Value = Value * _Setting.value
	Belt.speed = Value
end

local function BetterEntity( itemNew )

    -- Valdación básica
	if not itemNew.place_result then return false end

	-- Variable contenedora
	local Entity = Entitys[ itemNew.place_result ]

	-- Hacer una copia de la entidad
	Entity = table.deepcopy( Entity )

	-- Asignar objeto como minable
	if Entity.minable and Entity.minable.result then
		Entity.minable.result = itemNew.name
	end

    -- Sobre escribir los nombres
	if not Entity.localised_name then
		Entity.localised_name = { "entity-name." .. Entity.name }
	end Entity.localised_name = { "", Entity.localised_name, " [ = ]" }

    -- Sobre escribir las descripciones
    if not Entity.localised_description then
		Entity.localised_description = { "entity-description." .. Entity.name }
	end Entity.localised_description = Entity.localised_description

	-- Asignar la actualización
	if Entity.next_upgrade then
		Entity.next_upgrade = _Prefix .. Entity.next_upgrade
	end

	-- Renombrar la entidad
	Entity.name = _Prefix .. Entity.name

	---> <---     ---> <---     ---> <---

	-- Variado
	BetterLab( itemNew, Entity )
	BetterGate( itemNew, Entity )
	BetterTree( itemNew, Entity )
	BetterWall( itemNew, Entity )
	BetterBeacon( itemNew, Entity )
	BetterContainer( itemNew, Entity )
	BetterCircuitWire( itemNew, Entity )
	BetterMiningDrill( itemNew, Entity )
	BetterElectricPole( itemNew, Entity )
	BetterRailwayEntity( itemNew, Entity )
	BetterCraftingMachine( itemNew, Entity )

	-- Robots
	BetterRobot( itemNew, Entity )
	BetterRoboport( itemNew, Entity )

	-- Energy
	BetterGenerator( itemNew, Entity )
	BetterSolarPanel( itemNew, Entity )
	BetterAccumulator( itemNew, Entity )

	-- Armas
	BetterFluidWeapon( itemNew, Entity )
	BetterWeaponAmmoless( itemNew, Entity )

	-- Fluidos
	BetterPump( itemNew, Entity )
	BetterFluidWagon( itemNew, Entity )
	BetterInputFluidBox( itemNew, Entity )
	BetterOutputFluidBox( itemNew, Entity )

	-- Logistica
	BetterBelt( itemNew, Entity )
	BetterLoader( itemNew, Entity )
	BetterInserter( itemNew, Entity )
	BetterSplitter( itemNew, Entity )
	BetterUndergroundBelt( itemNew, Entity )

	---> <---     ---> <---     ---> <---

	-- Guardar el insertador
	data:extend( { Entity } )
	Entitys[ Entity.name ] = Entity

	-- Establecer el insertador al nuevo objeto
	itemNew.place_result = Entity.name
end

--------------------------------------
--------------------------------------

---> <---     ---> <---     ---> <---

--------------------------------------
--------------------------------------

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

--------------------------------------
--------------------------------------

local function CreateRecipe( itemOld )

	-- Variable contenedora
	local itemNew = Items[ _Prefix .. itemOld.name ]

    -- Valdación básica
	if not itemNew then return false end

	-- Valores para la receta
    local recipes      = { }
    recipes.compact    = { }
    recipes.uncompact  = { }

    -- Valores para la descompresion
    recipes.uncompact.name        = Prefix .. "un" .. modName .. "-" .. itemOld.name
    recipes.uncompact.results     = { { type = "item", amount = _Setting.value, name = itemOld.name            } }
    recipes.uncompact.ingredients = { { type = "item", amount = 1             , name = _Prefix .. itemOld.name } }
    recipes.uncompact.action      = true

    -- Valores para la compresion
    recipes.compact.name        = Prefix .. "" .. modName .. "-" .. itemOld.name
    recipes.compact.results     = { { type = "item", amount = 1             , name = _Prefix .. itemOld.name } }
    recipes.compact.ingredients = { { type = "item", amount = _Setting.value, name = itemOld.name            } }

    ---> <---     ---> <---     ---> <---

    for Category, Recipe in pairs( recipes ) do

        -- Copiar el objeto
        local recipeNew = { }

        -- Crear las recetas
        recipeNew.name = Recipe.name
        recipeNew.type = "recipe"

		recipeNew.order    = itemOld.order
        recipeNew.enabled  = false
        recipeNew.category = Category
        recipeNew.subgroup = _Prefix .. itemOld.subgroup

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
        table.insert( recipeName, { "recipe-name." .. Prefix .. Category } )
		table.insert( recipeName, itemNew.localised_name )

        -- Añadir el pez
        addIcon( itemOld, recipeNew, Recipe.action )

		---> <---     ---> <---     ---> <---

        -- Guardar la nueva receta
        data:extend( { recipeNew } )
        addTechnology( itemOld.name, recipeNew.name )
		local Result = recipeNew.results[ 1 ].name
		Recipes[ Result ] = Recipes[ Result ] or { }
		table.insert( Recipes[ Result ], recipeNew )
    end
end

local function CreateItem( itemOld )

    -- Copiar el objeto
    local itemNew = table.deepcopy( itemOld )

    -- Establecer los nombres
    itemNew.name     = _Prefix .. itemOld.name
    itemNew.subgroup = _Prefix .. itemOld.subgroup

    -- Preparar el nuevo nombre
	if not itemOld.localised_name then
		if itemOld.place_result then
			itemNew.localised_name = { "entity-name." .. itemOld.name }
		elseif itemOld.place_as_tile then
			itemNew.localised_name = { "item-name." .. itemOld.name }
		elseif itemOld.placed_as_equipment_result then
			itemNew.localised_name = { "equipment-name." .. itemOld.name }
		else
			itemNew.localised_name = { "item-name." .. itemOld.name }
		end
	end

    -- Sobre escribir los nombres
	itemNew.localised_name = { "", itemNew.localised_name, " [ = ]"}

    -- Sobre escribir las descripciones
    if not itemOld.localised_description then
        if itemOld.place_result then
            itemNew.localised_description = { "entity-description." .. itemOld.name }
        elseif itemOld.place_as_tile then
            itemNew.localised_description = { "tile-description." .. itemOld.name }
        else
            itemNew.localised_description = { "item-description." .. itemOld.name }
        end
    end

    -- Agregar el pez de referencia
    addIcon( itemOld, itemNew )

    ---> <---     ---> <---     ---> <---

	-- Mejoras en los objetos
	BetterAmmo( itemNew )
	BetterFuel( itemNew )
	BetterModule( itemNew )
	BetterCapsule( itemNew )
	BetterRepairTool( itemNew )

	-- Mejoras en los equipos
	BetterEquipament( itemNew )

	-- Mejoras en los suelos
	BetterTile( itemNew )

	-- Mejoras en las entidades
	BetterEntity( itemNew )

	---> <---     ---> <---     ---> <---

	-- Eliminar los valores problematicos
	itemNew.icon = nil
	itemNew.pictures = nil
	itemNew.icon_tintable = nil
	itemNew.icon_tintable_mask = nil
	itemNew.dark_background_icon = nil

	-- Posible problema con la imagen del objeto
	for key, value in pairs( itemNew ) do
		while isString( value ) and #value >= 4 do
			local Flag = string.sub( value, -4 ) == ".png"
			if not Flag then break end
			Log( modName .. " > " .. itemNew.name .. " > itemNew." .. key .. " = nil" )
			break
		end
	end

	---> <---     ---> <---     ---> <---

	-- Guardar el objeto
	data:extend( { itemNew } )
    Items[ itemNew.name ] = itemNew
end

--------------------------------------
--------------------------------------

-- Revisar todos los objetos
for _, item in pairs( Items ) do
    repeat

        -- Evitar los rieles
        if item.curved_rail then break end

        -- Evitar estos tipos
        if table.getKey( AvoidTypes, item.type ) then break end

        -- Evitar lo inapilable
		if table.getKey( item.flags, "hidden" ) then break end
		if table.getKey( item.flags, "not-stackable" ) then break end

        -- Evitar estos patrones
		local NotValid = false
		for _, Pattern in pairs( AvoidPatterns ) do
			NotValid = string.find( item.name, Pattern )
			if NotValid then break end
		end if NotValid then break end

		-- Evitar un bucle
        local prefix = Prefix
        prefix = string.gsub( prefix, "-", "%%-" )
        prefix = string.find( item.name, prefix )
        if prefix then break end

		-- Crear el nuevo objeto
		CreateItem( item )
		CreateRecipe( item )

	until true
end

------------------------------------