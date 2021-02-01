extends Node2D

signal end(cutsName)


var cutscene_name = "N/A"

func setName(cutName):
	cutscene_name = cutName

var convo_list = [
	"Granny: Who goes there?",
	"Adventurer: Woah woah Granny I’ve found your Fluffy for you, calm down."
]
var convo_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in $Decors.get_children():
		if "GroundPiece" in i.name: 
			i.set_static()
			i.set_sprite_type("FOREST")
	$Actors/Player.set_static()
	$Actors/Player/AnimatedSprite.play("running")
	$Actors/Player/AnimationPlayer.play("coming")
	$Actors/Grandma.play("idle")
	yield($Actors/Player/AnimationPlayer, "animation_finished")
	$Actors/Player/AnimatedSprite.play("standing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GrandmaFlipTimer_timeout():
	$Actors/Grandma.flip_h = true
	$Actors/Grandma.play("gunning")
	yield($Actors/Grandma, "animation_finished")
	$Actors/Grandma.play("gunback")
	yield($Actors/Grandma, "animation_finished")
	$Display/Label.text = convo_list[convo_index]
	$ConvoTimer.start()


func _on_ConvoTimer_timeout():
	convo_index += 1
	if convo_index < len(convo_list):
		$Display/Label.text = convo_list[convo_index]
	else:
		emit_signal("end", cutscene_name)
