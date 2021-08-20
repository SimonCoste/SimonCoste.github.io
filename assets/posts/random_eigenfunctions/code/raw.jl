# This file was generated, do not modify it. # hide
using GLMakie

field = [f(θ, φ) for θ in t, φ in u]
fig, ax, pltobj = surface(x, y, z, color = field, 
        colormap = :vik,
        lightposition = Vec3f0(0, 0, 0.8), 
        ambient = Vec3f0(0.6, 0.6, 0.6),
        backlight = 5f0, 
        show_axis = false) 

cbar = Colorbar(fig, pltobj,
        height = Relative(0.4), width = 10 )

fig[1,2] = cbar #hide
set_theme!(figure_padding = 0)#hide
save(joinpath(@OUTPUT, "raw.png"), fig) #hide