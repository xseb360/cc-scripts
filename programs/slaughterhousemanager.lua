-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

function main()
 	parallel.waitForAny(keepSlaugthering, skip)
  ccstatus.report("Slaughtering done.")
end


function keepSlaugthering()
  ccstatus.report("Slaughtering...")

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
