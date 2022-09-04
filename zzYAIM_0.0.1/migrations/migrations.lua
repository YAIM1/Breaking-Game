--------------------------------------

-- migrations.lua

--------------------------------------
--------------------------------------

-- Buscar la instancia correcta
for _, force in pairs( game.forces ) do

    -- Reiniciar todas las tecnologia
    force.reset_technologies( )

    -- Habilitar las recetas de las invetigaciones hechas
    for _, technology in pairs( force.technologies ) do
        for _, effect in pairs( technology.effects ) do
            if effect.type == "unlock-recipe" then
                local recipes = force.recipes[ effect.recipe ]
                recipes.enabled = technology.researched
            end
        end
    end
end

--------------------------------------