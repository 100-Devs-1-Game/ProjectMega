extends Node2D

@onready var terrain: TileMapLayer = $Terrain


func _ready() -> void:
	TileSetCreator.fill_tile_set(terrain.tile_set, ["terrain_tiles"])
	
	for x in 30:
		for y in 20:
			var def: TerrainTileDefinition = GameData.terrain_tiles.values().pick_random()
			terrain.set_cell(Vector2i(x, y), def.tile_source, def.atlas_coords)
