extends Node
class_name Health

@export_group("Health")
@export var max_health: float = -1
@export var starting_health: float = 3
@export var invincibility_time: float = 0.05
@export var has_invincibility: bool = false

@onready var health := clampf(starting_health, 0.0, max_health):
	set(v):
		health = v
		health_changed.emit(v)
var can_harm := true



signal healed(amount: float)
signal harmed(amount: float)
signal died
signal harmable_again
signal health_changed(hp: float)

enum Team {PLAYER, ENEMY}

@rpc("authority", "call_local", "reliable")
func harm(amount: float) -> float:
	if can_harm:
		health -= amount
		harmed.emit(amount)
		if health <= 0:
			died.emit()

		if has_invincibility:
			can_harm = false
			await get_tree().create_timer(invincibility_time).timeout
			harmable_again.emit()
			can_harm = true
	return health

@rpc("authority", "call_local", "reliable")
func heal(amount: float) -> float:
	health += amount
	health = minf(health, max_health) if max_health > 0 else health
	healed.emit(amount)
	return health
