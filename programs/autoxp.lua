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
   sleep(0.2)
	  if redstone.getInput("bottom") or redstone.getInput("top") or redstone.getInput("right") or redstone.getInput("left") then -- On
		  turtle.attack()
	  end
  
	  if math.fmod(m.getLevels(), 5) == 0 then
      reportLevel()
    end

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

function reportLevel()
  ccstatus.report("Current Level: "..m.getLevels())
end


print("Initializing XP Module...")
m = peripheral.wrap("right")
print("XP Module ready.")

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end

