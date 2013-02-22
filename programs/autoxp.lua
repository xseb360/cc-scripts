-- pastebin get 9p2GvMhu autoexec

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

print("Initializing XP Module...")

m = peripheral.wrap("right")
m.setAutoCollect(true)

print("Getting XP...")

while true do
 sleep(0.2)
	if redstone.getInput("bottom") or redstone.getInput("top") or redstone.getInput("right") or redstone.getInput("left") then -- On
		turtle.attack()
	end
  
	if math.fmod(m.getLevels(), 5) == 0 then
    reportLevel()
  end

end


function reportLevel()

  ccstatus.report("Current Level: "..m.getLevels())

end