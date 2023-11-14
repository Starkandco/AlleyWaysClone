extends CharacterBody2D

func _ready():
	velocity.y = 100

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
		get_parent().get_parent().on_bonus_caught()
