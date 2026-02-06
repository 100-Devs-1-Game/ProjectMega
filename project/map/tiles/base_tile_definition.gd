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
	data["layer"] = int(get_layer())
	data["name"] = name
	return data


func deserialize(data: Dictionary):
	name = data["name"]
	

func get_layer_str()-> String:
	return get_layer_str_static(get_layer())


func get_tile_path()-> String:
	return ("tiles").path_join(get_layer_str())


func get_export_path()-> String:
	return MapEditor.get_export_path().path_join(get_tile_path())


static func get_layer_str_static(layer: Layer)-> String:
	return (Layer.keys()[layer] as String).to_lower() + "_tiles"	


static func create_instance(layer: Layer):
	match layer:
		Layer.TERRAIN:
			return TerrainTileDefinition.new()
		_:
			assert(false, "not implemented")
