loop = true
m = peripheral.wrap("bottom")
m.clear()
m.setTextScale(3.5)

currentFuelLevel = turtle.getFuelLevel()
sleep(1)
for i = 1 , 3 do
	m.setCursorPos(1,1)
	m.write(tostring(currentFuelLevel))
	sleep(0.5)
	m.clear()
	sleep(0.5)
end

currentFuelLevel = turtle.getFuelLevel()
-- term.clear()
m.clear()
m.setCursorPos(1,1)
m.write(tostring(currentFuelLevel))
-- term.write(currentFuelLevel)  --print(currentFuelLevel)
while loop do
  sleep(1)
--  if redstone.getInput("bottom") then
    -- print(currentFuelLevel)
    if turtle.suckUp() then
	  turtle.select(1)
	  turtle.refuel()
	  currentFuelLevel = turtle.getFuelLevel()
          m.clear()
	  m.setCursorPos(1,1)
          m.write(tostring(currentFuelLevel))
          --term.clear()
          --term.write(currentFuelLevel)
	  turtle.drop()
     end
  --end
end