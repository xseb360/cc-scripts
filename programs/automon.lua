
-- 

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')


function monitorOnce()
  m = peripheral.wrap("left")
  m.clear()
 	m.setCursorPos(1,1)
  m.setTextScale(2)
  m.setTextColor(colors.yellow)



  if redstone.getInput("back") then
   	m.write("* * * OUT OF LAVA * * *")
    report("Out of Lava")
  else
 	  m.write("Monitoring...")
    report("Monitoring...")
  end
end

function keepMonitoring()

  report("Monitoring...")

  while true do
    monitorOnce()
    sleep(30)
  end
end

function main()
  
 	parallel.waitForAny(keepMonitoring, skip)

end



function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function report(s)
  ccstatus.report(s)
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end

