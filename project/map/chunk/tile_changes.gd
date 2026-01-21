class_name TileChanges

class Row:
	enum Type { PLACE, REMOVE }
	var type: Type
	var tile_pos: Vector2i
	var layer: BaseTileDefinition.Layer
	
	func _init(p_type: Type, pos: Vector2i, p_layer: BaseTileDefinition.Layer):
		type = p_type
		tile_pos = pos
		layer = p_layer


var rows: Array[Row]


func add_row(row: Row):
	rows.append(row)
