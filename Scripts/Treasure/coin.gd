extends RigidBody2D

@export var _value : int = 1
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	_sfx.play()
	if not body is Character:
		return
	collision_mask = 0
	_sprite.play("effect")
	print("Coin picked up")
	await _sprite.animation_finished 
	queue_free()
 
