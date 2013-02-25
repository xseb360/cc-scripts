-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')
os.loadAPI('cc-scripts/apis/bt')
--os.loadAPI('cc-scripts/apis/turtletracker')


local tArgs = { ... }

if #tArgs ~= 3 then
  print("Usage: tower <length> <width> <height>")
  print("Example: tower 8 4 3")
  print("* Includes starting space.")
  print("* Turtle is at the bottom.")
  print("* Build forward and to the right.")
  print("* Representative building block in slot 1.")
  return
end

local lengthArg = tonumber( tArgs[1] )
local widthArg = tonumber( tArgs[2] )
local heightArg = tonumber( tArgs[3] )

function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

-- Build 1 layer of the tower.
function buildLayer()

  buildWall(lengthArg)

  turtle.turnRight()
  bt.forceForward()
  buildWall(widthArg-1)

  turtle.turnRight()
  bt.forceForward()
  buildWall(lengthArg-1)

  turtle.turnRight()
  bt.forceForward()
  buildWall(widthArg-2)
  bt.forceForward()

end

function buildWall(length)

  for i = 1, length do

    while not inv.selectSimilarBlock(1) do    
      ccstatus.report("Out of tower building blocks. Retrying in 10 secs...")
      sleep(10)
    end

    turtle.placeDown()
    if i ~= length then forceForward() end
  end

end

function buildTower()

  for i = 1, heightArg do
    
    -- Move up once to placeDown blocks
    bt.forceUp()
    
    -- Will placeDown block and move forward until AFTER the end of the wall.
    ccstatus.report("Building Tower layer "..i.."/"..heightArg)
    buildLayer()

    -- turn corner
    turtle.turnRight()
    
  end

  ccstatus.report("Tower complete!")

end

function main()
  if not bt.init() then return end

  parallel.waitForAny(buildTower, skip)
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end