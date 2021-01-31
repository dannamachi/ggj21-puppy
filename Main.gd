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
	switch_to_menu()


func switch_to_menu():
	var menu = Menu.instance()
	menu.connect("start_game", self, "on_start_from_menu")
	menu.connect("quit_game", self, "on_quit")
	add_child(menu)
	

func switch_to_game():
	var game = Game.instance()
	game.connect("game_end", self, "on_game_end")
	add_child(game)
	
	
func switch_to_over():
	var over = GameOver.instance()
	over.connect("retry", self, "on_start_from_gameover")
	over.connect("give_up", self, "on_give_up")
	add_child(over)
	
	
func switch_to_cutscene(cutName):
	var cuts = cutArr[cutName].instance()
	cuts.setName(cutName)
	cuts.connect("end", self, "on_end_from_cuts")
	add_child(cuts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	for i in get_children():
#		print(i.name + ",")
	
	
func on_quit():
	get_tree().quit()
	
	
func on_end_from_cuts(cutName):
	for i in get_children():
		if "Cutscene" in i.name:
			i.queue_free()
	
	#GameFlow
	if cutName == "DropRock":
		switch_to_menu()


func on_game_end(gameResult):
	for i in get_children():
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
	for i in get_children():
		if "GameOver" in i.name:
			i.queue_free()
			
	switch_to_menu()
		
		
func on_start_from_gameover():
	for i in get_children():
		if "GameOver" in i.name:
			i.queue_free()
			
	#GameFlow might not start with game
	switch_to_game()
		

func on_start_from_menu():
	for i in get_children():
		if "Menu" in i.name:
			i.queue_free()
			
	#GameFlow might not start with game
	switch_to_game()
