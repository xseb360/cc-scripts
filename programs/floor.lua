-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

representativeBlockSlot = 1
firstInventorySlot = 3

if #tArgs ~= 2 then
  print("Usage: floor <length> <width>")
  print("* Floor starts under the turtle.")
  print("* Build forward and to the right.")
  print("* Representative building block in slot 1.")
  print("* Resupply Ender Chest in slot 2.")
  return
end

local length = tonumber( tArgs[1] )
local width  = tonumber( tArgs[2] )

function forward()
  while turtle.detect() do
    turtle.dig()
    sleep(0.5)
  end
  
  if not turtle.forward() then
    while not turtle.forward() do
      sleep(1)
    end
  end
end

-- Places a block from the provided slot beneath the turtle,
-- but only if the block beneath the turtle is different than
-- the block in slot 1 OR if the block below is empty (air or liquid).
function placeIfDifferent(slot)
  turtle.select(representativeBlockSlot)
  if not turtle.compareDown() then
    turtle.select(slot)
    turtle.placeDown()
  end
end

-- Find the first slot with the same block as
-- the one found in slot one, then place it under
-- the turtle. Always leaves at least one block in
-- slot 1.
--
-- Returns true if the turtle couple place a similar block,
-- returns false if there are no additional blocks identical
-- to the block in slot 1 to place.
function placeSimilarBlockFromInventoryUntilCompare()
  turtle.select(representativeBlockSlot)
  while not turtle.compareDown() do
    placeSimilarBlockFromInventory()
  end
end

function placeSimilarBlockFromInventory()
  turtle.select(representativeBlockSlot)

  while 1 do

  -- Place excess blocks from slot 1
    -- before using any other slots
    if turtle.getItemCount(representativeBlockSlot) > 1 then
      placeIfDifferent(representativeBlockSlot)
      return true
    end

    -- Attempt to find similar blocks in other slots
    for i = firstInventorySlot, 16 do
      if turtle.compareTo(i) then
        placeIfDifferent(i)
        return true
      end
    end
    
    -- If we've gotten this far, we're out of blocks to place
    ccstatus.report("Out of floor building blocks. Retrying in 10 secs...")
    sleep(10)
		
	--ResupplyFromEnderChest()
	  
  end -- while 1
  
  -- will never get here now. looping and waiting until new blocks are added to inventory.
  return false
end

function ResupplyFromEnderChest()

end

function placeRow(length)
  for i = 1, length do
    
    -- try to remove block under
    if turtle.detectDown() then turtle.digDown() end

    -- if block under was really removed (in case its bedrock, skip).
    if not turtle.detectDown() then placeSimilarBlockFromInventoryUntilCompare() end

    if i ~= length then forward() end
  end
end

function main()
  for currentWidth = 1, width do
    if currentWidth ~= 1 then
      if currentWidth % 2 == 0 then
        turtle.turnRight()
        forward()
        turtle.turnRight()
      else
        turtle.turnLeft()
        forward()
        turtle.turnLeft()
      end
    end
    
    ccstatus.report("Building floor row "..currentWidth.."/"..width)
    if placeRow(length) == false then
      ccstatus.report("Ran out of blocks to place!") --should never happen anymore...
    end
  end

  ccstatus.report("Floor complete!")
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end