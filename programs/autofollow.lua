-- pastebin get Y31PTzSz autoexec

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

function main()
    ccstatus.report("Following...")
  	parallel.waitForAny(autoFollow, skip)
end


function autoFollow()
  while true do
    turtle.forward()
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
