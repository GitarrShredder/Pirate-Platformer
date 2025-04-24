extends Area2D

var BIRD = preload("res://TreasureHunters/Bird/bird.tscn")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var bird_spawner: Node = $BirdSpawner
@onready var bird_l: Marker2D = $BirdL
@onready var bird_u: Marker2D = $BirdU
@onready var bird_timer: Timer = $BirdTimer
#@onready var bird_life_timer: Timer = $BirdLifeTimer

@onready var _area: CollisionShape2D = $CollisionShape2D
@onready var _half_size : Vector2 = _area.shape.get_rect().size / 2


#func _process(delta: float) -> void:
	#if Character is 

func _ready() -> void:
	spawn_bird()
	#audio_stream_player.play()

func get_min() -> Vector2:
	return _area.position - _half_size
	
func get_max() -> Vector2:
	return _area.position + _half_size


func spawn_bird() -> void:
	var _new_bird = BIRD.instantiate()
	var y_pos: float = randf_range(bird_u.position.y, bird_l.position.y)
	_new_bird.position = Vector2(bird_u.position.x,y_pos)
	
	#var random_size: float = randf_range(0.2,1)
	#_new_bird.scale  = Vector2.ONE * randf_range(0.2, 1)
	bird_spawner.add_child(_new_bird)
	
	
		


func _on_bird_timer_timeout() -> void:
	spawn_bird() 
