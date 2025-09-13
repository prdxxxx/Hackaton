extends Node3D

##@onready var label3d = $Cube_038/Area3D/CollisionShape3D/Sprite3D
##@onready var area = $Cube_038/Area3D

##func _ready():
	##label3d.visible = false
	##area.body_entered.connect(_on_body_entered)
	##area.body_exited.connect(_on_body_exited)

##func _on_body_entered(body):
	
	##if body.name == "Player":  # или используйте "body.is_in_group("player")"
		##label3d.visible = true

###func _on_body_exited(body):
	###if body.name == "Player":
		###label3d.visible = false
