extends CanvasLayer


signal restart


func _on_RestartButton_pressed() -> void:
	restart.emit()
