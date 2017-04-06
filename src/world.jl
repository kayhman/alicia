module Wd
using Bd
using Bd: Body
using Physics: Physics, MechanicalState

type World
    state::MechanicalState
    bodies::Vector{Body}
end


function World()
    World(MechanicalState(), [])
end

function addBody(world::World, body::Body, pos::Vector{Float64}, vel::Vector{Float64}, mass::Matrix{Float64})
    Physics.addBody(world.state, pos, vel, mass)
    push!(world.bodies, body)
end

function draw(window, world::World)
    for i=1:length(world.bodies)
        Bd.draw(window, world.bodies[i])
    end
end

end
