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
	return (Layer.keys()[get_layer()] as String).to_lower() + "_tiles"


func get_export_path()-> String:
	return MapEditor.get_export_path().path_join("tiles").path_join(get_layer_str())


static func create_instance(layer: Layer):
	match layer:
		Layer.TERRAIN:
			return TerrainTileDefinition.new()
		_:
			assert(false, "not implemented")
