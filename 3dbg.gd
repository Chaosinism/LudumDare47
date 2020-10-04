extends Spatial


func _ready():
    $Light/AnimationPlayer.play("LightAction")
    $Camera/AnimationPlayer.play("CameraAction")
