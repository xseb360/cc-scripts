-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')
os.loadAPI('cc-scripts/apis/bt')


local tArgs = { ... }

if #tArgs ~= 2 then
  print("Usage: ceiling <length> <width>")
  print("Example: ceiling 8 4")
  print("* Includes starting space.")
  print("* Turtle is under the ceiling.")
  print("* Build forward and to the right.")
  print("* Representative building block in slot 1.")
  return
end

local lengthArg = tonumber( tArgs[1] )
local widthArg = tonumber( tArgs[2] )

function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function buildRow(length)

  for i = 1, length do

    bt.digUpUntilClear()

    while not inv.selectSimilarBlock(1) do    
      ccstatus.report("Out of tower building blocks. Retrying in 10 secs...")
      sleep(10)
    end

    turtle.placeUp()
        
    if i ~= length then 
      bt.forceForward() 
    end

  end

end

function buildCeiling()

  for i = 1, widthArg do
    
    ccstatus.report("Building ceiling row "..i.."/"..widthArg)
    
    buildRow(lengthArg)


    -- change to the next row unless it's the last one
    if i ~= widthArg then
      turtle.turnRight()
      bt.forceForward()
      turtle.turnRight()
    end
    
  end

  ccstatus.report("Tower complete!")

end

function main()
  if not bt.init() then return end

  parallel.waitForAny(buildCeiling, skip)
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end