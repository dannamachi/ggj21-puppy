extends Node2D

export (PackedScene) var Rock
export (PackedScene) var BigRock
export (PackedScene) var LevelRock
export (PackedScene) var PitRock

var sprite_type = "CAVE"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	$SpawnTimer.wait_time = 3 + rand_range(-0.3, 2.3)
	
	var rock
	var num = randi()
	if num % 3 == 0:
		rock = BigRock.instance()
		rock.position = $SpawnPoint2.position
	elif num % 3 == 1:
		rock = Rock.instance()
		rock.position = $SpawnPoint.position
	else:
		num = randi()
		if num % 2 == 0:
			rock = LevelRock.instance()
			rock.position = $SpawnPoint2.position
		else:
			rock = PitRock.instance()
			rock.position = $SpawnPoint2.position
			
		
	rock.set_sprite_type(sprite_type)
		
	add_child(rock)
	$SpawnTimer.start()
