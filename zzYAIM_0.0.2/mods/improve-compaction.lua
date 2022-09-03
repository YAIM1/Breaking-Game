---------------------------------------------------------------------------------------------------

--> improve-compaction.lua <--

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

    -- Inicializar los valores
    local AllRecipes = ThisMOD.Requires.Information.Recipes

    local Find = ""
    Find = ThisMOD.Requires.Prefix_MOD_
    Find = string.gsub( Find, "-", "%%-" )

    -- Revisar las recetas
    for _, Recipes in pairs( AllRecipes ) do

        -- Copiar los valores básicos
        local Data = { }

        -- Identifica la receta
        for _, Recipe in pairs( Recipes ) do
            local Name = ""

            Name = Recipe.ingredients[ 1 ].name
            if string.find( Name, Find ) then
                Data.Uncompact = Recipe
            end

            Name = Recipe.results[ 1 ].name
            if string.find( Name, Find ) then
                Data.Compact = Recipe
            end
        end

        -- Identifica el objeto a afectar
        Data.Item = Data.Compact.ingredients[ 1 ]
        Data.Item = GPrefix.Items[ Data.Item.name ]
        Data.Item = GPrefix.DeepCopy( Data.Item )

        -- -- Valdación básica
        -- if string.find( Data.Item.name, Find ) then goto JumpItem end

        -- -- Mejoras en los objetos
        ThisMOD.ImproveAmmo( Data )
        ThisMOD.ImproveFuel( Data )
        ThisMOD.ImproveModule( Data )
        ThisMOD.ImproveCapsule( Data )
        ThisMOD.ImproveRepairTool( Data )

        -- Mejoras en los equipos
        ThisMOD.ImproveEquipament( Data )

        -- Mejoras en los suelos
        ThisMOD.ImproveTile( Data )

        -- Mejoras en las entidades
        ThisMOD.IdentifyEntity( Data )

        -- Agregar el objeto modificado
        ThisMOD.AddModifiedItem( Data )

        -- Recepción del salto
        :: JumpItem ::
    end
end

-- Agregar el objeto modificado
function ThisMOD.AddModifiedItem( Data )

    -- Validación básica
    if not Data.Modified then return end

    -- Cargar el objeto comprimido
    local Find = GPrefix.Prefix_
    Find = string.gsub( Find, "-", "%%-" )
    local Name = Data.Item.name
    Name = string.gsub( Name, Find, "" )
    Name = ThisMOD.Requires.Prefix_MOD_ .. Name
    local OldItem = GPrefix.Items[ Name ]
    if not OldItem then return end

    -- Oculatar el objeto comprimido
    OldItem.flags = OldItem.flags or { "hidden" }
    if not GPrefix.getKey( OldItem.flags, "hidden" ) then
        table.insert( OldItem.flags, "hidden" )
    end GPrefix.Items[ OldItem.name ] = nil

    -- Modificar el objeto con efecto
    Data.Item.name = Data.Item.name
    Data.Item.icon = nil
    Data.Item.icons = OldItem.icons
    Data.Item.subgroup = OldItem.subgroup
    Data.Item.localised_name = OldItem.localised_name
    Data.Item.localised_description = OldItem.localised_description

    -- Agregar la letra del MOD
    GPrefix.addLetter( Data.Item, ThisMOD )
    ThisMOD.addLetter( Data.Item, Data.Compact )
    ThisMOD.addLetter( Data.Item, Data.Uncompact )
    ThisMOD.addLetter( Data.Item, Data.LocalisedName )

    -- Modificar las recetas
    Data.Compact.results[ 1 ].name = Data.Item.name
    Data.Uncompact.ingredients[ 1 ].name = Data.Item.name

    -- Imagen de este MOD
    local MODIcon = ThisMOD.Patch .. "icons/status.png"

    -- Cambiar la imagen
    Data.Item.icons[ #Data.Item.icons ].icon = MODIcon
    Data.Compact.icons[ #Data.Compact.icons - 1 ].icon = MODIcon
    Data.Uncompact.icons[ #Data.Uncompact.icons - 1 ].icon = MODIcon

    -- Crear el objetos mejorado
    data:extend( { Data.Item } )
    GPrefix.Items[ Data.Item.name ] = Data.Item
    if Data.LocalisedName then data:extend( { Data.LocalisedName } ) end
end

-- Agregar la letra indicadora del MOD
function ThisMOD.addLetter( Source, Destiny )

    -- Validación básica
    if not Destiny then return end

    -- Inicializar las varebles
    local Array = { }
    local Start = 0
    local List = { }

    -- Guardar los nuevos inidicadores
    Start = 0
    List = Source.localised_name
    for i, Str in pairs( List ) do
        if Str == " [" then Start = i end
        if Start > 0 then table.insert( Array, Str ) end
    end

    -- Identificar el inicio de los inidicadores
    Start = 0
    List = Destiny.localised_name
    for i, Str in pairs( List ) do
        if Str == " [" then Start = i break end
    end

    -- Borrar los viejos idicadores
    List = Destiny.localised_name
    while List[ Start ] do table.remove( List, Start ) end

    -- Agregar los indicadores guardados
    for _, Str in pairs( Array ) do
        table.insert( Destiny.localised_name, Str )
    end
end

-- -- -- Mejoras en los objetos -- -- --

-- Mejorar las capsulas
function ThisMOD.ImproveCapsule( Data )

    -- Valdación básica
    if Data.Item.type ~= "capsule" then return end
    if Data.Item.name == "cliff-explosives" then return end

    -- Variable contenedora
    local Propietys = { }
    table.insert( Propietys, "capsule_action" )
    table.insert( Propietys, "attack_parameters" )
    table.insert( Propietys, "ammo_type" )

    -- Buscar el efecto deseado
    local Propiety = Data.Item
    for _, value in pairs( Propietys ) do
        Propiety = Propiety[ value ]
        if not Propiety then return end
    end

    -- Buscar la acción deseada
    if not Propiety.action then return end

    -- Renombrar la variable
    local Actions = Propiety.action
    Data.Projectiles = data.raw.projectile

    -- Validación de datos
    Actions = Actions[ 1 ] and Actions or { Actions }

    -- Buscar la acción deseada
    for _, Action in pairs( Actions ) do
        Data.ActionDelivery = Action.action_delivery
        ThisMOD.ImproveCapsuleInstant( Data )
        ThisMOD.ImproveCapsuleProjectiles( Data )
    end
end

-- Mejorar lo que se consume
function ThisMOD.ImproveCapsuleInstant( Data )

    -- Acción no encontrada
    if not Data.ActionDelivery then return end

    -- Daño instantaneo o cura instantanea
    if not Data.ActionDelivery.target_effects then return end

    -- Renombrar la variable
    local TargetEffects = Data.ActionDelivery.target_effects

    -- Validación de datos
    if not TargetEffects[ 1 ] then TargetEffects = { TargetEffects } end

    -- Buscar el efecto deseado
    for _, TargetEffect in pairs( TargetEffects ) do
        if TargetEffect.damage then
            Data.Array = TargetEffect
            ThisMOD.ImproveCapsuleAmount( Data )
        end
    end
end

-- Mejorar lo que se arroja
function ThisMOD.ImproveCapsuleProjectiles( Data )

    -- Acción no encontrada
    if not Data.ActionDelivery then return end

    -- Daño por efecto
    if not Data.ActionDelivery.projectile then return end

    -- Renombrar la variable
    Data.ProjectileName = Data.ActionDelivery.projectile

    -- Nombre de nuevo proyectil
    ThisMOD.IdentifyProyectile( Data )

    -- Crear el valor con el nuevo daño
    if not Data.Modified then return end

    -- Validar si existe el proyectil
    Data.ActionDelivery.projectile = Data.Projectile.name
    if Data.Projectiles[ Data.Projectile.name ] then return end

    -- Crear el nuevo proyectil
    data:extend( { Data.Projectile } )
end

-- Identificar el efecto de lo arojado
function ThisMOD.IdentifyProyectile( Data )

    -- Renombrar las varebles
    local Unit = data.raw.unit
    local Entities = GPrefix.Entities
    local CombatRobot = data.raw[ "combat-robot" ]

    -- Selecionar el efecto
    Data.Projectile = Data.Projectiles[ Data.ProjectileName ]

    -- Copiar el efecto
    Data.Projectile = GPrefix.DeepCopy( Data.Projectile )

    -- Renombrar el efecto
    Data.Projectile.name = ThisMOD.Prefix_MOD_ .. Data.Projectile.name

    -- Renombrar la variable
    local Actions = Data.Projectile.action

    -- Validación de datos
    Actions = Actions[ 1 ] and Actions or { Actions }

    for _, Action in pairs( Actions ) do
        local TargetEffects = { }
        local ActionDelivery = Action.action_delivery
        if not ActionDelivery then goto JumpContinue end

        if Action.type == "cluster" then
            Data.Action = Action
            ThisMOD.ImproveCapsuleCluster( Data )
        end

        TargetEffects = ActionDelivery.target_effects
        if not TargetEffects then goto JumpContinue end
        if #TargetEffects < 1 then TargetEffects = { ActionDelivery.target_effects } end

        for _, Effect in pairs( TargetEffects ) do
            Data.Array = Effect
            ThisMOD.ImproveCapsuleAmount( Data )
            ThisMOD.ImproveCapsuleStiker( Data )

            ThisMOD.ImproveCapsuleEnemies( Data, data.raw.unit )
            ThisMOD.ImproveCapsuleRobots( Data, data.raw[ "combat-robot" ] )

            if Effect.entity_name and Entities[ Effect.entity_name ] then
                GPrefix.Log( "Show this to YAIM904", Data.Projectile.name )
            end
        end

        -- Recepción del salto
        :: JumpContinue ::
    end
end

-- Mejorar las granadas y las curas
function ThisMOD.ImproveCapsuleAmount( Data )

    -- Renombrar la variable
    local Damage = Data.Array.damage

    -- Validación básica
    if not Damage then return end

    -- Potenciar el valor
    Damage.amount = Damage.amount * ThisMOD.Requires.Value

    -- Marcar como modificado
    Data.Modified = true
end

-- Mejora en las granadas de racimo
function ThisMOD.ImproveCapsuleCluster( Data )

    -- Renombrar la variable
    local Target = Data.Action.action_delivery

    -- Validación básica
    if not Target then return end
    if not Target.projectile then return end

    -- Crear el proyectil de ser necesario
    local Name = ThisMOD.Prefix_MOD_
    Name = Name .. Target.projectile
    if not Data.Projectiles[ Name ] then
        Data.ActionDelivery = { projectile = Target.projectile }
        ThisMOD.ImproveCapsuleProjectiles( Data )
    end

    -- Cambiar el proyectil
    Target.projectile = Name

    -- Marcar como modificado
    Data.Modified = true
end

-- Mejorar las cápsulas para realientizzar
function ThisMOD.ImproveCapsuleStiker( Data )

    -- Renombrar la variable
    local Target = Data.Array
    local Stickers = data.raw.sticker

    -- Validación básica
    if not Target then return end
    if not Target.sticker then return end

    -- Nombre del nuevo stiker
    local Name = ThisMOD.Prefix_MOD_
    Name = Name .. Target.sticker

    -- Validar si ya existe
    if Stickers[ Name ] then goto JumpSticker end

    -- Cargar efecto
    Data.Sticker = Stickers[ Target.sticker ]
    Data.Sticker = GPrefix.DeepCopy( Data.Sticker )
    if not Data.Sticker then return end

    -- Actualizar los valores
    Data.Sticker.name = Name
    Data.Sticker.duration_in_ticks = Data.Sticker.duration_in_ticks * ThisMOD.Requires.Value

    -- Crear el efecto mejorado
    data:extend( { Data.Sticker } )

    -- Recepción del salto
    :: JumpSticker ::

    -- Cambiar el efecto
    Target.sticker = Name

    -- Marcar como modificado
    Data.Modified = true
end

-- Mejorar los enemigos-aliados
function ThisMOD.ImproveCapsuleEnemies( Data, Array )
    ThisMOD.ImproveCapsuleEntities( Data, Array )
end

-- Mejorar los robots
function ThisMOD.ImproveCapsuleRobots( Data, Array )
    ThisMOD.ImproveCapsuleEntities( Data, Array )
end

-- Mejorar las entidades
function ThisMOD.ImproveCapsuleEntities( Data, Array )

    -- Renombrar la variable
    local Target = Data.Array

    -- Validación básica
    if not Target.entity_name then return end

    -- Nombre del nuevo proyectil
    local Name = ThisMOD.Prefix_MOD_
    Name = Name .. Target.entity_name

    -- Validar si ya existe
    if Array[ Name ] then goto JumpElement end

    -- Cargar el elemento
    Data.Element = Array[ Target.entity_name ]
    Data.Element = GPrefix.DeepCopy( Data.Element )
    if not Data.Element then return end

    -- Actualizar los valores
    Data.Element.name = Name
    Data.Element.localised_name = { "", { "entity-name." .. Target.entity_name } }
    Data.Element.max_health = Data.Element.max_health * ThisMOD.Requires.Value
    Data.LocalisedName = Data.Element

    -- Recepción del salto
    :: JumpElement ::

    -- Cambiar el efecto
    Target.entity_name = Name

    -- Marcar como modificado
    Data.Modified = true
end

-- Mejorar las municiones
function ThisMOD.ImproveAmmo( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if Item.type ~= "ammo"  then return end
    if not Item.ammo_type then return end

    -- Validación de datos
    Item.magazine_size = Item.magazine_size or 1

    -- Potenciar el valor
    Item.magazine_size = Item.magazine_size * ThisMOD.Requires.Value

    -- Marcar como modificado
    Data.Modified = true
end

-- Mejorar los combustibles
function ThisMOD.ImproveFuel( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if not Item.fuel_value then return end
    if Item.place_result then return end

    -- Potenciar el valor
    Item.fuel_value = ThisMOD.ReCalculate( Item.fuel_value )

    -- Marcar como modificado
    Data.Modified = true
end

-- Mejorar los modulos
function ThisMOD.ImproveModule( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if Item.type ~= "module" then return end
    if not Item.effect then return end

    -- Variable contenedora
    local Effects = { }
    table.insert( Effects, { "productivity", 1 } )
    table.insert( Effects, { "consumption", -1 } )
    table.insert( Effects, { "pollution", -1 } )
    table.insert( Effects, { "speed",  1 } )

    -- Buscar el efecto deseado
    for _, Effect in ipairs( Effects ) do

        -- Contenedor de valores
        local List = { }

        -- Encontrar el efecto
        List.Name = Effect[ 1 ]
        List.effect = Item.effect[ List.Name ]
        if not List.effect then goto JumpEffect end

        -- Cacular el nuevo valor
        List.Bonus = Effect[ 2 ]
        if List.Bonus > 0 then
            List.Bonus = List.Bonus * List.effect.bonus
            List.Bonus = List.Bonus * ThisMOD.Requires.Value
        end

        -- Validación de datos
        if List.Bonus > 300 then List.Bonus = 300 end
        if List.Bonus < 0 then List.Bonus = 0 end

        -- Establecer el valor
        if List.Bonus > 0 then List.effect.bonus = List.Bonus end

        -- Eliminar el efecto
        if List.Bonus < 1 then Item.effect[ List.Name ] = nil end

        -- Recepción del salto
        :: JumpEffect ::
    end

    -- Marcar como modificado
    Data.Modified = GPrefix.getLength( Item.effect ) > 0
end

-- Mejorar los objetos de reparación
function ThisMOD.ImproveRepairTool( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if Item.type ~= "repair-tool" then return end
    if not Item.durability then return end
    if not Item.speed then return end

    -- Establecer el suelo en el nuevo objeto
    if ThisMOD.Requires.Value > Item.speed then
        Item.speed = Item.speed * ThisMOD.Requires.Value
        Item.speed = Item.speed * 1 / 3
        Item.speed = math.floor( Item.speed )
    end

    -- Validación de datos
    if ThisMOD.Requires.Value > Item.durability then
        Item.durability = Item.durability * ThisMOD.Requires.Value
        Item.durability = Item.durability * 2 / 3
        Item.durability = math.ceil( Item.durability )
    end

    -- Marcar como modificado
    Data.Modified = true
end

-- -- -- Mejoras en los equipos -- -- --

function ThisMOD.ImproveEquipament( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if Item.type ~= "item" then return end
    if not Item.placed_as_equipment_result then return end

    -- Variable contenedora
    local List = { }

    -- Cargar el equipo
    List.Equipment = Item.placed_as_equipment_result
    List.Equipment = GPrefix.Equipaments[ List.Equipment ]
    List.Equipment = GPrefix.DeepCopy( List.Equipment )



    -- Buffer e IO
    if not List.Equipment.energy_source then goto JumpEnegy end

    -- Renombrar la variable
    List.Propiety = List.Equipment.energy_source

    -- Validación de datos
    if List.Propiety.buffer_capacity then
        List.Propiety.buffer_capacity = ThisMOD.ReCalculate( List.Propiety.buffer_capacity )
    end

    -- Validación de datos
    if List.Propiety.input_flow_limit then
        List.Propiety.input_flow_limit = ThisMOD.ReCalculate( List.Propiety.input_flow_limit )
    end

    -- Validación de datos
    if List.Propiety.output_flow_limit then
        List.Propiety.output_flow_limit = ThisMOD.ReCalculate( List.Propiety.output_flow_limit )
    end

    -- Marcar como modificado
    Data.Modified = true

    -- Recepción del salto
    :: JumpEnegy ::



    -- Armas
    if not List.Equipment.attack_parameters then goto JumpWeapon end

    -- Renombrar la variable
    List.Propiety = List.Equipment.attack_parameters

    -- Validación de datos
    if List.Propiety.damage_modifier then
        List.Propiety.damage_modifier = List.Propiety.damage_modifier * ThisMOD.Requires.Value
    end

    -- Marcar como modificado
    Data.Modified = true

    -- Recepción del salto
    :: JumpWeapon ::




    -- Escudos
    if List.Equipment.max_shield_value then
        List.Equipment.max_shield_value = List.Equipment.max_shield_value * ThisMOD.Requires.Value

        -- Marcar como modificado
        Data.Modified = true
    end



    -- Generadores
    if List.Equipment.power then
        List.Equipment.power = ThisMOD.ReCalculate( List.Equipment.power )

        -- Marcar como modificado
        Data.Modified = true
    end



    -- Recargas de los robopurtos
    if List.Equipment.charging_energy then
        List.Equipment.charging_energy = ThisMOD.ReCalculate( List.Equipment.charging_energy )

        -- Marcar como modificado
        Data.Modified = true
    end



    -- Regresar el objeto usado
    if List.Equipment.take_result then
        List.Equipment.take_result = nil

        -- Marcar como modificado
        Data.Modified = true
    end



    -- No es necesario agregar el equipo
    if not Data.Modified then return end

    -- Recombrar el equipo
    List.Find = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    List.Name = string.gsub( List.Equipment.name, List.Find, "" )
    List.Equipment.name = ThisMOD.Prefix_MOD_ .. List.Name
    List.Equipment.localised_name = Item.localised_name
    Data.LocalisedName = List.Equipment

    -- Guardar el nuevo equipo
    GPrefix.Equipaments[ List.Equipment.name ] = List.Equipment

    -- Establecer el equipamento en el nuevo objeto
    Item.placed_as_equipment_result = List.Equipment.name
end

-- -- -- Mejoras en los suelos -- -- --

function ThisMOD.ImproveTile( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if not Item.place_as_tile then return end

    -- Validar elemento
    local Alias = nil
    if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
    if Alias and Alias( Item.place_as_tile.result ) then return end

    -- Buscar el suelo
    local Titles = GPrefix.Tiles[ Item.name ]
    if not Titles then return end

    -- Nombre para la busqueda
    local Find = string.gsub( GPrefix.Prefix_, "-", "%%-" )
    local Name = string.gsub( Item.place_as_tile.result, Find, "" )
    local NameRef = ThisMOD.Prefix_MOD_ .. Name

    -- Marcar como modificado
    Data.Modified = true

    -- Recorrer todos los suelos
    for Key, Tile in pairs( Titles ) do

        -- Hacer una copia del suelo
        Tile = GPrefix.DeepCopy( Tile )

        -- Renombrar el suelo con otra dirección
        if Tile.next_direction then
            Tile.next_direction = ThisMOD.Prefix_MOD_ .. Tile.next_direction
        end

        -- Actualizar el piso a retiar
        if Tile.minable and Tile.minable.result then
            Name = string.gsub( Item.name, Find, "" )
            Tile.minable.result = ThisMOD.Prefix_MOD_ .. Name
        end

        -- Beneficion del suelo
        local Absorption = Tile.pollution_absorption_per_second or 0
        Absorption = Absorption * ThisMOD.Requires.Value
        Tile.pollution_absorption_per_second = Absorption

        -- Recombrar el suelo
        Name = string.gsub( Tile.name, Find, "" )
        Tile.name = ThisMOD.Prefix_MOD_ .. Name

        -- Guardar el nuevo suelo
        GPrefix.Tiles[ NameRef ] = GPrefix.Tiles[ NameRef ] or { }
        table.insert( GPrefix.Tiles[ NameRef ], Tile )
        data:extend( { Tile } )

        -- Establecer el suelo en el nuevo objeto
        if Key == 1 then Item.place_as_tile.result = Tile.name end
    end
end

-- -- -- Mejoras en las entidades -- -- --

-- Identificar la entidades
function ThisMOD.IdentifyEntity( Data )

    -- Renombrar la variable
    local Item = Data.Item

    -- Valdación básica
    if not Item.place_result then return end

    -- Variable contenedora
    Data.Entity = GPrefix.Entities[ Item.place_result ]
    if not Data.Entity then return end

    -- Hacer una copia de la entidad
    Data.Entity = GPrefix.DeepCopy( Data.Entity )

    -- Reemplazar la entidad no compactada
    if not Data.Entity.fast_replaceable_group then
        if GPrefix.Items[ Data.Entity.name ] then
            local Item = GPrefix.Items[ Data.Entity.name ]
            Data.Entity.fast_replaceable_group = Item.subgroup
        end
    end

    -- Patron del prefijo
    local Find = string.gsub( GPrefix.Prefix_, "-", "%%-" )

    -- Asignar objeto como minable
    if Data.Entity.minable and Data.Entity.minable.result then
        local Name = string.gsub( Item.name, Find, "" )
        Data.Entity.minable.result = ThisMOD.Prefix_MOD_ .. Name
    end

    -- Recombrar el suelo
    local Name = string.gsub( Data.Entity.name, Find, "" )
    Data.Entity.name = ThisMOD.Prefix_MOD_ .. Name
    Data.Entity.localised_name = Item.localised_name
    Data.LocalisedName = Data.Entity

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Variado
    ThisMOD.ImproveLab( Data )
    ThisMOD.ImproveGate( Data )
    ThisMOD.ImproveTree( Data )
    ThisMOD.ImproveWall( Data )
    ThisMOD.ImproveBeacon( Data )
    ThisMOD.ImproveContainer( Data )
    ThisMOD.ImproveMiningDrill( Data )
    ThisMOD.ImproveRailwayEntity( Data )
    ThisMOD.ImproveCraftingMachine( Data )

    -- Robots
    ThisMOD.ImproveRobot( Data )
    ThisMOD.ImproveRoboport( Data )

    -- Energy
    ThisMOD.ImproveGenerator( Data )
    ThisMOD.ImproveSolarPanel( Data )
    ThisMOD.ImproveAccumulator( Data )

    -- Armas
    ThisMOD.ImproveFluidWeapon( Data )
    ThisMOD.ImproveWeaponAmmoless( Data )

    -- Fluidos
    ThisMOD.ImprovePump( Data )
    ThisMOD.ImproveFluidWagon( Data )
    ThisMOD.ImproveInputFluidBox( Data )
    ThisMOD.ImproveOutputFluidBox( Data )

    -- Logistica
    ThisMOD.ImproveBelt( Data )
    ThisMOD.ImproveLoader( Data )
    ThisMOD.ImproveInserter( Data )
    ThisMOD.ImproveSplitter( Data )
    ThisMOD.ImproveUndergroundBelt( Data )

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- No se modificó la entidad
    if not Data.Modified then return end

    -- Guardar la nueva entidad
    GPrefix.Entities[ Data.Entity.name ] = Data.Entity

    -- Establecer la nueva entidad
    Item.place_result = Data.Entity.name
end

-- Mejoras los laboratorios
function ThisMOD.ImproveLab( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "lab" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.researching_speed = Entity.researching_speed * ThisMOD.Requires.Value
end

-- Mejoras los laboratorios
function ThisMOD.ImproveGate( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "gate" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.max_health = Entity.max_health * ThisMOD.Requires.Value
end

-- Mejoras los árboles
function ThisMOD.ImproveTree( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "tree" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.emissions_per_second = Entity.emissions_per_second * ThisMOD.Requires.Value
end

-- Mejoras los muros
function ThisMOD.ImproveWall( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "wall" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.max_health = Entity.max_health * ThisMOD.Requires.Value
end

-- Mejoras los faros
function ThisMOD.ImproveBeacon( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "beacon" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.distribution_effectivity = Entity.distribution_effectivity * ThisMOD.Requires.Value
end

-- Mejoras los contenedores
function ThisMOD.ImproveContainer( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "container" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.inventory_size = ThisMOD.Requires.Value
end

-- Mejoras los talatros
function ThisMOD.ImproveMiningDrill( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "mining-drill" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.mining_speed = Entity.mining_speed * ThisMOD.Requires.Value
end

-- Mejoras los rieles
function ThisMOD.ImproveRailwayEntity( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Entidades a modificar
    local Types = { }
    table.insert( Types, "locomotive" )
    table.insert( Types, "cargo-wagon" )
    table.insert( Types, "fluid-wagon" )
    table.insert( Types, "artillery-wagon" )

    -- Valdación básica
    if not GPrefix.getKey( Types, Entity.type ) then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar la velocidad
    Entity.max_speed = Entity.max_speed * ThisMOD.Requires.Value
    Entity.air_resistance = 0
end

-- Mejoras las maquinas que fabrican
function ThisMOD.ImproveCraftingMachine( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if not Entity.crafting_speed then return end

    -- Potenciar la absorción de la contaminación
    if Entity.energy_source then
        local EnergySource = Entity.energy_source
        local Pollution = EnergySource.emissions_per_minute
        if Pollution and Pollution < 0 then
            Pollution = Pollution  * ThisMOD.Requires.Value
            EnergySource.emissions_per_minute = Pollution

            -- Marcar como modificado
            Data.Modified = true
            return
        end
    end

    -- La entidad no tiene resulatados ni require inventario
    local Ingredient = Entity.source_inventory_size
    local Result = Entity.result_inventory_size
    if Result and Ingredient then
        if Result == 0 and Ingredient == 0 then
            return
        end
    end

    -- Potenciar la velocidad de creación
    local Speed = Entity.crafting_speed
    Speed = Speed * ThisMOD.Requires.Value
    Entity.crafting_speed = Speed

    -- Marcar como modificado
    Data.Modified = true
end



-- Mejoras los robots
function ThisMOD.ImproveRobot( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Entidades a modificar
    local Types = { }
    table.insert( Types, "logistic-robot" )
    table.insert( Types, "construction-robot" )

    -- Valdación básica
    if not GPrefix.getKey( Types, Entity.type ) then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.speed = Entity.speed * ThisMOD.Requires.Value
end

-- Mejoras los robot puertos
function ThisMOD.ImproveRoboport( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "roboport" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.charging_energy = ThisMOD.ReCalculate( Entity.charging_energy )
end



-- Mejoras los generadores
function ThisMOD.ImproveGenerator( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "generator" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- La energía generada es fija
    if Entity.max_power_output then
        Entity.max_power_output = ThisMOD.ReCalculate( Entity.max_power_output )
    end

    -- La energía generada se calcula
    if not Entity.max_power_output then
        Entity.effectivity = Entity.effectivity * ThisMOD.Requires.Value
    end
end

-- Mejoras los paneles solares 
function ThisMOD.ImproveSolarPanel( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "solar-panel" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.production = ThisMOD.ReCalculate( Entity.production )
end

-- Mejoras los acomuladores
function ThisMOD.ImproveAccumulator( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "accumulator" then return end

    -- Valdación básica
    local EnergySource = Entity.energy_source
    if not EnergySource then return end
    local Output = EnergySource.output_flow_limit
    if GPrefix.getNumber( Output ) == 0 then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    EnergySource.output_flow_limit = ThisMOD.ReCalculate( EnergySource.output_flow_limit )
    EnergySource.input_flow_limit = ThisMOD.ReCalculate( EnergySource.input_flow_limit )
    EnergySource.buffer_capacity = ThisMOD.ReCalculate( EnergySource.buffer_capacity )
end



-- Mejoras las armas de fluidos
function ThisMOD.ImproveFluidWeapon( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Variable contenedora
    local Value = Entity.attack_parameters

    -- Valdación básica
    if not Value then return end
    if not Value.fluids then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    for _, fluid in pairs( Value.fluids ) do
        if fluid.damage_modifier then
            fluid.damage_modifier = fluid.damage_modifier * ThisMOD.Requires.Value
        end
    end
end

-- Mejoras las armas si municiones
function ThisMOD.ImproveWeaponAmmoless( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Variable contenedora
    local Value = Entity.attack_parameters

    -- Valdación básica
    if not Value then return end
    if not Value.damage_modifier then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Value.damage_modifier = Value.damage_modifier * ThisMOD.Requires.Value
end



-- Mejoras los bombas de liquidos
function ThisMOD.ImprovePump( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if not Entity.pumping_speed then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    local Value = Entity.pumping_speed
    Value = Value * ThisMOD.Requires.Value
    Entity.pumping_speed = Value

    -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Variable contenedora
    local Table = Entity.fluid_box

    -- Valdación básica
    if not Table then return end

    -- Renombrar la variable
    Value = ThisMOD.Requires.Value

    -- Potenciar el valor
    if Table.height then
        Table.height = Table.height * Value
    end

    if Table.base_area then
        Table.base_area = Table.base_area * Value
    end

    if Table.base_level then
        Table.base_level = Table.base_level * Value
    end
end

-- Mejoras los vagones de fluidos
function ThisMOD.ImproveFluidWagon( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "fluid-wagon" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    Entity.capacity = Entity.capacity * ThisMOD.Requires.Value
end

-- Mejoras la capacidad y el flujo entrante
function ThisMOD.ImproveInputFluidBox( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "storage-tank" then return end

    -- Variable contenedora
    local Table = Entity.fluid_box

    -- Valdación básica
    if not Table then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Renombrar la variable
    local Value = ThisMOD.Requires.Value

    -- Potenciar el valor
    if Table.height then
        Table.height = Table.height * Value
    end

    if Table.base_area then
        Table.base_area = Table.base_area * Value
    end
end

-- Mejoras el flujo saliente
function ThisMOD.ImproveOutputFluidBox( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "storage-tank" then return end

    -- Variable contenedora
    local Table = Entity.output_fluid_box

    -- Valdación básica
    if not Table then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Renombrar la variable
    local Value = ThisMOD.Requires.Value

    -- Potenciar el valor
    if Table.height then
        Table.height = Table.height * Value
    end

    if Table.base_area then
        Table.base_area = Table.base_area * Value
    end

    if Table.base_level then
        Table.base_level = Table.base_level * Value
    end
end

-- Mejoras la capacidad y el flujo entrante
function ThisMOD.ImproveUndergroundPipe( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "pipe-to-ground" then return end

    -- Variable contenedora
    local Table = Entity.fluid_box

    -- Valdación básica
    if not Table then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Renombrar la variable
    local Value = ThisMOD.Requires.Value

    -- Buscar y cambiar la distancia maxima
    for _, value in pairs( Table.pipe_connections or { } ) do
        if value.max_underground_distance then
            local Distance = value.max_underground_distance
            if Value > Distance then Distance = Value end
            if Distance > 250 then Distance = 250 end
            value.max_underground_distance = Distance
        end
    end
end



-- Mejoras las cintas transportadoras
function ThisMOD.ImproveBelt( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "transport-belt" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    local Value = Entity.speed
    Value = Value * ThisMOD.Requires.Value
    Entity.speed = Value
end

-- Mejoras los cargadores
function ThisMOD.ImproveLoader( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Entidades a modificar
    local Types = { }
    table.insert( Types, "loader" )
    table.insert( Types, "loader-1x1" )

    -- Valdación básica
    if not GPrefix.getKey( Types, Entity.type ) then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    local Value = Entity.speed
    Value = Value * ThisMOD.Requires.Value
    Entity.speed = Value
end

-- Mejoras los insertadores
function ThisMOD.ImproveInserter( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "inserter" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Variable contenedora
    local Speed = 0

    -- Potenciar el valor
    Speed = Entity.extension_speed
    Speed = Speed * ThisMOD.Requires.Value
    if Speed > 0.2 then Speed = 0.2 end
    Entity.extension_speed = Speed

    Speed = Entity.rotation_speed
    Speed = Speed * ThisMOD.Requires.Value
    if Speed > 0.2 then Speed = 0.2 end
    Entity.rotation_speed = Speed
end

-- Mejoras los divisores
function ThisMOD.ImproveSplitter( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "splitter" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    local Value = Entity.speed
    Value = Value * ThisMOD.Requires.Value
    Entity.speed = Value
end

-- Mejoras las cintas subterraneas
function ThisMOD.ImproveUndergroundBelt( Data )

    -- Renombrar la variable
    local Entity = Data.Entity

    -- Valdación básica
    if Entity.type ~= "underground-belt" then return end

    -- Marcar como modificado
    Data.Modified = true

    -- Potenciar el valor
    local Value = 0

    Value = Entity.max_distance
    Value = Value * ThisMOD.Requires.Value
    if Value > 250 then Value = 250 end
    Entity.max_distance = Value

    Value = Entity.speed
    Value = Value * ThisMOD.Requires.Value
    Entity.speed = Value
end

-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Recalcular el valor de la energia
function ThisMOD.ReCalculate( OldValue )

    -- ValueOld = 10kW

    -- Convertir el valor en un número
    local Value = GPrefix.getNumber( OldValue ) -- 10000 <- 10kW

    -- Potenciar el valor
    Value = Value * ThisMOD.Requires.Value -- 500000 <- 10000 * 50

    -- Convertir el numero en cadena
    local NewValue = GPrefix.shortNumber( Value ) -- 500K <- 500000

    -- Agregarle la unidad de medición
    NewValue = NewValue .. GPrefix.getUnit( OldValue ) -- 500KW <- 500K .. 10kW

    -- Devolver el resultado
    return NewValue -- 500KW
end

-- Validar si se debe evitar este elemento
function ThisMOD.AvoidElement( Name )

    -- Patron a buscar
    local Find = ThisMOD.Prefix_MOD_
    Find = string.gsub( Find, "-", "%%-" )

    -- Ignonrar el elemento
    if string.find( Name, Find ) then return true end

    -- Elemento valido
    return false
end

-- Cargar los prototipos
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.LoadInformation( )   GPrefix.Improve = ThisMOD
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------