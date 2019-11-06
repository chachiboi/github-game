extends KinematicBody2D


const MAX_SPEED = 120
const ACCELERATION = 20
const GRAVITY = 10
const JUMP = -220
const FLOOR = Vector2(0, -1)
const WALLJUMP = Vector2(8, -10)

var velocity = Vector2()

var on_ground = false

var jump_count = 0

func _ready():
	pass


func _physics_process(delta):
	var friction = false
	
	# RESTART SCENE -----
	
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	# MOVEMENT -----
		
	if Input.is_action_pressed("right"):
		$CollisionShape2D.get_shape().set_extents(Vector2(4, 3))
		velocity.x = min(velocity.x+ACCELERATION, MAX_SPEED)
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
		
	elif Input.is_action_pressed("left"):
		velocity.x = max(velocity.x-ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.get_shape().set_extents(Vector2(4, 3))
		
	elif Input.is_action_pressed("down"):
		velocity.x = lerp(velocity.x, 0, 0.03)
		$CollisionShape2D.get_shape().set_extents(Vector2(4, 4))
		$AnimatedSprite.play("down")
	else:
		$CollisionShape2D.get_shape().set_extents(Vector2(4, 3))
		friction = true
		velocity.x = lerp(velocity.x, 0, 0.2)
		
		if on_ground == true:
			$AnimatedSprite.play("idle")
		
	if Input.is_action_just_pressed("jump"):
		#$Jump_effect.play("jump effect")
		#if on_ground == true:
			#velocity.y = JUMP
			#on_ground = false
		if jump_count < 1:
			jump_count += 1
			velocity.y = JUMP
			on_ground = false
			
		
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
		jump_count = 0
	else:
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("idle")
	if is_on_wall():
		$AnimatedSprite.play("non")
		$WallJump.play("OnWall")
		velocity.y = -100
		jump_count = 0
	else:
		$WallJump.play("NotOnWall")
		if velocity.x == -MAX_SPEED:
			$WallJump.flip_v = true
		elif velocity.x == MAX_SPEED:
			$WallJump.flip_v = false
	
	velocity = move_and_slide(velocity, FLOOR)
	
	