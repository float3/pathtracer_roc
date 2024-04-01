app "pathtracer"
    packages { image: "./roc-image/package/main.roc"}
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }

# Image.new 3 1 
# |> Result.try \image -> Image.set image 0 0 (255, 0, 0, 255)
# |> Result.try \image -> Image.set image 1 0 (0, 255, 0, 255)
# |> Result.try \image -> Image.set image 2 0 (0, 0, 255, 255)
# |> Result.map Image.toPNG