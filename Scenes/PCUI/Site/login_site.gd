extends Control

@onready var panel: Panel = $WindowBase/Panel
@onready var login_field: LineEdit = $WindowBase/Panel/VBoxContainer/LoginField
@onready var password_field: LineEdit = $WindowBase/Panel/VBoxContainer/PasswordField
@onready var submit_btn: Button = $WindowBase/Panel/VBoxContainer/SubmitButton
@onready var result_label: Label = $WindowBase/Panel/VBoxContainer/ResultLabel
@onready var login: Control = $"."
@onready var Bank: Control = $Bank


const CORRECT_LOGIN: String = "admin"
const CORRECT_PASSWORD: String = "12345"


func _on_submit_button_pressed(_arg: String = "") -> void:
	var login: String = login_field.text.strip_edges()
	var pwd: String = password_field.text.strip_edges()

	if login == "" and pwd == "":
		_show_result("[!] Please enter login and password.")
		return
	if login == "":
		_show_result("[!] Please enter your login.")
		return
	if pwd == "":
		_show_result("[!] Please enter your password.")
		return

	_show_result("Signing in...")

	# Simulated delay for response
	await get_tree().create_timer(0.5).timeout
	_show_result("Welcome, %s!" % login)
	
	if login == CORRECT_LOGIN and pwd == CORRECT_PASSWORD:
		_show_result("[✓] Access granted. Welcome, %s!" % login)
		Bank.show()
	else:
		_show_result("[X] Invalid login or password.")

func _show_result(text: String) -> void:
	result_label.text = text


func _on_button_pressed() -> void:
	login.hide()
