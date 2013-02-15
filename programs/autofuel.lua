-- Functions
 
function introQuestion()
        term.clear()
        term.setCursorPos(1,1)
        CurrentFuelLevel = turtle.getFuelLevel()
        print("")
        print("Current Fuel : "..CurrentFuelLevel)
        print("")
        print("Fuel up (y/n)?")
        answer = read()
        if answer == "y" then
                return true
        end
        return false
end
function AutoFuel()
        term.clear()
        term.setCursorPos(1,1)
        print("Fuelling up...")
        for slot=1, 16 do
                turtle.select(slot)
                if turtle.refuel() then
                        CurrentFuelLevel = turtle.getFuelLevel()
                        print("Fuel : "..CurrentFuelLevel)
                end
        end
        print("Done.")
end
 
if introQuestion() then
        AutoFuel()
end