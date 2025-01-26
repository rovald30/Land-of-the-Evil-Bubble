extends RigidBody2D

var enemyclass
var enemyArray = ["basic", "tank", "speedy"]

var animation_sets = {
	"basic": ["basicRight", "basicUp", "basicDown"],
	"tank": ["tankRight", "tankUp", "tankDown"],
	"speedy": ["speedyRight", "speedyUp", "speedyDown"],
	"boss": ["speedyRight", "speedyUp", "speedyDown"]
}

@export var health = 20
@export var armor = 5
@export var damage = 2


func _ready():
	contact_monitor = true
	max_contacts_reported = 2
	sprite_animation_driection()
	mob_stats()
	
func mob_stats():
	
	match enemyclass:
		"basic":
			pass
		"tank":
			health *= 1.5
			armor *= 1.5
			damage *= 1.5
		"speedy":
			health *= 0.8
			armor *= 0.8
			damage *= 0.8
		"boss":
			health *= 5
			armor *= 5
			damage *= 5
	
func sprite_animation_driection():
	
	$AnimatedSprite2D.animation = animation_sets[enemyclass][0]
	var screen_size = get_viewport_rect().size
	var velocity = linear_velocity
	var left_distance = position.x
	var right_distance = screen_size.x - position.x
	var top_distance = position.y
	var bottom_distance = screen_size.y - position.y

	var min_distance = min(left_distance, right_distance, top_distance, bottom_distance)

	if min_distance == left_distance:
		$AnimatedSprite2D.animation = animation_sets[enemyclass][0]  # Right (spawned from left)
	elif min_distance == right_distance:
		$AnimatedSprite2D.animation = animation_sets[enemyclass][0]
		$AnimatedSprite2D.flip_h = true  # Left (spawned from right)
	elif min_distance == top_distance:
		$AnimatedSprite2D.animation = animation_sets[enemyclass][2]  # Down (spawned from top)
	elif min_distance == bottom_distance:
		$AnimatedSprite2D.animation = animation_sets[enemyclass][1]  # Up (spawned from bottom)
	$AnimatedSprite2D.play()


func _physics_process(delta):
	if get_contact_count() > 0:
		for i in get_colliding_bodies():
			if i is RigidBody2D and i.is_in_group("Projectile"):
				  # Remove the collided body
				health -= i.damage
				i.queue_free()
				if health <= 0:
					$MobDeath.play()
					$CollisionShape2D.disabled = true
					hide()
					await get_tree().create_timer(0.5).timeout
					queue_free()


func _on_body_entered(body: Node) -> void:
	pass
	#queue_free() # Replace with function body.
