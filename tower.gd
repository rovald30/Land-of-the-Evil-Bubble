extends Area2D

@export var projectile_scene: PackedScene
@export var projectile_speed = 60000
@export var damage = 10
@export var shooting_speed = 1
var is_shooting_cooldown = false
const HEALTH = 20
@export var health = HEALTH

func can_shoot() -> bool:
	# Current weapon? võta sealt shooting speed
	#	Delay shooting speed põhjal
	return !is_shooting_cooldown
	
func get_enemies() -> Array[Node]:
	return get_tree().get_nodes_in_group("Enemy")

func get_nearest_enemy(enemies: Array[Node]):
	var nearest_enemy = null
	var shortest_distance = INF
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if enemy and distance < shortest_distance:# and !check_collision_between(global_position, enemy.global_position):
			shortest_distance = distance
			nearest_enemy = enemy
	return nearest_enemy

func check_collision_between(from: Vector2, to: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	if result.size() > 0:
		return true
	return false

func shoot_nearest_enemy():
	if !can_shoot():
		return
	
	# Loo bubble node-id, mis liiguvad otse vaenlase poole
	var nearest_enemy = get_nearest_enemy(get_enemies())
	if nearest_enemy == null:
		return
	var projectile = projectile_scene.instantiate()
	projectile.position = position
	var direction = (nearest_enemy.global_position - projectile.global_position).normalized()
	var force = direction * projectile_speed
	projectile.apply_central_force(force)
	projectile.damage = damage
	
	# Kui player tulistas
	is_shooting_cooldown = true
	$ShootingCooldown.start()
	$Shot.play()
	add_sibling(projectile)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BuildSFX.play()
	$CanvasLayer/HealthBar.max_value = HEALTH
	$CanvasLayer/HealthBar.value = HEALTH
	print(position)
	$CanvasLayer/HealthBar.position = position + Vector2(35, 0)
	print($CanvasLayer/HealthBar.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_shooting_cooldown:
		shoot_nearest_enemy()
	pass


func _on_shooting_cooldown_timeout() -> void:
	is_shooting_cooldown = false # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		$MobDeath.play()
		body.queue_free()
		health -= body.damage
		print($CanvasLayer/HealthBar.value)
		$CanvasLayer/HealthBar.value = health
		if health <= 0:
			queue_free()
