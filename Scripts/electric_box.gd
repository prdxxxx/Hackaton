extends Node3D

@onready var lights: Node3D = $Lights

var onoff = false

func _ready() -> void:
	SaveLoad._load()
	var onoff2 = SaveLoad.SaveFileData.main_light_switch
	onoff = onoff2
	$Indicator_Light_off.visible = onoff
	$Indicator_Light_on.visible = !onoff
	lights.visible = onoff
	
func toggle_light() -> void:
	onoff = !onoff
	$Indicator_Light_off.visible = onoff
	$Indicator_Light_on.visible = !onoff
	lights.visible = onoff
	SaveLoad.SaveFileData.main_light_switch = onoff
