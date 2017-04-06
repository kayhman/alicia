module Math
using SFML

function transform(width::Int64, height::Int64, pos::Vector{Float64})
    x = width / 2 + pos[1,1] * width/4
    y = height / 2 - pos[2,1] * height/4
    r = pos[3]
    [x, y, r]
end


function jacobian(f, x::Vector{Float64})
    eps = Float64(1e-8)
    fx = f(x)
    J = fill(Float64(0), length(fx), length(x))
    for i=1:length(fx)
        for j=1:length(x)
            xp = copy(x)
            xp[j] = xp[j] + eps
            val = (f(xp) - fx)[i] / eps
            J[i,j] = val
        end
    end
    J
end

end
