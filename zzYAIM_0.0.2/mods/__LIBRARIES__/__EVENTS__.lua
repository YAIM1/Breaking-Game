---------------------------------------------------------------------------------------------------

---> __EVENTS__.lua <---

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Es necesario ejecutar este codigo??
if not GPrefix.getKey( { "control" }, GPrefix.File ) then return end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Recorrer los eventos programados
for Function, Parameters in pairs( GPrefix.Script ) do

    -- Eventos NO contenidos en defines.events
    if Function ~= "on_event" then
        script[ Function ]( function ( Event )
            for _, onFunction in pairs( Parameters ) do
                onFunction( Event )
            end
        end )
    end

    -- Eventos contenidos en defines.events
    if Function == "on_event" then
        for Event, functions in pairs( Parameters ) do
            script[ Function ]( Event, function ( Event )
                for _, onFunction in pairs( functions ) do
                    onFunction( Event )
                end
            end )
        end
    end
end

---------------------------------------------------------------------------------------------------