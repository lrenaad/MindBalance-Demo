extends Node

var coins: int = 0
var fraud_level_done: bool = false


func add_coins(amount: int) -> void:
	coins += amount


func complete_fraud_level() -> void:
	fraud_level_done = true
