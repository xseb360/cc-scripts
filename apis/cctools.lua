-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')
os.loadAPI('cc-scripts/apis/inv')

function debugPrint(s)
  if debugMode then print(s) end
end

function waitExponentiallyLonger(waitingTime, maxWaitingTime, waitForDesc)

    if waitingTime > 0.1 then 
      debugPrint("waiting for "..waitForDesc..": "..waitingTime.."s...")
      sleep(waitingTime)
    end

    waitingTime = waitingTime * 2
    if waitingTime > maxWaitingTime then waitingTime = maxWaitingTime end
    
  return waitingTime
end
