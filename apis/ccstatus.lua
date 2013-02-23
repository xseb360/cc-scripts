

function report(s)

  print(s)

  s = string.gsub(s, " ", "+")

  status = ""

  if turtle then
    local fuelLevel = math.floor(turtle.getFuelLevel() / 1000).."k";
    
    if tonumber(turtle.getFuelLevel()) < 10000 then fuelLevel = "!"..fuelLevel end

    status = "("..fuelLevel..")+"..s
  else
    status = s
  end

  local conn = http.get("http://casper3.dyndns.org:8008/ccstatus/report.aspx?name="..os.getComputerLabel().."&status="..status)
  
  if conn then
    conn.readAll()
    conn.close()
  end

end