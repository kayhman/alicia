module Hist

type History{T}
    states::Vector{T}
    size::Int64
    period::Float64
end

#Default constructor
History{T}(s::Int64, dt::Float64) = History{T}([], s, dt)

#Insert new state
function add{T}(h::History{T}, v::T)
    unshift!(h.states,v)
    if length(h.states) > h.size
        pop!(h.states)
    end
    ()
end


function interpolate{T}(h::History{T}, t::Float64)::T
    idx = convert(Int64, round(t / h.period))
    if idx >= h.size-1 || idx >= length(h.states)-1
        h.states[end]
    else
        h.states[idx+1] + (t-convert(Float64,idx)*h.period) / h.period * (h.states[idx+2] - h.states[idx+1])
    end
end


end
