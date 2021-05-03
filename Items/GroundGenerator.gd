extends Node2D

export (PackedScene) var Piece

var ground_type = "CAVE"

var pieces = []
var piecesAhead = 40


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if "GroundPiece" in i.name:
			pieces.append(i)
			i.set_sprite_type(ground_type)

func set_ground_type(stuff):
	ground_type = stuff
	var i = 0
	while true:
		if pieces[i].position.x > 1140:
			break
		i += 1
	for j in range(i,pieces.size()):
		pieces[j].set_sprite_type(ground_type)
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pieces[piecesAhead - 1].position.x < -1000:
		#PopOldPieces
		for i in range(piecesAhead):
			var removed = pieces.pop_front()
			if removed != null:
				removed.queue_free()

func _on_SpawnTimer_timeout():
	#AppendNewPieces
	var lastPos = pieces[-1].position
	var lastSize = pieces[-1].getWidth()
	for i in range(piecesAhead):		
		var piece = Piece.instance()
		piece.position.x = lastPos.x + i * lastSize
		piece.position.y = lastPos.y	
		piece.set_sprite_type(ground_type)
		pieces.append(piece)
		add_child(piece)
