extends Node2D

export (PackedScene) var Random


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	$SpawnTimer.wait_time = 6 + rand_range(-0.7, 1.9)
	
	var rock = Random.instance()
	if get_node("../GroundGenerator").ground_type == "CAVE":
		rock.set_sprite_type("LOG")
	else:
		var rtype = randi() % 2
		if rtype == 0:
			rock.set_sprite_type("ROCK")
		else:
			rock.set_sprite_type("ROOT")
		
	rock.position = $SpawnPoint.position

		
	add_child(rock)
	$SpawnTimer.start()
