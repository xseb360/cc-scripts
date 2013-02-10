

function report(s)

  print(s)

  s = string.gsub(s, " ", "+")

  local fuelLevel = (tonumber(turtle.getFuelLevel()) / 1000).."k";
  if tonumber(turtle.getFuelLevel()) < 10000 then fuelLevel = "!"..fuelLevel end

  local conn = http.get("http://casper3.dyndns.org:8008/ccstatus/report.aspx?name="..os.getComputerLabel().."&status=("..fuelLevel..")+"..s)
  
  if conn then
    conn.readAll()
    conn.close()
  end

end