extends CharacterBody3D
## Contrôleur de déplacement et caméra hybride. Les entrées tactiles sont exposées
## via set_mobile_move() et add_mobile_look() pour le HUD mobile.
@export var walk_speed := 3.8
@export var acceleration := 13.0
@export var gravity := 18.0
@export var look_sensitivity := 0.0025

var is_working := false
var mobile_move := Vector2.ZERO
var yaw := 0.0
var pitch := -0.12
var camera_pivot: Node3D
var camera: Camera3D

func _ready() -> void:
    var collision := CollisionShape3D.new()
    var capsule := CapsuleShape3D.new()
    capsule.radius = 0.32
    capsule.height = 1.72
    collision.shape = capsule
    collision.position.y = 0.86
    add_child(collision)

    var visual := MeshInstance3D.new()
    var body_mesh := CapsuleMesh.new()
    body_mesh.radius = 0.29
    body_mesh.height = 1.65
    visual.mesh = body_mesh
    visual.position.y = 0.86
    var body_mat := StandardMaterial3D.new()
    body_mat.albedo_color = Color(0.19,0.23,0.24)
    visual.material_override = body_mat
    add_child(visual)

    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0,1.52,0)
    add_child(camera_pivot)
    camera = Camera3D.new()
    camera.position = Vector3(0,0.9,4.3)
    camera.current = true
    camera_pivot.add_child(camera)

func _physics_process(delta: float) -> void:
    var input_axis := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
    )
    if mobile_move.length() > 0.05:
        input_axis = mobile_move
    input_axis = input_axis.normalized()
    var forward := -global_transform.basis.z
    var right := global_transform.basis.x
    var direction := (right * input_axis.x + forward * input_axis.y).normalized()
    var speed := walk_speed * (0.55 if is_working else 1.0)
    velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
    velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0
    move_and_slide()

func set_mobile_move(value: Vector2) -> void:
    mobile_move = value.limit_length(1.0)

func add_mobile_look(delta: Vector2) -> void:
    _apply_look(delta)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        _apply_look(event.relative)

func _apply_look(delta: Vector2) -> void:
    yaw -= delta.x * look_sensitivity
    pitch = clamp(pitch - delta.y * look_sensitivity, -0.75, 0.4)
    rotation.y = yaw
    camera_pivot.rotation.x = pitch

func enter_work_mode(target: Vector3) -> void:
    is_working = true
    look_at(Vector3(target.x, global_position.y, target.z), Vector3.UP)
    yaw = rotation.y
    camera.position = Vector3(0,0.28,1.45)
    camera_pivot.position = Vector3(0,1.34,0)
    camera_pivot.rotation.x = -0.08

func toggle_work_mode() -> void:
    is_working = not is_working
    if is_working:
        camera.position = Vector3(0,0.28,1.45)
        camera_pivot.position = Vector3(0,1.34,0)
    else:
        camera.position = Vector3(0,0.9,4.3)
        camera_pivot.position = Vector3(0,1.52,0)

func get_aim_direction() -> Vector3:
    return -camera.global_transform.basis.z
