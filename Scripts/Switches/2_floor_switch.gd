extends Node3D

@onready var lights_2_floor: Node3D = $"../../ElectricBox/Lights/Lights_2_Floor"
@onready var switch_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Audio для этой группы ламп
@onready var lamp_sfx: AudioStreamPlayer3D = $"../../ElectricBox/Lights/Lights_2_Floor/Lights"  # твой AudioStreamPlayer3D в сцене

var onoff: bool = false

func _ready() -> void:
	SaveLoad._load()
	onoff = SaveLoad.SaveFileData.lights_2_floor
	
	$off.visible = onoff
	$on.visible = !onoff
	lights_2_floor.visible = onoff

	# Воспроизводим или останавливаем звук при старте сцены
	if onoff and lamp_sfx:
		lamp_sfx.play()
	else:
		if lamp_sfx:
			lamp_sfx.stop()

func toggle_light() -> void:
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_2_floor.visible = onoff
	SaveLoad.SaveFileData.lights_2_floor = onoff

	# Включаем или выключаем звук в зависимости от состояния света
	if lamp_sfx:
		if onoff:
			lamp_sfx.play()
		else:
			lamp_sfx.stop()
	if switch_sfx:
		switch_sfx.play()
