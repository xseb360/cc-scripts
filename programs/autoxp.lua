-- pastebin get 9p2GvMhu autoexec

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')


function main()
  
 	parallel.waitForAny(keepXPing, skip)

end

function keepXPing()

  m.setAutoCollect(true)
  print("Getting XP (press SPACE to stop)...")

  while true do
    attack()
    collectXP()  
    sleep(0.2)
  end

end

function attack()
	  if redstone.getInput("bottom") or redstone.getInput("top") or redstone.getInput("right") or redstone.getInput("left") then -- On
		  turtle.attack()
	  end
end

function collectXP()
  
--	if math.fmod(m.getLevels(), 5) == 0 then
    reportLevel()
--  end
end

function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function reportLevel()
  
  local currentLevel = m.getLevels()

  if currentLevel ~= lastReportLevel then
    ccstatus.report("Current Level: "..currentLevel)
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

