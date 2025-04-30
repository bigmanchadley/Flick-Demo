extends Node2D

# scenes
const CAR_SCENE = preload("res://scenes/car.tscn")
const COUNTDOWN_SCENE = preload("res://scenes/countdown.tscn")
const STOPWATCH_SCENE = preload("res://scenes/stopwatch.tscn")
# assets
const CAR_RED = preload("res://art/car_assets/redcar.png")
const CAR_BLACK = preload("res://art/car_assets/blackcar.png")
const CAR_YELLOW = preload("res://art/car_assets/yellowcar.png")



# Instantiate
	#Players
var p1
var p2
	#Countdown
var countdown
	#stopwatch (includes laptimers) # desperately needs to be decoupled or made intelligent (give locations to children somehow)
var stopwatch



# Switch to new locations-node model for better level design
var starting_position_1 = Vector2(-245, -430)
var starting_position_2 = Vector2(-245, -400)
var starting_position_3 = Vector2(-245, -370)

var player_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_players()
	#start_countdown()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_countdown():
	if countdown != null:
		countdown.queue_free()
		countdown = null
	countdown = COUNTDOWN_SCENE.instantiate()
	countdown.position = $locations/countdown_location.position
	add_child(countdown)

func start_laps():
	if stopwatch != null:
		stopwatch.queue_free()
		stopwatch = null
	stopwatch = STOPWATCH_SCENE.instantiate()
	stopwatch.position = $locations/stopwatch_location.position # This is still giga hardcoded since there is only 1 stopwatch location for 3 labels
	add_child(stopwatch)

func spawn_players():
	if p1:
		p1.queue_free()
		p1 = null
	if p2:
		p2.queue_free()
		p2 = null

	if player_count >= 1:
		p1 = CAR_SCENE.instantiate()
		p1.position = starting_position_1
		var p1_car = p1.get_node("Car")
		var p1_sprite = p1_car.get_node("Sprite2D")
		p1_sprite.texture = CAR_RED
		p1_car.input_up = "P1_Forward"
		p1_car.input_down = "P1_Backward"
		p1_car.input_left = "P1_Left"
		p1_car.input_right = "P1_Right"
		add_child(p1)
	if player_count >= 2:
		p2 = CAR_SCENE.instantiate()
		p2.position = starting_position_2
		var p2_car = p2.get_node("Car")
		var p2_sprite = p2_car.get_node("Sprite2D")
		p2_sprite.texture = CAR_BLACK
		p2_car.input_up = "P2_Forward"
		p2_car.input_down = "P2_Backward"
		p2_car.input_left = "P2_Left"
		p2_car.input_right = "P2_Right"
		add_child(p2)


func _on_add_drop_player_pressed():
	player_count += 1
	if player_count > 2:
		player_count = 1
	spawn_players()
	if player_count > 0:
		start_countdown()
		start_laps()
