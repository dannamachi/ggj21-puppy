extends Node2D

export (PackedScene) var Menu
export (PackedScene) var Game
export (PackedScene) var GameOver

var op1 = preload("res://Cutscenes/CutsceneA.tscn")
var op2 = preload("res://Cutscenes/CutsceneB.tscn")
var op3 = preload("res://Cutscenes/CutsceneC.tscn")
var op4 = preload("res://Cutscenes/CutsceneD.tscn")
var op5 = preload("res://Cutscenes/CutsceneE.tscn")
var op6 = preload("res://Cutscenes/CutsceneF.tscn")
var op7 = preload("res://Cutscenes/CutsceneG.tscn")

var cutArr = {
	"Opening1"     : op1,
	"Opening2"     : op2,
	"Opening3"     : op3,
	"Opening4"     : op4,
	"Opening5"     : op5,
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
	

func switch_to_menu():
	#MenuInstance
	var menu = Menu.instance()
	menu.connect("start_game", self, "on_start_from_menu")
	menu.connect("quit_game", self, "on_quit")
	$Scenes.add_child(menu)
	show_screen()
	

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
		switch_to_cutscene("Opening3")
	elif cutName == "Opening3":
		switch_to_cutscene("Opening4")
	elif cutName == "Opening4":
		switch_to_cutscene("Opening5")
	elif cutName == "Opening5":
		switch_to_game()
	elif cutName == "PreEnding":
		switch_to_cutscene("Ending")
	else:
		switch_to_menu()


func on_game_end(gameResult):
	cover_screen()
	yield($Transitions, "transition_out_done")
	#FreeInstance
	for i in $Scenes.get_children():
		if "Game" in i.name:
			i.queue_free()
			
	#WinGame
	if not gameResult:
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
