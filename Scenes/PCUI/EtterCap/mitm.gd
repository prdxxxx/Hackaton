extends Control

@export var max_lines_remembered := 30

@onready var mitm: Control = $"."  # кнопка закрытия
@onready var history_rows = $WindowBase/MainArea/MarginContainer/Rows/History/ScrollContainer/HistoryRows
@onready var scroll = $WindowBase/MainArea/MarginContainer/Rows/History/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var command_processor = $Command
const InputResponse = preload("res://Scenes/PCUI/InputResponse.tscn")

func _ready() -> void:
	# подключаем сигнал изменения scrollbar
	if scrollbar:
		scrollbar.changed.connect(_scroll_to_bottom)
	# сортировка дочерних элементов для автоматического скролла
	if history_rows:
		history_rows.connect("sort_children", Callable(self, "_scroll_to_bottom"))

func _scroll_to_bottom() -> void:
	if scroll:
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _append_system_line(line: String) -> void:
	var inst = InputResponse.instantiate()
	inst.set_text("", line)
	history_rows.add_child(inst)
	delete_history_beyond_limit()
	await get_tree().process_frame
	_scroll_to_bottom()

func _on_button_pressed() -> void:
	mitm.hide()

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return

	var input_response = InputResponse.instantiate()
	var response = command_processor.process_command(new_text)
	input_response.set_text(new_text, response)
	history_rows.add_child(input_response)
	delete_history_beyond_limit()
	await get_tree().process_frame
	_scroll_to_bottom()

func delete_history_beyond_limit() -> void:
	while history_rows.get_child_count() > max_lines_remembered:
		history_rows.get_child(0).queue_free()


func _on_scroll_container_sort_children() -> void:
	pass 
