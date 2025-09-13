extends Control
@onready var settings_container = $SettingsContainer as MarginContainer

@onready var panel_container: PanelContainer = $PanelContainer

signal _save
signal _load


func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hide()


func _process(delta: float) -> void:
	testEsc()


func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("pause_blur_animation")
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("pause_blur_animation")
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func options():
	settings_container.visible = true
	panel_container.visible = false
	
func _on_options_exit_pressed() -> void:
	settings_container.visible = false
	panel_container.visible = true

func testEsc():
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused == true:
		resume()

func _on_resume_pressed() -> void:
	resume()


func _on_options_pressed() -> void:
	options()


func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_save_pressed() -> void:
	_save.emit()


func _on_load_pressed() -> void:
	_load.emit()
