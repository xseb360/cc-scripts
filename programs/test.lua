


function install(path)
  local installPath = path
  local updated = fs.exists(installPath)

  print("Downloading " .. path .. " ...")
  local conn = http.get("http://casper3.dyndns.org:8008/cctest.lua")
  local file = fs.open(installPath, "w")

  assert(conn, "Unable to download " .. path .. " - aborting!")
  assert(file, "Unable to save " .. path .. " to " .. installPath .. " - aborting!")

  file.write(conn.readAll())

  file.close()
  conn.close()

  if updated then
    print("Updated " .. path)
  else
    print("Installed " .. path)
  end
end


install("cctest")
os.loadAPI("cctest")
cctest.test()