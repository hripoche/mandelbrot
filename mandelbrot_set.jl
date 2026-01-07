# mandelbrot.jl
# Generate a Mandelbrot set image and save as "mandelbrot.png".
#
# Dependencies:
#   julia> using Pkg; Pkg.add("Plots")
# Then run:
#   julia mandelbrot.jl

using Plots

# Parameters — change these to zoom, change resolution or quality
const WIDTH  = 1600           # image width in pixels
const HEIGHT = 1000           # image height in pixels
const MAXIT  = 1000           # max iterations (higher => more detail)
const XLIM   = (-2.5, 1.0)    # x range in the complex plane
const YLIM   = (-1.25, 1.25)  # y range in the complex plane
const OUTPUT = "mandelbrot.png"

# Compute the escape iteration count with a smooth coloring value
function mandelbrot_matrix(w::Int, h::Int; xlim=XLIM, ylim=YLIM, maxit=MAXIT)
    xs = range(xlim[1], xlim[2], length=w)
    ys = range(ylim[1], ylim[2], length=h)
    M = Array{Float64}(undef, h, w)
    for j in 1:h
        y = ys[h - j + 1]  # flip vertically so image looks "upright"
        for i in 1:w
            x = xs[i]
            c = complex(x, y)
            z = complex(0.0, 0.0)
            it = 0
            while abs(z) <= 2 && it < maxit
                z = z*z + c
                it += 1
            end
            if it == maxit
                M[j,i] = 0.0  # interior points -> black / zero
            else
                # smooth iteration count for nicer continuous coloring
                mu = it + 1 - log(log(abs(z))) / log(2)
                M[j,i] = mu / maxit
            end
        end
    end
    return M
end

println("Rendering Mandelbrot set — this may take a moment...")
M = mandelbrot_matrix(WIDTH, HEIGHT)

# Plot and save
# You can change the colormap (e.g., :viridis, :inferno, :turbo, :magma)
p = heatmap(
    M,
    color = :turbo,
    axis = nothing,
    legend = false,
    framestyle = :none,
    dpi = 300,
    size = (WIDTH, HEIGHT)
)

savefig(p, OUTPUT)
println("Saved: $OUTPUT")
