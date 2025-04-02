extends Area2D

@export var _splash : PackedScene
@onready var _splashsfx: AudioStreamPlayer2D = $WaterSplash
@onready var _splash_exit: AudioStreamPlayer2D = $WaterSplash2

@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2

var _splashsfx_has_played: bool = false
var _splash_exit_has_played : bool = false


func _spawn_splash_enter(x: float):
	var splash = _splash.instantiate()
	add_child(splash)
	splash.global_position.x = x
	if _splashsfx_has_played == true:
		return
	else:
		_splashsfx.play()
		_splashsfx_has_played = true
		timer.start()
		print("timer start")
		
func _spawn_splash_exit(x: float):
	var splash = _splash.instantiate()
	add_child(splash)
	splash.global_position.x = x
	if _splash_exit_has_played == true:
		return
	else:
		_splash_exit.play()
		print("splash 2")
		_splash_exit_has_played = true
		timer_2.start()
		print("timer 2 start")

func _on_body_entered(body: Node2D) -> void:
	if body is TileMap:
		return
	_spawn_splash_enter(body.position.x)
	if body is Character:
		body.enter_water(position.y)


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		if body.position.y -float(Global.ppt) / 2 <= position.y:
			body.exit_water()
			_spawn_splash_exit(body.position.x)
		else:
			body.dive()
			


func _on_timer_timeout() -> void:
	_splashsfx_has_played = false
	print(" timeout") # Replace with function body.


func _on_timer_2_timeout() -> void:
	_splash_exit_has_played = false
	 # Replace with function body.
