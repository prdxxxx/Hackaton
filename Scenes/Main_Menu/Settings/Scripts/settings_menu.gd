class_name SettingMenu
extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton as Button

signal exit_settings_menu


func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)


func on_exit_pressed() -> void:
	exit_settings_menu.emit()
	set_process(false)
