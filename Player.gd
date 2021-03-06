extends KinematicBody2D

signal game_start

var started = false
var is_static = false
var is_menu = false

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
var gravity

#FineTuningHit
export var HIT_IMMUNE = 15
export var HIT_VELX = 400
export var HIT_VELY = 200

#Hit
var is_hit = false
var hit_immu = 15

#FineTuningMovement
export var BASE_RUNNING = 0
export var GRAVITY = 1000
export var WALK_SPEED = 150
export var JUMP_SPEED = 600
export var BACKGROUND_OFFSET_MULT = 0.001


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("flying")
	

func on_being_hit():
	if not is_hit:
		get_node("../../HurtEffect").play()
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
				if position.y < 266 and not is_menu:
					velocity.x += WALK_SPEED
			#LeftRight
			if is_on_floor() and Input.is_action_pressed("ui_right"):
				velocity.x += WALK_SPEED
			if not is_on_floor() and Input.is_action_just_pressed("ui_right"):
				velocity.x += WALK_SPEED
			if is_on_floor() and Input.is_action_pressed("ui_left"):
				velocity.x -= WALK_SPEED * 1.5
			if not is_on_floor() and Input.is_action_just_pressed("ui_left"):
				velocity.x -= WALK_SPEED
				
			#Jump
			if is_on_floor() and Input.is_action_just_pressed("ui_up"):
				velocity.y = -JUMP_SPEED
			
			#Gravity
			if velocity.y > 0:
				gravity = GRAVITY + 300
			else:
				gravity = GRAVITY
			velocity.y += delta * jump_mult * gravity * high_force
		
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
			if velocity.y > 0:
				gravity = GRAVITY + 300
			else:
				gravity = GRAVITY
			velocity.y += delta * gravity * high_force
				
		
		#ApplyVelo
		move_and_slide(velocity, Vector2(0, -1))
	

func set_static():
	is_static = true
	
	
func _process(delta):
	#pass
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
						if not is_menu:
							toPlay = "running"
						else:
							toPlay = "standing"
				elif is_menu and currPlay == "running" and velocity.x == 0:
					toPlay = "standing"
				elif currPlay == "standing" and velocity.x != 0:
					toPlay = "running"
			elif not is_on_floor() and not is_hit:
				if currPlay == "jumping":
					jumpingTime -= 1
					if jumpingTime == 0:
						toPlay = "flying"
				else:
					toPlay = "flying"
						
			if toPlay != "N/A" and toPlay != currPlay:
				$AnimatedSprite.play(toPlay)


func _on_HighZone_body_entered(body):
	high_force = 1.5


func _on_HighZone_body_exited(body):
	high_force = 1.0
