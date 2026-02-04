class_name MapEditorEditMapState
extends NodeStateMachineState

@export var pan_speed: float = 100.0

var current_tile: BaseTileDefinition
var mouse_tile: Vector2i:
	set(v):
		if v == mouse_tile:
			return
		mouse_tile = v
		mouse_tile_changed = true

var mouse_tile_changed := false

func on_enter():
	current_tile = GameData.tiles[0].values()[0]


func on_unhandled_input(event: InputEvent):
	var map_editor: MapEditor = GlobalRefs.map_editor

	mouse_tile = map_editor.get_mouse_tile()

	if event is InputEventMouseButton:
		if not event.pressed:
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

	var camera := get_camera()
	if camera:
		if event.is_pressed(): 
			if event.is_action("zoom_in"):
				if camera.zoom.x < 2:
					camera.zoom *= 2
			elif event.is_action("zoom_out"):
				camera.zoom /= 2

	mouse_tile_changed = false


func on_process(delta: float):
	var pan := Input.get_vector("camera_pan_left", "camera_pan_right", "camera_pan_up", "camera_pan_down")

	var camera := get_camera()
	if camera:
		camera.position += pan * pan_speed * 1.0 / camera.zoom.x * delta
		

func get_camera()-> Camera2D:
	return (get_tree().current_scene as Node2D).get_viewport().get_camera_2d()
