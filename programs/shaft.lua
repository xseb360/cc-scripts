-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')
os.loadAPI('cc-scripts/apis/bt')


local tArgs = {...}

function shaftOne()

  bt.forceForward()
  bt.digUpUntilClear()
  turtle.digDown()

  inv.waitForSelectSimilarBlock(1, "floor block")
  turtle.placeDown()

end

function torchOne()
  turtle.turnRight()
  turtle.turnRight()

  inv.waitForSelectSimilarBlock(2, "torch")

  turtle.place()

  turtle.turnRight()
  turtle.turnRight()
end

function main()

  if #tArgs ~= 1 then
    print("Usage: shaft <length>")
    print("  Shaft begins in front of turtle.")
    print("  2 high. Replace floor. Torch every 5.")
    print("  Slots: Cobble, torch")
    return
  end

  local length = tonumber( tArgs[1] )

  ccstatus.report("Digging shaft "..length.." meters long...")

  for i=1,length do

    shaftOne()

    if math.fmod(i, 5) == 0 then
      torchOne()
    end

  end

  ccstatus.report("Shaft complete!")
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end


