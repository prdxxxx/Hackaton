extends Control

@onready var label: Label = $MarginContainer/Label as Label
@onready var label_2: Label = $MarginContainer/Label2 as Label
@onready var label_3: Label = $MarginContainer/Label3 as Label
@onready var label_4: Label = $Label4 as Label

@onready var new: Button = $MarginContainer/HBoxContainer/New as Button
@onready var load: Button = $MarginContainer/HBoxContainer/Load as Button

@onready var start_level = preload("res://Scenes/World.tscn") as PackedScene

signal start_game_exit

func _process(delta: float) -> void:
	if new.is_hovered():
		label.visible = false
		label_2.visible = true
		label_3.visible = false
		label_4.visible = false
	elif load.is_hovered():
		label.visible = false
		label_2.visible = false
		label_3.visible = true



func _on_new_pressed() -> void:
	DirAccess.remove_absolute("user://SaveFile.tres")
	SaveLoad.SaveFileData = SaveDataResourse.new()
	get_tree().change_scene_to_packed(start_level)

func _on_load_pressed() -> void:
	if FileAccess.file_exists("user://SaveFile.tres"):
		get_tree().change_scene_to_packed(start_level)
	elif !FileAccess.file_exists("user://SaveFile.tres"):
		label.visible = false
		label_2.visible = false
		label_3.visible = false
		label_4.visible = true

func _on_exit_pressed() -> void:
	start_game_exit.emit()
