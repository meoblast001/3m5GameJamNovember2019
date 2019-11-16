extends Node

class_name ItemManager
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var items: Array = []
var default_positions: Dictionary = Dictionary()
var torch_scene: PackedScene = preload("res://Scenes/Items/Torch.tscn")
var chainsaw_scene: PackedScene = preload("res://Scenes/Items/Chainsaw.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for torch_item in get_tree().get_nodes_in_group("torch_item"):
		wire_torch(torch_item)
	for chainsaw_item in get_tree().get_nodes_in_group("chainsaw_item"):
		wire_chainsaw(chainsaw_item)

func spawn_torch(pos: Vector2):
	var torch = torch_scene.instance()
	wire_torch(torch)
	get_parent().add_child(torch)
	
	if pos != null:
		torch.global_position = pos
	else:
		torch.global_position = default_positions.get("Torch")
		
	return torch

func wire_torch(torch):
	torch.connect("torch_picked_up", $"../Player", "_on_Item_picked_up")
	items.append(torch)

func spawn_chainsaw(pos: Vector2):
	var chainsaw = chainsaw_scene.instance()
	wire_chainsaw(chainsaw)
	get_parent().add_child(chainsaw)
	items.append(chainsaw)
	
	if pos != null:
		chainsaw.global_position = pos
	else:
		chainsaw.global_position = default_positions.get("Chainsaw")
	
	return chainsaw
	
func wire_chainsaw(chainsaw):
	chainsaw.connect("chainsaw_picked_up", $"../Player", "_on_Item_picked_up")
	items.append(chainsaw)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Item_spawned(item: Item):
	items.append(item)
	var name = item.get_parent().name
	print("added item " + item.get_parent().name + " to manager")
	if not default_positions.has(name):
		default_positions[name] = item.get_parent().global_position
		print("position: ", item.global_position)

#func get_first_collision(player: KinematicBody2D):
#	for item in items:
#		print(item.get_node("PlayerCollisionArea").get_colliding_bodies())
#	pass
