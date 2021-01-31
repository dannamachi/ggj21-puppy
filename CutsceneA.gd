extends Node2D

signal end(cutsName)


var cutscene_name = "N/A"

func setName(cutName):
	cutscene_name = cutName


# Called when the node enters the scene tree for the first time.
func _ready():
	#SetStaticForCutsceneControl
	for i in $Decors.get_children():
		i.set_static()
	for j in $Actors.get_children():
		j.set_static()
		
	$Actors/Player/AnimatedSprite.flip_h = true
	$Actors/Player/AnimatedSprite.play("running")
	var get_ani = $Actors/Player/AnimationPlayer
	get_ani.play("Enter")
	$Actors/BigRock/AnimationPlayer.play("DropDown")
	
	yield(get_ani, "animation_finished")
	$Display/Label.text = "W-What!?"
	$Actors/Player/AnimatedSprite.play("flying")
	get_ani.play("BackOff")
	
	yield(get_ani, "animation_finished")
	$Actors/Player/AnimatedSprite.play("standing")
	$Display/Label.text = "Did that just... fall down from the sky?"
	$Timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	emit_signal("end", cutscene_name)
