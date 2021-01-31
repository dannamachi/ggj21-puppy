extends RigidBody2D


export var SPEED = 3

var is_static = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_static:
		position.x -= SPEED
	
	
func set_static():
	is_static = true


func _on_VisibilityNotifier2D_screen_exited():
	if not is_static:
		queue_free()
