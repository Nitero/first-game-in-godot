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

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _input_direction: float
var _desired_velocity: Vector2

var _is_jump_desired: bool
var _is_jump_pressed: bool
var _is_jump_ongoing: bool
var _jump_buffer_timer: float

var _coyote_time_timer: float

var _is_dead: bool

@onready var _animated_sprite = $AnimatedSprite2D

func _input(_event):
	if _is_dead:
		_input_direction = 0
		_desired_velocity = velocity
		_is_jump_desired = false
		_is_jump_pressed = false
		return
	_input_direction = Input.get_axis("move_left", "move_right")#-1 | 0 | 1
	_desired_velocity = Vector2(_input_direction, 0) * max(0, GROUND_MAX_RUN_SPEED)
	if Input.is_action_just_pressed("jump"):
		_is_jump_desired = true
	_is_jump_pressed = Input.is_action_pressed("jump")
	if Input.is_action_just_pressed("restart"):
		_restart()

func _process(delta):
	_poll_jump_buffer(delta)
	_poll_coyote_time(delta)
	_flip_sprite_to_input_direction()
	_play_animation()

func _physics_process(delta):
	_move_horizontally(delta)
	_move_vertically(delta)
	move_and_slide()

func _move_horizontally(delta):
	var acceleration = GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	var deceleration = GROUND_DECELERATION if is_on_floor() else AIR_DECELERATION
	var turn_speed = GROUND_TURN_SPEED if is_on_floor() else AIR_TURN_SPEED

	var change_speed

	if _input_direction != 0:
		if _input_direction != sign(velocity.x):
			change_speed = turn_speed
		else:
			change_speed = acceleration
	else:
		change_speed = deceleration

	velocity.x = move_toward(velocity.x, _desired_velocity.x, change_speed * delta)

func _poll_jump_buffer(delta):
	if JUMP_BUFFER <= 0 || !_is_jump_desired:
		return
	_jump_buffer_timer += delta
	if _jump_buffer_timer > JUMP_BUFFER:
		_is_jump_desired = false
		_jump_buffer_timer = 0

func _poll_coyote_time(delta):
	if !_is_jump_ongoing && !is_on_floor():
		_coyote_time_timer += delta
	else:
		_coyote_time_timer = 0

func _move_vertically(delta):
	if is_on_floor():
		_is_jump_ongoing = false

	var gravity_multiplier = _get_gravity_multiplier()
	if _is_jump_desired:
		_execute_jump(gravity_multiplier)
	if !is_on_floor():
		velocity.y += _gravity * gravity_multiplier * delta

	velocity.y = clamp(velocity.y, -JUMP_SPEED_LIMIT, FALL_SPEED_LIMIT)

func _execute_jump(gravity_multiplier):
	if is_on_floor() || (_coyote_time_timer > EPSILON && _coyote_time_timer < COYOTE_TIME):
		_is_jump_ongoing = true
		_is_jump_desired = false
		_jump_buffer_timer = 0
		_coyote_time_timer = 0

		var jump_speed = sqrt(2.0 * _gravity * gravity_multiplier * JUMP_HEIGHT * JUMP_RISE_GRAVITY_MULTIPLIER)
		velocity.y -= jump_speed

func _get_gravity_multiplier():
	var gravity_multiplier = DEFAULT_GRAVITY_MULTIPLIER

	if velocity.y < -EPSILON && !is_on_floor():
		if _is_jump_pressed && _is_jump_ongoing:
			gravity_multiplier = JUMP_RISE_GRAVITY_MULTIPLIER
		else:
			gravity_multiplier = JUMP_CANCEL_GRAVITY_MULTIPLIER
	elif velocity.y > EPSILON && !is_on_floor():
		gravity_multiplier = JUMP_FALL_GRAVITY_MULTIPLIER

	var new_gravity = (2.0 * JUMP_HEIGHT * JUMP_RISE_GRAVITY_MULTIPLIER) / (JUMP_TIME * JUMP_TIME)
	gravity_multiplier *= (new_gravity / _gravity)
	return gravity_multiplier

func _flip_sprite_to_input_direction():
	if _input_direction > 0:
		_animated_sprite.flip_h = false
	elif _input_direction < 0:
		_animated_sprite.flip_h = true

func _play_animation():
	if _is_dead:
		_animated_sprite.play("death")
		return

	if is_on_floor():
		if velocity.x == 0:
			_animated_sprite.play("idle")
		else:
			_animated_sprite.play("run")
	else:
		_animated_sprite.play("jump")

func die(knockback):
	if _is_dead:
		return
	_is_dead = true
	velocity = knockback
	SignalBus.player_died.emit()
	$DeathSound.play()

func _restart():
	SignalBus.player_restarted.emit()