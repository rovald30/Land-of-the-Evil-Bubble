extends RigidBody2D

var damage
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
