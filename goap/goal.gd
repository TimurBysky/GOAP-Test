extends Node

class_name GoapGoal

#Нужна ли цель
func _is_valid()->bool:
	return true

#Её приоритет	
func _priority()->int:
	return 1
	
#Желаемое состояние
func _get_desired_state()-> Dictionary:
	return {}
