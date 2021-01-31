extends Node2D

signal retry
signal give_up


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("press-z"):
		emit_signal("retry")
	elif Input.is_action_pressed("press-x"):
		emit_signal("give_up")
