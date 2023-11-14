extends CharacterBody2D

const size_adjust = 20


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if position.y > 691:
		queue_free()
	if collision:
		if collision.get_collider().is_in_group("Paddle"):
			bounce(collision, true)
			velocity.x += collision.get_collider_velocity().x
		if collision.get_collider().is_in_group("Wall"):
			velocity.x *= -1
		if collision.get_collider().is_in_group("Roof"):
			velocity.y *= -1
		if collision.get_collider().is_in_group("Brick"):
			bounce(collision, false)
			collision.get_collider().hit()
		velocity.x = clamp(velocity.x, -400, 400)
		velocity.y = clamp(velocity.y, -400, 400)	

func bounce(collision, paddle):
	var diffX
	var diffY 
	if paddle:
		diffX = snappedf(abs((global_position.x + 10) - (collision.get_collider().position.x + 50)), 1)
		diffY = snappedf(abs((global_position.y + 10) - (collision.get_collider().position.y + 15)), 1)
	else:
		diffX = snappedf(abs((global_position.x + 10) - (collision.get_collider().position.x + 20)), 1)
		diffY = snappedf(abs((global_position.y + 10) - (collision.get_collider().position.y + 10)), 1)
	#if the diff between both is a combination of the height (or width) of both objects:
	#that's the axis we've collided and need to flip
	if diffX == 30 or diffX == 60:
			velocity.x *= -1
	if diffY == 20 or diffY == 25:
			velocity.y *= -1
