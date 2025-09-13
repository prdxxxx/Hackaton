extends CharacterBody3D

var t_bob = 0.0
var fov = 80           
var speed = 1.0
var Sensitivity = 2.0
var player_ref : CharacterBody3D = null
  
const walkingSpeed = 2.0
const runningSpeed = 3.6
const JUMP_VELOCITY = 4.5
const gravity = 9.8
const bob_freq = 4.0
const bob_amp = 0.03
const fovChange = 1.4

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var ray = $Head/Camera3D/RayCast3D
@onready var icon = $CanvasLayer/E
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"

func _ready():
	player_ref = self
	_on_pausemenu__load()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var path = "user://config.cfg"
	var cfg = ConfigFile.new()
	
	var err = cfg.load(path)
	if err == OK:
		fov = cfg.get_value("Graphics", "fov", fov)
		Sensitivity = cfg.get_value("Controls", "sensitivity", Sensitivity)
	
	camera.fov = fov
	
	var ssao = load_config("user://config.cfg", "Graphics", "SSAO", true)
	var sdfgi = load_config("user://config.cfg", "Graphics", "SDFGI", true)
	var glow = load_config("user://config.cfg", "Graphics", "Glow", true)

	world_environment.environment.ssao_enabled = ssao
	world_environment.environment.sdfgi_enabled = sdfgi
	world_environment.environment.glow_enabled = glow



func load_config(path, section, key, default_value):
	var cfg = ConfigFile.new()
	var err = cfg.load(path)
	if err != OK:
		return default_value
	return cfg.get_value(section, key, default_value)
	


func _unhandled_input(event):
	var cfg = ConfigFile.new()
	if cfg.load("user://config.cfg") == OK:
		Sensitivity = cfg.get_value("Controls", "sensitivity", Sensitivity)

	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * Sensitivity / 1000)
		camera.rotate_x(-event.relative.y * Sensitivity / 1000)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-62), deg_to_rad(82))

func _physics_process(delta):
	var cfg = ConfigFile.new()
	if cfg.load("user://config.cfg") == OK:
		fov = cfg.get_value("Graphics", "fov", fov)
		Sensitivity = cfg.get_value("Controls", "sensitivity", Sensitivity)

	if Input.is_action_pressed("Sprint"):
		speed = runningSpeed
	else:
		speed = walkingSpeed

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

	var offset := Vector3.ZERO
	if direction.length() > 0.1 and is_on_floor():
		t_bob += delta * velocity.length()
		offset = _headbob(t_bob)
	else:
		offset = camera.transform.origin.lerp(Vector3.ZERO, delta * 5.0)

	camera.transform.origin = offset

	var velocity_clamped = clamp(velocity.length(), 0.5, runningSpeed * 2)
	var targetFov = fov + fovChange * velocity_clamped
	camera.fov = lerp(camera.fov, targetFov, delta * 4.0)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2.0) * bob_amp
	return pos

var current_pos : Vector2
var target_pos : Vector2

func _ready2():
	icon.visible = false
	current_pos = icon.position

func _process(delta):
	if ray.is_colliding():
		var collision_point = ray.get_collider()
		if "ElectricBox_Switch" in collision_point.name:
			if Input.is_action_just_pressed("Interaction"):
				collision_point.get_parent().toggle_light()
		elif "Storage_Switch" in collision_point.name:
			if Input.is_action_just_pressed("Interaction"):
				collision_point.get_parent().toggle_light()
		elif "Hall_Switch" in collision_point.name:
			if Input.is_action_just_pressed("Interaction"):
				collision_point.get_parent().toggle_light()
		elif "Walls_Switch" in collision_point.name:
			if Input.is_action_just_pressed("Interaction"):
				collision_point.get_parent().toggle_light()
		elif "Stairs_Switch" in collision_point.name:
			if Input.is_action_just_pressed("Interaction"):
				collision_point.get_parent().toggle_light()
		elif "2_Floor_Switch" in collision_point.name:
			if Input.is_action_just_pressed("Interaction"):
				collision_point.get_parent().toggle_light()


	else:
		if ray.is_colliding() and ray.get_collider().is_in_group("Interaction"):
			var collision_point = ray.get_collision_point()  
			var screen_pos = get_viewport().get_camera_3d().unproject_position(collision_point)
			target_pos = screen_pos
			if !icon.visible:
				icon.visible = true
		else:
			if icon.visible:
				icon.visible = false
			target_pos = current_pos  

	current_pos = current_pos.lerp(target_pos, delta * 30.0)
	icon.position = current_pos



func _on_pausemenu__save() -> void:
	if player_ref:
		SaveLoad.SaveFileData.player_position = player_ref.global_position
		SaveLoad.SaveFileData.rotation["player_rotation"] = player_ref.rotation
		SaveLoad.SaveFileData.rotation["camera_rotation"] = camera.rotation

		SaveLoad._save()

func _on_pausemenu__load() -> void:
	if player_ref:
		SaveLoad._load()
		var pos = SaveLoad.SaveFileData.player_position 
		player_ref.global_position = pos
		player_ref.velocity = Vector3.ZERO  
		
		player_ref.rotation = SaveLoad.SaveFileData.rotation["player_rotation"]
		camera.rotation = SaveLoad.SaveFileData.rotation["camera_rotation"]
