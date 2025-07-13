# simple_agent.gd
extends CharacterBody3D
class_name CharacterBot

@export var movement_speed: float = 2.0
@export var rotation_speed: float = 5.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation: AnimationPlayer = $Agent2/AnimationPlayer
@onready var deliveryPoint = $"../DeliveryPoint"
@onready var deliveryPointPos = $"../DeliveryPoint".position
@onready var box:Node3D = $"../Box"
@onready var boxPos = $"../Box".position
@onready var area3D: Area3D = $Area3D

var has_box = false
var isBoxDelivered = false

func _ready() -> void:
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	area3D.body_entered.connect(thinking)
	thinking(null)
	animation.play("Idle")
	


func thinking(body: Node3D):
	if body != null:
		print(body.name)
		if body.name == "Box" or body.name == "DeliveryPointbox":
			if body.name == "Box":
				has_box = true
				area3D.body_entered.emit()
			if body.name == "DeliveryPointbox":
				has_box = false
				isBoxDelivered = true
				area3D.body_entered.emit()
				box.queue_free()
	if !has_box and !isBoxDelivered:
		go_to_object(boxPos)
	if has_box and !isBoxDelivered:
		go_to_object(deliveryPointPos)
	print(has_box)


#Логика движения
func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float):
	
	if has_box:
		box.position = self.position + Vector3(0,1.2,0)
		box.scale = Vector3(0.5,0.5,0.5)
	
	if navigation_agent.is_navigation_finished():
		animation.play("Idle")
		return
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_path_position)
	var new_velocity: Vector3 = direction * movement_speed
	
	# Плавный поворот в направлении движения
	if direction.length() > 0:
		var target_rotation = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	animation.play("Walk")

func go_to_object(target_position: Vector3):
	navigation_agent.set_target_position(target_position) #Конечная точка маршрута

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
