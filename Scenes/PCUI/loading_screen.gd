extends Control

var next_scene: String = "res://Scenes/PCUI/pcui.tscn"
var fake_progress: float = 0.0
var load_finished: bool = false
var min_show_time: float = 2.0
var elapsed: float = 0.0

func _ready() -> void:
	PcManager.ui_active = true
	$ColorRect/AnimatedSprite2D.play("gif")  # анимация
	ResourceLoader.load_threaded_request(next_scene)

func _exit_tree():
	PcManager.ui_active = false

func _process(delta: float) -> void:
	elapsed += delta

	# Получаем реальный прогресс
	var prog: Array = []
	var status: int = ResourceLoader.load_threaded_get_status(next_scene, prog)
	var real_progress: float = 0.0
	if prog.size() > 0:
		real_progress = float(prog[0])

	# Плавно увеличиваем фейковый прогресс
	var target: float = 0.0
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		target = 1.0
	else:
		target = min(real_progress * 0.9, 0.9)

	fake_progress = lerp(fake_progress, target, delta * 0.8)
	$ColorRect/ProgNumber.text = str(int(fake_progress * 100)) + "%"

	# Проверяем, готово ли к показу PCUI
	if status == ResourceLoader.THREAD_LOAD_LOADED and elapsed >= min_show_time and fake_progress >= 0.995:
		load_finished = true
		show_pcui()

func show_pcui() -> void:
	if load_finished:
		var pcui_instance: Node = load(next_scene).instantiate()
		pcui_instance.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().current_scene.add_child(pcui_instance)
		queue_free()  # убираем loading_screen
