module Helper
using SFML

Vector2f(v::Matrix{Float64}) = SFML.Vector2f(v[1], v[2]) 

end
