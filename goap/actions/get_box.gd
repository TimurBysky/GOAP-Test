extends GOAPActions

func get_clazz(): return "GetBoxAction"

func _predictions()->Dictionary:
	return {}
	
func _effects()->Dictionary:
	return {
		"have_box" : true
	}

func _get_cost(blackboard)->int:
	if blackboard.has("position"):
		var closest_box = WorldState.get_closest_element("boxes", blackboard)
		return int(closest_box.position.distance_to(blackboard.position) / 7)
	return 3
	
func _perform(actor, _delta)->bool:
	var closest_box = WorldState.get_closest_element("boxes", actor)
	
	if closest_box:
		if closest_box.position.distance_to(actor.position) < 10:
			return true
	return false
