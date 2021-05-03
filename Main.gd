extends Node2D

export (PackedScene) var Menu
export (PackedScene) var Game
export (PackedScene) var GameOver

var op1 = preload("res://Cutscenes/CutsceneA.tscn")
var op2 = preload("res://Cutscenes/CutsceneB.tscn")
var op6 = preload("res://Cutscenes/CutsceneF.tscn")
var op7 = preload("res://Cutscenes/CutsceneG.tscn")

var gametrack = preload("res://assets/sfx/future chill 3.wav")
var titletrack = preload("res://assets/sfx/future chill jazzy less onii.wav")
var isGameTrack = true

var cutArr = {
	"Opening1"     : op1,
	"Opening2"     : op2,
	"Ending"       : op6,
	"PreEnding"    : op7
}

# Called when the node enters the scene tree for the first time.
func _ready():
	cover_screen()
	yield($Transitions, "transition_out_done")
	switch_to_menu()
	
	
func cover_screen(slide=false):
	$Transitions.cover_screen(slide)
	
	
func show_screen(slide=false):
	$Transitions.show_screen(slide)
	

func switch_to_menu(musicPlay=true):
	#MenuInstance
	var menu = Menu.instance()
	menu.connect("start_game", self, "on_start_from_menu")
	menu.connect("quit_game", self, "on_quit")
	$Scenes.add_child(menu)
	show_screen()
	if musicPlay:
		$Music.stream = gametrack
		$Music.play()
		$Music/AnimationPlayer.play("fadein")
	

func switch_to_game():
	#GameInstance
	var game = Game.instance()
	game.connect("game_end", self, "on_game_end")
	$Scenes.add_child(game)
	show_screen()
	
	
func switch_to_over():
	#GameOverInstance
	var over = GameOver.instance()
	over.connect("retry", self, "on_start_from_gameover")
	over.connect("give_up", self, "on_give_up")
	$Scenes.add_child(over)
	show_screen()
	$Music.stream = titletrack
	$Music.play()
	$Music/AnimationPlayer.play("fadein")
	
	
func switch_to_cutscene(cutName):
	#CutsceneInstance
	var cuts = cutArr[cutName].instance()
	cuts.setName(cutName)
	cuts.connect("end", self, "on_end_from_cuts")
	$Scenes.add_child(cuts)
	show_screen(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print($Scenes.get_child_count())
#	for i in $Scenes.get_children():
#		print(i.name + ",")
	
	
func on_quit():
	get_tree().quit()
	
	
func on_end_from_cuts(cutName):
	cover_screen(true)
	yield($Transitions, "transition_out_done")
	#FreeInstance
	for i in $Scenes.get_children():
		if "Cutscene" in i.name:
			i.queue_free()
	
	#GameFlow
	if cutName == "Opening1":
		switch_to_cutscene("Opening2")
	elif cutName == "Opening2":
		switch_to_game()
	elif cutName == "PreEnding":
		switch_to_cutscene("Ending")
		$Music.stream = gametrack
		$Music.play()
		$Music/AnimationPlayer.play("fadein")
	else:
		switch_to_menu(false)


func on_game_end(gameResult):
	if gameResult:
		$GameOver.play()
		$Transitions.switch_red()
	cover_screen()
	yield($Transitions, "transition_out_done")
	if not gameResult:
		$Music/AnimationPlayer.play_backwards("fadein")
	#FreeInstance
	for i in $Scenes.get_children():
		if "Game" in i.name:
			i.queue_free()
			
	$Transitions.reset_red()
	#WinGame
	if not gameResult:
		$Music.stop()
		#GameFlow
		switch_to_cutscene("PreEnding")
	#LoseGame
	else:
		switch_to_over()
		
		
func on_give_up():
	cover_screen()
	yield($Transitions, "transition_out_done")
	#FreeInstance
	for i in $Scenes.get_children():
		if "GameOver" in i.name:
			i.queue_free()
			
	switch_to_menu()
		
		
func on_start_from_gameover():
	cover_screen()
	yield($Transitions, "transition_out_done")
	#FreeInstance
	for i in $Scenes.get_children():
		if "GameOver" in i.name:
			i.queue_free()
			
	#GameFlow might not start with game
	switch_to_game()
		

func on_start_from_menu():
	cover_screen()
	yield($Transitions, "transition_out_done")
	#FreeInstance
	for i in $Scenes.get_children():
		if "Menu" in i.name:
			i.queue_free()
			
	#GameFlow
	switch_to_cutscene("Opening1")
