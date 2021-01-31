extends Node2D

export (PackedScene) var Menu
export (PackedScene) var Game
export (PackedScene) var GameOver

var cuts1 = preload("res://Cutscenes/CutsceneA.tscn")

var cutArr = {
	"DropRock"     : cuts1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	cover_screen()
	yield($Transitions, "transition_out_done")
	switch_to_menu()
	
	
func cover_screen():
	$Transitions.cover_screen()
	
	
func show_screen():
	$Transitions.show_screen()
	

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
	show_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print($Scenes.get_child_count())
#	for i in $Scenes.get_children():
#		print(i.name + ",")
	
	
func on_quit():
	get_tree().quit()
	
	
func on_end_from_cuts(cutName):
	cover_screen()
	yield($Transitions, "transition_out_done")
	#FreeInstance
	for i in $Scenes.get_children():
		if "Cutscene" in i.name:
			i.queue_free()
	
	#GameFlow
	if cutName == "DropRock":
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
		switch_to_cutscene("DropRock")
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
			
	#GameFlow might not start with game
	switch_to_game()
