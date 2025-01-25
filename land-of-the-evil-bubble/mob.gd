extends RigidBody2D

#@export var enemy_type: String = "basic"  # Can be "basic", "tank", or "speedy"
#var velocity: Vector2 = Vector2.ZERO

var enemyclass

var animation_sets = {
	"basic": ["basicRight", "basicUp", "basicDown"],
	"tank": ["tankRight", "tankUp", "tankDown"],
	"speedy": ["speedyRight", "speedyUp", "speedyDown"]
}

@export var health = 100
@export var armor = 100
@export var damage = 100


func _ready():
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



func _on_body_entered(body: Node) -> void:
	print("hello my guyse")
	queue_free() # Replace with function body.
