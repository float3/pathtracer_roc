app "pathtracer"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br", 
        rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.0.1/x_XwrgehcQI4KukXligrAkWTavqDAdE5jGamURpaX-M.tar.br",
        image: "./roc-image/package/main.roc",
        float4: "./roc-float4/main.roc",
        # float3: "./roc-float3/main.roc",
        # ray: "./roc-ray/main.roc",
    }
    imports [
        pf.Stdout, pf.Task, pf.File, pf.Path,
        rand.Random,
        image.Image,
        float4.Float4,
        # float3.Float3,
        # ray.Ray
    ]
    provides [main] to pf

width = 127
height = 127
depth = 10
samples = 32
# camera_pos = Float4.new 0 0.5 3.0 0 

main =
    List.range { start: At 0, end: Before width }
    |> List.joinMap \x ->
        List.range { start: At 0, end: Before height }
        |> List.map \y ->
            Stdout.line
                """
                x: $(Num.toStr x)
                y: $(Num.toStr y)
                """