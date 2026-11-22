extends Node2D

var is_shorn := false

func _ready() -> void:
    queue_redraw()

func _draw() -> void:
    var fleece := Color("#eee5d0") if not is_shorn else Color("#a99b8c")
    draw_colored_polygon(PackedVector2Array([
        Vector2(-72, -18), Vector2(-55, -43), Vector2(-18, -50),
        Vector2(28, -43), Vector2(62, -18), Vector2(66, 20),
        Vector2(35, 43), Vector2(-42, 40), Vector2(-70, 15)
    ]), fleece)
    draw_circle(Vector2(67, -8), 21, Color("#d4b7a0"))
    draw_circle(Vector2(74, -13), 3.5, Color("#211d1b"))
    draw_line(Vector2(-38, 32), Vector2(-38, 61), Color("#292522"), 7)
    draw_line(Vector2(30, 32), Vector2(30, 61), Color("#292522"), 7)

func shear() -> void:
    is_shorn = true
    queue_redraw()
