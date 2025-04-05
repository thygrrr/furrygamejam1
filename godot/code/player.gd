extends Critter
class_name Player


var busy : bool

func _ready() -> void:
	super()


func execute(_event: InputEvent) -> void:
	await process
