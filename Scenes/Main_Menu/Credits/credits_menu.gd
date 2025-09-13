class_name CreditsMenu
extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton as Button


signal exit_credits_menu


func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)


func on_exit_pressed() -> void:
	exit_credits_menu.emit()
	set_process(false)
