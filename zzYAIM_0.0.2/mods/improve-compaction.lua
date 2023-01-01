---------------------------------------------------------------------------------------------------

---> improve-compaction.lua <---

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

    --- Aplicar el efecto del MOD por fuera del mismo
    --- @param TheMOD ThisMOD
    function ThisMOD.DoEffect( TheMOD )
        Private.DoEffect( TheMOD )
    end

    --- Procesar los prototipos del MOD
    Private.LoadPropotypes( )
    GPrefix.CreateNewElements( ThisMOD )

    --- Crear acceso directo al MOD
    GPrefix[ ThisMOD.MOD ] = ThisMOD
end

--- Procesar los prototipos cargados en el juego y
--- cargar los prototipos del MOD
function Private.LoadPropotypes( )

    --- Indicador de la recetas a buscar
    Private.PrefixDo = "%-" .. GPrefix.CI.PrefixDo
    Private.PrefixUndo = "%-" .. GPrefix.CI.PrefixUndo

    --- Procesar los prototipos
    Private.addPrototypes( )
    ThisMOD.DoEffect( ThisMOD )
    Private.removeItems( )
end

--- Agregar los iniciales
function Private.addPrototypes( )

    --- Renombrar la variable
    local Compact = GPrefix.CI

    --- Agregar los objetos a afectar
    Private.NewItems = { }
    for _, Item in pairs( Compact.NewItems ) do
        Private.NewItems[ Item.name ] = Item
        ThisMOD.NewItems[ Item.name ] = Item
    end

    --- Agregar las recetas a afectar
    for ItemName, Recipe in pairs( Compact.NewRecipes ) do
        ThisMOD.NewRecipes[ ItemName ] = Recipe
    end
end

--- Retirar los objetos iniciales
function Private.removeItems( )

    --- Contenedor de los objetos a afectar
    local Keys = { }

    --- En listar los objetos a afectar
    for ItemName, Item in pairs( ThisMOD.NewItems ) do

        --- El objetos no afectado
        local ImproveMOD = GPrefix.hasPrefixMOD( Item, ThisMOD )
        if ImproveMOD then goto JumpItem end

        --- El objetos no afectado
        local Change = Item == Private.NewItems[ ItemName ]
        if not Change then goto JumpItem end

        --- Agregar el objeto a la lista
        table.insert( Keys, 1, ItemName )

        --- Recepción del salto
        :: JumpItem ::
    end

    --- Eliminar el objeto de la lista
    for _, ItemName in pairs( Keys ) do
        ThisMOD.NewItems[ ItemName ] = nil
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Contenedor de los objetos a afectar
    Keys = { }

    --- En listar los objetos a afectar
    for ItemName, Recipes in pairs( ThisMOD.NewRecipes ) do
        for Key, Recipe in pairs( Recipes ) do

            --- Enlitar la receta de compactación
            if string.find( Recipe.name, Private.PrefixDo ) then
                table.insert( Keys, 1, { Recipes = ItemName, Recipe = Key } )
            end

            --- Enlitar la receta de descompactación
            if string.find( Recipe.name, Private.PrefixUndo ) then
                table.insert( Keys, 1, { Recipes = ItemName, Recipe = Key } )
            end
        end
    end

    --- Eliminar las recetas de la lista
    for _, Index in pairs( Keys ) do
        ThisMOD.NewRecipes[ Index.Recipes ][ Index.Recipe ] = nil
        if #ThisMOD.NewRecipes[ Index.Recipes ] < 1 then
            ThisMOD.NewRecipes[ Index.Recipes ] = nil
        end
    end
end

--- Aplicar el efecto del MOD por fuera del mismo
--- @param TheMOD ThisMOD
function Private.DoEffect( TheMOD )

    --- Contenedor de los objetos a afectar
    local Datas = { }

    --- Enlistar las recetas a afectar
    for ItemName, Recipes in pairs( TheMOD.NewRecipes ) do

        --- Variables a usar
        local IsValid = nil
        local Data = Datas[ ItemName ] or { }
        Datas[ ItemName ] = Data

        --- Recetas disponibles
        for _, Recipe in pairs( Recipes ) do

            --- Compactado
            IsValid = string.find( Recipe.category or "", Private.PrefixDo )
            if IsValid then Data.Compact = Recipe end

            --- Descompactado
            IsValid = string.find( Recipe.category or "", Private.PrefixUndo )
            if IsValid then Data.Uncompact = Recipe end
        end

        --- Eliminar los vacios
        if GPrefix.getLength( Data ) < 1 then
            Datas[ ItemName ] = nil
        end
    end

    --- Modificar los objetos enlistados
    for _, Data in pairs( Datas ) do
        Data.Others = { }
        Private.doChange( Data, TheMOD )
    end
end

--- Aplicar el efecto del MOD
--- @param Data table
--- @param TheMOD ThisMOD
function Private.doChange( Data, TheMOD )

    --- Identifica el objeto a afectar
    Data.BaseItem = Data.Compact.ingredients[ 1 ].name
    Data.BaseItem = GPrefix.Items[ Data.BaseItem ] or TheMOD.NewItems[ Data.BaseItem ]

    --- Identifica el objeto a afectar
    Data.NewItem = GPrefix.DeepCopy( Data.BaseItem )
    if not Data.NewItem then return end

    --- Objeto que se está cambiando
    Data.TheMOD = TheMOD

    if not Data.OldItem then
        Data.OldItem = Data.Compact.results[ 1 ].name
        Data.OldItem = GPrefix.Items[ Data.OldItem ]
    end

    if not Data.OldItem then
        Data.OldItem = Data.Compact.results[ 1 ].name
        Data.OldItem = TheMOD.NewItems[ Data.OldItem ]
    end

    --- Mejoras en los objetos
    Private.ImproveItems( Data )

    --- Mejorar en los equipos
    Private.ImproveEquipament( Data )

    --- Mejorar en los suelos
    Private.ImproveTile( Data )

    --- Mejorar en las entidades
    Private.IdentifyEntity( Data )

    --- Agregar el objeto modificado
    Private.AddModifiedItem( Data )
end

--- Comparar si se ha modificado el nuevo elemento al
--- compararlo con el elemento base
--- @param Data table
--- @param New table
--- @param Base table
function Private.isModified( Data, New, Base )
    local newString = GPrefix.toString( New )
    local oldString = GPrefix.toString( Base )
    Data.Modified = newString ~= oldString
    if not Data.Modified then Data.Modified = nil end
    return Data.Modified
end

--- Agregar el objeto modificado
--- @param Data table
function Private.AddModifiedItem( Data )

    --- Validación básica
    if not Data.Modified then return end

    --- Eliminar el objeto sin efectos
    Data.TheMOD.NewItems[ Data.OldItem.name ] = nil
    GPrefix.RemoveItem( Data.OldItem.name )

    --- Modificar el objeto con efecto
    local Properties = { }
    table.insert( Properties, "name" )
    table.insert( Properties, "icons" )
    table.insert( Properties, "subgroup" )
    table.insert( Properties, "localised_name" )
    table.insert( Properties, "localised_description" )
    for _, Property in pairs( Properties ) do
        Data.NewItem[ Property ] = GPrefix.DeepCopy( Data.OldItem[ Property ] )
    end

    --- Agregar la letra del MOD
    GPrefix.addLetter( Data.Uncompact, GPrefix.CI.Char )
    GPrefix.addLetter( Data.Uncompact, ThisMOD.Char )

    GPrefix.addLetter( Data.Compact, GPrefix.CI.Char )
    GPrefix.addLetter( Data.Compact, ThisMOD.Char )

    GPrefix.addLetter( Data.NewItem, GPrefix.CI.Char )
    GPrefix.addLetter( Data.NewItem, ThisMOD.Char )

    --- Modificar las recetas
    Data.NewItem.name = GPrefix.addPrefixMOD( Data.NewItem.name, ThisMOD )
    Data.NewItem.name = GPrefix.addPrefixMOD( Data.NewItem.name, Data.TheMOD )
    Data.Compact.results[ 1 ].name = Data.NewItem.name
    Data.Uncompact.ingredients[ 1 ].name = Data.NewItem.name

    --- Imagen de este MOD
    local IconMOD = ThisMOD.Patch .. "icons/status.png"

    --- Cambiar la imagen
    Data.NewItem.icons[ #Data.NewItem.icons ].icon = IconMOD
    Data.Compact.icons[ #Data.Compact.icons - 1 ].icon = IconMOD
    Data.Uncompact.icons[ #Data.Uncompact.icons - 1 ].icon = IconMOD

    --- Crear el objeto mejorado
    Data.TheMOD.NewItems[ Data.NewItem.name ] = Data.NewItem
    ThisMOD.NewItems[ Data.NewItem.name ] = Data.NewItem
    if #Data.Others > 0 then data:extend( Data.Others ) end
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Mejorar los objetos
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Identificar los objetos
function Private.ImproveItems( Data )
    Private.ImproveAmmo( Data )
    Private.ImproveFuel( Data )
    Private.ImproveModule( Data )
    Private.ImproveCapsule( Data )
    Private.ImproveRepairTool( Data )

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    Private.isModified( Data, Data.NewItem, Data.BaseItem )
end

--- Mejorar las capsulas
--- @param Data table
function Private.ImproveCapsule( Data )

    --- Valdación básica
    if Data.NewItem.type ~= "capsule" then return end
    if string.find( Data.NewItem.name, "cliff" ) then return end
    if Data.NewItem.name == "cliff-explosives" then return end

    --- Variable contenedora
    local Propietys = { }
    table.insert( Propietys, "capsule_action" )
    table.insert( Propietys, "attack_parameters" )
    table.insert( Propietys, "ammo_type" )

    --- Buscar el efecto deseado
    local Propiety = Data.NewItem
    for _, value in pairs( Propietys ) do
        Propiety = Propiety[ value ]
        if not Propiety then return end
    end

    --- Buscar la acción deseada
    if not Propiety.action then return end

    --- Renombrar la variable
    local Actions = Propiety.action
    Data.Projectiles = data.raw.projectile

    --- Validación de datos
    Actions = Actions[ 1 ] and Actions or { Actions }

    --- Buscar la acción deseada
    for _, Action in pairs( Actions ) do
        Data.ActionDelivery = Action.action_delivery
        Private.ImproveCapsuleInstant( Data )
        Private.ImproveCapsuleProjectiles( Data )
    end
end

--- Mejorar lo que se consume
--- @param Data table
function Private.ImproveCapsuleInstant( Data )

    --- Acción no encontrada
    if not Data.ActionDelivery then return end

    --- Daño instantaneo o cura instantanea
    if not Data.ActionDelivery.target_effects then return end

    --- Renombrar la variable
    local TargetEffects = Data.ActionDelivery.target_effects

    --- Validación de datos
    if not TargetEffects[ 1 ] then TargetEffects = { TargetEffects } end

    --- Buscar el efecto deseado
    for _, TargetEffect in pairs( TargetEffects ) do
        if TargetEffect.damage then
            Data.Array = TargetEffect
            Private.ImproveCapsuleAmount( Data )
        end
    end
end

--- Mejorar lo que se arroja
--- @param Data table
function Private.ImproveCapsuleProjectiles( Data )

    --- Acción no encontrada
    if not Data.ActionDelivery then return end

    --- Daño por efecto
    if not Data.ActionDelivery.projectile then return end

    --- Renombrar la variable
    Data.ProjectileName = Data.ActionDelivery.projectile

    --- Copiar el efecto
    Data.OldProjectile = Data.Projectiles[ Data.ProjectileName ]
    Data.NewProjectile = GPrefix.DeepCopy( Data.OldProjectile )

    --- Renombrar la variable
    local Actions = Data.NewProjectile.action

    --- Validación de datos
    Actions = Actions[ 1 ] and Actions or { Actions }
    for _, Action in pairs( Actions ) do
        local TargetEffects = { }
        local ActionDelivery = Action.action_delivery
        if not ActionDelivery then goto JumpContinue end

        if Action.type == "cluster" then
            Data.Action = Action
            Private.ImproveCapsuleCluster( Data )
        end

        TargetEffects = ActionDelivery.target_effects
        if not TargetEffects then goto JumpContinue end
        if #TargetEffects < 1 then TargetEffects = { ActionDelivery.target_effects } end

        for _, Effect in pairs( TargetEffects ) do
            Data.Array = Effect
            Private.ImproveCapsuleAmount( Data )
            Private.ImproveCapsuleStiker( Data )

            Private.ImproveCapsuleEnemies( Data, data.raw.unit )
            Private.ImproveCapsuleRobots( Data, data.raw[ "combat-robot" ] )

            if Effect.entity_name and GPrefix.Entities[ Effect.entity_name ] then
                GPrefix.Log( "Show this to YAIM904", Data.NewProjectile.name )
            end
        end

        --- Recepción del salto
        :: JumpContinue ::
    end

    --- Agregar el proyectil
    Private.isModified( Data, Data.NewProjectile, Data.OldProjectile )
    if not Data.Modified then return end

    --- Renombrar el proyectil
    local Name = Data.NewProjectile.name
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )
    Data.NewProjectile.name = Name

    --- Actualizar el proyectil
    Data.ActionDelivery.projectile = Name
    if Data.Projectiles[ Name ] then return end
    table.insert( Data.Others, Data.NewProjectile )
end

--- Mejorar las granadas y las curas
--- @param Data table
function Private.ImproveCapsuleAmount( Data )

    --- Renombrar la variable
    local Damage = Data.Array.damage

    --- Validación básica
    if not Damage then return end

    --- Potenciar el valor
    Damage.amount = Damage.amount * GPrefix.CI.Value
end

--- Mejora en las granadas de racimo
--- @param Data table
function Private.ImproveCapsuleCluster( Data )

    --- Renombrar la variable
    local Target = Data.Action.action_delivery

    --- Validación básica
    if not Target then return end
    if not Target.projectile then return end

    --- Nombre del proyectil
    local Name = Target.projectile
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )

    --- Crear el proyectil de ser necesario
    if not Data.Projectiles[ Name ] then
        Data.ActionDelivery = { projectile = Target.projectile }
        Private.ImproveCapsuleProjectiles( Data )
    end

    --- Cambiar el proyectil
    Target.projectile = Name
end

--- Mejorar las cápsulas para realientizzar
--- @param Data table
function Private.ImproveCapsuleStiker( Data )

    --- Renombrar la variable
    local Target = Data.Array
    local Stickers = data.raw.sticker

    --- Validación básica
    if not Target then return end
    if not Target.sticker then return end

    --- Nombre del nuevo stiker
    local Name = Target.sticker
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )

    --- Validar si ya existe
    if Stickers[ Name ] then goto JumpSticker end

    --- Cargar efecto
    Data.Sticker = Stickers[ Target.sticker ]
    Data.Sticker = GPrefix.DeepCopy( Data.Sticker )
    if not Data.Sticker then return end

    --- Actualizar los valores
    Data.Sticker.name = Name
    Data.Sticker.duration_in_ticks = Data.Sticker.duration_in_ticks * GPrefix.CI.Value
    table.insert( Data.Others, Data.Sticker )

    --- Recepción del salto
    :: JumpSticker ::

    --- Cambiar el efecto
    Target.sticker = Name
end

--- Mejorar los enemigos-aliados
--- @param Data table
--- @param Array table
function Private.ImproveCapsuleEnemies( Data, Array )
    Private.ImproveCapsuleEntities( Data, Array )
end

--- Mejorar los robots
--- @param Data table
--- @param Array table
function Private.ImproveCapsuleRobots( Data, Array )
    Private.ImproveCapsuleEntities( Data, Array )
end

--- Mejorar las entidades
--- @param Data table
--- @param Array table
function Private.ImproveCapsuleEntities( Data, Array )

    --- Renombrar la variable
    local Target = Data.Array

    --- Validación básica
    if not Target.entity_name then return end

    --- Nombre del nuevo proyectil
    local Name = Target.entity_name
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )

    --- Validar si ya existe
    if Array[ Name ] then goto JumpElement end

    --- Cargar el elemento
    Data.Element = Array[ Target.entity_name ]
    Data.Element = GPrefix.DeepCopy( Data.Element )
    if not Data.Element then return end

    --- Actualizar los valores
    Data.Element.name = Name
    Data.Element.max_health = Data.Element.max_health * GPrefix.CI.Value
    if not Data.Element.localised_name then
        Data.Element.localised_name = { "", { "entity-name." .. Target.entity_name } }
    elseif Data.Element.localised_name then
        Data.Element.localised_name = GPrefix.addLetter( Data.Element, "[" )
    end table.insert( Data.Others, Data.Element )

    --- Recepción del salto
    :: JumpElement ::

    --- Cambiar el efecto
    Target.entity_name = Name
end

--- Mejorar las municiones
--- @param Data table
function Private.ImproveAmmo( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if NewItem.type ~= "ammo"  then return end
    if not NewItem.ammo_type then return end

    --- Validación de datos
    NewItem.magazine_size = NewItem.magazine_size or 1

    --- Potenciar el valor
    NewItem.magazine_size = NewItem.magazine_size * GPrefix.CI.Value
end

--- Mejorar los combustibles
--- @param Data table
function Private.ImproveFuel( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if not NewItem.fuel_value then return end
    if NewItem.place_result then return end

    --- Potenciar el valor
    NewItem.fuel_value = Private.ReCalculate( NewItem.fuel_value )
end

--- Mejorar los modulos
--- @param Data table
function Private.ImproveModule( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if NewItem.type ~= "module" then return end
    if not NewItem.effect then return end

    --- Variable contenedora
    local Effects = { }
    table.insert( Effects, { "productivity", 1 } )
    table.insert( Effects, { "consumption", -1 } )
    table.insert( Effects, { "pollution", -1 } )
    table.insert( Effects, { "speed",  1 } )

    --- Buscar el efecto deseado
    for _, Effect in ipairs( Effects ) do

        --- Contenedor de valores
        local List = { }

        --- Encontrar el efecto
        List.Name = Effect[ 1 ]
        List.effect = NewItem.effect[ List.Name ]
        if not List.effect then goto JumpEffect end

        --- Cacular el nuevo valor
        List.Bonus = Effect[ 2 ]
        if List.Bonus > 0 then
            List.Bonus = List.Bonus * List.effect.bonus
            List.Bonus = List.Bonus * GPrefix.CI.Value
        end

        --- Validación de datos
        if List.Bonus > 300 then List.Bonus = 300 end
        if List.Bonus < 0 then List.Bonus = 0 end

        --- Establecer el valor
        if List.Bonus > 0 then List.effect.bonus = List.Bonus end

        --- Eliminar el efecto
        if List.Bonus < 1 then NewItem.effect[ List.Name ] = nil end

        --- Recepción del salto
        :: JumpEffect ::
    end

    --- Marcar como modificado
    if GPrefix.getLength( NewItem.effect ) < 1 then
        Data.NewItem = GPrefix.DeepCopy( Data.BaseItem )
    end
end

--- Mejorar los objetos de reparación
--- @param Data table
function Private.ImproveRepairTool( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if NewItem.type ~= "repair-tool" then return end
    if not NewItem.durability then return end
    if not NewItem.speed then return end

    --- Establecer el suelo en el nuevo objeto
    if GPrefix.CI.Value > NewItem.speed then
        NewItem.speed = NewItem.speed * GPrefix.CI.Value
        NewItem.speed = NewItem.speed * 1 / 3
        NewItem.speed = math.floor( NewItem.speed )
    end

    --- Validación de datos
    if GPrefix.CI.Value > NewItem.durability then
        NewItem.durability = NewItem.durability * GPrefix.CI.Value
        NewItem.durability = NewItem.durability * 2 / 3
        NewItem.durability = math.ceil( NewItem.durability )
    end
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Mejorar los equipos
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

function Private.ImproveEquipament( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if NewItem.type ~= "item" then return end
    if not NewItem.placed_as_equipment_result then return end

    --- Variable contenedora
    local oldEquipament = { }
    local newEquipament = { }
    local Propiety = { }

    --- Cargar el equipo
    oldEquipament = NewItem.placed_as_equipment_result
    oldEquipament = GPrefix.Equipaments[ oldEquipament ] or Data.TheMOD.NewEquipaments[ oldEquipament ]
    newEquipament = GPrefix.DeepCopy( oldEquipament )



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Buffer e IO
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    if not newEquipament.energy_source then goto JumpEnegy end

    --- Renombrar la variable
    Propiety = newEquipament.energy_source

    --- Validación de datos
    if Propiety.buffer_capacity then
        Propiety.buffer_capacity = Private.ReCalculate( Propiety.buffer_capacity )
    end

    --- Validación de datos
    if Propiety.input_flow_limit then
        Propiety.input_flow_limit = Private.ReCalculate( Propiety.input_flow_limit )
    end

    --- Validación de datos
    if Propiety.output_flow_limit then
        Propiety.output_flow_limit = Private.ReCalculate( Propiety.output_flow_limit )
    end

    --- Recepción del salto
    :: JumpEnegy ::



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Armas
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    if not newEquipament.attack_parameters then goto JumpWeapon end

    --- Renombrar la variable
    Propiety = newEquipament.attack_parameters

    --- Validación de datos
    if Propiety.damage_modifier then
        Propiety.damage_modifier = Propiety.damage_modifier * GPrefix.CI.Value
    end

    --- Recepción del salto
    :: JumpWeapon ::



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Escudos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    if newEquipament.max_shield_value then
        newEquipament.max_shield_value = newEquipament.max_shield_value * GPrefix.CI.Value
    end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Generadores
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    if newEquipament.power then
        newEquipament.power = Private.ReCalculate( newEquipament.power )
    end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Recargas de los robopurtos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    if newEquipament.charging_energy then
        newEquipament.charging_energy = Private.ReCalculate( newEquipament.charging_energy )
    end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Regresar el objeto usado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    if newEquipament.take_result then
        newEquipament.take_result = nil
    end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- No es necesario agregar el equipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    Private.isModified( Data, newEquipament, oldEquipament )
    if not Data.Modified then return end



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- Valores del nuevo equipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Recombrar el equipo
    local Name = newEquipament.name
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )
    newEquipament.name = Name

    --- Actualizar el equipameto a crear
    Name = Data.NewItem.placed_as_equipment_result
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )
    Data.NewItem.placed_as_equipment_result = Name

    --- Actualizar las letras
    GPrefix.addLetter( newEquipament, GPrefix.CI.Char )
    GPrefix.addLetter( newEquipament, ThisMOD.Char )
    newEquipament.localised_name = NewItem.localised_name

    --- Guardar el nuevo equipo
    Data.TheMOD.NewEquipaments[ Name ] = newEquipament
    ThisMOD.NewEquipaments[ Name ] = newEquipament
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Mejorar los suelos
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

function Private.ImproveTile( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if not NewItem.place_as_tile then return end

    --- Buscar el suelo
    local Tiles = GPrefix.Tiles[ NewItem.name ]
    if not Tiles then return end

    --- Nombre para la busqueda
    local NewTile = { }
    local Name = NewItem.name
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Data.TheMOD.NewTiles[ Name ] = NewTile
    ThisMOD.NewTiles[ Name ] = NewTile

    --- Establecer el suelo en el nuevo objeto
    Name = NewItem.place_as_tile.result
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )
    NewItem.place_as_tile.result = Name

    --- Marcar como modificado
    Data.Modified = true

    --- Recorrer todos los suelos
    for _, Tile in pairs( Tiles ) do

        --- Hacer una copia del suelo
        Tile = GPrefix.DeepCopy( Tile )

        --- Recombrar el suelo
        Tile.name = GPrefix.addPrefixMOD( Tile.name, GPrefix.CI )

        --- Renombrar el suelo con otra dirección
        if Tile.next_direction then
            Tile.next_direction = GPrefix.addPrefixMOD( Tile.next_direction, GPrefix.CI )
            Tile.next_direction = GPrefix.addPrefixMOD( Tile.next_direction, ThisMOD )
        end

        --- Actualizar el piso a retiar
        if Tile.minable and Tile.minable.result then
            Tile.minable.result = GPrefix.addPrefixMOD( Tile.minable.result, GPrefix.CI )
        end

        --- Beneficion del suelo
        local Absorption = Tile.pollution_absorption_per_second or 0
        Absorption = Absorption > 0 and Absorption or 0.1
        Absorption = Absorption * GPrefix.CI.Value
        Tile.pollution_absorption_per_second = Absorption

        --- Guardar el nuevo suelo
        table.insert( NewTile, Tile )
    end
end



--- --- --- --- --- --- --- --- --- --- --- --- --- --- 
--- Mejorar las entidades
--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

--- Identificar las entidades
function Private.IdentifyEntity( Data )

    --- Renombrar la variable
    local NewItem = Data.NewItem

    --- Valdación básica
    if not NewItem.place_result then return end

    --- Variable contenedora
    Data.oldEntity = GPrefix.Entities[ NewItem.place_result ] or Data.TheMOD.NewEntities[ NewItem.place_result ]
    Data.newEntity = GPrefix.DeepCopy( Data.oldEntity )
    if not Data.newEntity then
        GPrefix.Log(
            "improve-compaction.lua",
            NewItem.place_result,
            Data.TheMOD.NewElements
        )
    end
    if not Data.newEntity then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Variado
    Private.ImproveLab( Data )
    Private.ImproveGate( Data )
    Private.ImproveTree( Data )
    Private.ImproveWall( Data )
    Private.ImproveBeacon( Data )
    Private.ImproveContainer( Data )
    Private.ImproveMiningDrill( Data )
    Private.ImproveRailwayEntity( Data )
    Private.ImproveCraftingMachine( Data )

    --- Robots
    Private.ImproveRobot( Data )
    Private.ImproveRoboport( Data )

    --- Energy
    Private.ImproveGenerator( Data )
    Private.ImproveSolarPanel( Data )
    Private.ImproveAccumulator( Data )

    --- Armas
    Private.ImproveFluidWeapon( Data )
    Private.ImproveWeaponAmmoless( Data )

    --- Fluidos
    Private.ImprovePump( Data )
    Private.ImproveFluidWagon( Data )
    Private.ImprovePepeToGround( Data )
    Private.ImproveInputFluidBox( Data )
    Private.ImproveOutputFluidBox( Data )

    --- Logistica
    Private.ImproveBelt( Data )
    Private.ImproveLoader( Data )
    Private.ImproveInserter( Data )
    Private.ImproveSplitter( Data )
    Private.ImproveUndergroundBelt( Data )

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    Private.isModified( Data, Data.newEntity, Data.oldEntity )
    if not Data.Modified then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- No se modificó la entidad
    if not Data.Modified then return end

    --- Recombrar la entidad
    local Name = Data.newEntity.name
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )
    Data.newEntity.name = Name

    --- Reemplazar la entidad no compactada
    if not Data.newEntity.fast_replaceable_group then
        Data.newEntity.fast_replaceable_group = Data.BaseItem.subgroup
        Data.oldEntity.fast_replaceable_group = Data.BaseItem.subgroup
    end

    --- Asignar objeto como minable
    if Data.newEntity.minable and Data.newEntity.minable.result then
        Name = Data.newEntity.minable.result
        Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
        Name = GPrefix.addPrefixMOD( Name, ThisMOD )
        Data.newEntity.minable.result = Name
    end

    --- Establecer el apodo
    Data.newEntity.localised_name = NewItem.localised_name
    GPrefix.addLetter( Data.newEntity, ThisMOD.Char )
    GPrefix.addLetter( Data.newEntity, GPrefix.CI.Char )

    --- Guardar la nueva entidad
    Data.TheMOD.NewEntities[ Data.newEntity.name ] = Data.newEntity
    ThisMOD.NewEntities[ Data.newEntity.name ] = Data.newEntity

    --- Actualizar la entidad a crear
    Name = NewItem.place_result
    Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
    Name = GPrefix.addPrefixMOD( Name, ThisMOD )
    NewItem.place_result = Name

    --- Cambiar la mejora de la entidad
    if Data.newEntity.next_upgrade then
        Name = Data.newEntity.next_upgrade
        Name = GPrefix.addPrefixMOD( Name, GPrefix.CI )
        Name = GPrefix.addPrefixMOD( Name, ThisMOD )
        Data.newEntity.next_upgrade = Name
    end
end

--- Mejorar los laboratorios
function Private.ImproveLab( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "lab" then return end

    --- Potenciar el valor
    NewEntity.researching_speed = NewEntity.researching_speed * GPrefix.CI.Value
end

--- Mejorar las puertas
function Private.ImproveGate( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "gate" then return end

    --- Potenciar el valor
    NewEntity.max_health = NewEntity.max_health * GPrefix.CI.Value
end

--- Mejorar los árboles
function Private.ImproveTree( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "tree" then return end

    --- Potenciar el valor
    NewEntity.emissions_per_second = NewEntity.emissions_per_second * GPrefix.CI.Value
end

--- Mejorar los muros
function Private.ImproveWall( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "wall" then return end

    --- Potenciar el valor
    NewEntity.max_health = NewEntity.max_health * GPrefix.CI.Value
end

--- Mejorar los faros
function Private.ImproveBeacon( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "beacon" then return end

    --- Potenciar el valor
    NewEntity.distribution_effectivity = NewEntity.distribution_effectivity * GPrefix.CI.Value
end

--- Mejorar los contenedores
function Private.ImproveContainer( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Entidades a modificar
    local Types = { }
    table.insert( Types, "container" )
    table.insert( Types, "logistic-container" )

    --- Valdación básica
    if not GPrefix.getKey( Types, NewEntity.type ) then return end

    --- Potenciar el valor
    NewEntity.inventory_size = GPrefix.CI.Value
end

--- Mejorar los talatros
function Private.ImproveMiningDrill( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "mining-drill" then return end

    --- Potenciar el valor
    NewEntity.mining_speed = NewEntity.mining_speed * GPrefix.CI.Value
end

--- Mejorar los rieles
function Private.ImproveRailwayEntity( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Entidades a modificar
    local Types = { }
    table.insert( Types, "locomotive" )
    table.insert( Types, "cargo-wagon" )
    table.insert( Types, "fluid-wagon" )
    table.insert( Types, "artillery-wagon" )

    --- Valdación básica
    if not GPrefix.getKey( Types, NewEntity.type ) then return end

    --- Potenciar la velocidad
    NewEntity.max_speed = NewEntity.max_speed * GPrefix.CI.Value
    NewEntity.air_resistance = 0

    --- Mejorar el almacentamiento
    if NewEntity.inventory_size and NewEntity.inventory_size < GPrefix.CI.Value  then
        NewEntity.inventory_size = GPrefix.CI.Value
    end
end

--- Mejorar las maquinas que fabrican
function Private.ImproveCraftingMachine( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if not NewEntity.crafting_speed then return end

    --- Potenciar la absorción de la contaminación
    if NewEntity.energy_source then
        local EnergySource = NewEntity.energy_source
        local Pollution = EnergySource.emissions_per_minute
        if Pollution and Pollution < 0 then
            Pollution = Pollution  * GPrefix.CI.Value
            EnergySource.emissions_per_minute = Pollution
            return
        end
    end

    --- La entidad no tiene resulatados ni require inventario
    local Ingredient = NewEntity.source_inventory_size
    local Result = NewEntity.result_inventory_size
    if Result and Ingredient then
        if Result == 0 and Ingredient == 0 then
            return
        end
    end

    --- Potenciar la velocidad de creación
    local Speed = NewEntity.crafting_speed
    Speed = Speed * GPrefix.CI.Value
    NewEntity.crafting_speed = Speed
end



--- Mejorar los robots
function Private.ImproveRobot( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Entidades a modificar
    local Types = { }
    table.insert( Types, "logistic-robot" )
    table.insert( Types, "construction-robot" )

    --- Valdación básica
    if not GPrefix.getKey( Types, NewEntity.type ) then return end

    --- Potenciar el valor
    NewEntity.speed = NewEntity.speed * GPrefix.CI.Value
end

--- Mejorar los robot puertos
function Private.ImproveRoboport( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "roboport" then return end

    --- Potenciar el valor
    NewEntity.charging_energy = Private.ReCalculate( NewEntity.charging_energy )
end



--- Mejorar los generadores
function Private.ImproveGenerator( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "generator" then return end

    --- La energía generada es fija
    if NewEntity.max_power_output then
        NewEntity.max_power_output = Private.ReCalculate( NewEntity.max_power_output )
    end

    --- La energía generada se calcula
    if not NewEntity.max_power_output then
        NewEntity.effectivity = NewEntity.effectivity * GPrefix.CI.Value
    end
end

--- Mejorar los paneles solares 
function Private.ImproveSolarPanel( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "solar-panel" then return end

    --- Potenciar el valor
    NewEntity.production = Private.ReCalculate( NewEntity.production )
end

--- Mejorar los acomuladores
function Private.ImproveAccumulator( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "accumulator" then return end

    --- Valdación básica
    local EnergySource = NewEntity.energy_source
    if not EnergySource then return end
    local Output = EnergySource.output_flow_limit
    if GPrefix.getNumber( Output ) == 0 then return end

    --- Potenciar el valor
    EnergySource.output_flow_limit = Private.ReCalculate( EnergySource.output_flow_limit )
    EnergySource.input_flow_limit = Private.ReCalculate( EnergySource.input_flow_limit )
    EnergySource.buffer_capacity = Private.ReCalculate( EnergySource.buffer_capacity )
end



--- Mejorar las armas de fluidos
function Private.ImproveFluidWeapon( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Variable contenedora
    local Value = NewEntity.attack_parameters

    --- Valdación básica
    if not Value then return end
    if not Value.fluids then return end

    --- Potenciar el valor
    for _, fluid in pairs( Value.fluids ) do
        if fluid.damage_modifier then
            fluid.damage_modifier = fluid.damage_modifier * GPrefix.CI.Value
        end
    end
end

--- Mejorar las armas si municiones
function Private.ImproveWeaponAmmoless( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Variable contenedora
    local Value = NewEntity.attack_parameters

    --- Valdación básica
    if not Value then return end
    if not Value.damage_modifier then return end

    --- Potenciar el valor
    Value.damage_modifier = Value.damage_modifier * GPrefix.CI.Value
end



--- Mejorar los bombas de liquidos
function Private.ImprovePump( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if not NewEntity.pumping_speed then return end

    --- Potenciar el valor
    local Value = NewEntity.pumping_speed
    Value = Value * GPrefix.CI.Value
    NewEntity.pumping_speed = Value

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    --- Variable contenedora
    local Table = NewEntity.fluid_box

    --- Valdación básica
    if not Table then return end

    --- Renombrar la variable
    Value = GPrefix.CI.Value

    --- Potenciar el valor
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

--- Mejorar los vagones de fluidos
function Private.ImproveFluidWagon( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "fluid-wagon" then return end

    --- Potenciar el valor
    NewEntity.capacity = NewEntity.capacity * GPrefix.CI.Value
end

--- Mejorar la capacidad y el flujo entrante
function Private.ImprovePepeToGround( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "pipe-to-ground" then return end

    --- Variable contenedora
    local Table = NewEntity.fluid_box

    --- Valdación básica
    if not Table then return end

    --- Renombrar la variable
    local Value = GPrefix.CI.Value

    --- Buscar y cambiar la distancia maxima
    for _, value in pairs( Table.pipe_connections or { } ) do
        if value.max_underground_distance then
            local Distance = value.max_underground_distance
            if Value > Distance then Distance = Value end
            if Distance > 250 then Distance = 250 end
            value.max_underground_distance = Distance
        end
    end
end

--- Mejorar la capacidad y el flujo entrante
function Private.ImproveInputFluidBox( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "storage-tank" then return end

    --- Variable contenedora
    local Table = NewEntity.fluid_box

    --- Valdación básica
    if not Table then return end

    --- Renombrar la variable
    local Value = GPrefix.CI.Value

    --- Potenciar el valor
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

--- Mejorar el flujo saliente
function Private.ImproveOutputFluidBox( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "storage-tank" then return end

    --- Variable contenedora
    local Table = NewEntity.output_fluid_box

    --- Valdación básica
    if not Table then return end

    --- Renombrar la variable
    local Value = GPrefix.CI.Value

    --- Potenciar el valor
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



--- Mejorar las cintas transportadoras
function Private.ImproveBelt( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "transport-belt" then return end

    --- Potenciar el valor
    local Value = NewEntity.speed
    Value = Value * GPrefix.CI.Value
    NewEntity.speed = Value

    Value = NewEntity.animation_speed_coefficient
    Value = Value / GPrefix.CI.Value
    NewEntity.animation_speed_coefficient = Value
end

--- Mejorar los cargadores
function Private.ImproveLoader( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Entidades a modificar
    local Types = { }
    table.insert( Types, "loader" )
    table.insert( Types, "loader-1x1" )

    --- Valdación básica
    if not GPrefix.getKey( Types, NewEntity.type ) then return end

    --- Potenciar el valor
    local Value = NewEntity.speed
    Value = Value * GPrefix.CI.Value
    NewEntity.speed = Value

    Value = NewEntity.animation_speed_coefficient
    Value = Value / GPrefix.CI.Value
    NewEntity.animation_speed_coefficient = Value
end

--- Mejorar los insertadores
function Private.ImproveInserter( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "inserter" then return end

    --- Variable contenedora
    local Speed = 0

    --- Potenciar el valor
    Speed = NewEntity.extension_speed
    Speed = Speed * GPrefix.CI.Value
    if Speed > 0.2 then Speed = 0.2 end
    NewEntity.extension_speed = Speed

    Speed = NewEntity.rotation_speed
    Speed = Speed * GPrefix.CI.Value
    if Speed > 0.2 then Speed = 0.2 end
    NewEntity.rotation_speed = Speed
end

--- Mejorar los divisores
function Private.ImproveSplitter( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "splitter" then return end

    --- Potenciar el valor
    local Value = NewEntity.speed
    Value = Value * GPrefix.CI.Value
    NewEntity.speed = Value

    Value = NewEntity.animation_speed_coefficient
    Value = Value / GPrefix.CI.Value
    NewEntity.animation_speed_coefficient = Value
end

--- Mejorar las cintas subterraneas
function Private.ImproveUndergroundBelt( Data )

    --- Renombrar la variable
    local NewEntity = Data.newEntity

    --- Valdación básica
    if NewEntity.type ~= "underground-belt" then return end

    --- Potenciar el valor
    local Value = 0

    Value = NewEntity.max_distance
    Value = Value * GPrefix.CI.Value
    if Value > 250 then Value = 250 end
    NewEntity.max_distance = Value

    Value = NewEntity.speed
    Value = Value * GPrefix.CI.Value
    NewEntity.speed = Value

    Value = NewEntity.animation_speed_coefficient
    Value = Value / GPrefix.CI.Value
    NewEntity.animation_speed_coefficient = Value
end

--- --- --- --- --- --- --- --- --- --- --- --- --- --- 

-- Recalcular el valor de la energia
function Private.ReCalculate( OldValue )

    --- ValueOld = 10kW

    --- Convertir el valor en un número
    local Value = GPrefix.getNumber( OldValue ) --- 10000 <- 10kW

    --- Potenciar el valor
    --- GPrefix.CI.Value = 50
    Value = Value * GPrefix.CI.Value --- 500000 <- 10000 * 50

    --- Convertir el numero en cadena
    local NewValue = GPrefix.ShortNumber( Value ) --- 500K <- 500000

    --- Agregarle la unidad de medición
    NewValue = NewValue .. GPrefix.getUnit( OldValue ) --- 500KW <- 500K .. 10kW

    --- Devolver el resultado
    return NewValue --- 500KW
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------