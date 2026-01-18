@abstract
class_name BaseTileDefinition
extends Resource

@export var name: String

var tile_source: int
var atlas_coords: Vector2i 


func serialize()-> Dictionary:
	var data := {}
	data["type"] = get_type_str()
	data["name"] = name
	return data


func deserialize(data: Dictionary):
	name = data["name"]

@abstract
func get_type_str()-> String
