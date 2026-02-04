class_name AddTileForm
extends UIForm

@onready var create_button: Button = %Create
@onready var file_dialog: FileDialog = $FileDialog
@onready var tile_texture_rect: TextureRect = %TileTexture
@onready var name_hint_label: Label = %NameHint

var tile_layer: BaseTileDefinition.Layer
var tile_name: String
var tile_texture_path: String


func try_to_enable_create_button():
	if not tile_name.is_empty() and not tile_texture_path.is_empty():
		create_button.disabled = false


func set_name_hint(hint: String, is_warning: bool = true):
	name_hint_label.text = hint
	name_hint_label.modulate = Color.RED if is_warning else Color.GREEN


func _on_load_image_pressed() -> void:
	file_dialog.show()


func _on_create_pressed() -> void:
	var tile_exists_remove: bool = await does_tile_exist_in_repository()
	if tile_exists_remove:
		set_name_hint("name exists in repository")
		create_button.disabled = true
		return
		
	GlobalRefs.map_editor.register_tile(tile_name, tile_layer, tile_texture_path)
	close()


func _on_file_dialog_file_selected(path: String) -> void:
	tile_texture_path = path
	var texture = Utils.load_image_from_absolute_path(path)
	tile_texture_rect.texture = texture
	try_to_enable_create_button()


func _on_input_name_text_changed(new_text: String) -> void:
	tile_name = new_text
	create_button.disabled = true
	if tile_name.is_empty():
		set_name_hint("empty name")
		return
	elif GameData.get_tile_definition(tile_layer, tile_name) != null:
		set_name_hint("existing name")
		return
	
	set_name_hint("name available", false)
	try_to_enable_create_button()


func _on_type_option_item_selected(index: int) -> void:
	tile_layer = index as BaseTileDefinition.Layer


func does_tile_exist_in_repository()-> bool:
	var path := GameData.DATA_PATH.trim_prefix("res://").path_join(BaseTileDefinition.get_layer_str_static(tile_layer))
	var file_path := path.path_join(tile_name + ".json")
	var file_exists: bool = await Utils.does_repository_file_exist(file_path, self)
	return file_exists
