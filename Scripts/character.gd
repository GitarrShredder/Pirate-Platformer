extends CharacterBody2D




@export_category("Locomotion")
@export var  _speed: float = 8
@export var _acceleration: float = 16
@export var _deceleration: float = 32


@export_category("Jump")
@export var _jump_height: float = 2.5
@export var _air_control: float = 0.5
@export var _jump_dust: PackedScene
var _jump_velocity: float 

@onready var _sprite_2d: Sprite2D = $Sprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction : float

#region Public Methods

func face_left():
	_sprite_2d.flip_h = true
	
func face_right():
	_sprite_2d.flip_h = false

func run(direction : float):
	_direction = direction
	
func jump():
	if is_on_floor():
		velocity.y = _jump_velocity
		_spawn_dust(_jump_dust)

func stop_jump():
	if velocity.y < 0: #decreasing?
		velocity.y = 0
#endregion

func _ready() -> void:
	_speed *= Global.ppt
	_acceleration *= Global.ppt
	_deceleration *=Global.ppt
	_jump_height *= Global.ppt
	_jump_velocity = sqrt(_jump_height * gravity * 2) * -1

func _physics_process(delta: float) -> void:
	if sign(_direction) == -1:
		face_left()
	elif sign(_direction) ==1:
		face_right()
	
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	move_and_slide()
	# Add the gravity.
func _ground_physics(delta : float):
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
	#accelerate from not moving or moving in the same direction
	elif velocity.x == 0 || sign(_direction)== sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)
	#decelerate if trying to move in the opposite direction
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _deceleration * delta)

func _air_physics(delta :float):
	velocity.y += gravity * delta
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)

func _spawn_dust(dust: PackedScene):
	var _dust = dust.instantiate()
	_dust.position = position
	_dust.flip_h = _sprite_2d.flip_h
	get_parent().add_child(_dust)
