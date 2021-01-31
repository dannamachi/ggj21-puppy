extends Node2D

signal end(cutsName)


var cutscene_name = "N/A"

func setName(cutName):
	cutscene_name = cutName
	
var pic_list = [
	preload("res://assets/cuts/Opening2.png"),
	preload("res://assets/cuts/Opening3.png"),
	preload("res://assets/cuts/Opening4.png"),
	preload("res://assets/cuts/Opening5.png")
]

var pic_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
#	$Transitions.show_screen()
#	yield($Transitions, "transition_in_done")
	$TextureRect.texture = pic_list[pic_index]
	$Timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	pic_index += 1
	if pic_index < len(pic_list):
		$TextureRect.texture = pic_list[pic_index]
	else:
		emit_signal("end", cutscene_name)
