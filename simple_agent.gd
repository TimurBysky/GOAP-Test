extends CharacterBody3D
class_name CharacterBot

@export var movement_speed: float = 1.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var animation: AnimationPlayer = get_node("Agent2/AnimationPlayer")


# Состояние мира (world state)
var world_state = {
	"has_energy": true,
	"has_money": false,
	"has_food": true,
	"is_hungry": false
}

# Определим возможные действия
var actions = {
	"Sleep": {
		"preconditions": {"has_energy": false},
		"effects": {"has_energy": true},
		"cost": 1
	},
	"Work": {
		"preconditions": {"has_energy": true, "has_food": true},
		"effects": {"has_money": true, "has_energy": false},
		"cost": 3
	},
	"Eat": {
		"preconditions": {"is_hungry": true, "has_food": true},
		"effects": {"is_hungry": false, "has_food": false},
		"cost": 2
	}
}

# Определим возможные цели
var goals = {
	"BeRested": {
		"condition": {"has_energy": true},
		"priority": 1
	},
	"EarnMoney": {
		"condition": {"has_money": true},
		"priority": 3
	},
	"BeFed": {
		"condition": {"is_hungry": false},
		"priority": 2
	}
}

func test_goap():
	print("=== Начальное состояние ===")
	print_state(world_state)
	
	# Выбираем цель
	var current_goal = choose_goal()
	print("\nВыбранная цель: ", current_goal)
	
	# Планируем действия
	var plan = plan_actions(current_goal)
	print("\nПлан действий: ", plan)
	
	# Выполняем план
	execute_plan(plan)
	
	print("\n=== Конечное состояние ===")
	print_state(world_state)

func choose_goal():
	# Выбираем цель с наивысшим приоритетом, которая еще не выполнена
	var best_goal = null
	var best_priority = -1
	
	for goal_name in goals:
		var goal = goals[goal_name]
		if not is_state_match(world_state, goal["condition"]) and goal["priority"] > best_priority:
			best_goal = goal_name
			best_priority = goal["priority"]
	
	return best_goal

func plan_actions(goal_name):
	var goal = goals[goal_name]
	var target_state = goal["condition"].duplicate()
	
	var plan = []
	var current_state = world_state.duplicate()
	
	while not is_state_match(current_state, target_state):
		var best_action = null
		var best_action_cost = INF
		var best_action_effects = {}
		
		# Ищем действие, которое приближает нас к цели
		for action_name in actions:
			var action = actions[action_name]
			
			# Проверяем, можно ли выполнить это действие
			if is_state_match(current_state, action["preconditions"]):
				# Проверяем, помогает ли это действие достичь цели
				if helps_achieve_goal(action["effects"], target_state, current_state):
					if action["cost"] < best_action_cost:
						best_action = action_name
						best_action_cost = action["cost"]
						best_action_effects = action["effects"]
		
		if best_action == null:
			print("Не могу найти подходящее действие для достижения цели!")
			return []
		
		plan.append(best_action)
		# Применяем эффекты действия к текущему состоянию
		for effect in best_action_effects:
			current_state[effect] = best_action_effects[effect]
	
	return plan

func helps_achieve_goal(effects, target_state, current_state):
	# Проверяем, помогает ли действие достичь цели
	for key in target_state:
		if key in effects and effects[key] == target_state[key] and current_state[key] != target_state[key]:
			return true
	return false

func execute_plan(plan):
	for action in plan:
		print("\nВыполняем действие: ", action)
		var action_data = actions[action]
		# Применяем эффекты действия
		for effect in action_data["effects"]:
			world_state[effect] = action_data["effects"][effect]
		print("Новое состояние: ")
		print_state(world_state)

func is_state_match(state, conditions):
	# Проверяем, удовлетворяет ли состояние условиям
	for key in conditions:
		if not key in state or state[key] != conditions[key]:
			return false
	return true

func print_state(state):
	for key in state:
		print(key, ": ", state[key])


func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	animation.play("Idle")
	test_goap()

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		animation.play("Idle")
		return
	if navigation_agent.is_navigation_finished():
		animation.play("Idle")
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	animation.play("Walk")

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
