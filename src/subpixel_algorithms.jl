abstract type AbstractSubPixelAlgorithm end

struct None <: AbstractSubPixelAlgorithm end

function subpixel(::None, r)
    maxr, I = findmax(r)
    I, maxr
end

struct Foroosh <: AbstractSubPixelAlgorithm end

function subpixel(::Foroosh, r)
    I, maxr = subpixel(::None, r)
    Δ = ntuple(i -> _delta_foroosh(r, I, maxr, i), ndims(r))
    J = Tuple(I - one(I))
    hs = size(sig1) ./ 2
    @. J - hs + Δ, maxr
end

function _delta_foroosh(r1, r2, maxr)
    if r1 > r2
        δ = - r1 / (r1 + maxr)
    elseif r2 > r1
        δ = r2 / (r2 + maxr)
    else
        δ = 0.0
    end
    δ
end

function _delta_foroosh(r, I, maxr, dims)
    O = CartesianIndex(ntuple(i -> i == dims ? 1 : 0, ndims(r)))
    J = I - O
    K = I + O
    if !checkbounds(Bool, r, J) || !checkbounds(Bool, r, K)
        δ = 0.0 # edge, NaN  
    else
        δ = _delta_foroosh(r[J], r[K], maxr)
    end
    δ
end
