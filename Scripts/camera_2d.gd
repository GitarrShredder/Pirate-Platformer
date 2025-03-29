extends Camera2D

@export var _subject : Node2D
@export var _offset : Vector2
@export var _duration : float = 1
@onready var  _look_ahead_distance: float = _offset.x	
var _look_ahead_tween : Tween
var _floor_heigt_tween: Tween

func _ready() -> void:
	_offset *= Global.ppt

func _process(delta: float) -> void:
	position.x = _subject.position.x +_offset.x + _look_ahead_distance

func _on_subject_changed_direction(is_facing_left: bool) -> void:
	if _look_ahead_tween && _look_ahead_tween.is_running():
		_look_ahead_tween.kill()
	_look_ahead_tween = create_tween()
	_look_ahead_tween.tween_property(self,"_look_ahead_distance", _offset.x*(-1 if is_facing_left else 1), _duration)

func _on_subject_landed(floor_height: float) -> void:
	position.y =floor_height + _offset.y # Replace with function body.
