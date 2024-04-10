interface Float4
    exposes [Float4, get]
    imports []

Float4 := { x: F64, y: F64, z: F64, w: F64 }

new : F64, F64, F64, F64 -> Float4
new = \x, y, z, w -> 
    @Float4 { x, y, z, w }

idx : Float4, U8 -> Result F64 [OutOfBounds]
idx = \@Float4 vec, i ->
    when i is 
        0 -> Ok vec.x
        1 -> Ok vec.y
        2 -> Ok vec.z
        3 -> Ok vec.w
        _ -> Err OutOfBounds

x : Float4 -> F64
x = \@Float4 vec -> vec.x

y : Float4 -> F64
y = \@Float4 vec -> vec.y

z : Float4 -> F64
z = \@Float4 vec -> vec.z

w : Float4 -> F64
w = \@Float4 vec -> vec.w

scale : Float4, F64 -> Float4
scale = \@Float4 vec, scalar ->
    x = vec.x * scalar,
    y = vec.y * scalar
    z = vec.z * scalar
    w = vec.w * scalar

dot: Float4, Float4 -> F64
dot = \@Float4 a, b ->
    a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w

length : Float4 -> F64
length = \@Float4 vec ->
    sqrt(dot(vec, vec))

length_squared : Float4 -> F64
length_squared = \@Float4 vec ->
    dot(vec, vec)

normalize : Float4 -> Float4
normalize = \@Float4 vec ->
    len = length(vec)
    scale(vec, 1.0 / len)

add : Float4, Float4 -> Float4
add = \@Float4 a, b ->
    x = a.x + b.x,
    y = a.y + b.y,
    z = a.z + b.z,
    w = a.w + b.w

sub : Float4, Float4 -> Float4
sub = \@Float4 a, b ->
    x = a.x - b.x,
    y = a.y - b.y,
    z = a.z - b.z,
    w = a.w - b.w

mul : Float4, Float4 -> Float4
mul = \@Float4 a, b ->
    x = a.x * b.x,
    y = a.y * b.y,
    z = a.z * b.z,
    w = a.w * b.w

div : Float4, Float4 -> Float4
div = \@Float4 a, b ->
    x = a.x / b.x,
    y = a.y / b.y,
    z = a.z / b.z,
    w = a.w / b.w

pow : Float4, Float4 -> Float4
pow = \@Float4 a, b ->
    x = a.x ^ b.x,
    y = a.y ^ b.y,
    z = a.z ^ b.z,
    w = a.w ^ b.w