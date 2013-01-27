local tArgs = { ... }

if #tArgs ~= 2 then
  print("Usage: wall <length> <heigth>")
  print("  Example: wall 20 4")
  print("  Notes: * Wall include turtle starting space.")
  print("         * Wall will be built in the same direction as the turtle.")
  print("         * Turtle is at the bottom of the wall.")
  print("         * At least 1 representative building block must be in slot 1.")
  print("         * All slots may contain building blocks too.")
  print("         * Will not return to empty itself.")
  print("         * Will stop in its track waiting for block when empty.")
  return
end

local length = tonumber( tArgs[1] )
local heigth  = tonumber( tArgs[2] )



if not turtle.position then
  os.loadAPI('cc-scripts/apis/betterapi.lua')
  --  os.loadAPI('turtletracker.lua')
  os.loadAPI('inv.lua')
end


-- Build 1 layer of the wall.
function buildLayer()
  for i = 1, length do

    while not inv.selectSimilarBlock(1) do
      sleep(10)
    end

    turtle.placeDown()
    if i ~= length then turtle.forward() end
  end
end


for i = 1, heigth do
  
  -- Move up once to placeDown blocks
  turtle.up()
  
  -- Will placeDown block and move forward until AFTER the end of the wall.
  buildLayer()

  -- turn around
  turtle.right()
  turtle.right()
end
