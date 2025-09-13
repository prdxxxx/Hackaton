extends Control

# === Настройки ===
@export var GrabThreshold := 20         # зона для перетаскивания (верх окна)
@export var ResizeThreshold := 5        # зона для ресайза (границы окна)
@export var MinSize := Vector2(100, 50) # минимальный размер окна
@export var CenterOnShow := true        # центрировать окно при показе?

# === Внутренние переменные ===
var start: Vector2
var initialPosition: Vector2
var initialSize: Vector2 = Vector2.ZERO

var isMoving: bool = false
var isResizing: bool = false
var resizeX: bool = false
var resizeY: bool = false
var resizeLeft: bool = false
var resizeTop: bool = false

var current_cursor = null # текущий курсор

# === Обработка ввода ===
func _input(event):
	if not visible:
		return

	var mouse_pos = get_global_mouse_position()
	var rect = get_global_rect()

	# Игнорируем события, если мышь вне окна и мы не двигаем/ресайзим
	if not rect.has_point(mouse_pos) and not isMoving and not isResizing:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		return

	if event is InputEventMouseMotion:
		_update_cursor(mouse_pos)
		_handle_mouse_motion(event)
	elif event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		if event.pressed:
			_handle_mouse_press(event)
		else:
			_handle_mouse_release()

# === Перетаскивание и ресайз ===
func _handle_mouse_press(event: InputEventMouseButton) -> void:
	var rect = get_global_rect()
	var localMousePos = event.position - get_global_position()

	# Перемещение окна (верхняя полоска)
	if localMousePos.y < GrabThreshold:
		start = get_global_mouse_position()  # глобальная позиция
		initialPosition = get_global_position()
		isMoving = true
		return

	# Правый ресайз
	if abs(localMousePos.x - rect.size.x) < ResizeThreshold:
		start.x = get_global_mouse_position().x
		initialSize.x = get_size().x
		resizeX = true
		isResizing = true

	# Нижний ресайз
	if abs(localMousePos.y - rect.size.y) < ResizeThreshold:
		start.y = get_global_mouse_position().y
		initialSize.y = get_size().y
		resizeY = true
		isResizing = true

	# Левый ресайз
	if localMousePos.x < ResizeThreshold:
		start.x = get_global_mouse_position().x
		initialPosition.x = get_global_position().x
		initialSize.x = get_size().x
		resizeX = true
		resizeLeft = true
		isResizing = true

	# Верхний ресайз
	if localMousePos.y < ResizeThreshold:
		start.y = get_global_mouse_position().y
		initialPosition.y = get_global_position().y
		initialSize.y = get_size().y
		resizeY = true
		resizeTop = true
		isResizing = true

# === Движение и изменение размера ===
func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if isMoving:
		set_position(initialPosition + (get_global_mouse_position() - start))

	if isResizing:
		var newWidth = get_size().x
		var newHeight = get_size().y
		var newPos = get_global_position()

		if resizeX:
			if resizeLeft:
				newWidth = max(MinSize.x, initialSize.x - (get_global_mouse_position().x - start.x))
				newPos.x = initialPosition.x + (initialSize.x - newWidth)
			else:
				newWidth = max(MinSize.x, initialSize.x + (get_global_mouse_position().x - start.x))

		if resizeY:
			if resizeTop:
				newHeight = max(MinSize.y, initialSize.y - (get_global_mouse_position().y - start.y))
				newPos.y = initialPosition.y + (initialSize.y - newHeight)
			else:
				newHeight = max(MinSize.y, initialSize.y + (get_global_mouse_position().y - start.y))

		set_global_position(newPos)
		set_size(Vector2(newWidth, newHeight))

# === Сброс флагов при отпускании мыши ===
func _handle_mouse_release():
	isMoving = false
	isResizing = false
	resizeX = false
	resizeY = false
	resizeLeft = false
	resizeTop = false
	initialPosition = Vector2.ZERO

# === Курсоры ===
func _update_cursor(mouse_pos: Vector2):
	var rect = get_global_rect()
	var cursor_shape = Input.CURSOR_ARROW

	if mouse_pos.x >= rect.position.x + rect.size.x - ResizeThreshold and mouse_pos.y >= rect.position.y + rect.size.y - ResizeThreshold:
		cursor_shape = Input.CURSOR_FDIAGSIZE
	elif mouse_pos.x <= rect.position.x + ResizeThreshold and mouse_pos.y >= rect.position.y + rect.size.y - ResizeThreshold:
		cursor_shape = Input.CURSOR_BDIAGSIZE
	elif mouse_pos.x >= rect.position.x + rect.size.x - ResizeThreshold:
		cursor_shape = Input.CURSOR_HSIZE
	elif mouse_pos.x <= rect.position.x + ResizeThreshold:
		cursor_shape = Input.CURSOR_HSIZE
	elif mouse_pos.y >= rect.position.y + rect.size.y - ResizeThreshold:
		cursor_shape = Input.CURSOR_VSIZE
	elif mouse_pos.y <= rect.position.y + GrabThreshold:
		cursor_shape = Input.CURSOR_POINTING_HAND

	if cursor_shape != current_cursor:
		current_cursor = cursor_shape
		Input.set_default_cursor_shape(current_cursor)

# === Центрирование при показе ===
func _on_visibility_changed():
	if visible:
		_handle_mouse_release()
		if CenterOnShow:
			var viewport_size = get_viewport_rect().size
			set_position((viewport_size - get_size()) / 2)


func _on_exit_pressed() -> void:
	pass # Replace with function body.
