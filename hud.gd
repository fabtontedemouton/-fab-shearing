extends CanvasLayer
signal action_requested
signal camera_requested

var status_label: Label
var score_label: Label
var mode_label: Label
var action_button: Button
var move_origin := Vector2.ZERO
var move_touch := -1
var look_touch := -1
var last_look := Vector2.ZERO
var player_ref: Node

func _ready() -> void:
    _make_interface()
    player_ref = get_parent().get_node_or_null("Player")

func _make_interface() -> void:
    var panel := PanelContainer.new()
    panel.position = Vector2(18,18)
    panel.custom_minimum_size = Vector2(390,140)
    add_child(panel)
    var col := VBoxContainer.new()
    panel.add_child(col)
    var title := Label.new()
    title.text = "FAB SHEARING — THE REAL LIFE"
    title.add_theme_font_size_override("font_size",20)
    col.add_child(title)
    status_label = Label.new()
    col.add_child(status_label)
    score_label = Label.new()
    col.add_child(score_label)
    mode_label = Label.new()
    col.add_child(mode_label)

    var buttons := HBoxContainer.new()
    buttons.position = Vector2(20,620)
    add_child(buttons)
    action_button = Button.new()
    action_button.text = "INTERAGIR / PASSE"
    action_button.custom_minimum_size = Vector2(240,72)
    action_button.pressed.connect(func(): action_requested.emit())
    buttons.add_child(action_button)
    var cam := Button.new()
    cam.text = "CAMÉRA"
    cam.custom_minimum_size = Vector2(150,72)
    cam.pressed.connect(func(): camera_requested.emit())
    buttons.add_child(cam)

    var help := Label.new()
    help.text = "PC : ZQSD/WASD • souris : regarder • E : poste • ESPACE : action"
    help.position = Vector2(20,690)
    add_child(help)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.x < get_viewport().get_visible_rect().size.x * 0.45 and move_touch == -1:
                move_touch = event.index
                move_origin = event.position
            elif look_touch == -1:
                look_touch = event.index
                last_look = event.position
        else:
            if event.index == move_touch:
                move_touch = -1
                _set_move(Vector2.ZERO)
            if event.index == look_touch:
                look_touch = -1
    elif event is InputEventScreenDrag:
        if event.index == move_touch:
            var delta: Vector2 = (event.position - move_origin) / 90.0
            _set_move(Vector2(clamp(delta.x,-1,1), clamp(delta.y,-1,1)))
        elif event.index == look_touch:
            var delta: Vector2 = event.position - last_look
            last_look = event.position
            _add_look(delta)

func _set_move(value: Vector2) -> void:
    var p := get_parent().get_node_or_null("Player")
    if p and p.has_method("set_mobile_move"):
        p.set_mobile_move(value)

func _add_look(value: Vector2) -> void:
    var p := get_parent().get_node_or_null("Player")
    if p and p.has_method("add_mobile_look"):
        p.add_mobile_look(value)

func set_status(value: String) -> void:
    if status_label:
        status_label.text = value

func set_score(value: int, remaining: int) -> void:
    if score_label:
        score_label.text = "POINTS PROVISOIRES : %d  |  ZONES RESTANTES : %d" % [value, remaining]
