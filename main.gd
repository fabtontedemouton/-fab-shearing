
extends Node2D

var sheep_total := 6
var sheep_shorn := 0
var points := 0

var info_label: Label
var score_label: Label
var sheep_list: Array[Node2D] = []

func _ready() -> void:
    var background := ColorRect.new()
    background.color = Color("#394638")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var title := Label.new()
    title.text = "FAB SHEARING — THE REAL LIFE"
    title.position = Vector2(28, 22)
    title.add_theme_font_size_override("font_size", 30)
    add_child(title)

    info_label = Label.new()
    info_label.position = Vector2(30, 80)
    info_label.add_theme_font_size_override("font_size", 20)
    add_child(info_label)

    score_label = Label.new()
    score_label.position = Vector2(30, 118)
    score_label.add_theme_font_size_override("font_size", 20)
    add_child(score_label)

    _spawn_sheep()

    var shear_button := Button.new()
    shear_button.text = "TONDRE LE PROCHAIN MOUTON"
    shear_button.position = Vector2(30, 640)
    shear_button.size = Vector2(360, 55)
    shear_button.pressed.connect(_shear_next)
    add_child(shear_button)

    var reset_button := Button.new()
    reset_button.text = "RECOMMENCER"
    reset_button.position = Vector2(410, 640)
    reset_button.size = Vector2(200, 55)
    reset_button.pressed.connect(_reset_day)
    add_child(reset_button)

    _refresh()


func _spawn_sheep() -> void:
    for i in range(sheep_total):
        var sheep := Node2D.new()
        sheep.set_script(load("res://sheep.gd"))
        sheep.position = Vector2(
            170 + (i % 3) * 300,
            270 + int(i / 3) * 175
        )
        add_child(sheep)
        sheep_list.append(sheep)


func _shear_next() -> void:
    for sheep in sheep_list:
        if not sheep.is_shorn:
            sheep.shear()
            sheep_shorn += 1
            points += 100
            info_label.text = "Mouton tondu. Continue ta tournée !"
            _refresh()
            return

    info_label.text = "Tous les moutons sont tondus. Recommence une journée."


func _reset_day() -> void:
    for sheep in sheep_list:
        sheep.queue_free()

    sheep_list.clear()
    sheep_shorn = 0
    points = 0

    _spawn_sheep()

    info_label.text = "Nouvelle journée de tonte."
    _refresh()


func _refresh() -> void:
    score_label.text = "Production : %d/%d     Points : %d" % [
        sheep_shorn,
        sheep_total,
        points
    ]

    if info_label.text.is_empty():
        info_label.text = "Bergerie prête. Bonne journée !"
