extends Control

@export var max_lines_remembered := 30
@onready var history_rows = $WindowBase/MainArea/MarginContainer/History/ScrollContainer/HistoryRows
@onready var scroll = $WindowBase/MainArea/MarginContainer/History/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()
const InputResponse = preload("res://Scenes/PCUI/InputFORScanNet.tscn")
@onready var scan = $"."  # кнопка Scan

var monitor_enabled = false

func _ready() -> void:
	if scrollbar and scrollbar.has_signal("changed"):
		scrollbar.changed.connect(Callable(self, "_deferred_scroll_to_bottom"))
	_try_connect_scan_button_with_timeout(5.0)
	await _append_system_line("[*] Ready.")

# Скролл вниз
func _deferred_scroll_to_bottom() -> void:
	await get_tree().process_frame
	scroll.scroll_vertical = scrollbar.max_value

# Удаление старых строк, если больше лимита
func delete_history_beyond_limit() -> void:
	while history_rows.get_child_count() > max_lines_remembered:
		history_rows.get_child(0).queue_free()

func _append_system_line(line: String) -> void:
	var inst = InputResponse.instantiate()
	inst.set_text("", "")  # пустая строка
	history_rows.add_child(inst)
	delete_history_beyond_limit()
	await _deferred_scroll_to_bottom()

	var current_text := ""
	for i in range(line.length()):
		current_text += line[i]
		inst.set_text("", current_text)  # обновляем текст пошагово
		await get_tree().create_timer(0.03).timeout

	await _deferred_scroll_to_bottom()


# Поиск кнопки Scan с таймаутом
func _try_connect_scan_button_with_timeout(timeout_seconds: float) -> void:
	var t := 0.0
	while t < timeout_seconds:
		var nodes := get_tree().get_nodes_in_group("scan_buttons")
		if nodes.size() > 0:
			var btn = nodes[0]
			var cb := Callable(self, "_on_scan_button_pressed")
			if not btn.is_connected("pressed", cb):
				btn.connect("pressed", cb)
				await _append_system_line("[*] Scan ready.")
			return
		await get_tree().create_timer(0.2).timeout
		t += 0.2
	await _append_system_line("[!] No Scan button.")


# Сканирование сети (Ettercap-стиль)
func _on_scan_button_pressed() -> void:
	await _cmd("> ettercap -T -q -i eth0")
	if monitor_enabled:
		await _append_system_line("Interface already active")
	else:
		monitor_enabled = true
		await _append_system_line("Interface eth0 enabled")

	await _cmd("> scan hosts in local network")

	# Имитация обнаружения устройств в LAN через Events
	Events.sample_hosts = [
		{"ip":"192.168.0.10", "mac":"AA:BB:CC:DD:EE:01", "ports":"80,443"},
		{"ip":"192.168.0.15", "mac":"11:22:33:44:55:02", "ports":"22,3389"},
		{"ip":"192.168.0.20", "mac":"77:88:99:AA:BB:03", "ports":"21,25"}
	]

	Events.scan_done = true

	for host in Events.sample_hosts:
		await _append_system_line("Host %s  MAC %s  Ports [%s]" % [host.ip, host.mac, host.ports])
		await get_tree().create_timer(0.4).timeout

	await _append_system_line("Scan complete. Found %d hosts." % Events.sample_hosts.size())


# Авто-команда с задержкой
func _cmd(cmd: String) -> void:
	await _append_system_line(cmd)
	await get_tree().create_timer(0.5).timeout

func _on_button_pressed() -> void:
	scan.hide()
