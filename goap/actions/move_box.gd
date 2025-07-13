extends GOAPActions

class_name MoveBoxAction

func get_clazz(): return "MoveBoxAction"

func _predictions()->Dictionary:
	return {}
	
func _effects()->Dictionary:
	return {
		"have_box": false,
		"box_deliverd": true
	}

func _get_cost(blackboard)->int:
	return 3

func _perform(actor, _delta)->bool:
	var delivery_point = WorldState.get_closest_element("deliveryPoint", actor)
	
	if delivery_point:
		if delivery_point.position.distance_to(actor.position) < 10:
			return true
	return false
