---------------------------------------------------------------------------------------------------

--> equipament-1x1.lua <--

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

    -- Renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    local Equipaments = Info.Equipaments or { }
    Info.Equipaments = Equipaments

    local Items = Info.Items or { }
    Info.Items = Items

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Redimencionar el tamñao del equipamento
    for _, Equipament in pairs( GPrefix.Equipaments ) do

        -- Validar elemento
        local Alias = nil
        if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
        if Alias and Alias( Equipament.name ) then goto JumpEquipament end

        -- Validar las dimensiones
        if Equipament.shape.width > 1 then
            Equipaments[ Equipament.name ] = Equipament
        elseif Equipament.shape.height > 1 then
            Equipaments[ Equipament.name ] = Equipament
        end

        -- Recepción del salto
        :: JumpEquipament ::
    end

    -- Hacer una copia de los equipos
    for Name, Equipament in pairs( Equipaments ) do
        Equipaments[ Name ] = GPrefix.DeepCopy( Equipament )
        Items[ Name ] = GPrefix.DeepCopy( GPrefix.Items[ Name ] )
        Recipes[ Name ] = GPrefix.DeepCopy( GPrefix.Recipes[ Name ] )
    end

    -- Hacer el cambio
    for _, Equipament in pairs( Equipaments ) do
        Equipament.shape.width = 1
        Equipament.shape.height = 1
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