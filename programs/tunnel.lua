-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')
os.loadAPI('cc-scripts/apis/bt')


local tArgs = {...}

function tunnelOne()

  bt.forceForward()
  bt.digUpUntilClear()
  turtle.digDown()

end


function main()

  if #tArgs ~= 1 then
    print("Usage: tunnel <length>")
    print("  tunnel begins in front of turtle.")
    print("  3 high. 1 up, 1 down, turtle in the middle.")
    return
  end

  local length = tonumber( tArgs[1] )

  ccstatus.report("Digging tunnel "..length.." meters long...")

  for i=1,length do
    tunnelOne()
  end

  ccstatus.report("tunnel complete!")
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end


