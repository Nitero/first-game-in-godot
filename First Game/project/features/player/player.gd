extends CharacterBody2D
class_name Player

const GROUND_MAX_RUN_SPEED = 115

const GROUND_ACCELERATION = 500
const GROUND_DECELERATION = 500
const GROUND_TURN_SPEED = 800

const AIR_ACCELERATION = 500
const AIR_DECELERATION = 500
const AIR_TURN_SPEED = 400

const JUMP_HEIGHT = 50
const TIME_TO_JUMP_APEX = 0.5

const JUMP_RISE_GRAVITY_MULTIPLIER   = 0.5
const JUMP_FALL_GRAVITY_MULTIPLIER   = 1.25
const JUMP_CANCEL_GRAVITY_MULTIPLIER = 1.5
const DEFAULT_GRAVITY_MULTIPLIER     = 1

const JUMP_SPEED_LIMIT = INF
const FALL_SPEED_LIMIT = 350

const JUMP_BUFFER = 0.2
const COYOTE_TIME = 0.2

const EPSILON = 0.01

const JUMP_TIME = TIME_TO_JUMP_APEX * JUMP_RISE_GRAVITY_MULTIPLIER

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var look_direction: float
var desired_velocity: Vector2

var is_jump_desired: bool
var is_jump_pressed: bool
var is_jump_ongoing: bool
var jump_buffer_timer: float

var coyote_time_timer: float

var id_dead: bool

@onready var animated_sprite = $AnimatedSprite2D

func _input(_event):
	if id_dead:
		look_direction = 0
		desired_velocity = velocity
		is_jump_desired = false
		is_jump_pressed = false
		return
	look_direction = Input.get_axis("move_left", "move_right")#-1 | 0 | 1
	desired_velocity = Vector2(look_direction, 0) * max(0, GROUND_MAX_RUN_SPEED)
	if Input.is_action_just_pressed("jump"):
		is_jump_desired = true
	is_jump_pressed = Input.is_action_pressed("jump")
	if Input.is_action_just_pressed("restart"):
		restart()

func _process(delta):
	poll_jump_buffer(delta)
	poll_coyote_time(delta)
	flip_sprite_to_look_direction()
	play_animation()

func _physics_process(delta):
	move_horizontally(delta)
	move_vertically(delta)
	move_and_slide()

func move_horizontally(delta):
	var acceleration = GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	var deceleration = GROUND_DECELERATION if is_on_floor() else AIR_DECELERATION
	var turn_speed = GROUND_TURN_SPEED if is_on_floor() else AIR_TURN_SPEED

	var change_speed

	if look_direction != 0:
		if look_direction != sign(velocity.x):
			change_speed = turn_speed
		else:
			change_speed = acceleration
	else:
		change_speed = deceleration

	velocity.x = move_toward(velocity.x, desired_velocity.x, change_speed * delta)

func poll_jump_buffer(delta):
	if JUMP_BUFFER <= 0 || !is_jump_desired:
		return
	jump_buffer_timer += delta
	if jump_buffer_timer > JUMP_BUFFER:
		is_jump_desired = false
		jump_buffer_timer = 0

func poll_coyote_time(delta):
	if !is_jump_ongoing && !is_on_floor():
		coyote_time_timer += delta
	else:
		coyote_time_timer = 0

func move_vertically(delta):
	if is_on_floor():
		is_jump_ongoing = false

	var gravity_multiplier = get_gravity_multiplier()
	if is_jump_desired:
		execute_jump(gravity_multiplier)
	if !is_on_floor():
		velocity.y += gravity * gravity_multiplier * delta

	velocity.y = clamp(velocity.y, -JUMP_SPEED_LIMIT, FALL_SPEED_LIMIT)

func execute_jump(gravity_multiplier):
	if is_on_floor() || (coyote_time_timer > EPSILON && coyote_time_timer < COYOTE_TIME):
		is_jump_ongoing = true
		is_jump_desired = false
		jump_buffer_timer = 0
		coyote_time_timer = 0

		var jump_speed = sqrt(2.0 * gravity * gravity_multiplier * JUMP_HEIGHT * JUMP_RISE_GRAVITY_MULTIPLIER)
		velocity.y -= jump_speed

func get_gravity_multiplier():
	var gravity_multiplier = DEFAULT_GRAVITY_MULTIPLIER

	if velocity.y < -EPSILON && !is_on_floor():
		if is_jump_pressed && is_jump_ongoing:
			gravity_multiplier = JUMP_RISE_GRAVITY_MULTIPLIER
		else:
			gravity_multiplier = JUMP_CANCEL_GRAVITY_MULTIPLIER
	elif velocity.y > EPSILON && !is_on_floor():
		gravity_multiplier = JUMP_FALL_GRAVITY_MULTIPLIER

	var new_gravity = (2.0 * JUMP_HEIGHT * JUMP_RISE_GRAVITY_MULTIPLIER) / (JUMP_TIME * JUMP_TIME)
	gravity_multiplier *= (new_gravity / gravity)
	return gravity_multiplier

func flip_sprite_to_look_direction():
	if look_direction > 0:
		animated_sprite.flip_h = false
	elif look_direction < 0:
		animated_sprite.flip_h = true

func play_animation():
	if id_dead:
		animated_sprite.play("death")
		return

	if is_on_floor():
		if velocity.x == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func die(knockback):
	if id_dead:
		return
	id_dead = true
	velocity = knockback
	Events.player_died.emit()
	$DeathSound.play()

func restart():
	Events.player_restarted.emit()
