extends Node

class_name GOAPActions

#Стоит ли рассматривать это действие
func is_valid()->bool:
	return true

#Условия для совершения этого действия
func get_predictions()->Dictionary:
	return {}
	
#Эффекты от его выполнения
func get_effects()->Dictionary:
	return {}

#Получить стоимость действия
func get_cost(_blackboard)->int:
	return 1000
	
#Проверить выполнено ли действие
func perform(actor, _delta)->bool:
	return false
