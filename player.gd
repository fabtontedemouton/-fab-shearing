extends CharacterBody3D

@export var move_speed: float = 4.2
var move_vector := Vector2.ZERO

func _ready() -> void:
    var collision := CollisionShape3D.new()
    var collision_shape := CapsuleShape3D.new()
    collision_shape.radius = 0.32
    collision_shape.height = 1.65
    collision.shape = collision_shape
    collision.position.y = 0.85
    add_child(collision)

    var capsule := CapsuleMesh.new()
    capsule.radius = 0.32
    capsule.height = 1.65
    var body := MeshInstance3D.new()
    body.mesh = capsule
    body.position.y = 0.85
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.16, 0.24, 0.30)
    body.material_override = mat
    add_child(body)

    var head := MeshInstance3D.new()
    var head_mesh := SphereMesh.new()
    head_mesh.radius = 0.22
    head_mesh.height = 0.44
    head.mesh = head_mesh
    head.position = Vector3(0, 1.72, 0)
    var skin := StandardMaterial3D.new()
    skin.albedo_color = Color(0.82, 0.63, 0.48)
    head.material_override = skin
    add_child(head)

    var camera := Camera3D.new()
    camera.position = Vector3(0, 4.2, 7.2)
    camera.rotation_degrees = Vector3(-25, 0, 0)
    camera.current = true
    add_child(camera)

func _physics_process(_delta: float) -> void:
    var direction := Vector3(move_vector.x, 0, move_vector.y)
    if direction.length() > 1.0:
        direction = direction.normalized()
    velocity.x = direction.x * move_speed
    velocity.z = direction.z * move_speed
    velocity.y -= 18.0 * get_physics_process_delta_time()
    move_and_slide()
    if direction.length() > 0.1:
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 0.18)
