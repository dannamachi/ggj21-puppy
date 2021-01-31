extends Node2D

signal end(cutsName)


var cutscene_name = "N/A"

func setName(cutName):
	cutscene_name = cutName
	
	
var convo_list = [
	"Grandma: He's just a wee little boy~",
	"Grandma: Thank you so much for bringing him home.",
	"Grandma: Come if you want to play with him any time!",
	"Perhaps another day..."
]
var convo_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Actors/Grandma.play()
	$Display/Label.text = convo_list[convo_index]
	$ConvoTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ConvoTimer_timeout():
	convo_index += 1
	if convo_index < len(convo_list):
		$Display/Label.text = convo_list[convo_index]
	else:
		emit_signal("end", cutscene_name)
