interface Float4
    exposes [Float4, new , get, scale, dot, length, normalize, add, sub, mul, div, pow]
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

scale : Float4, F64 -> Float4
scale = \@Float4 vec, scalar ->
    x = vec.x * scalar
    y = vec.y * scalar
    z = vec.z * scalar
    w = vec.w * scalar
    @Float4 { x, y, z, w }

dot: Float4, Float4 -> F64
dot = \@Float4 a, b ->
    a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w

length : Float4 -> F64
length = \@Float4 vec ->
    Num.sqrt(dot(vec, vec))

normalize : Float4 -> Float4
normalize = \@Float4 vec ->
    len = length(vec)
    scale(vec, 1.0 / len)

add : Float4, Float4 -> Float4
add = \@Float4 a, b ->
    x = a.x + b.x
    y = a.y + b.y
    z = a.z + b.z
    w = a.w + b.w
    @Float4 { x, y, z, w }

sub : Float4, Float4 -> Float4
sub = \@Float4 a, b ->
    x = a.x - b.x
    y = a.y - b.y
    z = a.z - b.z
    w = a.w - b.w
    @Float4 { x, y, z, w }

mul : Float4, Float4 -> Float4
mul = \@Float4 a, b ->
    x = a.x * b.x
    y = a.y * b.y
    z = a.z * b.z
    w = a.w * b.w
    @Float4 { x, y, z, w }

div : Float4, Float4 -> Float4
div = \@Float4 a, b ->
    x = a.x / b.x
    y = a.y / b.y
    z = a.z / b.z
    w = a.w / b.w
    @Float4 { x, y, z, w }

pow : Float4, Float4 -> Float4
pow = \@Float4 a, b ->
    x = a.x ^ b.x
    y = a.y ^ b.y
    z = a.z ^ b.z
    w = a.w ^ b.w
    @Float4 { x, y, z, w }