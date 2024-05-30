extends Resource
class_name HitInfo

var _colliders = []
var _distances = []

func add_collider(collider: CollisionObject2D, distance: float):
    var index = _colliders.find(collider)

    # if collider doesn't exist in our list, add it
    if index == -1:
        _colliders.append(collider)
        _distances.append(distance)
        return
    
    if distance < _distances[index]:
        _distances[index] = distance
        return


func get_hit_info() -> Array:
    return [_colliders, _distances]


func apply_damage(ammo_type: AmmoType):
    for i in range(_colliders.size()):
        if not _colliders[i] is HittableComponent:
            continue
        
        _colliders[i].health = _colliders[i].health - ammo_type.get_damage(_distances[i])
        print("Doing " + str(ammo_type.get_damage(_distances[i])) + " damage!");