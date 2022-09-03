---------------------------------------------------------------------------------------------------

--> force-production.lua <--

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

    local Items = Info.Items or { }
    Info.Items = Items

    local Recipes = Info.Recipes or { }
    Info.Recipes = Recipes

    -- Duplicar los modulos de producción
    for _, Item in pairs( GPrefix.Items ) do

        -- Es un modulo??
        if not Item.limitation then goto JumpItem end

        -- Validar elemento
        local Alias = nil
        if GPrefix.Improve then Alias = GPrefix.Improve.AvoidElement end
        if Alias and Alias( Item.name ) then goto JumpItem end

        -- Duplicar el objeto
        Items[ Item.name ] = GPrefix.DeepCopy( Item )

        -- Recepción del salto
        :: JumpItem ::
    end

    -- Variable contenedora
    local limitation = { }

    -- Guardar el nombre de las recetas que afecta
    for _, Recipe in pairs( GPrefix.Recipes ) do
        for _, recipe in pairs( Recipe ) do
            if not GPrefix.getKey( limitation, recipe.name ) then
                table.insert( limitation, recipe.name )
            end
        end
    end

    -- Duplicar las recestas de los modulos
    for _, Module in pairs( Items ) do
        Recipes[ Module.name ] = GPrefix.Recipes[ Module.name ]
        Recipes[ Module.name ] = GPrefix.DeepCopy( Recipes[ Module.name ] )
        Module.limitation = limitation
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