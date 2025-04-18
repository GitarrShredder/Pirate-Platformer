extends Node2D
@onready var _camera: Camera2D = $Camera2D
@onready var _level: Area2D = $Level
@onready var _player_character: Character = $Roger


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var min_boundary : Vector2 = _level.get_min()
	var max_boundary : Vector2 = _level.get_max()
	_camera.set_bounds(min_boundary, max_boundary)
	_player_character.set_bounds(min_boundary,max_boundary)


# Called every frame. 'delta' is the elapsed time since the previous frame.
