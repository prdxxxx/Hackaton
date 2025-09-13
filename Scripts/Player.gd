extends CharacterBody3D

# -------------------- Переменные движения --------------------
var t_bob: float = 0.0
var fov: float = 80.0
var speed: float = 1.0
var Sensitivity: float = 2.0
var player_ref: CharacterBody3D = null

const walkingSpeed: float = 2.0
const runningSpeed: float = 3.6
const JUMP_VELOCITY: float = 4.5
const gravity: float = 9.8
const bob_freq: float = 4.0
const bob_amp: float = 0.03
const fovChange: float = 1.4

# -------------------- Ссылки --------------------
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var ray: RayCast3D = $Head/Camera3D/RayCast3D
@onready var icon: Sprite2D = $CanvasLayer/E
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"

# -------------------- FOOTSTEPS --------------------
@onready var footstep_player: AudioStreamPlayer = $PlayerAudio/Footstep
@onready var groundcheck: RayCast3D = $PlayerAudio/GroundCheck
var step_sounds: Array[AudioStream] = []
var step_timer: float = 0.0
var base_step_interval: float = 0.5  # базовый интервал шага

# -------------------- UI Interaction --------------------
var current_pos: Vector2
var target_pos: Vector2

# -------------------- Ready --------------------
func _ready():
	player_ref = self
	_on_pausemenu__load()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Загружаем FOV и сенсу
	var cfg = ConfigFile.new()
	if cfg.load("user://config.cfg") == OK:
		fov = cfg.get_value("Graphics", "fov", fov)
		Sensitivity = cfg.get_value("Controls", "sensitivity", Sensitivity)
	camera.fov = fov

	# Эффекты графики
	var ssao = load_config("user://config.cfg", "Graphics", "SSAO", true)
	var sdfgi = load_config("user://config.cfg", "Graphics", "SDFGI", true)
	var glow = load_config("user://config.cfg", "Graphics", "Glow", true)
	world_environment.environment.ssao_enabled = ssao
	world_environment.environment.sdfgi_enabled = sdfgi
	world_environment.environment.glow_enabled = glow

	# Загружаем звуки шагов
	step_sounds = [
		preload("res://Assets/SFX/footstep.mp3")
	]

	# Инициализация иконки взаимодействия
	icon.visible = false
	current_pos = icon.position
	target_pos = icon.position


# -------------------- Config --------------------
func load_config(path, section, key, default_value):
	var cfg = ConfigFile.new()
	if cfg.load(path) != OK:
		return default_value
	return cfg.get_value(section, key, default_value)


# -------------------- Input --------------------
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * Sensitivity / 1000.0)
		camera.rotate_x(-event.relative.y * Sensitivity / 1000.0)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-62), deg_to_rad(82))


# -------------------- Physics --------------------
func _physics_process(delta: float) -> void:
	# Настройки
	var cfg = ConfigFile.new()
	if cfg.load("user://config.cfg") == OK:
		fov = cfg.get_value("Graphics", "fov", fov)
		Sensitivity = cfg.get_value("Controls", "sensitivity", Sensitivity)

	# Скорость
	speed = runningSpeed if Input.is_action_pressed("Sprint") else walkingSpeed

	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Прыжок
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Движение
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction.length() > 0:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * 8.0)
			velocity.z = lerp(velocity.z, 0.0, delta * 8.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

	# Камера + headbob
	var offset := Vector3.ZERO
	if direction.length() > 0.1 and is_on_floor():
		t_bob += delta * velocity.length()
		offset = _headbob(t_bob)
	else:
		offset = camera.transform.origin.lerp(Vector3.ZERO, delta * 5.0)
	camera.transform.origin = offset

	# FOV при движении
	var velocity_clamped = clamp(velocity.length(), 0.5, runningSpeed * 2)
	var targetFov = fov + fovChange * velocity_clamped
	camera.fov = lerp(camera.fov, targetFov, delta * 4.0)

	move_and_slide()

	# --- FOOTSTEPS ---
	if is_on_floor() and velocity.length() > 0.1:
		step_timer -= delta
		if step_timer <= 0.0:
			_play_footstep()
			# корректируем интервал по скорости
			step_timer = base_step_interval / (speed / walkingSpeed)
	else:
		step_timer = 0.0

	# --- UI Interaction ---
	_process_interaction(delta)


# -------------------- Headbob --------------------
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2.0) * bob_amp
	return pos


# -------------------- Footsteps --------------------
func _play_footstep():
	if not step_sounds.is_empty() and groundcheck.is_colliding():
		footstep_player.stream = step_sounds[randi() % step_sounds.size()]
		footstep_player.pitch_scale = randf_range(0.8, 1.0)
		footstep_player.play()


# -------------------- Interaction --------------------
func _process_interaction(delta: float) -> void:
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and "Switch" in collider.name:
			if Input.is_action_just_pressed("Interaction"):
				collider.get_parent().toggle_light()
		elif collider and collider.is_in_group("Interaction"):
			var collision_point = ray.get_collision_point()
			var screen_pos = get_viewport().get_camera_3d().unproject_position(collision_point)
			target_pos = screen_pos
			if not icon.visible:
				icon.visible = true
	else:
		if icon.visible:
			icon.visible = false
		target_pos = current_pos

	current_pos = current_pos.lerp(target_pos, delta * 30.0)
	icon.position = current_pos


# -------------------- SAVE / LOAD --------------------
func _on_pausemenu__save() -> void:
	if player_ref:
		SaveLoad.SaveFileData.player_position = player_ref.global_position
		SaveLoad.SaveFileData.rotation["player_rotation"] = player_ref.rotation
		SaveLoad.SaveFileData.rotation["camera_rotation"] = camera.rotation
		SaveLoad._save()

func _on_pausemenu__load() -> void:
	if player_ref:
		SaveLoad._load()
		player_ref.global_position = SaveLoad.SaveFileData.player_position
		player_ref.velocity = Vector3.ZERO
		player_ref.rotation = SaveLoad.SaveFileData.rotation["player_rotation"]
		camera.rotation = SaveLoad.SaveFileData.rotation["camera_rotation"]


func _on_camera_3d_exit_pc() -> void:
	exit_pc.emit()
