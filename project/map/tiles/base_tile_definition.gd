@abstract
class_name BaseTileDefinition
extends Resource

enum Type { TERRAIN, DECORATION, PROP }

@export var name: String

var tile_source: int
var atlas_coords: Vector2i 


@abstract
func get_type()-> Type

func serialize()-> Dictionary:
	var data := {}
	data["type"] = get_type_str()
	data["name"] = name
	return data


func deserialize(data: Dictionary):
	name = data["name"]


func get_type_str()-> String:
	return (Type.keys()[get_type()] as String).to_lower() + "_tile"


func get_export_path()-> String:
	return OS.get_user_data_dir().path_join(MapEditor.EXPORT_PATH).path_join(get_type_str() + "s")
