extends CharacterBody3D

# type safety
#@export var speed : float= 5.0 

@export var speed := 5.0  # does not show in inspector panel without export

@onready var camera:Node3D = $CameraRig/Camera3D

const JUMP_VELOCITY = 4.5

#func get_boosted_Speed(boost_multiplier):
	#return speed * boost_multiplier

#func _ready() -> void:
	#print("Print Boosted Speed")
	#print(get_boosted_Speed(10))

#func _process(delta: float) -> void:
	#print('processing')

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
#
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
#
	move_and_slide()
	turn_to(direction)
	
	
func turn_to(direction:Vector3) -> void:
	if direction.length() > 0:
		var yaw:= atan2(-direction.x, -direction.y)
		yaw = lerp_angle(rotation.y, yaw, 0.25)
		rotation.y = yaw
