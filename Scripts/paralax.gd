extends Node2D
@export var _scroll_speed : float = -100
@export var _width : float = 448

@onready var big_clouds: Sprite2D = $BigClouds
@onready var big_clouds_2: Sprite2D = $BigClouds2
@onready var small_cloud_1: Sprite2D = $SmallCloud1
@onready var small_cloud_2: Sprite2D = $SmallCloud2
@onready var small_cloud_3: Sprite2D = $SmallCloud3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_scroll(big_clouds, _scroll_speed * delta)
	_scroll(big_clouds_2,_scroll_speed * delta)
	_scroll(small_cloud_1, _scroll_speed * delta / 7)
	_scroll(small_cloud_2, _scroll_speed * delta / 5)
	_scroll(small_cloud_3, _scroll_speed * delta / 3)
	
	
func _scroll(cloud : Node2D, distance: float):
	cloud.position.x *= distance
	if cloud.position.x < _width * -1:
		cloud.position.x += _width *2
