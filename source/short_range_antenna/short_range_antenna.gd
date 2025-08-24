extends StaticBody3D

func _physics_process(_delta):
	var editor_highlight:MeshInstance3D = get_node_or_null("EditorHighlight")
	if editor_highlight:
		editor_highlight.position = $MeshInstance3D.position
