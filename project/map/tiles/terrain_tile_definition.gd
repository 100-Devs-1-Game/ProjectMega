class_name TerrainTileDefinition
extends BaseTileDefinition

var walk_speed: float = 1.0


func deserialize(data: Dictionary):
	super(data)
	walk_speed = data.get("walk_speed", 1.0)


func get_layer()-> Layer:
	return Layer.TERRAIN
