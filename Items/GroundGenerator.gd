extends Node2D

export (PackedScene) var Piece

var ground_type = "CAVE"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if "GroundPiece" in i.name:
			i.connect("escape_scene", self, "on_piece_destroyed")
			i.set_sprite_type(ground_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	var piece = Piece.instance()
	piece.position = $SpawnPoint.position
	piece.connect("escape_scene", self, "on_piece_destroyed")
	piece.set_sprite_type(ground_type)
	add_child(piece)
