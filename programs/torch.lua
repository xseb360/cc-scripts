local tArgs = { ... }
 
term.clear()
print("Enter far:")
vFar = tonumber(read())
vFarPos = 0
print("Enter width:")
vWidth = tonumber(read())
vWidthPos = 0
facing = 1
 
 
function forward()
  if not turtle.forward() then
    repeat
      turtle.dig()
      turtle.attack()
      sleep(0.6)
    until turtle.forward()
  end
  updatePos()
end
 
function placeTorch()
  if vFarPos % 5 == 0 and vWidthPos % 5 == 0 then
    loop = true
    while loop do
    torchSlot = findTorch()
      if torchSlot > 0 then
        turtle.select(torchSlot)
        turtle.placeDown()
        loop = false
      else
        print("Please add more torches.")
        print("Hit ENTER to continue.")
        read()
      end
    end
  end
end
 
 
function findTorch()
  for i=1, 16 do
    if turtle.getItemCount(i) > 0 then
      return i
    end
  end
  return 0
end
 
function updatePos()
-- 1-In front, 2-right, 3-back, 4-left
  modifFarPos   = {1,0,-1,0}
  modifWidthPos = {0,1,0,-1}
  vFarPos = vFarPos + modifFarPos[facing]
  vWidthPos = vWidthPos + modifWidthPos[facing]
  print("far ".. vFarPos.."Width"..vWidthPos)
end
 
function turnLeft()
  facing = facing - 2
  facing = facing % 4
  facing = facing + 1
  turtle.turnLeft()
end
 
function turnRight()
  facing = facing % 4
  facing = facing + 1
  turtle.turnRight()
end
 
function rotate()
  if vWidthPos % 2 == 0 then
    turnRight()
  else
    turnLeft()
  end
end
 
function rotateBack()
  if vWidthPos % 2 == 1 then
    turnRight()
  else
    turnLeft()
  end
end
 
function back()
  rotateBack()
  while vWidthPos > 0 do
    forward()
  end
  rotateBack()
  while vFarPos >  vFar-1 do
    forward()
  end
end
 
 
function main()
  turtle.up()
  placeTorch()
  for column=1, vWidth do
    for steps=1, vFar do
      forward()
      turtle.digDown()
      placeTorch()
    end
    rotate()
    forward()
    rotateBack()
    turtle.digDown()
    placeTorch()
  end
  back()
end
 
 
 
main()
