-- pastebin get 9p2GvMhu autoexec


local m = peripheral.wrap("right")
m.setAutoCollect(true)

while true do
 sleep(0.2)
	if redstone.getInput("bottom") or redstone.getInput("top") or redstone.getInput("right") or redstone.getInput("left") then -- On
		turtle.attack()
	end
end