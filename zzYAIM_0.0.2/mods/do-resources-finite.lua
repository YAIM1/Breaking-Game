---------------------------------------------------------------------------------------------------

--> do-resources-finite.lua <--

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

-- Configuración del MOD
local function Settings( )
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
    if true then return end
end

-- Cargar la configuración
Settings( )

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Hacer que los recursos sean finitos
function ThisMOD.doChange( )
    for _, Resource in pairs( data.raw.resource ) do
        Resource.infinite = nil
    end
end

-- Configuración del MOD
function ThisMOD.DataFinalFixes( )
    if not GPrefix.getKey( { "data-final-fixes" }, GPrefix.File ) then return end
    if ThisMOD.Requires and not ThisMOD.Requires.Active then return end
    if not ThisMOD.Active then return end

    ThisMOD.doChange( )
end

-- Cargar la configuración
ThisMOD.DataFinalFixes( )

---------------------------------------------------------------------------------------------------