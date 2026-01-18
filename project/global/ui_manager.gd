extends CanvasLayer

@onready var dark_background: PanelContainer = $DarkBackground
@onready var center_container: CenterContainer = $CenterContainer

var current_form: UIForm


func open_form(scene: PackedScene):
	current_form = scene.instantiate()
	assert(current_form)
	dark_background.show()
	center_container.add_child(current_form)


func close_form(notify: bool = false):
	if not current_form:
		return
	if notify:
		current_form.on_close()
	current_form.queue_free()
	dark_background.hide()


func _on_dark_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if current_form:
				close_form(true)
