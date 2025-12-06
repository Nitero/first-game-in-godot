extends GutTest

var player_scene = load("res://project/features/player/player.tscn")

const LOOP_SAFETY = 100000
const DELTA = 1.0 / 60.0
const POSITION_EPSILON = 0.02

var input_sender = InputSender.new(Input)

func after_each():
	input_sender.release_all()
	input_sender.clear()

func create_floor() -> CollisionShape2D:
	var floor_body = StaticBody2D.new()
	var collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()

	collision_shape.shape = rect_shape
	floor_body.add_child(collision_shape)
	add_child_autofree(floor_body)
	return collision_shape

func create_player(floor_collision_shape: CollisionShape2D) -> Player:
	var player: Player = player_scene.instantiate()
	add_child_autofree(player)

	var floor_height = floor_collision_shape.shape.size.y
	player.position = floor_collision_shape.position + Vector2.UP * floor_height * 0.5
	return player

func test_jump_apex_height_and_duration() -> void:
	var player = create_player(create_floor())
	await wait_physics_frames(10)
	var start_y = player.position.y

#	input_sender.action_down("jump")#TODO: get it working using input simulation
	player.is_jump_desired = true
	player.is_jump_pressed = true

	var highest_y = player.position.y
	var last_y = player.position.y
	var current_time = 0.0
	var time_at_highest = 0.0
	var is_jump_ongoing = false

	var loop_safety_counter = 0
	while loop_safety_counter < LOOP_SAFETY:
		loop_safety_counter += 1
#		gut.simulate(player, 1, DELTA)
		await wait_physics_frames(1)
		current_time += DELTA

		if is_jump_ongoing && last_y >= start_y - POSITION_EPSILON:
			break

		if player.position.y < highest_y:
			highest_y = player.position.y
			time_at_highest = current_time
			is_jump_ongoing = true

		last_y = player.position.y

	var measured_height = start_y - highest_y
	assert_almost_eq(measured_height, float(Player.JUMP_HEIGHT), 2.0)
	assert_almost_eq(time_at_highest, float(Player.JUMP_TIME), 0.05)