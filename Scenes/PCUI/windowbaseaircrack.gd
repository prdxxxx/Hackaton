extends Control

var start: Vector2
var initialPosition: Vector2
var isMoving: bool = false
var isResizing: bool = false
var resizeX: bool = false
var resizeY: bool = false
var resizeLeft: bool = false
var resizeTop: bool = false
var initialSize: Vector2 = Vector2.ZERO

@export var GrabThreshold := 20
@export var ResizeThreshold := 5
@export var MinSize := Vector2(100, 50)  # минимальный размер окна

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		if event.pressed:
			_handle_mouse_press(event)
		else:
			_handle_mouse_release(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)

# ----------------- Внутренние функции -----------------

func _handle_mouse_press(event: InputEventMouseButton) -> void:
	var rect = get_global_rect()
	var localMousePos = event.position - get_global_position()

	# Захват окна для перемещения
	if localMousePos.y < GrabThreshold:
		start = event.position
		initialPosition = get_global_position()
		isMoving = true
		return

	# Правый ресайз
	if abs(localMousePos.x - rect.size.x) < ResizeThreshold:
		start.x = event.position.x
		initialSize.x = get_size().x
		resizeX = true
		isResizing = true

	if abs(localMousePos.y - rect.size.y) < ResizeThreshold:
		start.y = event.position.y
		initialSize.y = get_size().y
		resizeY = true
		isResizing = true

	# Левый ресайз
	if localMousePos.x < ResizeThreshold:
		start.x = event.position.x
		initialPosition.x = get_global_position().x
		initialSize.x = get_size().x
		resizeX = true
		resizeLeft = true
		isResizing = true

	if localMousePos.y < ResizeThreshold:
		start.y = event.position.y
		initialPosition.y = get_global_position().y
		initialSize.y = get_size().y
		resizeY = true
		resizeTop = true
		isResizing = true

func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if isMoving:
		set_position(initialPosition + (event.position - start))

	if isResizing:
		var newWidth = get_size().x
		var newHeight = get_size().y
		var newPos = get_global_position()

		if resizeX:
			if resizeLeft:
				newWidth = max(MinSize.x, initialSize.x - (event.position.x - start.x))
				newPos.x = initialPosition.x + (initialSize.x - newWidth)
			else:
				newWidth = max(MinSize.x, initialSize.x + (event.position.x - start.x))

		if resizeY:
			if resizeTop:
				newHeight = max(MinSize.y, initialSize.y - (event.position.y - start.y))
				newPos.y = initialPosition.y + (initialSize.y - newHeight)
			else:
				newHeight = max(MinSize.y, initialSize.y + (event.position.y - start.y))

		set_global_position(newPos)
		set_size(Vector2(newWidth, newHeight))

func _handle_mouse_release(event: InputEventMouseButton) -> void:
	isMoving = false
	isResizing = false
	resizeX = false
	resizeY = false
	resizeLeft = false
	resizeTop = false
	initialPosition = Vector2.ZERO
