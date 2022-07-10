--------------------------------------

-- compact-items.lua

--------------------------------------
--------------------------------------

-- Identifica el mod que se está usando
local MOD = GPrefix.getFile( debug.getinfo( 1 ).short_src )

-- Crear la vareble si no existe
GPrefix.MODs[ MOD ] = GPrefix.MODs[ MOD ] or { }

-- Guardar en el acceso rapido
GPrefix.MOD = GPrefix.MODs[ MOD ]

--------------------------------------
--------------------------------------

local Files = { }
table.insert( Files, "settings" )

-- Cargar la configuración
if GPrefix.getKey( Files, GPrefix.File ) then

    -- Preparar la configuración de este mod
    local SettingOption =  {
        type          = "int-setting",
        setting_type  = "startup",
        default_value = 50,
        minimum_value = 1,
        maximum_value = 65000
    }

    -- Construir valores
    SettingOption.name  = GPrefix.MOD.Prefix_MOD
    SettingOption.order = GPrefix.SettingOrder[ SettingOption.type ]
	SettingOption.order = SettingOption.order .. "-" .. SettingOption.name
    SettingOption.localised_name  = { GPrefix.MOD.Local .. "setting-name"}
    SettingOption.localised_description  = { GPrefix.MOD.Local .. "setting-description"}

    -- Cargar configuración del mod al juego
    data:extend( { SettingOption } )
	return
end

--------------------------------------
--------------------------------------

Files = { }
table.insert( Files, "control" )
table.insert( Files, "data-final-fixes" )

-- Es necesario ejecutar este codigo??
if not GPrefix.getKey( Files, GPrefix.File ) then return end

-- MOD Inactivo
if not GPrefix.MOD.Active then return end

--------------------------------------
--------------------------------------

---> <---     ---> <---     ---> <---

--------------------------------------
--------------------------------------

-- Renombrar la variable
local GMOD = GPrefix.MOD

-- Agregar al jugador los objeto
local function AddItems( Player )

	-- Identificar al jugador
	local Data = { Player = Player }
	local gPlayer = GPrefix.setGlobal( Data ).Player

	-- Lista de objetos a agregar
	local Items = { }
	table.insert( Items, { count = 1, name = GMOD.Prefix_MOD_ .. "compact" } )

	-- Agregar los objetos
	for _, Item in pairs( Items ) do
		repeat
			local Flag = gPlayer[ Item.name ]
			Flag = Flag and gPlayer[ Item.name ] <= Item.count
			if Flag then break end gPlayer[ Item.name ] = Item.count
			Player.insert( Item )
		until true
	end
end

-- Inicializar las variables
local function Initialize( Player )

	-- Identificar el MOD
    GPrefix.MOD = GPrefix.MODs[ MOD ]

	-- Validación básica
	if not( game or Player ) then return end

	-- Jugadores a inicializar
    local Players = game.players
    if Player then Players = { Player } end

    -- Inicializar jugadores
    for _, _Player in pairs( Players ) do
		if _Player.connected then AddItems( _Player ) end
    end

	-- Inicializar las tecnologias
    GPrefix.MOD = false
end

Files = { }
table.insert( Files, "control" )

-- Darle al jugador un compactador
if GPrefix.getKey( Files, GPrefix.File ) then

	-- Gestor de eventos
    GPrefix.addEvent( {

        -- Al crear el mapa
        [ "on_init" ] = Initialize,

        -- Al cargar el mapa
        [ "on_load" ] = Initialize,

        -- Al unirse a la partida
        [ { "on_event", defines.events.on_player_created } ] = function( Event )
            Initialize( game.get_player( Event.player_index ) )
        end,
	} )

	return
end

--------------------------------------
--------------------------------------

---> <---     ---> <---     ---> <---

--------------------------------------
--------------------------------------

local function BrighterColour( Colour )
    local function SubFunction( RGB )
        return math.floor( ( RGB + 240 ) / 2 )
    end

	local ColourNew = { }
	ColourNew.r = SubFunction( Colour.r )
	ColourNew.g = SubFunction( Colour.g )
	ColourNew.b = SubFunction( Colour.b )

	return ColourNew
end

local function CompactEntity( List )

	-- Variable contenedora con los valores referenciales
	local AssemblingMachine = GPrefix.Entities[ List.Compact.Base ]

	---> <---     ---> <---     ---> <---

	-- Variable contenedora
    local Entity = { }
    Entity.type = "furnace"
    Entity.name = List.Compact.Name
    Entity.energy_usage   = AssemblingMachine.energy_usage
    Entity.crafting_speed = AssemblingMachine.crafting_speed
    Entity.crafting_categories   = { "compact", "uncompact" }
    Entity.localised_description = { "entity-description." .. GMOD.Prefix_MOD_ .. "compact" }

    Entity.corpse = "small-remnants"
    Entity.max_health = AssemblingMachine.max_health
	Entity.next_upgrade = List.Compact.Next
    Entity.allowed_effects = AssemblingMachine.allowed_effects
    Entity.dying_explosion = "explosion"
    Entity.show_recipe_icon = true
    Entity.result_inventory_size = 1
    Entity.source_inventory_size = 1
	Entity.fast_replaceable_group =  GMOD.Prefix_MOD_ .. "compact"

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
    icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/beltbox-icon-base.png"
    table.insert( Entity.icons, icon )

    icon = { }
    icon.tint = List.Colour
    icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/beltbox-icon-mask.png"
    table.insert( Entity.icons, icon )

    ---> <---     ---> <---     ---> <---

    Entity.animation = { }
    Entity.animation.layers = { }

    local Layer = { }
    local HR_Version = { }

	HR_Version = { }
    HR_Version.frame_count = 60
    HR_Version.line_length = 10
    HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/beltbox-base.png"
    HR_Version.priority = "high"
    HR_Version.height = 96
    HR_Version.scale  = 0.5
    HR_Version.shift  = { 0, 0 }
    HR_Version.width  = 96

    Layer = { }
    Layer.frame_count = 60
    Layer.line_length = 10
    Layer.filename = GPrefix.FolderGraphics .. "entity/low/beltbox-base.png"
    Layer.priority = "high"
    Layer.height = 48
    Layer.scale  = 1
    Layer.shift  = { 0, 0 }
    Layer.width  = 48

    Layer.hr_version = HR_Version
    table.insert( Entity.animation.layers, Layer )

    HR_Version = { }
    HR_Version.repeat_count = 60
    HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/beltbox-mask.png"
    HR_Version.priority = "high"
    HR_Version.height = 96
    HR_Version.scale = 0.5
    HR_Version.shift = { 0, 0 }
    HR_Version.width = 96
    HR_Version.tint  = List.Colour

    Layer = { }
    Layer.repeat_count = 60
    Layer.filename = GPrefix.FolderGraphics .. "entity/low/beltbox-mask.png"
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
    HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/beltbox-shadow.png"
    HR_Version.height = 96
    HR_Version.scale = 0.5
    HR_Version.shift = { 0.5, 0 }
    HR_Version.width = 144

    Layer = { }
    Layer.draw_as_shadow  = true
    Layer.frame_count = 60
    Layer.line_length = 10
    Layer.filename = GPrefix.FolderGraphics .. "entity/low/beltbox-shadow.png"
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
    HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/beltbox-working.png"
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
    Animation.filename = GPrefix.FolderGraphics .. "entity/low/beltbox-working.png"
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
	GPrefix.Entities[ Entity.name ] = Entity
end

local function CompactRecipe( List )

	-- Variable contenedora
	local Recipe = { }
    Recipe.type = "recipe"

	-- Establecer el nombre de la nueva receta
    Recipe.name = List.Compact.Name

	-- Establecer el apodo de la descripcion
	Recipe.localised_description = { "entity-description." .. GMOD.Prefix_MOD_ .. "compact" }

	-- Establece la categoria y el subgrupo
    Recipe.category = List.Category
    Recipe.subgroup = GMOD.Prefix_MOD_ .. "compact"

	-- Establecer el orden de la receta
    Recipe.order = GPrefix.Items[ List.Compact.Base ].order

	-- Establecer los valores de fabricación
    Recipe.result = Recipe.name
    Recipe.enabled = false
    Recipe.energy_required = 3

	-- Crear la receta con cada ingredientes
	for Index, Ingredients in pairs( List.Compact.Ingredients ) do

		-- Copiar la recera base
		local recipe = GPrefix.DeepCopy( Recipe )

		-- Establece el nombre de esta receta
		recipe.name = recipe.name .. "-" .. Index

		-- Establecer los ingredientes
		recipe.ingredients = Ingredients

		-- Guardar la receta
		data:extend( { recipe } )

		-- Guardar la receta
		GPrefix.Recipes[ recipe.result ] = GPrefix.Recipes[ recipe.result ] or { }
		table.insert( GPrefix.Recipes[ recipe.result ], recipe )

		-- Agregar a la tecnologia
		GPrefix.addTechnology( List.Technology, recipe.name )
	end
end

local function CompactItem( List )

	-- Variable contenedora
	local Item = { }
    Item.type = "item"
    Item.name =  List.Compact.Name
    Item.localised_description = { "entity-description." .. GMOD.Prefix_MOD_ .. "compact" }

    Item.icons = { }
    Item.icon_size = 64
    Item.icon_mipmaps = 4

	local icon = { }

	icon = { }
	icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/beltbox-icon-base.png"
	table.insert( Item.icons, icon )

	icon = { }
	icon.tint = List.Colour
	icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/beltbox-icon-mask.png"
	table.insert( Item.icons, icon )

	Item.flags = { }
    Item.subgroup = GMOD.Prefix_MOD_ .. "compact"
	Item.stack_size = 50
    Item.place_result = Item.name

    Item.order = GPrefix.Items[ List.Compact.Base ].order

	-- Guardar el objeto
	data:extend( { Item } )
	GPrefix.Items[ Item.name ] = Item
end

--------------------------------------
--------------------------------------

local function LoaderEntity( List )

	-- Variable contenedora con los valores referenciales
	local Belt = GPrefix.Entities[ List.Loader.Base ]

    ---> <---     ---> <---     ---> <---

	-- Variable contenedora
	local Entity = { }
	Entity.type = "loader-1x1"
	Entity.name = List.Loader.Name
	Entity.speed = Belt.speed * GMOD.Value
	Entity.localised_description = { "entity-description." .. GMOD.Prefix_MOD_ .. "loader" }

	Entity.corpse = "small-remnants"
	Entity.max_health = 170
	Entity.belt_length = 0.5
	Entity.filter_count = 5
	Entity.next_upgrade = List.Loader.Next
	Entity.belt_distance = 0.5
	Entity.container_distance = 1
	Entity.belt_animation_set = Belt.belt_animation_set
	Entity.fast_replaceable_group =  GMOD.Prefix_MOD_ .. "loader"
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
	icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/loader-icon-base.png"
	table.insert( Entity.icons, icon )

	icon = { }
	icon.tint = List.Colour
	icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/loader-icon-mask.png"
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
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-back.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }

	Sheet = { }
	Sheet.hr_version = HR_Version
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-back.png"
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
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-shadow.png"
	HR_Version.priority = "medium"
	HR_Version.height = 96
	HR_Version.width = 144
	HR_Version.scale = 0.5
	HR_Version.shift = { 0.5, 0 }

	Sheet = { }
	Sheet.draw_as_shadow = true
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-shadow.png"
	Sheet.priority = "medium"
	Sheet.height = 48
	Sheet.width = 72
	Sheet.scale = 1
	Sheet.shift = { 0.5, 0 }

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-base.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }

	Sheet = { }
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-base.png"
	Sheet.priority = "extra-high"
	Sheet.height = 48
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-mask.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }
	HR_Version.tint = List.Colour

	Sheet = { }
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-mask.png"
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
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-shadow.png"
	HR_Version.priority = "medium"
	HR_Version.height = 96
	HR_Version.width = 144
	HR_Version.scale = 0.5
	HR_Version.shift = { 0.5, 0 }

	Sheet = { }
	Sheet.draw_as_shadow = true
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-shadow.png"
	Sheet.priority = "medium"
	Sheet.height = 48
	Sheet.width = 72
	Sheet.scale = 1
	Sheet.shift = { 0.5, 0 }

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-base.png"
	HR_Version.height = 96
	HR_Version.priority = "extra-high"
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }
	HR_Version.y = 96

	Sheet = { }
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-base.png"
	Sheet.height = 48
	Sheet.priority = "extra-high"
	Sheet.width = 48
	Sheet.scale = 1
	Sheet.shift = { 0, 0 }
	Sheet.y = 48

	Sheet.hr_version = HR_Version
	table.insert( Sheets, Sheet )

	HR_Version = { }
	HR_Version.filename = GPrefix.FolderGraphics .. "entity/high/loader-mask.png"
	HR_Version.priority = "extra-high"
	HR_Version.height = 96
	HR_Version.width = 96
	HR_Version.scale = 0.5
	HR_Version.shift = { 0, 0 }
	HR_Version.tint = List.Colour
	HR_Version.y = 96

	Sheet = { }
	Sheet.filename = GPrefix.FolderGraphics .. "entity/low/loader-mask.png"
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
	GPrefix.Entities[ Entity.name ] = Entity
end

local function LoaderRecipe( List )

	-- Variable contenedora
	local Recipe = { }
	Recipe.type = "recipe"

	-- Establecer el nombre de la nueva receta
	Recipe.name = List.Loader.Name

	-- Establecer el apodo de la descripcion
	Recipe.localised_description = { "entity-description." .. GMOD.Prefix_MOD_ .. "loader" }

	-- Establece la categoria y el subgrupo
	Recipe.category = List.Category
    Recipe.subgroup = GMOD.Prefix_MOD_ .. "loader"

	-- Establecer el orden de la receta
	Recipe.order = GPrefix.Items[ List.Loader.Base ].order

	-- Establecer los valores de fabricación
	Recipe.result = List.Loader.Name
	Recipe.enabled = false
	Recipe.energy_required = 2

	-- Crear la receta con cada ingredientes
	for Index, Ingredients in pairs( List.Loader.Ingredients ) do

		-- Copiar la recera base
		local recipe = GPrefix.DeepCopy( Recipe )

		-- Establece el nombre de esta receta
		recipe.name = recipe.name .. "-" .. Index

		-- Establecer los ingredientes
		recipe.ingredients = Ingredients

		-- Guardar la receta
		data:extend( { recipe } )

		-- Guardar la receta
		GPrefix.Recipes[ recipe.result ] = GPrefix.Recipes[ recipe.result ] or { }
		table.insert( GPrefix.Recipes[ recipe.result ], recipe )

		-- Agregar a la tecnologia
		GPrefix.addTechnology( List.Technology, recipe.name )
	end
end

local function LoaderItem( List )

	-- Variable contenedora
	local Item = { }
	Item.type = "item"
	Item.name = List.Loader.Name
	Item.localised_description = { "entity-description." .. GMOD.Prefix_MOD_ .. "loader" }

	Item.icon_size = 64
	Item.icon_mipmaps = 4
	Item.icons = { }

	local icon = { }

	icon = { }
	icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/loader-icon-base.png"
	table.insert( Item.icons, icon )

	icon = { }
	icon.tint = List.Colour
	icon.icon = GPrefix.FolderGraphics .. "icons/mipmaps/loader-icon-mask.png"
	table.insert( Item.icons, icon )

    Item.subgroup = GMOD.Prefix_MOD_ .. "loader"
	Item.stack_size = 50
	Item.place_result = Item.name

	Item.order = GPrefix.Items[ List.Loader.Base ].order

	-- Guardar el objeto
	data:extend( { Item } )
	GPrefix.Items[ Item.name ] = Item
end

--------------------------------------
--------------------------------------

-- Crear la vareble si no existe
GMOD.Result = GMOD.Result or { }

-- Cargador y compactador Amarillo
if true then

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
	Compact.Loader.Name = GMOD.Prefix_MOD_ .. Compact.Prefix .. "loader"
	Compact.Loader.Next = GMOD.Prefix_MOD_ .. Compact.Next .. "loader"
	Compact.Loader.Base = Compact.Prefix .. "transport-belt"

	-- Ingredientes de la recetas
	Compact.Loader.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-plate"    , amount = 5, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "transport-belt", amount = 1, type = "item" } )
	table.insert( Compact.Loader.Ingredients, Compact.Ingredient )



	-- Valores de los compactadores
	Compact.Compact = { }
	Compact.Compact.Name = GMOD.Prefix_MOD_ .. Compact.Prefix .. "compact"
	Compact.Compact.Next = GMOD.Prefix_MOD_ .. Compact.Next .. "compact"
	Compact.Compact.Base = "assembling-machine" .. Compact.Tier

	-- Ingredientes de la recetas
	Compact.Compact.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-plate"        , amount = 10, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "transport-belt"    , amount =  4, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-gear-wheel"   , amount = 10, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "electronic-circuit", amount =  4, type = "item" } )
	table.insert( Compact.Compact.Ingredients, Compact.Ingredient )



	-- Eliminar la variable
	table.insert( GMOD.Result, Compact )
end

-- Cargador y compactador Rojo
if true then

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
	Compact.Loader.Name = GMOD.Prefix_MOD_ .. Compact.Prefix .. "loader"
	Compact.Loader.Next = GMOD.Prefix_MOD_ .. Compact.Next .. "loader"
	Compact.Loader.Base = Compact.Prefix .. "transport-belt"

	-- Ingredientes de la recetas
	Compact.Loader.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "loader", amount =  1, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-gear-wheel"  , amount = 20, type = "item" } )
	table.insert( Compact.Loader.Ingredients, Compact.Ingredient )



	-- Valores de los compactadores
	Compact.Compact = { }
	Compact.Compact.Name = GMOD.Prefix_MOD_ .. Compact.Prefix .. "compact"
	Compact.Compact.Base = "assembling-machine" .. Compact.Tier

	-- Ingredientes de la recetas
	Compact.Compact.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "compact", amount =  1, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-plate"        , amount = 20, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-gear-wheel"   , amount = 20, type = "item" } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "advanced-circuit"  , amount =  2, type = "item" } )
	table.insert( Compact.Compact.Ingredients, Compact.Ingredient )



	-- Eliminar la variable
	table.insert( GMOD.Result, Compact )
end

-- Cargador y compactador Azul
if true then

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
	Compact.Loader.Name = GMOD.Prefix_MOD_ .. Compact.Prefix .. "loader"
	Compact.Loader.Base = Compact.Prefix .. "transport-belt"

	-- Ingredientes de la recetas
	Compact.Loader.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "fast-loader", type = "item" , amount =  1 } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-gear-wheel"       , type = "item" , amount = 40 } )
	table.insert( Compact.Ingredient, { name = "lubricant"             , type = "fluid", amount = 20 } )
	table.insert( Compact.Loader.Ingredients, Compact.Ingredient )



	-- Valores de los compactadores
	Compact.Compact = { }
	Compact.Compact.Name = GMOD.Prefix_MOD_ .. Compact.Prefix .. "compact"
	Compact.Compact.Base = "assembling-machine" .. Compact.Tier

	-- Ingredientes de la recetas
	Compact.Compact.Ingredients = { }

	-- Receta
	Compact.Ingredient = { }
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "fast-compact", type = "item" , amount =   1 } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-plate"             , type = "item" , amount =  30 } )
	table.insert( Compact.Ingredient, { name = GMOD.Prefix_MOD_ .. "iron-gear-wheel"        , type = "item" , amount =  30 } )
	table.insert( Compact.Ingredient, { name = "lubricant"              , type = "fluid", amount = 100 } )
	table.insert( Compact.Compact.Ingredients, Compact.Ingredient )



	-- Eliminar la variable
	table.insert( GMOD.Result, Compact )
end

--------------------------------------
--------------------------------------

-- Agregar el subgrupo de los objetos
if true then

	GPrefix.addSubGroup( data.raw[ "item-subgroup" ] )
	local subGroup = false

	subGroup = { }
	subGroup.type  = "item-subgroup"
	subGroup.name  = GMOD.Prefix_MOD_ .. "loader"
	subGroup.group = "logistics"
	subGroup.order = GMOD.Prefix_MOD_ .. "0"
	data:extend( { subGroup } )

	subGroup = { }
	subGroup.type  = "item-subgroup"
	subGroup.name  = GMOD.Prefix_MOD_ .. "compact"
	subGroup.group = "logistics"
	subGroup.order = GMOD.Prefix_MOD_ .. "1"
	data:extend( { subGroup } )
end

-- Agregar el subgrupo de las recetas
if true then
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
for _, List in pairs( GMOD.Result ) do
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
	local ValueNew = GPrefix.getNumber( ValueOld ) -- 10000 <- 10kW

	-- Potenciar el valor
	ValueNew = ValueNew * GMOD.Value -- 500000 <- 10000 * 50

	-- Convertir el numero en cadena
	ValueNew = GPrefix.shortNumber( ValueNew ) -- 500K <- 500000

	-- Agregarle la unidad de medición
	ValueNew = ValueNew .. GPrefix.getUnit( ValueOld ) -- 500KW <- 500K .. 10kW

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
	Grenade = GPrefix.DeepCopy( Grenade )

	-- Renombrar el efecto
	Grenade.name = GMOD.Prefix_MOD_ .. Grenade.name

	-- Renombrar la variable
	local Actions = Grenade.action

	-- Validación de datos
	Actions = Actions[ 1 ] and  Actions or { Actions }

	-- Buscar la acción deseada
	for _, Action in pairs( Actions ) do
		if Action.cluster_count then

			-- Potenciar el valor
			Action.cluster_count = Action.cluster_count * GMOD.Value

			-- Guardar el nuevo efecto
			data:extend( { Grenade } )
			List.projectile = Grenade.name
			return
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
	Grenade = GPrefix.DeepCopy( Grenade )

	-- Renombrar el efecto
	Grenade.name = GMOD.Prefix_MOD_ .. Grenade.name

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
					Damage.amount = Damage.amount * GMOD.Value

					-- Guardar el nuevo efecto
					data:extend( { Grenade } )
					List.projectile = Grenade.name
					return
				end
			end
		end
	end
end

local function BetterCapsule( itemNew )

    -- Valdación básica
	if not itemNew.capsule_action then return end
	if itemNew.name == GMOD.Prefix_MOD_ .. "cliff-explosives" then return end

	-- Variable contenedora
	local Propietys = { }
	table.insert( Propietys, "capsule_action" )
	table.insert( Propietys, "attack_parameters" )
	table.insert( Propietys, "ammo_type" )

	-- Buscar el efecto deseado
	local Propiety = itemNew
	for _, value in pairs( Propietys ) do
		Propiety = Propiety[ value ]
		if not Propiety then return end
	end

	-- Buscar la acción deseada
	if not Propiety.action then return end

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
						Damage.amount = Damage.amount * GMOD.Value

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
	if not itemNew.ammo_type then return end

	-- Validación de datos
	itemNew.magazine_size = itemNew.magazine_size or 1

	-- Potenciar el valor
	itemNew.magazine_size = itemNew.magazine_size * GMOD.Value

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

local function BetterFuel( itemNew )

	-- Valdación básica
    if not itemNew.fuel_value then return end

	-- Potenciar el valor
	itemNew.fuel_value = ReCalculate( itemNew.fuel_value )

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

local function BetterModule( itemNew )

	-- Valdación básica
	if not itemNew.effect then return end

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
			local Bonus = Effect.bonus * GMOD.Value

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
	if not itemNew.durability then return end
	if not itemNew.speed then return end

	-- Establecer el suelo en el nuevo objeto
	itemNew.speed = GMOD.Value

	-- Validación de datos
	if GMOD.Value > itemNew.durability then
		itemNew.durability = GMOD.Value
	end

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"
end

-- Mejoras en los equipos

local function BetterEquipament( itemNew )

	-- Valdación básica
    if not itemNew.placed_as_equipment_result then return end

	-- Variable contenedora
	local Equipment = itemNew
	Equipment = Equipment.placed_as_equipment_result
	Equipment = GPrefix.Equipaments[ Equipment ]
	Equipment = GPrefix.DeepCopy( Equipment )

	-- Validación de datos
	if not Equipment.localised_name then
		Equipment.localised_name =  { "equipment-name." .. Equipment.name }
	end

	-- Renombrar el equipo
	Equipment.name = GMOD.Prefix_MOD_ .. Equipment.name

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
			Propiety.damage_modifier = Propiety.damage_modifier * GMOD.Value

			-- Marcar el objeto y el equipo
			Equipment.localised_name[ 3 ] = " [ + ]"
			itemNew.localised_name[ 3 ] = " [ + ]"
		end
	end

	-- Escudos
	if Equipment.max_shield_value then

		-- Potenciar el valor
		Equipment.max_shield_value = Equipment.max_shield_value * GMOD.Value

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
	GPrefix.Equipaments[ Equipment.name ] = Equipment

	-- Establecer el equipamento en el nuevo objeto
	itemNew.placed_as_equipment_result = Equipment.name
end

-- Mejoras en los suelos

local function BetterTile( itemNew )

	-- Valdación básica
    if not itemNew.place_as_tile then return end

	-- Buscar el suelo deseado
	local Index = false
	for key, _ in pairs( GPrefix.Tiles ) do
		if GMOD.Prefix_MOD_ .. key == itemNew.name then
			Index = key break
		end
	end

	-- Suelo no encontrado
	if not Index then return end

	-- Marcar el objeto
	itemNew.localised_name[ 3 ] = " [ + ]"

	-- Recorrer todos los suelos
	for key, Tile in pairs( GPrefix.Tiles[ Index ] ) do

		-- Hacer una copia del suelo
		Tile = GPrefix.DeepCopy( Tile )

		-- Validación de datos
		if not Tile.localised_name then
			Tile.localised_name = { "item-name." .. Tile.name }
		end

		if Tile.next_direction then
			Tile.next_direction = GMOD.Prefix_MOD_ .. Tile.next_direction
		end

		if Tile.minable and Tile.minable.result then
			Tile.minable.result = itemNew.name
		end

		-- Renombrar el suelo
		Tile.name = GMOD.Prefix_MOD_ .. Tile.name

		-- Beneficion del suelo
		Tile.pollution_absorption_per_second = GMOD.Value

		-- Establecer el podo y marcar el suelo
		Tile.localised_name = { "", Tile.localised_name, " [ + ]" }

		-- Guardar el nuevo suelo
		data:extend( { Tile } )
		GPrefix.Tiles[ Tile.name ] = Tile

		-- Establecer el suelo en el nuevo objeto
		if key == 1 then itemNew.place_as_tile.result = Tile.name end
	end
end

-- Mejoras en las entidades

local function BetterLab( itemNew, Lab )

	-- Valdación básica
	if not Lab.researching_speed then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Lab.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Lab.researching_speed = Lab.researching_speed * GMOD.Value
end

local function BetterGate( itemNew, Gate )

	-- Valdación básica
	if not Gate.opening_speed then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Gate.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Gate.max_health = Gate.max_health * GMOD.Value
end

local function BetterTree( itemNew, Tree )

	-- Valdación básica
	if not Tree.emissions_per_second then return end
	if Tree.emissions_per_second >= 0 then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Tree.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Tree.emissions_per_second = Tree.emissions_per_second * GMOD.Value
end

local function BetterWall( itemNew, Wall )

	-- Valdación básica
	if not Wall.wall_diode_red then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Wall.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Wall.max_health = Wall.max_health * GMOD.Value
end

local function BetterBeacon( itemNew, Beacon )

	-- Valdación básica
	if not Beacon.distribution_effectivity then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Beacon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Beacon.distribution_effectivity = Beacon.distribution_effectivity * GMOD.Value
end

local function BetterContainer( itemNew, Container )

	-- Valdación básica
	if Container.energy_usage then return end
	if Container.energy_source then return end
	if not Container.inventory_size then return end
	if Container.inventory_size > GMOD.Value then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Container.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Container.inventory_size = GMOD.Value
end

local function BetterCircuitWire( itemNew, Entity )

	-- Valdación básica
	if not Entity.circuit_wire_max_distance then return end
	if Entity.circuit_wire_max_distance == 0 then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Entity.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Entity.circuit_wire_max_distance = GMOD.Value
end

local function BetterMiningDrill( itemNew, MiningDrill )

	-- Valdación básica
	if not MiningDrill.mining_speed then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	MiningDrill.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	MiningDrill.mining_speed = MiningDrill.mining_speed * GMOD.Value
end

local function BetterElectricPole( itemNew, ElectricPole )

	-- Valdación básica
	if not ElectricPole.maximum_wire_distance then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	ElectricPole.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	if 	GMOD.Value > ElectricPole.maximum_wire_distance then
		local Value = GMOD.Value
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
	if not GPrefix.getKey( types, Entity.type ) then return end

	-- Potenciar la velocidad
	Entity.max_speed = Entity.max_speed * GMOD.Value
    Entity.air_resistance = 0

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Entity.localised_name[ 3 ] = " [ + ]"
end

local function BetterCraftingMachine( itemNew, Machine )

	-- Valdación básica
	if not Machine.crafting_speed then return end

	-- Potenciar la absorción de la contaminación
	if Machine.energy_source then
		local EnergySource = Machine.energy_source
		local Pollution = EnergySource.emissions_per_minute
		if Pollution and Pollution < 0 then
			Pollution = Pollution  * GMOD.Value
			EnergySource.emissions_per_minute = Pollution

			-- Marcar el objeto y la entidad
			itemNew.localised_name[ 3 ] = " [ + ]"
			Machine.localised_name[ 3 ] = " [ + ]"

			return
		end
	end

	local Ingredient = Machine.source_inventory_size
	local Result = Machine.result_inventory_size
	if Result and Ingredient then
		if Result == 0 and Ingredient == 0 then
			return
		end
	end

	-- Potenciar la velocidad de creación
	local Speed = Machine.crafting_speed
	Speed = Speed * GMOD.Value
	Machine.crafting_speed = Speed

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Machine.localised_name[ 3 ] = " [ + ]"
end



local function BetterRobot( itemNew, Robot )

	-- Valdación básica
	if not Robot.energy_per_move then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Robot.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Robot.speed = Robot.speed * GMOD.Value
end

local function BetterRoboport( itemNew, Roboport )

	-- Valdación básica
	if not Roboport.charging_energy then return end
	if not Roboport.charging_offsets then return end
	if #Roboport.charging_offsets <= 0 then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Roboport.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Roboport.charging_energy = ReCalculate( Roboport.charging_energy )
end



local function BetterGenerator( itemNew, Generator )

	-- Valdación básica
	if Generator.type ~= "generator" then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Generator.localised_name[ 3 ] = " [ + ]"
	-- Generator.maximum_temperature = GPrefix.Fluids[ "steam" ].max_temperature

	-- La energía generada es fija
	if Generator.max_power_output then
		Generator.max_power_output = ReCalculate( Generator.max_power_output )
	end

	-- La energía generada se calcula
	if not Generator.max_power_output then
		Generator.effectivity = Generator.effectivity * GMOD.Value
	end
end

local function BetterSolarPanel( itemNew, Generator )

	-- Valdación básica
	if not Generator.production then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Generator.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Generator.production = ReCalculate( Generator.production )
end

local function BetterAccumulator( itemNew, Accumulator )

	-- Valdación básica
	if not Accumulator.charge_animation then return end

	-- Renombrar la variable
	local EnergySource = Accumulator.energy_source

	-- Valdación básica
	if not EnergySource then return end

	local Output = EnergySource.output_flow_limit
	if GPrefix.getNumber( Output ) == 0 then return end

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
	if not Value then return end
	if not Value.fluids then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Weapon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	for _, fluid in pairs( Value.fluids ) do
		if fluid.damage_modifier then
			fluid.damage_modifier = fluid.damage_modifier * GMOD.Value
		end
	end
end

local function BetterWeaponAmmoless( itemNew, Weapon )

	-- Variable contenedora
	local Value = Weapon.attack_parameters

	-- Valdación básica
	if not Value then return end
	if not Value.damage_modifier then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Weapon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Value.damage_modifier = Value.damage_modifier * GMOD.Value
end



local function BetterPump( itemNew, Pump )

	-- Valdación básica
	if not Pump.pumping_speed then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Pump.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Pump.pumping_speed
	Value = Value * GMOD.Value
	Pump.pumping_speed = Value
end

local function BetterFluidWagon( itemNew, Wagon )

	-- Valdación básica
	if not Wagon.capacity then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Wagon.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	Wagon.capacity = Wagon.capacity * GMOD.Value
end

local function BetterInputFluidBox( itemNew, Container )

	-- Variable contenedora
	local Value = Container.fluid_box

	-- Valdación básica
	if not Value then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Container.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	if Value.height then
		Value.height = Value.height * GMOD.Value
	end

	if Value.base_area then
		Value.base_area = Value.base_area * GMOD.Value
	end

	for _, value in pairs( Value.pipe_connections or { } ) do
		if value.max_underground_distance then
			local Distance = value.max_underground_distance
			if GMOD.Value > Distance then Distance = GMOD.Value end
			if Distance > 250 then Distance = 250 end
			value.max_underground_distance = Distance
		end
	end
end

local function BetterOutputFluidBox( itemNew, Container )

	-- Variable contenedora
	local Value = Container.output_fluid_box

	-- Valdación básica
	if not Value then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Container.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	if Value.height then
		Value.height = Value.height * GMOD.Value
	end

	if Value.base_area then
		Value.base_area = Value.base_area * GMOD.Value
	end
end



local function BetterBelt( itemNew, Belt )

	-- Valdación básica
	if not Belt.related_underground_belt then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Belt.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Belt.speed
	Value = Value * GMOD.Value
	Belt.speed = Value
end

local function BetterLoader( itemNew, Loader )

	-- Valdación básica
	if not Loader.container_distance then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Loader.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Loader.speed
	Value = Value * GMOD.Value
	Loader.speed = Value
end

local function BetterInserter( itemNew, Inserter )

	-- Valdación básica
	if not Inserter.extension_speed then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Inserter.localised_name[ 3 ] = " [ + ]"

	-- Variable contenedora
	local Speed = 0

	-- Potenciar el valor
	Speed = Inserter.extension_speed
	Speed = Speed * GMOD.Value
	if Speed > 0.2 then Speed = 0.2 end
	Inserter.extension_speed = Speed

	Speed = Inserter.rotation_speed
	Speed = Speed * GMOD.Value
	if Speed > 0.2 then Speed = 0.2 end
	Inserter.rotation_speed = Speed
end

local function BetterSplitter( itemNew, Splitter )

	-- Valdación básica
	if not Splitter.structure_patch then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Splitter.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = Splitter.speed
	Value = Value * GMOD.Value
	Splitter.speed = Value
end

local function BetterUndergroundBelt( itemNew, Belt )

	-- Valdación básica
	if not Belt.max_distance then return end

	-- Marcar el objeto y la entidad
	itemNew.localised_name[ 3 ] = " [ + ]"
	Belt.localised_name[ 3 ] = " [ + ]"

	-- Potenciar el valor
	local Value = 0

	Value = Belt.max_distance
	Value = Value * GMOD.Value
	if Value > 250 then Value = 250 end
	Belt.max_distance = Value

	Value = Belt.speed
	Value = Value * GMOD.Value
	Belt.speed = Value
end

local function BetterEntity( itemNew )

    -- Valdación básica
	if not itemNew.place_result then return end

	-- Variable contenedora
	local Entity = GPrefix.Entities[ itemNew.place_result ]

	-- Reemplazar la entidad no compactada
	if not Entity.fast_replaceable_group then
		if GPrefix.Items[ Entity.name ] then
			local SubGroup = GPrefix.Items[ Entity.name ].subgroup
			Entity.fast_replaceable_group = SubGroup
		end
	end

	-- Hacer una copia de la entidad
	Entity = GPrefix.DeepCopy( Entity )

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
		Entity.next_upgrade = GMOD.Prefix_MOD_ .. Entity.next_upgrade
	end

	-- Renombrar la entidad
	Entity.name = GMOD.Prefix_MOD_ .. Entity.name

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
	GPrefix.Entities[ Entity.name ] = Entity

	-- Establecer el insertador al nuevo objeto
	itemNew.place_result = Entity.name
end

--------------------------------------
--------------------------------------

---> <---     ---> <---     ---> <---

--------------------------------------
--------------------------------------

-- Establecer la lists de cambios
local Corrections = { }
Corrections[ "se-big-turbine" ] = 5.5
Corrections[ "se-condenser-turbine" ] = 3

-- Establecer los cambios
for Entity, Value in pairs( Corrections ) do
	repeat

		-- Buscar la entidad
		Entity = GPrefix.Entities[ Entity ]

		-- Validación basica
		if not Entity then break end
		if not Entity.fluid_boxes then break end

		-- Buscar el valor a acambiar
		local PipeConnections = 0
		for _, FluidBox in pairs( Entity.fluid_boxes ) do
			if not FluidBox.filter then break end
			if not FluidBox.production_type then break end
			if not FluidBox.pipe_connections then break end

			if FluidBox.filter ~= "se-decompressing-steam" then break end
			if FluidBox.production_type ~= "output" then break end
			if #FluidBox.pipe_connections < 1 then break end

			PipeConnections = FluidBox.pipe_connections
		end

		-- Realizar el cambio
		for _, PipeConnection in pairs( PipeConnections ) do
			if not PipeConnection.position then break end
			PipeConnection.position[ 2 ] = Value
		end
	until true
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
	local itemNew = GPrefix.Items[ GMOD.Prefix_MOD_ .. itemOld.name ]

    -- Valdación básica
	if not itemNew then return end

	-- Valores para la receta
    local recipes      = { }
    recipes.compact    = { }
    recipes.uncompact  = { }

    -- Valores para la descompresion
    recipes.uncompact.name        = GMOD.Prefix_MOD_ .. "uncompact-" .. itemOld.name
    recipes.uncompact.results     = { { type = "item", amount = GMOD.Value, name = itemOld.name } }
    recipes.uncompact.ingredients = { { type = "item", amount = 1 , name = GMOD.Prefix_MOD_ .. itemOld.name } }
    recipes.uncompact.action      = true

	-- Valores para la compresion
    recipes.compact.name        = GMOD.Prefix_MOD_ .. "compact-" .. itemOld.name
    recipes.compact.results     = { { type = "item", amount = 1 , name = GMOD.Prefix_MOD_ .. itemOld.name } }
    recipes.compact.ingredients = { { type = "item", amount = GMOD.Value, name = itemOld.name  } }

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
        recipeNew.subgroup = GMOD.Prefix_MOD_ .. itemOld.subgroup

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
        table.insert( recipeName, { "recipe-name." .. GMOD.Prefix_MOD_ .. Category } )
		table.insert( recipeName, itemNew.localised_name )

        -- Añadir el pez
        GPrefix.addIcon( itemOld, recipeNew, Recipe.action )

		---> <---     ---> <---     ---> <---

        -- Guardar la nueva receta
        data:extend( { recipeNew } )
        GPrefix.addTechnology( itemOld.name, recipeNew.name )
		local Result = recipeNew.results[ 1 ].name
		GPrefix.Recipes[ Result ] = GPrefix.Recipes[ Result ] or { }
		table.insert( GPrefix.Recipes[ Result ], recipeNew )
    end
end

local function CreateItem( itemOld )

    -- Copiar el objeto
    local itemNew = GPrefix.DeepCopy( itemOld )

    -- Establecer los nombres
    itemNew.name     = GMOD.Prefix_MOD_ .. itemOld.name
    itemNew.subgroup = GMOD.Prefix_MOD_ .. itemOld.subgroup

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
    GPrefix.addIcon( itemOld, itemNew )

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
		while GPrefix.isString( value ) and #value >= 4 do
			local Flag = string.sub( value, -4 ) == ".png"
			if not Flag then break end
			GPrefix.Log( MOD .. " > " .. itemNew.name .. " > itemNew." .. key .. " = nil" )
			break
		end
	end

	---> <---     ---> <---     ---> <---

	-- Guardar el objeto
	data:extend( { itemNew } )
    GPrefix.Items[ itemNew.name ] = itemNew
end

--------------------------------------
--------------------------------------

-- Revisar todos los objetos
for _, item in pairs( GPrefix.Items ) do
    repeat

        -- Evitar los rieles
        if item.curved_rail then break end

        -- Evitar estos tipos
        if GPrefix.getKey( AvoidTypes, item.type ) then break end

        -- Evitar lo inapilable
		if GPrefix.getKey( item.flags, "hidden" ) then break end
		if GPrefix.getKey( item.flags, "not-stackable" ) then break end

        -- Evitar estos patrones
		local NotValid = false
		for _, Pattern in pairs( AvoidPatterns ) do
			NotValid = string.find( item.name, Pattern )
			if NotValid then break end
		end if NotValid then break end

		-- Evitar un bucle
        local PrefixFind = GPrefix.Prefix
        PrefixFind = string.gsub( PrefixFind, "-", "%%-" )
        PrefixFind = string.find( item.name, PrefixFind )
        if PrefixFind then break end

		-- Crear el nuevo objeto
		CreateItem( item )
		CreateRecipe( item )

	until true
end

--------------------------------------