extends Control

@onready var password_field = $WindowBase/PanelContainer/VBoxContainer/LineEdit
@onready var result_label = $WindowBase/PanelContainer/VBoxContainer/ResultLabel
@onready var subbutton = $WindowBase/PanelContainer/VBoxContainer/Button
@onready var exit = $"." 

# 4 пароля
const PASSWORD_1 := "aether_pw"
const PASSWORD_2 := "james_pw"
const PASSWORD_3 := "maria_pw"
const PASSWORD_4 := "ivan_pw"

func _on_button_pressed(_arg: String = "") -> void:
	var pwd: String = password_field.text.strip_edges()
	
	if pwd == "":
		_show_result("[!] Please enter your password.")
		return

	_show_result("Signing in...")

	# Симуляция задержки
	await get_tree().create_timer(0.5).timeout
	
	match pwd:
		PASSWORD_1:
			_show_result("[✓] Access granted. Money will be transfered.")
			SaveLoad.SaveFileData.money += 50
		PASSWORD_2:
			_show_result("[✓] Access granted. Money will be transfered.")
			SaveLoad.SaveFileData.money += 30
		PASSWORD_3:
			_show_result("[✓] Access granted. Money will be transfered.")
			SaveLoad.SaveFileData.money += 70
		PASSWORD_4:
			_show_result("[✓] Access granted. Money will be transfered.")
			SaveLoad.SaveFileData.money += 130
		_:
			_show_result("[X] Invalid password.")

func _show_result(text: String) -> void:
	result_label.text = text

func _on_exit_pressed() -> void:
	exit.hide()
