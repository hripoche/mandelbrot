@info "Rendering Julia set" width=width height=height center=center zoom=zoom c=c maxiter=maxiter output=output
for j in 1:height
    im = im_max - (j - 1) * (im_max - im_min) / (height - 1)  # y -> imag (flip for top-down)
    for i in 1:width
        re = re_min + (i - 1) * (re_max - re_min) / (width - 1)
        z0 = complex(re, im)
        mu = smooth_iteration(z0, c, maxiter)
        if mu >= maxiter
            # inside set: use black
            col = RGB{N0f8}(0,0,0)
        else
            t = mu / maxiter
            col = color_from_t(t)
        end
        img[j, i] = col
    end
    # optional progress print every 50 lines
    if (j % 50) == 0
        @info("row", row=j, of=height)
    end
end

# Save image (FileIO uses ImageIO/PNG backend)
save(output, permutedims(img, (2,1))) # permute so image isn't transposed by some backends
@info "Saved image to $output"
