extends Node2D

signal end(cutsName)


var cutscene_name = "N/A"

func setName(cutName):
	cutscene_name = cutName
	
	
var convo_list = [
	"Granny: Oh! You’ve found my Fluffy for me I sssee! Good goooood...",
	"Granny: Here’s your reward adventurer",
	"Granny: Fluffy was bigger than you expected?",
	"Granny: KEkEKEkEk that is what being an adventurer’sss all about!",
	"Granny: Ssssee you are uninjured, Fluffy doesn’t like to break his toys you see...",
	"Granny: There there, Come again next time if you want to play with him mooorrre",
	"Adventurer: Perhaps another day..."
]
var convo_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
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
