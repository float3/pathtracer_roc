interface Float3
    exposes [Float3, new, get, x, y, z, w, scale, dot, length, normalize, add, sub, mul, div, pow]
    imports []

Float3 := { x: F64, y: F64, z: F64 }

new : F64, F64, F64 -> Float3
new = \x, y, z-> 
    @Float3 { x, y, z }

idx : Float3, U8 -> Result F64 [OutOfBounds]
idx = \@Float3 vec, i ->
    when i is 
        0 -> Ok vec.x
        1 -> Ok vec.y
        2 -> Ok vec.z
        _ -> Err OutOfBounds

x : Float3 -> F64
x = \@Float3 vec -> vec.x

y : Float3 -> F64
y = \@Float3 vec -> vec.y

z : Float3 -> F64
z = \@Float3 vec -> vec.z

scale : Float3, F64 -> Float3
scale = \@Float3 vec, scalar ->
    x = vec.x * scalar,
    y = vec.y * scalar
    z = vec.z * scalar

dot: Float3, Float3 -> F64
dot = \@Float3 a, b ->
    a.x * b.x + a.y * b.y + a.z * b.z

length : Float3 -> F64
length = \@Float3 vec ->
    sqrt(dot(vec, vec))

normalize : Float3 -> Float3
normalize = \@Float3 vec ->
    len = length(vec)
    scale(vec, 1.0 / len)

add : Float3, Float3 -> Float3
add = \@Float3 a, b ->
    x = a.x + b.x,
    y = a.y + b.y,
    z = a.z + b.z,

sub : Float3, Float3 -> Float3
sub = \@Float3 a, b ->
    x = a.x - b.x,
    y = a.y - b.y,
    z = a.z - b.z,

mul : Float3, Float3 -> Float3
mul = \@Float3 a, b ->
    x = a.x * b.x,
    y = a.y * b.y,
    z = a.z * b.z,

div : Float3, Float3 -> Float3
div = \@Float3 a, b ->
    x = a.x / b.x,
    y = a.y / b.y,
    z = a.z / b.z,

pow : Float3, Float3 -> Float3
pow = \@Float3 a, b ->
    x = a.x ^ b.x,
    y = a.y ^ b.y,
    z = a.z ^ b.z,