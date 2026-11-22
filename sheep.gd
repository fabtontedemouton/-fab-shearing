extends Node2D

var is_shorn := false

func _ready() -> void:
    queue_redraw()

func _draw() -> void:
    # Prototype visuel temporaire : silhouette stylisée, à remplacer par un vrai modèle 3D.
    var wool_color := Color("#eee7d2") if not is_shorn else Color("#b9a99a")
    draw_ellipse(Vector2.ZERO, Vector2(82, 48), wool_color)
    draw_circle(Vector2(67, -8), 22, Color("#d6bca7"))
    draw_circle(Vector2(77, -14), 4, Color("#202020"))
    draw_line(Vector2(-45, 35), Vector2(-45, 68), Color("#29251f"), 8)
    draw_line(Vector2(30, 35), Vector2(30, 68), Color("#29251f"), 8)

func shear() -> void:
    is_shorn = true
    queue_redraw()
