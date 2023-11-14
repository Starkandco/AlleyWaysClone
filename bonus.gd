extends CharacterBody2D

func _ready():
	velocity.y = 100
	for c in get_parent().get_children():
		if !c.is_in_group("Paddle"):
			add_collision_exception_with(c)
			c.add_collision_exception_with(self)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("Paddle"):
			queue_free()
			get_parent().get_parent().on_bonus_caught()
