extends Node2D

signal start_game
signal quit_game

var quitted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.is_menu = true
	for i in $Decor.get_children():
		if "GroundPiece" in i.name:
			i.set_static()
			i.set_sprite_type("FOREST")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not quitted:
		if $Player.position.x >= $Bounds/StartPos.position.x:
			emit_signal("start_game")
			quitted = true
		elif $Player.position.x <= $Bounds/QuitPos.position.x:
			emit_signal("quit_game")
			quitted = true
	
	#LeftRightFlip
	if Input.is_action_just_pressed("ui_right"): $Player/AnimatedSprite.flip_h = false
	elif Input.is_action_just_pressed("ui_left"): $Player/AnimatedSprite.flip_h = true
