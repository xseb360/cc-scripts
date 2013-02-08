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
    sleep(0.2)
  end

end