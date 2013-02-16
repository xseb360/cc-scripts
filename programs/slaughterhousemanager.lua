-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

local tArgs = { ... }


function main()
 	parallel.waitForAny(keepSlaugthering, skip)
  ccstatus.report("Slaughtering done.")
end


function keepSlaugthering()
  ccstatus.report("Slaughtering...")
 
  while 1 do
    slaugtherOnce()
    longSleep(20 * 60)
  end

end

function longSleep(sleepTime)

  local totalElapse = 0;

  while totalElapse < sleepTime do
  
    local sleepSegment = 60
    if sleepSegment + totalElapse > sleepTime then
      sleepSegment = sleepTime - totalElapse
    end

    sleep(sleepSegment)

    totalElapse = totalElapse + sleepSegment

    ccstatus.report("Slept "..totalElapse.."/"..sleepTime.."secs.")

  end

end

function slaugtherOnce()
  
  ccstatus.report("Slaughtering...")

  purge()
  sleep(3)
  resupply()

end

function purge()

  closeTop()
  openBottom()

  sleep(5)

  closeBottom()

end

function resupply()

  closeBottom()
  openTop()

  sleep(5)

  closeTop()

end

function openTop()
  redstone.setOutput("top", false)
end

function closeTop()
  redstone.setOutput("top", true)
end

function openBottom()
  redstone.setOutput("bottom", false)
end

function closeBottom()
  redstone.setOutput("bottom", true)
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
