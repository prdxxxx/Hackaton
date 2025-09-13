extends Node3D

@onready var lights: Node3D = $Lights
@onready var indicator_off := $Indicator_Light_off
@onready var indicator_on := $Indicator_Light_on

var onoff = false
var random = RandomNumberGenerator.new()
var timer: Timer

@export var min_interval := 150  # 5 минут
@export var max_interval := 300  # 10 минут

func _ready() -> void:
	random.randomize()
	SaveLoad._load()
	onoff = SaveLoad.SaveFileData.main_light_switch
	_update_indicators()
	lights.visible = onoff
	Events.main_light_on = onoff
	
	# Создаём таймер для случайного выключения
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	_set_random_timer()

func toggle_light() -> void:
	onoff = !onoff
	_update_indicators()
	lights.visible = onoff
	SaveLoad.SaveFileData.main_light_switch = onoff
	Events.main_light_on = onoff

func _update_indicators() -> void:
	indicator_off.visible = onoff
	indicator_on.visible = !onoff

# -------------------------
# Рандомное выключение света
func _set_random_timer() -> void:
	var interval = random.randf_range(min_interval, max_interval)
	timer.start(interval)
	print("[*] Следующее случайное выключение света через %.2f секунд" % interval)

func _on_timer_timeout() -> void:
	# Выключаем свет, если он включен
	if onoff:
		onoff = false
		_update_indicators()
		lights.visible = onoff
		SaveLoad.SaveFileData.main_light_switch = onoff
		Events.main_light_on = onoff
		print("[!] Свет выключен автоматически")
	
	# Устанавливаем следующий таймер
	_set_random_timer()
