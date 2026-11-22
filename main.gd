extends Node2D

var sheep_count := 6
var shorn_count := 0
var score := 0
var status_label: Label
var score_label: Label
var sheep_nodes: Array[Node2D] = []

func _ready() -> void:
    _build_scene()

func _build_scene() -> void:
    var background := ColorRect.new()
    background.color = Color("#343d32")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var title := Label.new()
    title.text = "FAB SHEARING — THE REAL LIFE"
    title.position = Vector2(30, 20)
    title.add_theme_font_size_override("font_size", 30)
    add_child(title)

    status_label = Label.new()
    status_label.text = "Bergerie : prépare ta journée"
    status_label.position = Vector2(30, 75)
    status_label.add_theme_font_size_override("font_size", 20)
    add_child(status_label)

    score_label = Label.new()
    score_label.position = Vector2(30, 115)
    score_label.add_theme_font_size_override("font_size", 20)
    add_child(score_label)

    for i in range(sheep_count):
        var sheep := Node2D.new()
        sheep.set_script(load("res://scripts/sheep.gd"))
        sheep.position = Vector2(170 + (i % 3) * 300, 260 + int(i / 3) * 190)
        sheep.set_meta("index", i)
        add_child(sheep)
        sheep_nodes.append(sheep)

    var shear_button := Button.new()
    shear_button.text = "TONDRE LE MOUTON SÉLECTIONNÉ"
    shear_button.position = Vector2(30, 650)
    shear_button.size = Vector2(390, 48)
    shear_button.pressed.connect(_shear_selected)
    add_child(shear_button)

    var reset_button := Button.new()
    reset_button.text = "NOUVELLE JOURNÉE"
    reset_button.position = Vector2(440, 650)
    reset_button.size = Vector2(220, 48)
    reset_button.pressed.connect(_new_day)
    add_child(reset_button)

    _refresh_labels()

func _shear_selected() -> void:
    for sheep in sheep_nodes:
        if not sheep.get_meta("shorn", false):
            sheep.set_meta("shorn", true)
            sheep.call("shear")
            shorn_count += 1
            score += 100
            status_label.text = "Mouton tondu ! Belle progression."
            _refresh_labels()
            return
    status_label.text = "Tous les moutons sont déjà tondus."

func _new_day() -> void:
    for sheep in sheep_nodes:
        sheep.queue_free()
    sheep_nodes.clear()
    shorn_count = 0
    score = 0
    for i in range(sheep_count):
        var sheep := Node2D.new()
        sheep.set_script(load("res://scripts/sheep.gd"))
        sheep.position = Vector2(170 + (i % 3) * 300, 260 + int(i / 3) * 190)
        sheep.set_meta("index", i)
        add_child(sheep)
        sheep_nodes.append(sheep)
    status_label.text = "Nouvelle journée : bon courage !"
    _refresh_labels()

func _refresh_labels() -> void:
    score_label.text = "Production : %d / %d moutons     Points : %d" % [shorn_count, sheep_count, score]
