os.loadAPI('cc-scripts/apis/ccstatus')


local tArgs = { ... }

if #tArgs ~= 1 then
  print("Usage: report <message>")
  return
end

ccstatus.report(tArgs[1])