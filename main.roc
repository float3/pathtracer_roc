app "pathtracer"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br", 
        rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.0.1/x_XwrgehcQI4KukXligrAkWTavqDAdE5jGamURpaX-M.tar.br",
        image: "./roc-image/package/main.roc",
        float4: "./roc-float4/main.roc",
        ray: "./roc-ray/main.roc",
    }
    imports [
        pf.Stdout, pf.Task, pf.File, pf.Path,
        rand.Random,
        image.Image,
        float4.Float4,
    ]
    provides [main] to pf

width = 128
height = 128
cameraPos = Float3.new 0 0.5 3.0

# div = \n, max ->
#     (Num.toFrac n / Num.toFrac max)
#     |> Num.mul 255
#     |> Num.floor

# mapping =
#     List.range { start: At 0, end: Before height }
#     |> List.joinMap \y ->
#         List.range { start: At 0, end: Before width }
#         |> List.map \x -> (x, y, (div x width, div y height, 0, 255))

# main =
#     Image.new width height
#     |> Result.try \image -> List.walkTry mapping image \img, (x, y, pixel) -> Image.set img x y pixel
#     |> Result.map Image.toPNG
#     |> Task.fromResult
#     |> Task.await \bytes -> File.writeBytes (Path.fromStr "gradient.png") bytes
    # |> Task.onErr \_ -> crash "File write error"

main =
    r = Float4 { x: 0.5, y: 0.5, z: 0.5, w: 1.0 }
    r.x
    |> Num.toFloat
    |> Num.toString
    |> Stdout.line
    # Image.new width height #shoot a ray for each pixel
    # |> Result.try \image -> 
    #     List.range { start: At 0, end: Before height }
    #     |> List.joinMap \y ->
    #         List.range { start: At 0, end: Before width }
    #         |> List.map \x -> 
    #             let u = Num.toFrac x / Num.toFrac width
    #             let v = Num.toFrac y / Num.toFrac height
    #             let r = Ray.new (Float3.new 0 0 0) (Float3.new (u - 0.5) (v - 0.5) -1)
    #             let pixel = Ray.color r
    #             (x, y, pixel)