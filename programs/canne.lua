-- plant a 21 * 21 field


slot = 1

function plantcanne()
	
	while turtle.getItemCount(slot) == 0 do
		slot = slot + 1
	end
	
	turtle.select(slot)
	turtle.placeDown()
end


function move(x)
  for i=1, x do
    turtle.forward()
	plantcanne()
  end
end

function plantall()
	turtle.up()
	plantcanne()
	for j=1,10 do
		move(20)
		turtle.turnRight()
		move(1)
		turtle.turnRight()
		move(20)
		turtle.turnLeft()
		move(1)
		turtle.turnLeft()
	end
	move(20)
end

plantall()	