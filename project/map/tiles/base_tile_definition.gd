@abstract
class_name BaseTileDefinition
extends Resource

enum Layer { TERRAIN, DECORATION, PROP }

@export var name: String

var tile_source: int
var atlas_coords: Vector2i 


@abstract
func get_layer()-> Layer

func serialize()-> Dictionary:
	var data := {}
	data["layer"] = get_layer_str()
	data["name"] = name
	return data


func deserialize(data: Dictionary):
	name = data["name"]


func get_layer_str()-> String:
	return (Layer.keys()[get_layer()] as String).to_lower() + "_tile"


func get_export_path()-> String:
	return OS.get_user_data_dir().path_join(MapEditor.EXPORT_PATH).path_join(get_layer_str() + "s")
