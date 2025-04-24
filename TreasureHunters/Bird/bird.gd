class_name Bird extends AnimatedSprite2D

@onready var life_timer: Timer = $LifeTimer

@export var _fly_speed: float = 500



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= _fly_speed 


func _on_life_timer_timeout() -> void:
	queue_free()
	print("Bird_gone")
	
