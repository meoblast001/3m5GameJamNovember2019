extends Node

# Declare member variables here. Examples:
var item: String = ""
var group: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event.is_action("ui_down") and item != "":
		print("Dropping ", item, " from key")
		drop(get_parent().global_position)

func pickup(newItem: Item):
	print("Player picked up item ", newItem.name)
	newItem.queue_free()
	if item != "":
		print("Dropping ", item, " from pickup")
		drop(newItem.global_position)
	item = newItem.name
	if newItem.is_in_group("torch"):
		group = "torch"
		get_parent().current_item = "torch"
		get_parent().add_to_group("torch")
	else:
		group = "chainsaw"
		get_parent().current_item = "chainsaw"
	

func drop(global_position: Vector2):
	var new_item
	match group:
		"torch":
			new_item = get_tree().get_nodes_in_group("ItemManager")[0].spawn_torch(global_position)
			new_item.name = item
			new_item._ondrop()
			
		"chainsaw":
			new_item = get_tree().get_nodes_in_group("ItemManager")[0].spawn_chainsaw(global_position)
	
	if new_item != null:
		new_item.set_collision_timeout()
	
	# We may call drop() directly, so player may end up without item (read: no explicit override)
	get_parent().current_item = "none"
	if get_parent().is_in_group("torch"):
		get_parent().remove_from_group("torch")
	item = ""
	group = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
