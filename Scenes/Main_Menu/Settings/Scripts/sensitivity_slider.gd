extends Control

@onready var sensitivity_slider: HSlider = $HBoxContainer/Sensitivity_Slider
@onready var sensitivity_num: Label = $HBoxContainer/Sensitivity_num

var sens = 2.0  # default sensitivity

func _ready() -> void:
	# Load sensitivity from config safely
	sens = load_config("user://config.cfg", "Controls", "sensitivity", 2.0)
	
	# Update UI
	sensitivity_num.text = str(sens)
	sensitivity_slider.value = sens

func _on_sensitivity_slider_value_changed(value: float) -> void:
	sens = value
	sensitivity_num.text = str(sens)
	save_sens_data(sens)

# Safe config loader with default
func load_config(path: String, section: String, key: String, default_value) -> Variant:
	var cfg = ConfigFile.new()
	if cfg.load(path) != OK:
		return default_value
	return cfg.get_value(section, key, default_value)

# Save sensitivity to config
func save_sens_data(s_sens):
	var cfg = ConfigFile.new()
	
	# Load existing config or start fresh
	cfg.load("user://config.cfg")
	
	# Set and save sensitivity
	cfg.set_value("Controls", "sensitivity", s_sens)
	cfg.save("user://config.cfg")
