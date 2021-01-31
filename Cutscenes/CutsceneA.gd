extends Node2D

signal end(cutsName)


var cutscene_name = "N/A"

func setName(cutName):
	cutscene_name = cutName


# Called when the node enters the scene tree for the first time.
func _ready():
#	$Transitions.show_screen()
#	yield($Transitions, "transition_in_done")
	$Timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	emit_signal("end", cutscene_name)
