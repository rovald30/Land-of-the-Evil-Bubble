extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func game_over():
	#$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Base.start($StartPosition.position)
	$StartTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	var midpos = $Midpos.position

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	var direction = (midpos - mob.position).normalized()

	# Choose the velocity for the mob.
	var speed = randf_range(150.0, 250.0)
	var velocity = direction * speed
	mob.linear_velocity = velocity

	mob.enemyclass = "basic"

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
func _on_score_timer_timeout():
	score += 1

func _on_start_timer_timeout():
	score = 0;
	$MobTimer.start()
	$ScoreTimer.start()
	


func _on_base_hit() -> void:
	pass # Replace with function body.
