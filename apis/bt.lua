-- Better Turtle


function forceForward()
  
  while not turtle.forward() do
    turtle.dig()
    sleep(0.2)
  end

end

function digUpUntilClear()

  while turtle.detectUp() do
    turtle.digUp()
    sleep(0.5)
  end

end

function forceUp()

  while not turtle.up() then
  
    digUpUntilClear()

    if turtle.up() then return true end
    
    for i=1,5 do -- attack for a while, but maybe the gravel just got here, so we break and retry digging up
      turtle.attackUp()
    end

  end

  return true

end