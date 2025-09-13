extends Control
class_name HotkeyRebindButton

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name : String = "action"

func _ready() -> void:
	set_process_input(false)
	set_action_name()
	load_key_binding()
	set_text_for_key()

# -----------------------------
# UI
# -----------------------------
func set_action_name() -> void:
	label.text = "Unassigned"
	match action_name:
		"Forward": label.text = "Move Forward"
		"Backward": label.text = "Move Backward"
		"Left": label.text = "Move Left"
		"Right": label.text = "Move Right"
		"Sprint": label.text = "Sprint"
		"Jump": label.text = "Jump"
		"Interaction": label.text = "Interact"
		"Pause": label.text = "Pause"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var ev = action_events[0]
		if ev is InputEventKey:
			button.text = OS.get_keycode_string(ev.keycode)
	else:
		button.text = "Unassigned"

# -----------------------------
# Button toggle
# -----------------------------
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Press any key..."
		set_process_input(true)
		button.grab_focus()
		# Disable other hotkey buttons
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i != self:
				i.button.toggle_mode = false
				i.set_process_input(false)
	else:
		set_process_input(false)
		set_text_for_key()

# -----------------------------
# Capture key input
# -----------------------------
func _input(event: InputEvent) -> void:
	if button.toggle_mode and event is InputEventKey and event.pressed:
		# Optional: ignore modifiers alone
		if event.keycode != 0:
			rebind_action_key(event)
			button.toggle_mode = false

# -----------------------------
# Rebinding
# -----------------------------
func rebind_action_key(event: InputEventKey) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	save_key_binding(event)
	set_text_for_key()
	set_action_name()

# -----------------------------
# Config save/load
# -----------------------------
func get_config_path() -> String:
	return "user://config.cfg"

func save_key_binding(event: InputEventKey) -> void:
	var cfg = ConfigFile.new()
	cfg.load(get_config_path())
	cfg.set_value("KeyBindings", action_name, event.keycode)
	cfg.save(get_config_path())

func load_key_binding() -> void:
	var cfg = ConfigFile.new()
	if cfg.load(get_config_path()) != OK:
		# First run defaults
		var defaults = {
			"Forward": KEY_W,
			"Backward": KEY_S,
			"Left": KEY_A,
			"Right": KEY_D,
			"Jump": KEY_SPACE,
			"Sprint": KEY_SHIFT,
			"Interaction": KEY_E,
			"Pause": KEY_ESCAPE
		}
		for action in defaults.keys():
			cfg.set_value("KeyBindings", action, defaults[action])
		cfg.save(get_config_path())

	var keycode = cfg.get_value("KeyBindings", action_name, 0)
	if keycode != 0:
		InputMap.action_erase_events(action_name)
		var ev = InputEventKey.new()
		ev.keycode = int(keycode)
		InputMap.action_add_event(action_name, ev)
