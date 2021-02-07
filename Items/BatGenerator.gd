extends Node2D

export (PackedScene) var Bat
export var BAT_SPEED = 200

var bat_list = []
var time_start = false
var sprite_type = "BAT"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(bat_list) > 0 and not time_start:
		$QueueTimer.start()
		time_start = true


func spawn_bats(num=1):
	var unit_interval = 1.0/num
	for i in range(num):
		var bat = Bat.instance()
		$Path2D/PathFollow2D.unit_offset = i * unit_interval
		bat.position.x = $Path2D/PathFollow2D.position.x
		bat.position.y = $Path2D/PathFollow2D.position.y
		
		bat.connect("hit_player", get_node("../Player"), "on_being_hit")
		
		bat.set_sprite_type(sprite_type)
		
		bat_list.append(bat)
		


func _on_SpawnTimer_timeout():
	$SpawnTimer.wait_time = 4 + rand_range(-3.0, 3.0)
	spawn_bats(randi() % 5 + 1)
	

func _on_QueueTimer_timeout():
	#AddChild
	var bat = bat_list[0]
	add_child(bat)
	#SetVelo
	var playerPosX = get_node("../Player").position.x
	var playerPosY = get_node("../Player").position.y
	bat.look_at(Vector2(playerPosX, playerPosY))
	bat.rotate(rand_range(-PI / 6, PI / 6))
	var velo = Vector2(BAT_SPEED, 0).rotated(bat.rotation)
	if sprite_type == "BAT":
		bat.rotation = -PI / 2
	bat.set_velo(velo.x, velo.y)
	#UpdateQueue
	bat_list.pop_front()
	if len(bat_list) == 0:
		$QueueTimer.stop()
		$QueueTimer.wait_time = 0.3 + rand_range(-0.2, 0.2)
		time_start = false
