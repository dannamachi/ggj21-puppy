extends Node2D

signal start_game
signal quit_game

var quitted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not quitted:
		if Input.is_action_just_pressed("press-z"):
			emit_signal("start_game")
			quitted = true
		elif Input.is_action_just_pressed("press-q"):
			emit_signal("quit_game")
			quitted = true
