extends Node2D

@export var brick_scene: PackedScene

var multiplier = 1
var score = 0

var lives = 3

var level = 1
var levelLoaded
var levelOne = [[0,0,0,0,0,1,0,0,0,0,0,0]]
var levelTwo = [[0,0,0,0,0,1,1,0,0,0,0,0],[0,0,2,3,4,5,5,4,3,2,0,0],[0,0,1,1,1,1,1,1,1,1,0,0]]
var levelThree = [[0,0,0,0,0,1,1,0,0,0,0,0],[0,0,6,7,8,9,9,8,7,6,0,0],[0,0,5,5,5,5,5,5,5,5,0,0]]
var levelFour = [[0,0,0,0,0,0,0,0,0,0,0,0],[0,1,1,1,0,0,0,0,1,1,1,0],[0,1,20,1,0,0,0,0,1,20,1,0],[0,1,1,1,0,0,0,0,1,1,1,0],[1,1,1,1,1,1,1,1,1,1,1,1],[1,1,10,1,1,1,1,1,1,10,1,1],[1,1,10,1,1,1,1,1,1,10,1,1],[1,1,1,1,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1,1,1],[0,1,1,1,1,30,30,1,1,1,1,0],[0,1,1,1,1,30,30,1,1,1,1,0],[0,0,0,1,1,1,1,1,1,0,0,0],[0,0,0,0,1,1,1,1,0,0,0,0]]
var levels = {1:levelFour,2:levelTwo,3:levelThree}

var ball

const TWOMULTIPLIER = 0
const FOURMULTIPLIER = 1
const BALLMULTIPLIER = 2
const EXTRALIVES = 3
const BIGGERPADDLE = 4
var bonuses = [TWOMULTIPLIER, FOURMULTIPLIER, BALLMULTIPLIER, EXTRALIVES, BIGGERPADDLE]

@export var ball_scene: PackedScene

func _ready():
	$UI/ColorRect/Score.text = str(0)
	load_level()

func _input(event):
	var balls = get_tree().get_nodes_in_group("Ball")
	if balls:
		if Input.is_action_just_pressed("space") and balls[0].process_mode == 4:
			ball.velocity.x += $Elements/Paddle.direction.x * $Elements/Paddle.speed
			ball.velocity.y = -300
			ball.process_mode = 0
	else:
		if Input.is_action_just_pressed("space"):
			no_ball(true)

func _process(delta):
	if is_instance_valid(ball):
		if ball.process_mode == 4:
			ball.position = $Elements/Paddle/Marker2D.global_position

func no_ball(liveLost):
	ball = ball_scene.instantiate()
	ball.position = $Elements/Paddle/Marker2D.global_position
	ball.process_mode = 4
	$Elements.add_child.call_deferred(ball)
	if liveLost:
		lives -= 1
	$UI/ColorRect/Lives.text = "Lives: " + str(lives)
	var run_bonuses = get_tree().get_nodes_in_group("Bonus")
	for b in run_bonuses:
		ball.add_collision_exception_with(b)
	
func load_level():
	for e in $Elements.get_children():
		if !e.is_in_group("Paddle"):
			e.call_deferred("queue_free")
	$UI/ColorRect/Level.text = "Level " + str(level)
	var pos = 0
	for row in (levels[level]):
		for cell in row:
			if cell == 0:
				pass
			else:
				var brick = brick_scene.instantiate()
				brick.health = cell
				brick.position.x = (pos % 12) * 40
				brick.position.y = (pos / 12) * 20
				brick.scored.connect(on_scored)
				$Elements.add_child(brick)
			pos += 1
	level += 1
	no_ball(false)

func on_scored():
	score += 100 * multiplier
	var count = 0
	for c in $Elements.get_children():
		if c.is_in_group("Brick"):
			count += 1
	if count == 1:
		load_level()
		ball.position = $Elements/Paddle/Marker2D.global_position
		ball.process_mode = 4
	$UI/ColorRect/Score.text = str(score)

func set_new_timer(waitTime, method):
	var newT = Timer.new()
	newT.wait_time = waitTime
	newT.timeout.connect(method)
	add_child(newT)
	newT.one_shot = true
	newT.start()

func on_bonus_caught():
	match randi_range(0, bonuses.size() + 1):
		TWOMULTIPLIER:
			if multiplier <= 2:
				multiplier = 2
				$UI/ColorRect/Multiplier.text = "x2"
				set_new_timer(20, clear_multi_bonus)
		FOURMULTIPLIER:
			multiplier = 4			
			$UI/ColorRect/Multiplier.text = "x4"
			set_new_timer(20, clear_multi_bonus)
		BALLMULTIPLIER:
			var balls = get_tree().get_nodes_in_group("Ball")
			if balls[0].process_mode == 0:
				var run_bonuses = get_tree().get_nodes_in_group("Bonus")
				for b in balls:
					var newBall = b.duplicate()
					newBall.global_position.x += 15
					newBall.velocity = b.velocity
					call_deferred("add_child", newBall)
		EXTRALIVES:
			lives += 1
			$UI/ColorRect/Lives.text = "Lives: " + str(lives)
		BIGGERPADDLE:
			if !$Elements/Paddle.is_in_group("Enlargened"):
				$Elements/Paddle.scale.x *= 2
				$Elements/Paddle.add_to_group("Enlargened")
				set_new_timer(20, clear_bigger_size)

func clear_multi_bonus():
	multiplier = 1
	$UI/ColorRect/Multiplier.text = ""

func clear_bigger_size():
	if $Elements/Paddle.is_in_group("Enlargened"):
		$Elements/Paddle.scale.x /= 2
		$Elements/Paddle.remove_from_group("Enlargened")
