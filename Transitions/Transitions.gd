extends CanvasLayer

signal transition_in_done
signal transition_out_done



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func cover_screen():
	#Transition
	$TransitionTierOut.show()
	var ani = $TransitionTierOut/AnimationPlayer
	ani.play("run")
	yield(ani, "animation_finished")
	emit_signal("transition_out_done")
	$TransitionTierOut.hide()
	ani.play_backwards("run")
	
	
func show_screen():
	#Transition
	$TransitionTierIn.show()
	var ani = $TransitionTierIn/AnimationPlayer
	ani.play("run")
	yield(ani, "animation_finished")
	emit_signal("transition_in_done")
	$TransitionTierIn.hide()
	ani.play_backwards("run")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
