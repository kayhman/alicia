#run: julia src/anim.jl
include("helper.jl")
include("math.jl")
include("history.jl")
include("physics.jl")
include("body.jl")
include("bestiary.jl")
include("world.jl")

using SFML
using Bd: Ball, Rectangle, move
using Wd: World, draw
using Math: transform
using Physics: MechanicalState, addForce, integrate, init
using Bestiary: multiConstraint, spring, force
    
ball_radius = 15.0

window_width = 800
window_height = 600

function reset(ball::Ball)
    set_position(ball.shape, ball.starting_pos)
end

function update(state, balls)
    for i=1:20
        integrate(state, 1e-4, Vector2f(1e4, 100))
    end
    for i=1:length(balls)
        ball = balls[i]
        move(ball, transform(window_width, window_height, state.pos[ball.stateOffset:ball.stateOffset+2]))
    end
end

function main()
    world = World()
    constraintLength = 1.0
    world.state.constraint = multiConstraint(constraintLength)
    ####
    # Create Body 1
    ####
    pos = [-2.0, 0., 0.]
    vel = [0.0, 0.0, 0.]
    mass = eye(3)
    ball1 = Ball(ball_radius, 1)
    Wd.addBody(world, ball1, pos, vel, mass)

    ####
    # Create Body 2
    ####
    pos = [-1.0, 0., 0.]
    vel = [0.0, 0.0, 0.]
    mass = eye(3)
    ball2 = Ball(ball_radius, 4)
    Wd.addBody(world, ball2, pos, vel, mass)


    ####
    # Create Body 3
    ####
    pos = [0.0, 0., 0.]
    vel = [0.0, 0.0, 0.]
    mass = eye(3)
    ball3 = Rectangle(ball_radius, ball_radius, 7)
    Wd.addBody(world, ball3, pos, vel, mass)

    s = spring(1e2,1.,0.,0.,8)
    addForce(world.state, s)
    t = force(1e2,9)
    addForce(world.state, t)
    
    
    ###
    # Init Jacobian
    ###
    init(world.state)
    
    window = RenderWindow("Forth", window_width, window_height)
    set_framerate_limit(window, 60)
    set_vsync_enabled(window, true)
    event = Event()
    start = false
    pause = true
    while isopen(window)
        while pollevent(window, event)
            if get_type(event) == EventType.CLOSED
                close(window)
            end
            # Press Space
            if get_type(event) == EventType.KEY_PRESSED && get_key(event).key_code == 57
                start = true
                pause = !pause
            end
            # Press q
            if get_type(event) == EventType.KEY_PRESSED && get_key(event).key_code == 16
                close(window)
            end
        end

	if !start
            clear(window, SFML.white)
            display(window)
	    continue
	end

        if pause
            continue
        end
        
        clear(window, SFML.white)
        update(world.state, world.bodies)
        draw(window, world)

        display(window)
    end
end

main()
