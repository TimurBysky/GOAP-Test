extends GoapGoal

class_name DeliverBoxGoal

func get_clazz(): return "DeliverBoxGoal"

func is_valid()->bool:
	return !WorldState.get_state("box_deliverd", false)
	
func priority()->int:
	return 2

func get_desired_state()->Dictionary:
	return{
		"box_deliverd" : true
	}
