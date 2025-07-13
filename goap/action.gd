extends Node

class_name GOAPActions

#Стоит ли рассматривать это действие
func _is_valid()->bool:
	return true

#Условия для совершения этого действия
func _predictions()->Dictionary:
	return {}
	
#Эффекты от его выполнения
func _effects()->Dictionary:
	return {}

#Получить стоимость действия
func _get_cost(_blackboard)->int:
	return 1000
	
#Проверить выполнено ли действие
func _perform(actor, _delta)->bool:
	return false
