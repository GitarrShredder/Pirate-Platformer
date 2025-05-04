extends Node2D
@onready var _camera: Camera2D = $Camera2D
@onready var _level: Area2D = $Level
@onready var _player_character: Character = $Roger
@onready var _coin_counter: Control = $UserInterface/CoinCounter
@onready var _lives_counter: Control = $UserInterface/LivesCounter



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_boundaries()
	_init_ui()
	
	
func _init_ui():
	_coin_counter.set_value(File.data.coins)
	_lives_counter.set_value(File.data.lives)
	
func _init_boundaries():
	var min_boundary : Vector2 = _level.get_min()
	var max_boundary : Vector2 = _level.get_max()
	_camera.set_bounds(min_boundary, max_boundary)
	_player_character.set_bounds(min_boundary,max_boundary)
	


func collect_coin(value: int):
	File.data.coins += value
	if  File.data.coins >= 100:
		File.data.coins -= 100
		File.data.lives += 1
		_coin_counter.set_value(File.data.coins)
	_lives_counter.set_value(File.data.lives)

func collect_skull():
	File.data.lives += 1
	_lives_counter.set_value(File.data.lives)
	
