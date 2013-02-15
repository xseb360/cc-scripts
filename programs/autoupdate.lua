-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }

function main()
  	parallel.waitForAny(autoUpdate, skip)
end


function autoUpdate()
  print("Auto Update [Press SPACE to skip] 3...")
  sleep(1)
  print("Auto Update [Press SPACE to skip] 2...")
  sleep(1)
  print("Auto Update [Press SPACE to skip] 1...")
  sleep(1)
  print("Updating...")

  loadstring(http.get("https://raw.github.com/xseb360/cc-scripts/master/programs/ccs.lua").readAll())("full")
  
  ccstatus.report("Up to date.")

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
