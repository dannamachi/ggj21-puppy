extends RigidBody2D

signal escape_scene

export var SPEED = 3

var is_static = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func set_static():
	is_static = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_static:
		position.x -= SPEED


func _on_VisibilityNotifier2D_screen_exited():
	if not is_static:
		#emit_signal("escape_scene")
		$Timer.start()


func _on_Timer_timeout():
	queue_free()
