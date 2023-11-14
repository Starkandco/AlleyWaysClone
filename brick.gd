extends StaticBody2D

var health
signal scored
var Mat

@export var bonus_scene: PackedScene

func _ready():
	update_colour()

func hit():
	health -= 1
	if health == 0:
		queue_free()
		scored.emit()
		drop_bonus()
	else:
		update_colour()

func update_colour():
	Mat = $ColorRect.get_material()
	self.material = Mat.duplicate()
	Mat.set_shader_parameter("health", float(health))

func drop_bonus():
	var objects_collide = [] #The colliding objects go here.
	while $RayCast2D.is_colliding():
		var obj = $RayCast2D.get_collider() #get the next object that is colliding.
		objects_collide.append( obj ) #add it to the array.
		$RayCast2D.add_exception( obj ) #add to ray's exception. That way it could detect something being behind it.
		$RayCast2D.force_raycast_update() #update the ray's collision query.
	var bonus = bonus_scene.instantiate() 
	if objects_collide.size() > 0:
		bonus.global_position = objects_collide[objects_collide.size() - 1].global_position
		bonus.position.y += 20
	else:
		bonus.global_position = global_position
		bonus.position.y += 20
	get_parent().add_child(bonus)
	var balls = get_tree().get_nodes_in_group("Ball")
	for b in balls:
		bonus.add_collision_exception_with(b)
