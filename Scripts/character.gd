class_name Character extends CharacterBody2D

var _is_bound : bool
var _min : Vector2
var _max : Vector2


@export_category("Locomotion")
@export var  _speed: float = 8
@export var _acceleration: float = 16
@export var _deceleration: float = 32


@export_category("Jump")
@export var _jump_height: float = 2.5
@export var _air_control: float = 0.5
@export var _jump_dust: PackedScene
@export var _jump_velocity: float 
var _was_on_floor : bool

@export_category("Sprite")
@export var _is_facing_left : bool
@export var _sprites_face_left : bool
@onready var _sprite: Sprite2D = $Sprite2D


@export_category("swim")
@export var _density : float = -0.1
@export var _drag : float = 0.5 #downward pull, slowing down
var _water_surface_height : float
var _is_in_water : bool
var _is_below_surface : bool


signal changed_direction(_is_facing_left : bool)  
signal landed(floor_height : float)


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction : float

#region Public Methods

func face_left():
	_is_facing_left = true
	_sprite.flip_h = true
	changed_direction.emit(_is_facing_left)
		
func face_right():
	_is_facing_left = false
	_sprite.flip_h = false
	changed_direction.emit(_is_facing_left)
	
func run(direction : float):
	_direction = direction
	
func jump():
	if _is_in_water:
		if _is_below_surface:
			velocity.y = _jump_velocity * _drag
			landed.emit(position.y)
		else:
			velocity.y = _jump_velocity
	
	elif is_on_floor():
		velocity.y = _jump_velocity
		_spawn_dust(_jump_dust)
		
func stop_jump():
	if velocity.y < 0 and not _is_in_water: #decreasing?
		velocity.y = 0
#endregion

func enter_water(water_surface_height : float):
	_water_surface_height = water_surface_height
	_is_in_water = true
	_is_below_surface = false
	landed.emit(position.y)
	if velocity.y > 0:
		velocity.y *= _drag
	
func exit_water():
	_is_in_water = false
	print("exit water")
	

func dive():
	_is_below_surface = true
	

func _ready() -> void:
	_speed *= Global.ppt
	_acceleration *= Global.ppt
	_deceleration *=Global.ppt
	_jump_height *= Global.ppt
	_jump_velocity = sqrt(_jump_height * gravity * 2) * -1
	face_left() if _is_facing_left else face_right()
	
func set_bounds(min_boundary: Vector2, max_boundary : Vector2):
	_is_bound = true
	_min = min_boundary
	_max = max_boundary
	var sprite_size : Vector2 = _sprite.get_rect().size
	_min.x += sprite_size.x / 2
	_max.x -= sprite_size.x / 2
	_min.y += sprite_size.y 

	

func _physics_process(delta: float) -> void:
	if not _is_facing_left and sign(_direction) == -1:
		face_left()
	elif _is_facing_left and sign(_direction) ==1:
		face_right()
	if _is_in_water:
		_water_physics(delta)
	
	elif is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	_was_on_floor = is_on_floor()
	move_and_slide()
	if not _was_on_floor and is_on_floor():
		_landed()
	if _is_bound:
		position.x = clamp(position.x, _min.x, _max.x)
		position.y = clamp(position.y, _min.y, _max.y)
	
	# Add the gravity.
func _ground_physics(delta : float):
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
	#accelerate from not moving or moving in the same direction
	elif velocity.x == 0 or sign(_direction)== sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * delta)
	#decelerate if trying to move in the opposite direction
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _deceleration * delta)

func _air_physics(delta :float):
	velocity.y += gravity * delta
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * _air_control * delta)

func _water_physics(delta: float):
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * _drag * delta)
		#print("1")
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration * _drag * delta)
		#print("2")
	if _is_below_surface or _density >0:
		velocity.y = move_toward(velocity.y, gravity * _density * _drag, gravity * _drag * delta)
		#print("3")
	elif position.y -float(Global.ppt) / 4 >_water_surface_height:
		velocity.y = move_toward(velocity.y, gravity * _density * _drag, gravity * _drag * delta)
		#print("4")
	else:
		velocity.y = move_toward(velocity.y, gravity * _density * _drag * -1, gravity * _drag * delta)
		#print("5")
		
func _landed():
	landed.emit(position.y)
	print("Roger landed")

func _spawn_dust(dust: PackedScene):
	var _dust = dust.instantiate()
	_dust.position = position
	_dust.flip_h = _sprite.flip_h
	get_parent().add_child(_dust)


func _on_changed_direction(_is_facing_left: bool) -> void:
	pass 
