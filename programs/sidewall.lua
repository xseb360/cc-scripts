-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')
os.loadAPI('cc-scripts/apis/bt')


local tArgs = {...}

function sidewallOne()


  turtle.turnRight()

  bt.digUntilClear()

  while not inv.selectSimilarBlock(1) do    
    ccstatus.report("Out of sidewall building blocks. Retrying in 10 secs...")
    sleep(10)
  end
  
  turtle.place()

  turtle.turnLeft()
end


function main()

  if #tArgs ~= 1 then
    print("Usage: sidewall <length>")
    print("  sidewall is on turtle's right.")
    print("* Representative building block in slot 1.")
    return
  end

  local length = tonumber( tArgs[1] )

  ccstatus.report("Building sidewall "..length.." meters long...")

  for i=1,length do
    sidewallOne()

    if i ~= length then
      bt.forceForward()
    end

  end

  ccstatus.report("sidewall complete!")
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end


