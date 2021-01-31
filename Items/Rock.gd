extends RigidBody2D


export var SPEED = 3

var is_static = false
var in_screen = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_static:
		position.x -= SPEED
	
	
func set_sprite_type(name="CAVE"):
	$Sprite.hide()
	$Sprite2.hide()
	if name == "CAVE": 
		$Sprite.show()
	else:
		$Sprite2.show()

	
func set_static():
	is_static = true


func _on_VisibilityNotifier2D_screen_exited():
	if not is_static and in_screen:
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	in_screen = true
