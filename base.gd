extends Area2D

signal hit
signal end
@export var health = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


func _on_body_entered(body: Node2D) -> void:
	
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	if body.is_in_group("Enemy"):
		health -= body.damage
	if health <= 0:
		end.emit()
		get_tree().change_scene_to_file("res://end_screen.tscn")
	if body.is_in_group("Enemy"):
		$MobDeath.play()
		body.queue_free()
