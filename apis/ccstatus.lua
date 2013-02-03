

function report(s)

  local conn = http.get("http://casper3.dyndns.org:8008/ccstatus/report.aspx?name="..os.getComputerLabel().."&status="..s)
  conn.readAll()
  conn.close()

end