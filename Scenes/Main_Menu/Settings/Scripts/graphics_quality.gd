extends Control

@onready var ssao_check: CheckBox = $VBoxContainer/SSAO/SSAO_check
@onready var sdfgi_check: CheckBox = $VBoxContainer/SDFGI/SDFGI_check
@onready var glow_check: CheckBox = $VBoxContainer/Glow/Glow_check

var ssao = true
var sdfgi = true
var glow = true

func _ready() -> void:
	# Load saved values or defaults
	ssao = load_config("user://config.cfg", "Graphics", "SSAO", true)
	sdfgi = load_config("user://config.cfg", "Graphics", "SDFGI", true)
	glow = load_config("user://config.cfg", "Graphics", "Glow", true)

	# Update checkboxes
	ssao_check.button_pressed = ssao
	sdfgi_check.button_pressed = sdfgi
	glow_check.button_pressed = glow


func _on_ssao_check_toggled(toggled_on: bool) -> void:
	save_config(toggled_on, "SSAO")

func _on_sdfgi_check_toggled(toggled_on: bool) -> void:
	save_config(toggled_on, "SDFGI")

func _on_glow_check_toggled(toggled_on: bool) -> void:
	save_config(toggled_on, "Glow")


# Safe config loader with default
func load_config(path: String, section: String, key: String, default_value) -> Variant:
	var cfg = ConfigFile.new()
	if cfg.load(path) != OK:
		return default_value
	return cfg.get_value(section, key, default_value)

# Save graphics option to config
func save_config(value, g_name: String) -> void:
	var cfg = ConfigFile.new()
	cfg.load("user://config.cfg")  # Load existing or start new
	cfg.set_value("Graphics", g_name, value)
	cfg.save("user://config.cfg")
