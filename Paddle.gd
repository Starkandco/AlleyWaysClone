extends CharacterBody2D

var size = 100
var speed = 600.0
var direction = Vector2.ZERO
var paddle_size_x = 100

func _physics_process(delta):
	var collision = move_and_collide(speed * direction * delta)
	if collision:
		if collision.get_collider().is_in_group("Bonus"):
			collision.get_collider().queue_free()
			get_parent().get_parent().on_bonus_caught()
	global_position.y = clamp(global_position.y, 670, 670)

func _input(event):
	if Input.is_action_pressed("left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO

