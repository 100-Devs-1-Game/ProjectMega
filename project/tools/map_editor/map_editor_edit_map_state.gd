class_name MapEditorEditMapState
extends NodeStateMachineState

var current_tile: BaseTileDefinition
var mouse_tile: Vector2i:
	set(v):
		if v == mouse_tile:
			return
		mouse_tile = v
		mouse_tile_changed = true

var mouse_tile_changed := false

func on_enter():
	current_tile = GameData.terrain_tiles.values()[0]


func on_unhandled_input(event: InputEvent):
	var map_editor: MapEditor = GlobalRefs.map_editor

	mouse_tile = map_editor.get_mouse_tile()

	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					map_editor.place_tile(mouse_tile, current_tile)
				MOUSE_BUTTON_RIGHT:
					map_editor.remove_tile(mouse_tile)

	elif event is InputEventMouseMotion:
		if mouse_tile_changed:
			if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
				map_editor.place_tile(mouse_tile, current_tile)
			if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
				map_editor.remove_tile(mouse_tile)

	mouse_tile_changed = false
