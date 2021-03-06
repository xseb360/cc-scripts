

function report(s)

  print(s)

  s = string.gsub(s, " ", "+")

  statusToReport = "none"

  if turtle then
    local fuelLevel = math.floor(turtle.getFuelLevel() / 1000).."k";
    
    if tonumber(turtle.getFuelLevel()) < 10000 then fuelLevel = "!"..fuelLevel end

    statusToReport = "("..fuelLevel..")+"..s
  else
    statusToReport = s
  end

  local conn = http.get("http://casper3.duckdns.org:8008/ccstatus/report.aspx?name="..os.getComputerLabel().."&status="..statusToReport)
  
  if conn then
    conn.readAll()
    conn.close()
  end

end
