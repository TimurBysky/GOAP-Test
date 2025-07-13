extends GoapGoal

func get_clazz(): return "DeliverBoxGoal"

func _is_valid()->bool:
	return WorldState.get_state("have_box", false)
	
func _priority()->int:
	return 2

func get_desired_state()->Dictionary:
	return{
		"box_deliverd" : true
	}
