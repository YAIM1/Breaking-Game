---------------------------------------------------------------------------------------------------

--> __CONSTANT__.lua <--

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Solo por el TOC
_G.log = log
_G.data = data
_G.game = game
_G.mods = mods
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
table.insert( MODs, { "pruebas", "p" } )
table.insert( MODs, { "compact-items", "CI" } )
table.insert( MODs, { "maximum-stack-size", "MaxStack" } )
table.insert( MODs, { "improve-compaction", "IC", "compact-items" } )
table.insert( MODs, { "miniloader", "L" } )
table.insert( MODs, { "queue-to-research", "QtR" } )
-- table.insert( MODs, { "start-with-items", "SwI" } )
-- table.insert( MODs, { "micro-machines", "MM" } )
-- table.insert( MODs, { "better-module", "BM" } )
-- table.insert( MODs, { "uncraft", "U" } )
-- table.insert( MODs, { "Deepminer", "D" } )
table.insert( MODs, { "free-fluids", "FF" } )
table.insert( MODs, { "armor-with-immunity", "AwI" } )
table.insert( MODs, { "equipament-1x1", "E1x1" } )
table.insert( MODs, { "sort-items", "SI" } )
table.insert( MODs, { "robots-with-unlimited-electricity", "RwUE" } )
table.insert( MODs, { "force-a-slot-module", "FaSM" } )
table.insert( MODs, { "minimum-electrical-consumption", "MEC" } )
table.insert( MODs, { "pollution-free-burner", "PFB" } )
table.insert( MODs, { "pollution-free-electricity", "PFE" } )
table.insert( MODs, { "force-production", "FP" } )

GPrefix.MODs = GPrefix.MODs or { }
for Index, MOD in pairs( MODs ) do

    -- Renombrar las variables
    local Name = MOD[ 1 ]

    -- Crea la variable y renombrar la variable
    local TheMOD = GPrefix.MODs[ Name ] or { }
    GPrefix.MODs[ Name ] = TheMOD

    -- Ruta de los archivos
    TheMOD.Patch = ""
    TheMOD.Patch = TheMOD.Patch .. "__" .. GPrefix.Prefix .. "__/"
    TheMOD.Patch = TheMOD.Patch .. "mods/"
    TheMOD.Patch = TheMOD.Patch .. "__MULTIMEDIES__/"
    TheMOD.Patch = TheMOD.Patch .. Name .. "/"

    -- Guardar datos base
    TheMOD.Name  = Name
    TheMOD.Index = Index
    TheMOD.Char  = string.char( 64 + Index )
    TheMOD.Local = GPrefix.Prefix_ .. TheMOD.Name .. "."
    TheMOD.MOD  = MOD[ 2 ]
    TheMOD.MOD_ = TheMOD.MOD .. "-"
    TheMOD.Prefix_MOD  = GPrefix.Prefix_ .. TheMOD.MOD
    TheMOD.Prefix_MOD_ = GPrefix.Prefix_ .. TheMOD.MOD_
end

for _, MOD in pairs( MODs ) do
    if #MOD > 2 then local This = MOD[ 1 ] local Main = MOD[ 3 ]
        GPrefix.MODs[ This ].Requires = GPrefix.MODs[ Main ]
    end
end

---------------------------------------------------------------------------------------------------