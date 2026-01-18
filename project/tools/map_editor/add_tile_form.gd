class_name AddTileForm
extends UIForm

@onready var create_button: Button = %Create
@onready var file_dialog: FileDialog = $FileDialog
@onready var tile_texture_rect: TextureRect = %TileTexture

var tile_name: String
var tile_texture_path: String


func try_to_enable_create_button():
	if not tile_name.is_empty() and not tile_texture_path.is_empty():
		create_button.disabled= false


func _on_load_image_pressed() -> void:
	file_dialog.show()


func _on_create_pressed() -> void:
	GlobalRefs.map_editor.register_tile(tile_name, tile_texture_path)
	close()


func _on_file_dialog_file_selected(path: String) -> void:
	tile_texture_path = path
	var texture = load(tile_texture_path)
	tile_texture_rect.texture = texture
	try_to_enable_create_button()


func _on_input_name_text_changed(new_text: String) -> void:
	tile_name = new_text
	try_to_enable_create_button()
