

function report(s)

  s = string.gsub(s, " ", "+")

  local conn = http.get("http://casper3.dyndns.org:8008/ccstatus/report.aspx?name="..os.getComputerLabel().."&status=(FL"..turtle.getFuelLevel()..")+"..s)
  conn.readAll()
  conn.close()

end