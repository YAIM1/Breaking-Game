---------------------------------------------------------------------------------------------------

--> __CONSTANT__.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Solo por el TOC
_G.log = log
_G.data = data
_G.game = game
_G.global = global
_G.script = script
_G.defines = defines

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Contenedor de todo
GPrefix = GPrefix or { }
GPrefix.Prefix  = "zzYAIM"
GPrefix.Prefix_ = GPrefix.Prefix .. "-"
GPrefix.Local   = GPrefix.Prefix .. "."
GPrefix.Script  = { }

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Unidades de energia
GPrefix.Unit = { }
GPrefix.Unit.K =  3
GPrefix.Unit.M =  6
GPrefix.Unit.G =  9
GPrefix.Unit.T = 12
GPrefix.Unit.P = 15
GPrefix.Unit.E = 18
GPrefix.Unit.Z = 21
GPrefix.Unit.Y = 24
GPrefix.Unit[ 0 ] = ""

-- Invertir valores
for Key, Value in pairs( GPrefix.Unit ) do
    GPrefix.Unit[ Value ] = Key
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Crear los espacio para los MODs
local MODs = { }
table.insert( MODs, "pruebas" )
table.insert( MODs, "compact-items" )
-- table.insert( MODs, "improve-compaction" )
table.insert( MODs, "maximum-stack-size" )
table.insert( MODs, "miniloader" )
table.insert( MODs, "queue-to-research" )
-- table.insert( MODs, "start-with-items" )
table.insert( MODs, "free-fluids" )
table.insert( MODs, "armor-with-immunity" )
table.insert( MODs, "equipament-1x1" )
table.insert( MODs, "sort-items" )
table.insert( MODs, "robots-with-unlimited-electricity" )
table.insert( MODs, "force-a-slot-module" )
table.insert( MODs, "minimum-electrical-consumption" )
table.insert( MODs, "pollution-free-burner" )
table.insert( MODs, "pollution-free-electricity" )
table.insert( MODs, "force-production" )

GPrefix.MODs = GPrefix.MODs or { }
for Index, NameMOD in pairs( MODs ) do

    -- Crea la variable si aún no ha sido creada
    GPrefix.MODs[ NameMOD ] = GPrefix.MODs[ NameMOD ] or { }

    -- Renombrar la variable
    local TheMOD = GPrefix.MODs[ NameMOD ]

    -- Guardar datos base
    TheMOD.Name  = NameMOD
    TheMOD.Index = Index
    TheMOD.Patch = "__" .. GPrefix.Prefix .. "__/mods/__MULTIMEDIES__/" .. NameMOD .. "/"
    TheMOD.Char = string.char( 64 + Index )
    TheMOD.Prefix_MOD = GPrefix.Prefix_ .. NameMOD
    TheMOD.Prefix_MOD_ = TheMOD.Prefix_MOD .. "-"
    TheMOD.Local = TheMOD.Prefix_MOD .. "."
end

---------------------------------------------------------------------------------------------------