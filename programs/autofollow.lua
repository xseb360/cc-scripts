-- pastebin get Y31PTzSz autoexec

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

moveCount = 0

function main()
    ccstatus.report("Following...")
  	parallel.waitForAny(autoFollow, skip)
end


function autoFollow()
  while true do
    
    if turtle.forward() then
      moveCount = moveCount + 1

    if math.fmod(moveCount, 10) == 0 then 
      ccstatus.report("Followed for "..moveCount.." meters...")
    end

    sleep(1)
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


local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end
