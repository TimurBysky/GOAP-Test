extends GOAPActions

class_name GetBoxAction

func get_clazz(): return "GetBoxAction"

func is_valid():
	return WorldState.get_elements("boxes").size() > 0

func get_preconditions()->Dictionary:
	return {}
	
func get_effects()->Dictionary:
	return {
		"have_box" : true
	}

func get_cost(blackboard)->int:
	if blackboard.has("position"):
		var closest_box = WorldState.get_closest_element("boxes", blackboard)
		return int(closest_box.position.distance_to(blackboard.position) / 7)
	return 3
	
func perform(actor, _delta)->bool:
	var closest_box = WorldState.get_closest_element("boxes", actor)
	
	if closest_box:
		if actor.has_box:
			return true
		else:
			actor.set_movement_target(closest_box.position)
	return false
