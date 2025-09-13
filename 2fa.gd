extends Control
@onready var password_field = $WindowBase/PanelContainer/VBoxContainer/LineEdit
@onready var result_label = $WindowBase/PanelContainer/VBoxContainer/ResultLabel
@onready var subbutton = $WindowBase/PanelContainer/VBoxContainer/Button
@onready var exit = $"."

const CORRECT_PASSWORD: String = "525252"

func _on_button_pressed(_arg: String = "") -> void:
	var pwd: String = password_field.text.strip_edges()
	
	if pwd == "":
		_show_result("[!] Please enter your password.")
		return

	_show_result("Signing in...")

	# Simulated delay for response
	await get_tree().create_timer(0.5).timeout
	
	if pwd == CORRECT_PASSWORD:
		_show_result("[✓] Access granted. Your money will be transfered. ")
		SaveLoad.SaveFileData.money += 50
		
	else:
		_show_result("[X] Invalid password.")

func _show_result(text: String) -> void:
	result_label.text = text


func _on_exit_pressed() -> void:
	exit.hide()
