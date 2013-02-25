-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

if #tArgs ~= 1 then
  print("Usage: craft <recipe>")
  print("Example: craft coaldust")
  print("Known Recipes:")
  print("* coaldust")
  print("* steeldust")
  return
end

local recipeArg = tArgs[1]


function emptySlot(slotToEmpty, firstInv, lastInv, maxStack)
  selectSlotWithSpace(firstInv, lastInv, maxStack)
  while m.suck(slotToEmpty, 1) do
    selectSlotWithSpace(firstInv, lastInv, maxStack)
  end
end

function craftCoalDustOnce(firstCoalInvSlot, lastCoalInvSlot)

  emptySlot(0, firstCoalInvSlot, lastCoalInvSlot, 64)
  emptySlot(1, firstCoalInvSlot, lastCoalInvSlot, 64)
  emptySlot(2, firstCoalInvSlot, lastCoalInvSlot, 64)
  emptySlot(3, firstCoalInvSlot, lastCoalInvSlot, 64)
    
  selectItem(4, firstCoalInvSlot, lastCoalInvSlot)
  
  m.drop(0, 1)
  m.drop(1, 1)
  m.drop(2, 1)
  m.drop(3, 1)
end

function craftSteelDustOnce(firstIronInvSlot, lastIronInvSlot, firstGraphiteInvSlot, lastGraphiteInvSlot)
  emptySlot(0, firstIronInvSlot, lastIronInvSlot, 64)
  emptySlot(1, firstIronInvSlot, lastIronInvSlot, 64)
  emptySlot(2, firstIronInvSlot, lastIronInvSlot, 64)
  emptySlot(3, firstGraphiteInvSlot, lastGraphiteInvSlot, 64)
    
  selectItem(3, firstIronInvSlot, lastIronInvSlot)
  m.drop(0, 1)
  m.drop(1, 1)
  m.drop(2, 1)

  selectItem(1, firstGraphiteInvSlot, lastGraphiteInvSlot)
  m.drop(3, 1)
end


function trySelect(slot, minCount)
  if turtle.getItemCount(slot) >= minCount then
    turtle.select(slot)
    return true
  end

  return false
end

function selectItem(minCount, firstInv, lastInv)
  local slot = firstInv

  while not trySelect(slot, minCount) do
    slot = slot + 1
    if slot > lastInv then
      slot = firstInv
    end
    sleep(0.1)
  end

end


function trySelectSlotWithSpace(slot, maxStack)
  if turtle.getItemCount(slot) < maxStack then
    turtle.select(slot)
    return true
  end

  return false
end

function selectSlotWithSpace(firstInv, lastInv, maxStack)
  slot = firstInv

  while not trySelectSlotWithSpace(slot, maxStack) do
    slot = slot + 1
    if slot > lastInv then
      slot = firstInv
    end
    sleep(0.1)
  end
end


function craftCoal()
  print("Crafting coal dust... [press space to stop]")
  turtle.select(1)

  while true do
    craftCoalDustOnce(1, 16)
    sleep(0.2)
  end
end




function craftStealDust()
  print("Crafting steel dust... [press space to stop]")

  firstIronInvSlot = 1
  lastIronInvSlot = 12
  firstGraphiteInvSlot = 13
  lastGraphiteInvSlot = 16

  print("Iron Slots: "..firstIronInvSlot.."-"..lastIronInvSlot)
  print("Graphite Slots: "..firstGraphiteInvSlot.."-"..lastGraphiteInvSlot)

  while true do
    craftSteelDustOnce(firstIronInvSlot, lastIronInvSlot, firstGraphiteInvSlot, lastGraphiteInvSlot)
    sleep(0.2)
  end


end



function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end



function main()

  m = peripheral.wrap("right")

  if not m or not m.drop then
    print("Requires inventory turtle.")
    return
  end

  if recipeArg == "coaldust" then
    parallel.waitForAny(craftCoal, skip)
  elseif recipeArg == "steelDust" then
    parallel.waitForAny(craftStealDust, skip)
  else
    print("Unknown recipe: "..recipeArg)
  end

end


local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end