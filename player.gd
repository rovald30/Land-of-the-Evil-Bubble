extends Area2D

@export var projectile_scene: PackedScene
@export var projectile_speed = 60000
@export var damage = 10
@export var shooting_speed = 1
var is_shooting_cooldown = false

signal hit
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@export var health = 100

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
		if enemy and distance < shortest_distance:
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



func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	print(screen_size / 2)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shoot_nearest_enemy()
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "left"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "down"


func _on_body_entered(body: Node2D) -> void:
	hit.emit()


func _on_shooting_cooldown_timeout() -> void:
	is_shooting_cooldown = false # Replace with function body.
