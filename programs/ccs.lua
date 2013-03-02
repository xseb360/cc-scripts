-- Name: ccs
-- Source: /cc-scripts/programs/ccs.lua
-- A script to manage cc-script packages.

apis = {
  "betterapi",
  "bt",
  "cc_scripts",
  "ccstatus",
  "cctools",
  "direction",
  "events",
  "funct",
  "installer",
  "inv",
  "turtletracker"
}

programs = {
  "autocraft",
  "autofollow",
  "autofuel",
  "automon",
  "autoupdate",
  "autoxp",
  "aof",
  "b",
  "bore",
  "canne",
  "cannehole",
  "ccs",
  "ceiling",
  "d",
  "dig",
  "direction",
  "excavateakr",
  "excavateresume",
  "f",
  "fl",
  "floor",
  "gas",
  "gasstation",
  "l",
  "move",
  "position",
  "r",
  "room",
  "report",
  "sidewall",
  "shaft",
  "slaughterhousemanager",
  "startup",
  "test",
  "torch",
  "tower",
  "treefarm",
  "u",
  "wall"
}


cc_scripts.loadAPI("installer")
assert(installer, "Unable to load installer")

local tArgs = { ... }

if #tArgs == 0 then
  print("Usage: ccs <update|install|full> [[api|program] NAME]")
  print()
  print("Examples:")
  print("  Install and update all programs and apis from cc-scripts:")
  print("    ccs full [branch]")
  print()
  print("  Install all programs and apis from cc-scripts:")
  print("    ccs install")
  print()
  print("  Install a program from cc-scripts:")
  print("    ccs install program room")
  print()
  print("  Install an api from cc-scripts:")
  print("    ccs install api turtletracker")
  print()
  print("  Update all installed programs and apis:")
  print("    ccs update")
  print()
  print("  Update the 'room' program:")
  print("    ccs update program room")
  print()
  print("  Update the 'events' api:")
  print("    ccs update api events")
  print()
end


branch = "master"

-- Pull a script down from the cc-scripts repository and put it on the local computer.
function install(path, force)

  if not branch then branch = "master" end

  local url = "https://raw.github.com/xseb360/cc-scripts/"..branch.."/" .. path .. ".lua"
  local installPath = "/cc-scripts/" .. path
  return installer.install(url, installPath, force)
end

-- Update one or more named programs or apis
function update(updateArguments)
  local path = ""

  if updateArguments[1] == "api" then
    path = "apis/"
  elseif updateArguments[1] == "program" then
    path = "programs/"
  end

  -- Update each named api or program
  for i = 2, #updateArguments do
    install(path .. updateArguments[i], true)
    print("Updated " .. updateArguments[i])
  end
end

-- Update ALL apis, programs, and associated files
function updateAll()
  local apis = fs.list("/cc-scripts/apis")
  local programs = fs.list("/cc-scripts/programs")

  for _, api in ipairs(apis) do
    install("apis/" .. api, true)
  end

  for _, program in ipairs(programs) do
    install("programs/" .. program, true)
  end

  print("Updated all programs and apis")
end



function printFileList(path)
  local FileList = fs.list("/cc-scripts/programs") --Table with all the files and directories available
  local programList = ""

  for _, file in ipairs(FileList) do --Loop. Underscore because we don't use the key, ipairs so it's in order
    --print(file) --Print the file name
    programList = programList..""..file..", "
  end --End the loop

  print(programList)
end

function printInstalledFiles()
  print("Programs:")
  printFileList("/cc-scripts/programs")
  print("APIs:")
  printFileList("/cc-scripts/apis")
end

function installAll()
	  -- install everything
    

    -- Install all our APIs
    fs.makeDir("/cc-scripts/apis")
    for i = 1, #apis do
      install("apis/"..apis[i])
    end

    -- Install all of our programs
    fs.makeDir("/cc-scripts/programs")
    for i = 1, #programs do
      install("programs/"..programs[i])
    end

    printInstalledFiles()
end



-- ie: "update"
local subCommand = tArgs[1]

-- ie: "program", "room"
local subCommandArgs = {}

-- Stick all arguments after the first one into
-- the subCommandArgs table.
if #tArgs > 1 then
  for i = 2, #tArgs do
    table.insert(subCommandArgs, tArgs[i])
  end
end

function cleanAllObsoletePrograms()
  cleanObsoleteProgram("/cc-scripts/programs/craft")
  cleanObsoleteProgram("/cc-scripts/programs/tunnel")
end

function cleanObsoleteProgram(fileName)
  if fs.exists(fileName) then
    fs.delete(fileName)
  end
end







-- "css update ..."

cleanAllObsoletePrograms()

if subCommand == "update" then
  if #tArgs == 1 then
    updateAll()
  else
    update(subCommandArgs)
  end
elseif subCommand == "full" then
  if #tArgs > 2 then
    print("Subcommand [full] cannot take more than 1 argument.")
    print("    ccs full [branch]")
  else
    
    if #tArgs > 1 then
      branch = subCommandArgs[1]
    end
    
    installAll()
    updateAll()    
  end
elseif subCommand == "install" then
  if #subCommandArgs > 2 then
    print("You may only install one item at a time.")
    return
  end    
  local path = ""
  if #subCommandArgs == 0 then
    installAll()
	  return
  elseif subCommandArgs[1] == "api" then
    path = "apis/"
  elseif subCommandArgs[1] == "program" then
    path = "programs/"
  else
    print("Invalid subcommand '" .. subCommandArgs[1] .. "'")
    print("Valid subcommands are 'install' and 'update'")
    return
  end

  if install(path .. subCommandArgs[2]) then
    print("Successfully installed " .. subCommandArgs[2] .. " " .. subCommandArgs[1])
  else
    print(subCommandArgs[2] .. " " .. subCommandArgs[1] .. " is already installed!")
    print("Try running: ccs update " .. subCommandArgs[1] .. " " .. subCommandArgs[2])
  end
end



-- update startup
local hadStartup = fs.exists("/startup")
-- Clobber any previous startup script
if hadStartup then
  fs.delete("/startup")
end
fs.copy("/cc-scripts/programs/startup", "/startup")
