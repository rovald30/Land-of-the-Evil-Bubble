extends RigidBody2D

#@export var enemy_type: String = "basic"  # Can be "basic", "tank", or "speedy"
#var velocity: Vector2 = Vector2.ZERO

# Define animation sets for different enemy types


func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
