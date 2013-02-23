-- pastebin get 9p2GvMhu autoexec

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')
os.loadAPI('cc-scripts/apis/cctools')

debugMode = false
enchantedBookCount = 0

function main()
  
 	parallel.waitForAny(keepXPing, skip)

end

function keepXPing()

  m.setAutoCollect(true)
  print("Getting XP (press SPACE to stop)...")

  while true do
--    attack()
    collectXP()  
    sleep(10)
  end

end

function attack()
	  if redstone.getInput("bottom") or redstone.getInput("top") or redstone.getInput("right") or redstone.getInput("left") then -- On
		  turtle.attack()
	  end
end

function collectXP()
  
  local currentLevel = m.getLevels()

--	if math.fmod(m.getLevels(), 5) == 0 then
    reportLevel(currentLevel)
--  end


  if currentLevel >= 30 then
    enchant()
  end

end

function enchant()
  local enchantingSlot = 16

  cctools.debugPrint("emptyInv")
  emptyInv()

  cctools.debugPrint("getOneBook")
  getOneBook(enchantingSlot)
  
  cctools.debugPrint("enchantOneBook")
  enchantOneBook(enchantingSlot)
  
  cctools.debugPrint("dropEnchantedBook")
  dropEnchantedBook(enchantingSlot)

end

function emptyInv()
  inv.emptyAllInvDown()
end

function getOneBook(slot)
  
  turtle.select(slot)
  turtle.suckUp() -- get some book in slot 16

  inv.emptyUpButKeepSome(slot, 1) -- drop all but one
  
end

function enchantOneBook(slot)

  turtle.select(slot)
  m.enchant(30)

  enchantedBookCount = enchantedBookCount + 1

end

function dropEnchantedBook(slot)

  turtle.select(slot)
  turtle.dropDown()

end

function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function reportLevel(currentLevel)
  
  if currentLevel ~= lastReportLevel then
    ccstatus.report("Current Level: "..currentLevel.." ("..enchantedBookCount.." book(s) enchanted)")
    lastReportLevel = currentLevel
  end

end


print("Initializing XP Module...")
m = peripheral.wrap("right")
print("XP Module ready.")

lastReportLevel = 0

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end

