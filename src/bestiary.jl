module Bestiary

########################
# Constraint functions #
########################
function distConstraint(l::Float64)
    f(x::Vector{Float64})::Float64 = 0.5 * ((x[1]^2 + x[2]^2) - l^2)
    f
end

function elliConstraint(l::Float64)
    f(x::Vector{Float64}) = [x[1,1]^2/2^2 + x[2,1]^2/1^2 - l^2]
    f
end

function multiConstraint(l::Float64)
    f(x::Vector{Float64}) = [x[1,1]^2/2^2 + x[2,1]^2/1^2 - l^2 ; 0.5 * ((x[4]^2 + x[5]^2) - l^2)]
    f
end

########################
#   Force functions    #
########################
function spring(stiffness::Float64, damping::Float64, restLength::Float64, restPos::Float64, coordIdx::Int64)
    function s(x::Vector{Float64}, v::Vector{Float64})
        f = fill(0.0, length(x))
        f[coordIdx] = - stiffness * ((x[coordIdx] - restLength) - restPos) - damping * v[coordIdx]
        f
    end
    s
end

function force(intensity::Float64, coordIdx::Int64)
    function t(x::Vector{Float64}, v::Vector{Float64})
        f = fill(0.0, length(x))
        f[coordIdx] = intensity
        f
    end
    t
end

end
