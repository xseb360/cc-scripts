-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

function main()
  print("Usage: gas [fueler] [maxFuel]")
  print(" fueler starts fuel maker mode")
  print(" No arg starts fuel taker mode. Stops at 150k fuel or [maxFuel]K.")
  print("")
  print(" Top chest has empty buckets")
  print(" Bottom chest has full buckets")
  print("")
  print(" Press space to stop at any time...")

  if #tArgs == 1 and tArgs[1] == "fueler" then
  	parallel.waitForAny(keepMakingFuel, skip)
  else
    if #tArgs == 1 then
      paramMaxFuel = tArgs[1]
    else
      paramMaxFuel = 150
    end

  	parallel.waitForAny(keepTakingFuel, skip)

  end

  print("done")
end


function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function keepMakingFuel()
  print("Making fuel...")

  emptyInvDown()

  while 1 do 
    makeFuelOnce() 
  end

end

function makeFuelOnce()

  turtle.select(1)

  if turtle.getItemCount(1) > 0 then emptyInvDown() end

  if turtle.suckUp() then -- there's empty buckets
    fillInternalTank() -- suck until internaltank has 10k
    packAll() -- pack until slot 1 has only 1 item (unstacking bucket stacks)
    emptyInvDown() -- empty everything below
  end

end

function fillInternalTank()
  local m = peripheral.wrap("right")
  local waitingTime = 0.1
  local maxWaitingTime = 6.4

  repeat
    m.suck()
    liquidId, liquidAmount = m.getLiquid()
    waitingTime = waitExponentiallyLonger(waitingTime, maxWaitingTime, "liquid refill")
  until liquidAmount == 10000


end

function packAll()

  local m = peripheral.wrap("right")

  if not m.pack() then return false end

  while turtle.getItemCount(1) > 1 do
    m.suck() --try getting one more squeeze...
    if not m.pack() then return false end
  end

  return true
end

function emptyInvDown()
  local maxWaitingTime = 6.4


  for i=1,16 do
    turtle.select(i)
    local waitingTime = 0.1

    while turtle.getItemCount(i) > 0 do 
      waitingTime = waitExponentiallyLonger(waitingTime, maxWaitingTime, "inv dump")
      turtle.dropDown() 
    end
  end
end


function debugPrint(s)
  local debugMode = true

  if debugMode then print(s) end
end

function waitExponentiallyLonger(waitingTime, maxWaitingTime, waitForDesc)

    if waitingTime > 0.1 then 
      debugPrint("waiting for "..waitForDesc..": "..waitingTime.."s...")
      sleep(waitingTime)
    end

    waitingTime = waitingTime * 2
    if waitingTime > maxWaitingTime then waitingTime = maxWaitingTime end
    
  return waitingTime
end

function keepTakingFuel()
  local waitingTime = 0.1
  local maxWaitingTime = 6.4

  print("Taking fuel...")

  while 1 do 
    if takeFuelOnce() then 
      waitingTime = 0.1
    else
      waitingTime = waitExponentiallyLonger(waitingTime, maxWaitingTime, "full buckets")
    end

    if turtle.getFuelLevel() > paramMaxFuel * 1000 then
      ccstatus.report("Fueled up!")
      return
    end

  end

end

function takeFuelOnce()

  turtle.select(1)

  if turtle.suckDown() then
    turtle.refuel()
    turtle.dropUp()
  else
    return false
  end

  print(turtle.getFuelLevel())

  return true
  
end



local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end

