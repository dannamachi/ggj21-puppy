extends Area2D

signal hit_player

var velocity = Vector2(0, 0)
var in_screen = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta
	

func set_velo(velX, velY):
	velocity.x = velX
	velocity.y = velY


func _on_VisibilityNotifier2D_screen_exited():
	if in_screen:
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	in_screen = true


func _on_Bat_body_entered(body):
	if "Player" in body.name:
		emit_signal("hit_player")
