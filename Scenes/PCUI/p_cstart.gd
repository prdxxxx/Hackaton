extends Control

@onready var password_line = $TextureRect/Left/Password/PasswordCont/Inputpass
var correct_password := "1234"
var pcui_instance: Node = null

func _ready():
	PcManager.ui_active = true  # блокируем камеру и ввод
	# Если пароль уже введён, сразу открываем PCUI
	if PcManager.login_completed:
		open_pcui_direct()

func _exit_tree():
	PcManager.ui_active = false  # разблокируем камеру при выходе

func _on_inputpass_text_submitted(new_text: String) -> void:
	check_password()

func check_password():
	if password_line.text == correct_password:
		login_success()
		open_pcui_direct()

func login_success():
	PcManager.login_completed = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func open_pcui_direct():
	# закрываем экран логина
	queue_free()
	# открываем PCUI
	pcui_instance = preload("res://Scenes/PCUI/loading_screen.tscn").instantiate()
	pcui_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(pcui_instance)

func close_login():
	queue_free()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event.is_action_pressed("Cancel"):  # Ctrl
		close_login()
