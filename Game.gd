extends Node2D

signal game_end(gameResult)

var game_over = false
var num_time_bar = 10
var bar_interval = 0
var time_left = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = $Timer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $C2/Player.position.x <= $C2/EatenWall/LastPos.position.x and not game_over:
		game_over = true
		$C2/Display/Cover.show()
		$C2/Display/FancyText.bbcode_text = "[center]GAME OVER[/center]"
		$Timer.stop()
		$WinTimer.start()
		
	if not game_over: time_left = $Timer.get_time_left()
	var progressBar = "<< "
	for i in num_time_bar:
		if (30 - time_left) <= i * bar_interval:
			progressBar += "="
		else:
			progressBar += "O"
	progressBar += " >>"
	$C2/Display/ProgressLine.text = progressBar
	

func _on_Player_game_start():
	$Timer.start()
	$C2/GroundGenerator/SpawnTimer.start()
	bar_interval = $Timer.wait_time / num_time_bar
	

func _on_Timer_timeout():
	if not game_over:
		$C2/Display/Cover.show()
		$C2/Display/FancyText.bbcode_text = "[center]YOU WIN[/center]"
		$WinTimer.start()


func _on_WinTimer_timeout():
	#WinPlaceHolder
	emit_signal("game_end", game_over)
