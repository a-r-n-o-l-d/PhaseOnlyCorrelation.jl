abstract type AbstractSubPixelAlgorithm end

struct None <: AbstractSubPixelAlgorithm end

subpixel(::None, r, Imax, maxr) = ntuple(zero(r), ndims(r))

struct Foroosh <: AbstractSubPixelAlgorithm end

subpixel(::Foroosh, r, Imax, maxr) = ntuple(i -> _delta_foroosh(r, Imax, maxr, i), ndims(r))

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
