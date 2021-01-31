extends RigidBody2D

signal escape_scene

export var SPEED = 3

var is_static = false
var sprite_dict = {
	"CAVE"    : load("res://assets/tile_cave.png"),
	"FOREST"  : load("res://assets/tile_forest.png")
}
var in_screen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func set_static():
	is_static = true
	
func set_sprite_type(name="CAVE"):
	if name in sprite_dict:
		$Sprite.texture = sprite_dict[name]
		$Sprite2.texture = sprite_dict[name]
		$Sprite3.texture = sprite_dict[name]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_static:
		position.x -= SPEED


func _on_VisibilityNotifier2D_screen_exited():
	if not is_static and in_screen:
		#emit_signal("escape_scene")
		#yield(get_tree().create_timer(0.3), "timeout")
		queue_free()



func _on_VisibilityNotifier2D_screen_entered():
	in_screen = true
