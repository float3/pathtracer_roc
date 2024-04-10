app "pathtracer"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br", 
        rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.0.1/x_XwrgehcQI4KukXligrAkWTavqDAdE5jGamURpaX-M.tar.br",
        image: "./roc-image/package/main.roc",
        float4: "./roc-float4/main.roc",
        float3: "./roc-float3/main.roc",
        ray: "./roc-ray/main.roc",
    }
    imports [
        pf.Stdout, pf.Task, pf.File, pf.Path,
        rand.Random,
        image.Image,
        float4.Float4,
        float3.Float3,
    ]
    provides [main] to pf

width = 128
height = 128
depth = 10
samples = 32
camera_pos = Float3.new 0 0.5 3.0

traceRay : Ray, U8, State U32 -> (Color, State U32)
traceRay = \ray, depth, rand_state ->
    if depth == 0 then
        (Color.new 0 0 0, rand_state)
    else
        (Color.new 1 1 1, rand_state)

print : I32 
print = \x -> 
    Stdout.line "x: " x

main =
    # rand_state = Seed 42
    image = Image.new width height
    List.range { start: At 0, end: At height-1 }
    |> List.range { start: At 0, end: At width-1 }
    #         ray = Ray.new camera_pos (Float3.new (Float.of x / Float.of width) (Float.of y / Float.of height) 0)
    #         color, rand_state = traceRay ray depth rand_state
    #         Image.set image x y color

    # Image.save image "output.png"