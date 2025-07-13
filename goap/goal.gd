extends Node

class_name GoapGoal

#Нужна ли цель
func is_valid()->bool:
	return true

#Её приоритет	
func get_priority()->int:
	return 1
	
#Желаемое состояние
func get_desired_state()-> Dictionary:
	return {}
