class_name BootsplashScene
extends Control

@export var fade_duration:float = 1.0
@export var stay_duration:float = 1.5
@export var node:PackedScene
@export var next_scene:PackedScene
@export var interuptable:bool = true

@onready var control = %NodeContainer
@onready var instance:Node2D = node.instantiate()

func _ready():
	instance.modulate.a = 0.0
	control.add_child(instance)
	if await Tweens.play(instance, Tweens.modulate_alpha(1.0, fade_duration, Tweens.Ease.CUBIC_IN).with_from(0.0)).end == Tweens.Reason.COMPLETED:
		_fade_out()

func _process(_delta):
	if interuptable and Input.is_action_just_pressed("exit"):
		_change_scene()

func _fade_out():
	if await Tweens.play(instance, Tweens.modulate_alpha(0.0, fade_duration, Tweens.Ease.CUBIC_IN, stay_duration)).end == Tweens.Reason.COMPLETED:
		_change_scene()

func _change_scene():
	get_tree().change_scene_to_packed(next_scene)
