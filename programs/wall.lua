os.loadAPI('cc-scripts/apis/inv')


local tArgs = { ... }

if #tArgs ~= 2 then
  print("Usage: wall <length> <heigth>")
  print("Example: wall 20 4")
  print("* Includes starting space.")
  print("* Turtle is at the bottom.")
  print("* Representative building block in slot 1.")
  return
end

local length = tonumber( tArgs[1] )
local heigth  = tonumber( tArgs[2] )



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
  turtle.turnRight()
  turtle.turnRight()
  
end
