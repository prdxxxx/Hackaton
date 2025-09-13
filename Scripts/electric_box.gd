extends Node3D

# -------------------- Ссылки --------------------
@onready var lights: Node3D = $Lights
@onready var indicator_off: Node3D = $Indicator_Light_off
@onready var indicator_on: Node3D = $Indicator_Light_on

# Массив всех AudioStreamPlayer3D ламп
@onready var lamp_sfx_list: Array = [
	$Lights/Lights_2_Floor/Lights,
	$Lights/Lights_Hall2/Lights,
	$Lights/Lights_Storage/Lights
]

# -------------------- Переменные --------------------
var onoff: bool = false  # состояние щитка (главного выключателя)
var random = RandomNumberGenerator.new()
var timer: Timer

@export var min_interval: float = 150.0
@export var max_interval: float = 300.0

# -------------------- Ready --------------------
func _ready() -> void:
	random.randomize()
	SaveLoad._load()
	onoff = SaveLoad.SaveFileData.main_light_switch

	_update_state()

	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	_set_random_timer()

# -------------------- Включение/выключение --------------------
func toggle_light() -> void:
	onoff = !onoff
	SaveLoad.SaveFileData.main_light_switch = onoff
	_update_state()

# -------------------- Обновление состояния света и звука --------------------
func _update_state() -> void:
	# Индикаторы
	indicator_off.visible = !onoff
	indicator_on.visible = onoff

	# Свет
	lights.visible = onoff

	# Управление звуками ламп по состоянию щитка
	for sfx in lamp_sfx_list:
		if sfx:
			if onoff:
				if not sfx.playing:
					sfx.play()
			else:
				if sfx.playing:
					sfx.stop()

# -------------------- Таймер для случайного выключения --------------------
func _set_random_timer() -> void:
	var interval = random.randf_range(min_interval, max_interval)
	timer.start(interval)
	print("[*] Следующее случайное выключение света через %.2f секунд" % interval)

func _on_timer_timeout() -> void:
	if onoff:
		onoff = false
		SaveLoad.SaveFileData.main_light_switch = onoff
		_update_state()
		print("[!] Свет выключен автоматически")
	_set_random_timer()
