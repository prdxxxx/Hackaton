class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton as Button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Quit as Button
@onready var settings_button: Button = $MarginContainer/VBoxContainer/Settings as Button
@onready var credits_button: Button = $MarginContainer/VBoxContainer/Credits as Button

@onready var start_game_options: Control = $"../Start_game_options" as Control
@onready var settings_menu: SettingMenu = $"../Settings_menu" as SettingMenu
@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer
@onready var credits_menu: CreditsMenu = $"../Credits" as CreditsMenu


func _ready() -> void:
	handle_connection_signals()
	
func on_start_pressed() -> void:
	margin_container.visible = false
	credits_menu.set_process(true)
	start_game_options.visible = true
	

func on_settings_pressed() -> void:
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true
	
func on_credits_pressed() -> void:
	margin_container.visible = false
	credits_menu.set_process(true)
	credits_menu.visible = true
	
func on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_settings_menu() -> void:
	margin_container.visible = true
	settings_menu.visible = false

func on_exit_credits_menu() -> void:
	margin_container.visible = true
	credits_menu.visible = false

func _on_start_game_options_start_game_exit() -> void:
	margin_container.visible = true
	start_game_options.visible = false

func handle_connection_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	quit_button.button_down.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)
	credits_menu.exit_credits_menu.connect(on_exit_credits_menu)
