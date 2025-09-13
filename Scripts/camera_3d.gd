extends Camera3D

# -------------------- Ссылки --------------------
@onready var target_position = get_node("/root/World/Apartamentu/chair/Looking_at_monitor")
@onready var player = get_parent().get_parent()
@onready var head = player.get_node("Head")
@onready var original_local_transform = transform
@onready var player_mesh = player.get_node("MeshInstance3D")
@onready var icon = player.get_node("CanvasLayer/E")
@onready var podskaz = get_node("/root/World/Apartamentu/chair/Looking_at_monitor/Label")
@onready var chair_area = target_position.get_node("/root/World/Apartamentu/chair/Chair/Area3D")

# -------------------- Состояния --------------------
var is_teleported = false
var is_animating = false
var icon_locked = false
var mouse_locked = false
var can_sit = false

# Мышь
var mouse_sensitivity = 0.003
var yaw := 0.0
var pitch := 0.0

# PC UI
const PC_START_SCENE := preload("res://Scenes/PCUI/pc_start.tscn")
const PCUI_SCENE := preload("res://Scenes/PCUI/pcui.tscn")
var pc_instance: Node = null  # login screen или PCUI

# -------------------- Ready --------------------
func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS  # Важно, чтобы работало при паузе
	if podskaz:
		podskaz.visible = false
	chair_area.body_entered.connect(_on_chair_body_entered)
	chair_area.body_exited.connect(_on_chair_body_exited)

# -------------------- Chair Trigger --------------------
func _on_chair_body_entered(body):
	if body == player:
		can_sit = true
		if icon and not icon_locked:
			icon.show()

func _on_chair_body_exited(body):
	if body == player:
		can_sit = false
		if icon:
			icon.hide()

# -------------------- Input --------------------
func _unhandled_input(event):
	if PcManager.ui_active:
		return  # блокируем камеру при активном ПК

	# Телепортация
	if event.is_action_pressed("Interaction") and can_sit and not is_teleported:
		teleport_to_target()
		return

	if is_animating:
		return

	if is_teleported:
		if event.is_action_pressed("Interaction"):
			return_to_player()
		elif event.is_action_pressed("Zoom"):
			toggle_pc_login()
		elif event.is_action_pressed("Cancel"):  # Ctrl
			close_pc()
		elif event is InputEventMouseMotion and not mouse_locked:
			yaw -= event.relative.x * mouse_sensitivity
			pitch -= event.relative.y * mouse_sensitivity
			pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(60))
			yaw = clamp(yaw, deg_to_rad(-90), deg_to_rad(90))
		rotation = Vector3(pitch, yaw, 0)

# -------------------- Process --------------------
func _process(delta):
	if podskaz:
		podskaz.visible = is_teleported and can_sit

	# Автоматический выход с ПК при выключении света
	if is_teleported and not Events.main_light_on:
		if pc_instance and pc_instance.is_inside_tree():
			print("[!] Свет выключен! Выход с ПК...")
			return_to_player()
			close_pc()

# -------------------- PC / Login --------------------
func toggle_pc_login():
	if pc_instance and pc_instance.is_inside_tree():
		close_pc()
		return

	PcManager.ui_active = true

	if PcManager.login_completed:
		open_pcui_direct()
		return

	pc_instance = PC_START_SCENE.instantiate()
	pc_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(pc_instance)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func open_pcui_direct():
	if pc_instance and pc_instance.is_inside_tree():
		pc_instance.queue_free()
	pc_instance = PCUI_SCENE.instantiate()
	pc_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(pc_instance)
	PcManager.login_completed = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close_pc():
	if pc_instance and pc_instance.is_inside_tree():
		pc_instance.queue_free()
		pc_instance = null
	PcManager.ui_active = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# -------------------- Телепортация --------------------
func teleport_to_target():
	icon.hide()
	is_animating = true
	icon_locked = true
	if player_mesh:
		player_mesh.visible = false

	var tween = create_tween()
	tween.tween_property(self, "global_transform", target_position.global_transform, 1.0)
	tween.tween_callback(func():
		get_parent().remove_child(self)
		target_position.add_child(self)
		transform = Transform3D()
		is_teleported = true
		is_animating = false
		yaw = rotation.y
		pitch = rotation.x
	)

func return_to_player():
	is_animating = true
	mouse_locked = false
	var target_transform = head.global_transform * original_local_transform
	var tween = create_tween()
	tween.tween_property(self, "global_transform", target_transform, 1.0)
	tween.tween_callback(func():
		get_parent().remove_child(self)
		head.add_child(self)
		transform = original_local_transform
		is_teleported = false
		is_animating = false
		icon_locked = false
		if player_mesh:
			player_mesh.visible = true
		if icon:
			icon.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		yaw = rotation.y
		pitch = rotation.x
	)
