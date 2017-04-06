module Bd
using SFML
using Helper
using Hist
using Hist: History
using Math: transform

abstract Body

type Ball <: Body
    shape::CircleShape
    trail::Vector{CircleShape}
    traj::History{Vector{Float64}}
    stateOffset::Int64
end

type Rectangle <: Body
    shape
    trail
    traj
    stateOffset
end


# Ball constructor
function Ball(radius, offset)
    #############
    # Init trail#
    #############
    trailSize = 15
    trail = []
    shape = CircleShape()
    set_radius(shape, radius)
    set_origin(shape, Vector2f(radius, radius))
    green = convert(Int64, round(rand() * 125.0))
    for i=1:20
        c = copy(shape)
        t = convert(Int64, 255 - i * 255 / trailSize)
        set_fillcolor(c, SFML.Color(255, green, 0, t))
        push!(trail, c)
    end

    #############
    # Init Ball#
    #############
    traj = History{Vector{Float64}}([], 1000, 0.1)
    ball = Ball(CircleShape(), trail, traj, offset)
    
    set_radius(ball.shape, radius)
    set_fillcolor(ball.shape, SFML.Color(255, green, 0))
    set_origin(ball.shape, Vector2f(radius, radius))
    
    return ball
end

# Ball constructor
function Rectangle(length, height, offset)
    #############
    # Init trail#
    #############
    trailSize = 15
    trail = []
    shape = RectangleShape()
    set_size(shape, Vector2f(length, height))
    set_origin(shape, Vector2f(length/2.0, height/2.0))
    green = convert(Int64, round(rand() * 255.0))
    for i=1:20
        c = copy(shape)
        t = convert(Int64, 255 - i * 255 / trailSize)
        set_fillcolor(c, SFML.Color(255, green, 0, t))
        push!(trail, c)
    end

    #############
    # Init Ball#
    #############
    traj = History{Vector{Float64}}([], 1000, 0.1)
    rect = Rectangle(RectangleShape(), trail, traj, offset)
    
    set_size(rect.shape, Vector2f(length, height))
    set_fillcolor(rect.shape, SFML.Color(255, green, 0))
    set_origin(rect.shape, Vector2f(length/2.0, height/2.0))
    
    return rect
end

function move(body::Body, pos::Vector{Float64})
    set_position(body.shape, Vector2f(pos[1], pos[2]))
    set_rotation(body.shape, pos[3] * 180 / pi)
    Hist.add(body.traj, pos)
    for i=1:length(body.trail)
        p = Hist.interpolate(body.traj, 0.25 * i)
        set_position(body.trail[i], Vector2f(p[1], p[2]))
        set_rotation(body.trail[i], pos[3] * 180 / pi)
    end
end

function draw(window, body::Body)
    SFML.draw(window, body.shape)
    for i=1:length(body.trail)
        SFML.draw(window, body.trail[i])
    end
end

end
