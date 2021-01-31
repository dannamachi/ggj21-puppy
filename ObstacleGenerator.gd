extends Node2D

export (PackedScene) var Rock
export (PackedScene) var BigRock

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	$SpawnTimer.wait_time = 5 + rand_range(-2.0, 2.0)
	
	var rock
	if randi() % 3 == 0:
		rock = BigRock.instance()
		rock.position = $SpawnPoint2.position
	else:
		rock = Rock.instance()
		rock.position = $SpawnPoint.position
		
	add_child(rock)
	$SpawnTimer.start()
