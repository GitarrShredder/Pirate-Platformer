class_name Treasure extends CollisionObject2D


@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _collect():
	#$/root/Game.collect_coin(_value)
	pass


func _on_body_entered(body: Node) -> void:
	_sfx.play()
	if not body is Character:
		return
	collision_mask = 0
	_sprite.play("effect")
	_collect()
	await _sprite.animation_finished 
	queue_free()
