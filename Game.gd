extends Node2D

signal game_end(gameResult)

var game_over = false
var num_time_bar = 20
var bar_interval = 0
var time_left = 0
var level_start = false
var progressText = "%d km left"
var is_switching = false
var stop_playing_cave = false

var threshold_time_list = [
	60,
	53,
	46,
	39,
	32,
	25,
	18,
	11,
	4
]

var threshold_line_list = [
	"Dog?: ROAAAAAAAAAAAAARRRR~",
	"Why am I doing this again?",
	"Right, it's the coins. A lot of 'em.",
	"What a beautiful day today.",
	"Aaaaaaaaaaaaaaaaaa",
	"Are coins really worth running for my life?",
	"Of course they are, silly me.",
	"Almost there! The coins!!",
	"If I don't make it coming this far I'll--"
]

export var LEVEL_TIME = 60


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = LEVEL_TIME
	time_left = $Timer.wait_time
	$C2/Monster.play()
	
	
func stop_game():
	$Timer.stop()
#	$C2/BatGenerator/SpawnTimer.stop()
#	$C2/GroundGenerator/SpawnTimer.stop()
#	$C2/BatGenerator/SpawnTimer.stop()
#	$C2/BatGenerator/QueueTimer.stop()
#	for i in $C2/GroundGenerator.get_children():
#		if "GroundPiece" in i.name: i.set_static()
#	for i in $C2/ObstacleGenerator.get_children():
#		if "Rock" in i.name: i.set_static()
#	$C2/Player.set_static()
	emit_signal("game_end", game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#MoveBackGround
	if not $C2/Player.is_static:
		if not stop_playing_cave:
			$ParallaxBackground.scroll_offset.x -= ($C2/Player.base_displacement + $C2/Player.velocity.x * $C2/Player.BACKGROUND_OFFSET_MULT) * delta
	
		#MoveTransitionBackground
		if is_switching:
			$TransitionAddon.scroll_offset.x -= ($C2/Player.base_displacement + $C2/Player.velocity.x * $C2/Player.BACKGROUND_OFFSET_MULT) * delta
			if $TransitionAddon.scroll_offset.x < -4000 and not stop_playing_cave:
				$TransitionAddon/ParallaxLayerForest2.show()
				$C2/GroundGenerator.ground_type = "FOREST"
				$C2/BatGenerator.sprite_type = "OWL"
				$C2/ObstacleGenerator.sprite_type = "FOREST"
				stop_playing_cave = true
				
	#ShowProgress
	if level_start:
		if not game_over:
			if $C2/Player.position.x <= $C2/EatenWall/LastPos.position.x:
				game_over = true
				$C2/Display/FancyText.bbcode_text = "[center]NOOOOO~[/center]"
				stop_game()
			
		if not game_over and level_start: 
			time_left = $Timer.get_time_left()
	#		var progressBar = "<<"
	#		for i in num_time_bar:
	#			if (LEVEL_TIME - time_left) <= i * bar_interval:
	#				progressBar += "-"
	#			else:
	#				progressBar += "O"
	#		progressBar += "->>"
			$C2/Display/ProgressLine.text = progressText % time_left
			
			#TextUpdate
			for i in range(len(threshold_time_list)):
				if time_left >= threshold_time_list[i] - 7:
					$C2/Display/FancyText.bbcode_text = "[center]%s[/center]" % threshold_line_list[i]
					break
	

func _on_Player_game_start():
	$Timer.start()
	$SwitchTimer.start()
	bar_interval = $Timer.wait_time / num_time_bar
	level_start = true
	

func _on_Timer_timeout():
	if not game_over:
		$C2/Display/FancyText.bbcode_text = "[center]I'M HERE!!![/center]"
		stop_game()


func _on_SwitchTimer_timeout():
#	$C1/TransitionSlideOut.show()
#	$C1/TransitionSlideOut/AnimationPlayer.play("run")
#	yield($C1/TransitionSlideOut/AnimationPlayer, "animation_finished")
	is_switching = true
#	$C1/TransitionSlideIn.show()
#	$ParallaxBackground/ParallaxLayerCave.hide()
#	$ParallaxBackground/ParallaxLayerForest.show()
#	$C1/TransitionSlideOut.hide()
#	$C1/TransitionSlideOut/AnimationPlayer.play_backwards("run")
#	$C1/TransitionSlideIn/AnimationPlayer.play("run")
#	yield($C1/TransitionSlideIn/AnimationPlayer, "animation_finished")
#	$C1/TransitionSlideIn.hide()
#	$C1/TransitionSlideIn/AnimationPlayer.play_backwards("run")

