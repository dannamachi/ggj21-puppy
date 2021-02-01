extends CanvasLayer

signal transition_in_done
signal transition_out_done



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func switch_red():
	$TransitionTierOut.color = Color( 1, 0, 0, 1)
	$TransitionSlideOut.color = Color( 1, 0, 0, 1)
	$TransitionTierIn.color = Color( 1, 0, 0, 1)
	$TransitionSlideIn.color = Color( 1, 0, 0, 1)
	
func reset_red():
	$TransitionTierOut.color = Color( 0, 0, 0, 1 )
	$TransitionSlideOut.color = Color( 0, 0, 0, 1 )
	$TransitionTierIn.color = Color( 0, 0, 0, 1 )
	$TransitionSlideIn.color = Color( 0, 0, 0, 1 )


func cover_screen(slide):
	#Transition
	var ani
	if not slide:
		$TransitionTierOut.show()
		ani = $TransitionTierOut/AnimationPlayer
	else:
		$TransitionSlideOut.show()
		ani = $TransitionSlideOut/AnimationPlayer
	ani.play("run")
	yield(ani, "animation_finished")
	emit_signal("transition_out_done")
	if not slide:
		$TransitionTierOut.hide()
	else:
		$TransitionSlideOut.hide()
	ani.play_backwards("run")
	
	
func show_screen(slide):
	#Transition
	var ani
	if not slide:
		$TransitionTierIn.show()
		ani = $TransitionTierIn/AnimationPlayer
	else:
		$TransitionSlideIn.show()
		ani = $TransitionSlideIn/AnimationPlayer
	ani.play("run")
	yield(ani, "animation_finished")
	emit_signal("transition_in_done")
	if not slide:
		$TransitionTierIn.hide()
	else:
		$TransitionSlideIn.hide()
	ani.play_backwards("run")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
