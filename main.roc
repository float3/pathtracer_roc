app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.2/9zUBxb1LtXYVc4eR4hAtd1WQDwBYDhM6HQdZz1UFCm2m.tar.zst" }

import pf.OsStr
import pf.Path
import pf.Stdout

width : U64
width = 400

height : U64
height = 300

samples : U64
samples = 128

max_depth : U64
max_depth = 8

Vec3 : { x : F64, y : F64, z : F64 }

Ray : { origin : Vec3, dir : Vec3 }

Sphere : { center : Vec3, radius : F64, albedo : Vec3, emission : Vec3 }

Hit : { t : F64, point : Vec3, normal : Vec3, sphere : Sphere }

vec : F64, F64, F64 -> Vec3
vec = |x, y, z| { x: x, y: y, z: z }

black : Vec3
black = vec(0.0, 0.0, 0.0)

add : Vec3, Vec3 -> Vec3
add = |a, b| { x: a.x + b.x, y: a.y + b.y, z: a.z + b.z }

sub : Vec3, Vec3 -> Vec3
sub = |a, b| { x: a.x - b.x, y: a.y - b.y, z: a.z - b.z }

mul : Vec3, Vec3 -> Vec3
mul = |a, b| { x: a.x * b.x, y: a.y * b.y, z: a.z * b.z }

scale : Vec3, F64 -> Vec3
scale = |v, s| { x: v.x * s, y: v.y * s, z: v.z * s }

dot : Vec3, Vec3 -> F64
dot = |a, b| a.x * b.x + a.y * b.y + a.z * b.z

length : Vec3 -> F64
length = |v| dot(v, v).sqrt()

normalize : Vec3 -> Vec3
normalize = |v| scale(v, 1.0 / length(v))

camera_origin : Vec3
camera_origin = vec(0.0, 0.5, 2.5)

scene : List(Sphere)
scene = [
	{ center: vec(0.0, -1000.5, -1.0), radius: 1000.0, albedo: vec(0.6, 0.6, 0.6), emission: black },
	{ center: vec(-0.9, 0.0, -1.2), radius: 0.5, albedo: vec(0.85, 0.25, 0.2), emission: black },
	{ center: vec(0.3, 0.0, -1.0), radius: 0.5, albedo: vec(0.2, 0.4, 0.9), emission: black },
	{ center: vec(1.3, 0.1, -1.9), radius: 0.6, albedo: vec(0.9, 0.9, 0.9), emission: black },
	{ center: vec(0.2, 1.7, -0.7), radius: 0.4, albedo: black, emission: vec(6.0, 5.5, 5.0) },
]

# xorshift64*: every function that draws a number returns the next state with it.
next_rng : U64 -> U64
next_rng = |s0| {
	s1 = s0.bitwise_xor(s0.shr_zf_wrap(12))
	s2 = s1.bitwise_xor(s1.shl_wrap(25))
	s2.bitwise_xor(s2.shr_zf_wrap(27))
}

rand_f64 : U64 -> (F64, U64)
rand_f64 = |rng| {
	next = next_rng(rng)
	bits = next.times_wrap(2685821657736338717).shr_zf_wrap(11)
	(bits.to_f64() / 9007199254740992.0, next)
}

random_unit_vector : U64 -> (Vec3, U64)
random_unit_vector = |rng| {
	(u1, r1) = rand_f64(rng)
	(u2, r2) = rand_f64(r1)
	z = 1.0 - 2.0 * u1
	r = (1.0 - z * z).sqrt()
	phi = 2.0 * F64.pi * u2
	(vec(r * phi.cos(), r * phi.sin(), z), r2)
}

hit_sphere : Ray, Sphere -> Try(Hit, [Miss])
hit_sphere = |ray, sphere| {
	oc = sub(ray.origin, sphere.center)
	a = dot(ray.dir, ray.dir)
	half_b = dot(oc, ray.dir)
	c = dot(oc, oc) - sphere.radius * sphere.radius
	disc = half_b * half_b - a * c
	if disc < 0.0 {
		Err(Miss)
	} else {
		root = disc.sqrt()
		near = (0.0 - half_b - root) / a
		far = (0.0 - half_b + root) / a
		t = if near > 0.001 near else far
		if t > 0.001 {
			point = add(ray.origin, scale(ray.dir, t))
			outward = scale(sub(point, sphere.center), 1.0 / sphere.radius)
			normal = if dot(ray.dir, outward) < 0.0 outward else scale(outward, -1.0)
			Ok({ t: t, point: point, normal: normal, sphere: sphere })
		} else {
			Err(Miss)
		}
	}
}

closest_hit : Ray -> Try(Hit, [NoHit])
closest_hit = |ray|
	scene.fold(
		Err(NoHit),
		|best, sphere| {
			match hit_sphere(ray, sphere) {
				Err(Miss) => best
				Ok(hit) => {
					match best {
						Ok(other) => if hit.t < other.t Ok(hit) else best
						Err(NoHit) => Ok(hit)
					}
				}
			}
		},
	)

sky : Ray -> Vec3
sky = |ray| {
	t = 0.5 * (normalize(ray.dir).y + 1.0)
	add(scale(vec(0.25, 0.25, 0.25), 1.0 - t), scale(vec(0.15, 0.25, 0.45), t))
}

trace : Ray, U64, U64 -> (Vec3, U64)
trace = |ray, depth, rng| {
	if depth == 0 {
		(black, rng)
	} else {
		match closest_hit(ray) {
			Err(NoHit) => (sky(ray), rng)
			Ok(hit) => {
				(bounce, rng2) = random_unit_vector(rng)
				candidate = add(hit.normal, bounce)
				dir = if length(candidate) < 0.000001 hit.normal else candidate
				(incoming, rng3) = trace({ origin: hit.point, dir: dir }, depth - 1, rng2)
				(add(hit.sphere.emission, mul(hit.sphere.albedo, incoming)), rng3)
			}
		}
	}
}

camera_ray : U64, U64, U64 -> (Ray, U64)
camera_ray = |x, y, rng| {
	(jx, rng1) = rand_f64(rng)
	(jy, rng2) = rand_f64(rng1)
	aspect = width.to_f64() / height.to_f64()
	u = ((x.to_f64() + jx) / width.to_f64()) * 2.0 - 1.0
	v = 1.0 - ((y.to_f64() + jy) / height.to_f64()) * 2.0
	dir = normalize(vec(u * aspect * 0.8, v * 0.8, -1.0))
	({ origin: camera_origin, dir: dir }, rng2)
}

render_pixel : U64, U64, U64 -> (Vec3, U64)
render_pixel = |x, y, rng0| {
	var $rng = rng0
	var $sum = black
	for _sample in (0).until(samples) {
		(ray, rng1) = camera_ray(x, y, $rng)
		(color, rng2) = trace(ray, max_depth, rng1)
		$sum = add($sum, color)
		$rng = rng2
	}
	(scale($sum, 1.0 / samples.to_f64()), $rng)
}

to_byte : F64 -> U8
to_byte = |c| {
	clamped = if c < 0.0 0.0 else if c > 1.0 1.0 else c
	(clamped.sqrt() * 255.0).floor_to_u8_try().ok_or(255)
}

main! : List(OsStr) => Try({}, _)
main! = |_args| {
	var $rng = 88172645463325252
	var $bytes = List.with_capacity(width * height * 3)
	for y in (0).until(height) {
		for x in (0).until(width) {
			(color, next) = render_pixel(x, y, $rng)
			$rng = next
			$bytes = $bytes.append(to_byte(color.x)).append(to_byte(color.y)).append(to_byte(color.z))
		}
	}
	out : Path
	out = "output.ppm"
	out.write_bytes!("P6\n${width.to_str()} ${height.to_str()}\n255\n".to_utf8().concat($bytes))?
	Stdout.line!("wrote output.ppm")?
	Ok({})
}
