extends Node

@export var mob_scene: PackedScene
@export var tower_scene: PackedScene
var score
var wave
var enemycount
var screensize
var money
# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = $Player.get_viewport_rect().size / 2
	new_game()

func game_over():
	#$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	wave = 0
	enemycount = 0
	score = 0
	money = 100
	$Player.start(screensize / 2)
	$Base.start(screensize - Vector2(10, 90))
	$StartTimer.start()
	
func _process(delta: float) -> void:
	$CanvasLayer/HealthBar.value = $Base.health
	$CanvasLayer/Money.text = str(money) + " $"
	if Input.is_action_pressed("start_wave"):
		if enemycount <= 0:
			wave += 1
			$CanvasLayer/WaveCounter.text = str(wave)
			
			enemycount = wave * 5
			$MobTimer.start()
	if Input.is_action_pressed("build_basic_tower"):
		#TODO check for money/score if can even build it
		build_tower()
	

func _on_mob_timer_timeout():
	if enemycount == 0:
		$MobTimer.stop()
		money += 100 + wave * 10
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	

	var midpos = screensize - Vector2(10, 90)

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	var direction = (midpos - mob.position).normalized()
	
	mob.enemyclass = mob.enemyArray.pick_random()
	if enemycount == 1:
		mob.enemyclass = "boss"
	# Choose the velocity for the mob.
	var speed
	match mob.enemyclass:
		"basic":
			speed = 150
		"tank":
			speed = 100
		"speedy":
			speed = 200
		"boss":
			speed = 80
			
	var velocity = direction * speed
	mob.linear_velocity = velocity

	
	# Spawn the mob by adding it to the Main scene.
	enemycount -= 1
	add_child(mob)
	
func _on_score_timer_timeout():
	score += 1

func _on_start_timer_timeout():
	wave = 1
	enemycount = wave * 5
	score = 0;
	$MobTimer.start()
	$ScoreTimer.start()

func is_object_near_position(target_position: Vector2, radius: float, objects: Array) -> bool:
	for obj in objects:
		if obj.position.distance_to(target_position) <= radius:
			return true
	return false


func build_tower():
	if money < 100:
		return
	
	if is_object_near_position($Player.position, 100, get_tree().get_nodes_in_group("Tower")):
		return
	money -= 100
	var tower = tower_scene.instantiate()
	print($Player.position)
	tower.position = $Player.position
	add_child(tower)
	
