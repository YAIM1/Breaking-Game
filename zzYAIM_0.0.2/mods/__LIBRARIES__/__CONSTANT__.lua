---------------------------------------------------------------------------------------------------

---> __CONSTANT__.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Opciones propias del juego

--- Escribe el texto dado en el archivo factorio-current.log
---@type function
_G.log = log

--- Contiene TODOS los prototipos del juego en tiempo de carga
---@type table
_G.data = data

--- Contiene TODAS las funciones y datos del juego entiempo de ejecución
---@type table
_G.game = game

--- Directorio de los MOD activados en el juego
---@type table
_G.mods = mods

--- Contiene todos los valores que se guardan con la partida
---@type table
_G.global = global

--- Contiene las funciones para ejectutar los eventos en el juego
---@type table
_G.script = script

--- Directorio con los ID definidos en el juego
---@type table
_G.defines = defines

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Contenedor global del MOD
---@type table
_G.GPrefix = _G.GPrefix or { }

--- Nombre del archivo de origen
GPrefix.File = GPrefix.File or nil

--- Prefijo global del MOD
GPrefix.Prefix  = "zzYAIM"

--- Prefijo global del MOD con un guión
GPrefix.Prefix_ = GPrefix.Prefix .. "-"

--- Prefijo para ubicar la traducción
GPrefix.Local   = GPrefix.Prefix .. "."

--- Directorio de funciones que se ejectuta según el evento indicado
GPrefix.Script  = { }

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Unidades de energia
GPrefix.Unit = { }

--- Creat el directorio 
for Digits, Unit in pairs( { "", "K", "M", "G", "T", "P", "E", "Z", "Y" } ) do
    GPrefix.Unit[ Unit ] = 3 * ( Digits - 1 )
end

--- Invertir valores
for Key, Value in pairs( GPrefix.Unit ) do
    GPrefix.Unit[ Value ] = Key
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Array con los datos de los MODs contenidos
---@type { [ integer ]: newMOD }
local MODs = { }

--- Listado de MODs contenidos y cagados
MODs[ #MODs + 1 ] = { LUA = "compact-items",                        Prefix = "CI",      }
MODs[ #MODs + 1 ] = { LUA = "maximum-stack-size",                   Prefix = "MSS",     }
MODs[ #MODs + 1 ] = { LUA = "free-minerals",                        Prefix = "FM",      }
MODs[ #MODs + 1 ] = { LUA = "free-fluids",                          Prefix = "FF",      }
MODs[ #MODs + 1 ] = { LUA = "improve-compaction",                   Prefix = "IC",      Requires = { "compact-items" } }
MODs[ #MODs + 1 ] = { LUA = "start-with-items",                     Prefix = "SwI",     }
MODs[ #MODs + 1 ] = { LUA = "armor-with-immunity",                  Prefix = "AwI",     }
MODs[ #MODs + 1 ] = { LUA = "equipament-1x1",                       Prefix = "E1x1",    }
MODs[ #MODs + 1 ] = { LUA = "sort-items",                           Prefix = "SI",      }
MODs[ #MODs + 1 ] = { LUA = "robots-with-unlimited-electricity",    Prefix = "RwUE",    }
MODs[ #MODs + 1 ] = { LUA = "force-a-slot-module",                  Prefix = "FaSM",    }
MODs[ #MODs + 1 ] = { LUA = "minimum-electrical-consumption",       Prefix = "MEC",     }
MODs[ #MODs + 1 ] = { LUA = "pollution-free-burner",                Prefix = "PFB",     }
MODs[ #MODs + 1 ] = { LUA = "pollution-free-electricity",           Prefix = "PFE",     }
MODs[ #MODs + 1 ] = { LUA = "do-resources-finite",                  Prefix = "MRF",     }
MODs[ #MODs + 1 ] = { LUA = "slots-with-filters",                   Prefix = "SwF",     }
MODs[ #MODs + 1 ] = { LUA = "force-production",                     Prefix = "FP",      }
-- MODs[ #MODs + 1 ] = { LUA = "pruebas",                              Prefix = "p",       }

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- Directorio que contiene toda la información básica de ThisMOD
---@type { [ string ]: ThisMOD }
GPrefix.MODs = GPrefix.MODs or { }

--- Carga los datos para cada MOD ( Archivo ) indicado
---@param Index integer
---@param MOD newMOD
for Index, MOD in pairs( MODs ) do
    local TheMOD = GPrefix.MODs[ MOD.LUA ] or { }
    GPrefix.MODs[ MOD.LUA ] = TheMOD

    TheMOD.Patch = ""
    TheMOD.Patch = TheMOD.Patch .. "__" .. GPrefix.Prefix .. "__/"
    TheMOD.Patch = TheMOD.Patch .. "mods/"
    TheMOD.Patch = TheMOD.Patch .. "__MULTIMEDIES__/"
    TheMOD.Patch = TheMOD.Patch .. MOD.LUA .. "/"

    TheMOD.Name  = MOD.LUA
    TheMOD.Index = Index
    TheMOD.Char  = string.char( 64 + Index )
    TheMOD.Local = GPrefix.Prefix_ .. TheMOD.Name .. "."
    TheMOD.MOD  = MOD.Prefix
    TheMOD.MOD_ = TheMOD.MOD .. "-"
    TheMOD.Prefix_MOD  = GPrefix.Prefix_ .. TheMOD.MOD
    TheMOD.Prefix_MOD_ = GPrefix.Prefix_ .. TheMOD.MOD_

    TheMOD.NewElements = { }
    TheMOD.NewElements.NewItems = { }
    TheMOD.NewElements.NewTiles = { }
    TheMOD.NewElements.NewFluids = { }
    TheMOD.NewElements.NewRecipes = { }
    TheMOD.NewElements.NewEntities = { }
    TheMOD.NewElements.NewEquipaments = { }

    TheMOD.NewItems = TheMOD.NewElements.NewItems
    TheMOD.NewTiles = TheMOD.NewElements.NewTiles
    TheMOD.NewFluids = TheMOD.NewElements.NewFluids
    TheMOD.NewRecipes = TheMOD.NewElements.NewRecipes
    TheMOD.NewEntities = TheMOD.NewElements.NewEntities
    TheMOD.NewEquipaments = TheMOD.NewElements.NewEquipaments
end

--- Enlazar las dependencia
---@param MOD newMOD
for _, MOD in pairs( MODs ) do

    --- Array con los nombres de los MODs requeridos
    ---@type table | nil
    local Array = MOD.Requires
    local Requires = { } ---@type { [ number ]: ThisMOD }
    local Mains = GPrefix.MODs

    --- Directorio de los MODs requeridos por este MOD
    Mains[ MOD.LUA ].Requires = Requires
    -- if #MOD > 2 then Array = MOD.Requires end
    if type( Array ) == "nil" then Array = { } end

    --- Ordenar los requisitos
    for i = 1, #Requires - 1, 1 do
        for j = i + 1, #Requires, 1 do
            local iMOD = Mains[ MOD[ i ] ]
            local jMOD = Mains[ MOD[ j ] ]
            if jMOD.Index < iMOD.Index then
                local nMOD = MOD[ i ]
                MOD[ i ] = MOD[ j ]
                MOD[ j ] = nMOD
            end
        end
    end

    for _, NameMOD in pairs( Array ) do
        Requires[ NameMOD ] = Mains[ NameMOD ]
    end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---@class ThisMOD
---@field Patch string Ruta de los archivos media
---@field Name string Nombre del mod o archivo
---@field Index integer Posición del MOD
---@field Char string Letra correspodiente a la posición del MOD
---@field Local string Prefijo para ubicar la traducción
---@field MOD string Prefijo del MOD
---@field MOD_ string Prefijo del MOD con un guión
---@field Prefix_MOD string Prefijo global y del MOD
---@field Prefix_MOD_ string Prefijo global y del MOD con un guión
---@field NewElements table Prototipos que el MOD desea agregar al juego
---@field NewItems table Diccionario con prototipos que el MOD desea agregar al juego
---@field NewTiles table Diccionario con prototipos que el MOD desea agregar al juego
---@field NewFluids table Diccionario con prototipos que el MOD desea agregar al juego
---@field NewRecipes table Diccionario con prototipos que el MOD desea agregar al juego, __ADVERTENCIA__ El indicador de las recetas, debe ser vacío si no requiere de una tecnología o el nombre de un objeto que desbloquee la tecnología objetivo
---@field NewEntities table Diccionario con prototipos que el MOD desea agregar al juego
---@field NewEquipaments table Diccionario con prototipos que el MOD desea agregar al juego
---@field DoEffect function Función que aplica el efecto del mismo a la tabla dada
---@field Active boolean Bandera que indica si el MOD está activo
---@field Value number Cantidad con la solicitada por el MOD
---@field Requires table Array con los MODs que se deben activar para usar este MOD

---@class newMOD
---@field LUA string Nombre del archivo donde se contiene el código del MOD
---@field Prefix string Prefijo del MOD, usado para nombrar los elementos del MOD por lo que debe ser único
---@field Requires table Array con los nombres de los MODs requeridos

---------------------------------------------------------------------------------------------------