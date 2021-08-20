# This file was generated, do not modify it. # hide
signs = [x > 0 ? 0 : 1 for x in field]
fig2, ax2, pltobj2 = surface(x, y, z, color = signs, 
        colormap = :ice,
        lightposition = Vec3f0(0, 0, 0.8), 
        ambient = Vec3f0(0.6, 0.6, 0.6),
        backlight = 5f0, 
        show_axis = false) 
save(joinpath(@OUTPUT, "raw2.png"), fig2) #hide