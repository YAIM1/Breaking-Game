---------------------------------------------------------------------------------------------------

---> do-resources-finite.lua <---

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

    --- Aplicar el efecto del MOD
    Private.doChange( "", ThisMOD )

    --- Crear acceso directo al MOD
    GPrefix[ ThisMOD.MOD ] = ThisMOD
end

--- Aplicar el efecto del MOD
--- @param Name string
--- @param TheMOD ThisMOD
function Private.doChange( Name, TheMOD )
    for _, Resource in pairs( data.raw.resource ) do
        Resource.infinite = nil
    end
end

--- Sección para los prototipos
Private.DataFinalFixes( )

---------------------------------------------------------------------------------------------------