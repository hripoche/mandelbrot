function mandel(z; maxiter = 100)
    c = z
    for n in 1:maxiter
        if abs(z) > 2
            return n - 1
        end
        z = z^2 +c
    end
    return maxiter
end
