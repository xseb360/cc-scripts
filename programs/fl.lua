

local tArgs = { ... }



if #tArgs == 1 and tArgs[1] == "xp" then

  m = peripheral.wrap("right")
  print("Current Level: "..m.getLevels())

else

  if turtle then
    turtleLabel = os.getComputerLabel()
    turtleFuel = turtle.getFuelLevel()
    print(turtleLabel.." fuel level is : "..turtleFuel)
  end

end