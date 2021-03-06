-- Better Turtle


function init()
  print("Better Turtle API Ready.")
  return true
end

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

function digUntilClear()

  while turtle.detect() do
    turtle.dig()
    sleep(0.5)
  end

end


function forceUp()

  while not turtle.up() do
  
    digUpUntilClear()

    if turtle.up() then return true end
    sleep(0.5)
    
    for i=1,5 do -- attack for a while, but maybe the gravel just got here, so we break and retry digging up
      turtle.attackUp()
    end

  end

  return true

end