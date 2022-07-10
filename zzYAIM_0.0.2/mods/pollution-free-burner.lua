---------------------------------------------------------------------------------------------------

--> pollution-free-burner.lua <--

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

-- Cargar la infomación
function ThisMOD.LoadInformation( )

    -- Buscar las entidades a afectar
    for _, Entity in pairs( GPrefix.Entities ) do

        -- Validación básica
        local Flag = Entity
        if not Flag.energy_source then goto JumpEntity end

        Flag = Flag.energy_source
        if not Flag.type then goto JumpEntity end
        if Flag.type ~= "burner" then goto JumpEntity end

        if not Flag.emissions_per_minute then goto JumpEntity end

        -- Duplicar la información relacionada
        GPrefix.duplicateEntity( Entity, ThisMOD )

        -- Recepción del salto
        :: JumpEntity ::
    end

    ---> <---     ---> <---     ---> <---

    -- Inicializar y renombrar la variable
    local Info = ThisMOD.Information or { }
    ThisMOD.Information = Info

    ---> <---     ---> <---     ---> <---

    -- Inicializar y renombrar la variable
    local Entities = Info.Entities or { }
    Info.Entities = Entities

    -- Hacer los cambios
    for _, Entity in pairs( Entities ) do
        Entity.energy_source.emissions_per_minute = nil
    end
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