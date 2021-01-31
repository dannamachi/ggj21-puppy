extends KinematicBody2D

signal game_start

var started = false
var is_static = false

#FineTuningAnimation
var LANDING_TIME = 30
var landingTime = 0
var JUMPING_TIME = 30
var jumpingTime = 0

#Velocity
var velocity = Vector2(0,0)
var base_displacement = 300
var jump_mult = 1.0
var high_force = 1.0

#FineTuningHit
export var HIT_IMMUNE = 15
export var HIT_VELX = 400
export var HIT_VELY = 200

#Hit
var is_hit = false
var hit_immu = 15

#FineTuningMovement
export var BASE_RUNNING = 0
export var GRAVITY = 900
export var WALK_SPEED = 150
export var JUMP_SPEED = 550
export var BACKGROUND_OFFSET_MULT = 0.001


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("flying")
	

func on_being_hit():
	if not is_hit:
		is_hit = true
		hit_immu = HIT_IMMUNE
		if not is_on_floor():
			velocity.x = -HIT_VELX
			velocity.y = -HIT_VELY
		else:
			velocity.x = -HIT_VELX
			velocity.y = -HIT_VELY
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_static:
		#AutoRun
		if is_on_floor():
			if not started: 
				started = true
				emit_signal("game_start")
			jump_mult = 1.0
		#NormalMovement
		if not is_hit:	
			#AutoRun
			if is_on_floor():
				velocity.x = BASE_RUNNING
			#LeftRight
			if is_on_floor() and Input.is_action_pressed("ui_right"):
				velocity.x += WALK_SPEED
			if not is_on_floor() and Input.is_action_just_pressed("ui_right"):
				velocity.x += WALK_SPEED
			if is_on_floor() and Input.is_action_pressed("ui_left"):
				velocity.x -= WALK_SPEED
			if not is_on_floor() and Input.is_action_just_pressed("ui_left"):
				velocity.x -= WALK_SPEED
				
			#Jump
			if is_on_floor() and Input.is_action_just_pressed("ui_up"):
				velocity.y = -JUMP_SPEED
			
			#Gravity
			velocity.y += delta * jump_mult * GRAVITY * high_force
		
			#ExtendedJump
			if velocity.y < 0:
				if Input.is_action_just_released("ui_up"):
					jump_mult = clamp(-velocity.y / 100, 1.0, 5.0)
		#NoInputWhileHit
		else:	
			#CancelHit
			hit_immu -= 1
			if hit_immu == 0:
				is_hit = false
			#Gravity
			velocity.y += delta * GRAVITY * high_force
				
		
		#ApplyVelo
		move_and_slide(velocity, Vector2(0, -1))
	

func set_static():
	is_static = true
	
	
func _process(delta):
	#pass
	#MoveBackGround
	if get_node("../../ParallaxBackground") and not is_static:
		get_node("../../ParallaxBackground").scroll_offset.x -= (base_displacement + velocity.x * BACKGROUND_OFFSET_MULT) * delta

	if not is_static:
		#AnimationSwitch
		if Input.is_action_just_pressed("ui_up"):
			$AnimatedSprite.play("jumping")
			jumpingTime = JUMPING_TIME
		elif Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
			if is_on_floor():
				$AnimatedSprite.play("running")
		else:
			var currPlay = $AnimatedSprite.get_animation()
			var toPlay = "N/A"
			if is_hit and currPlay != "hitting":
				toPlay = "hitting"
			elif is_on_floor():
				if currPlay == "jumping" or currPlay == "flying":
					toPlay = "landing"
					landingTime = LANDING_TIME
				elif currPlay == "landing":
					landingTime -= 1
					if landingTime == 0:
						if position.y > 266:
							toPlay = "running"
						else:
							toPlay = "standing"
			elif not is_on_floor() and not is_hit:
				if currPlay == "jumping":
					jumpingTime -= 1
					if jumpingTime == 0:
						toPlay = "flying"
				else:
					toPlay = "flying"
						
			if toPlay != "N/A" and toPlay != currPlay:
				print("switching to " + toPlay)
				$AnimatedSprite.play(toPlay)

	#print(position.y)


func _on_HighZone_body_entered(body):
	high_force = 1.5


func _on_HighZone_body_exited(body):
	high_force = 1.0
