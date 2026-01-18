class_name MapEditorUI
extends CanvasLayer

signal upload_files

@export var create_tile_form: PackedScene


func _on_create_tile_pressed() -> void:
	UIManager.open_form(create_tile_form)


func _on_upload_files_pressed() -> void:
	upload_files.emit()
