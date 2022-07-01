module PhaseOnlyCorrelation

using FFTW
using ApodizationFunctions: AbstractApodizationFunction
using Images

export poc, displacement, None, Foroosh #, local_displacement

include("subpixel_algorithms.jl")

"""
    poc(sig1, sig2)


"""
function poc(sig1, sig2)
    c = fft(sig1) .* conj.(fft(sig2))
    real.(ifftshift(ifft(c ./ abs.(c))))
end

poc(sig1::Array{T}, sig2::Array{T}) where {T<:AbstractGray} = poc(channelview(sig1), channelview(sig2))

function displacement(sig1, sig2)
    r = poc(sig1, sig2)
    maxr, Imax = findmax(r)
    shift = Tuple(Imax - oneunit(Imax))
    hs = size(sig1) ./ 2
    @. shift - hs, maxr
end

function displacement(algo::AbstractSubPixelAlgorithm, sig1, sig2)
    r = poc(sig1, sig2)
    maxr, Imax = findmax(r)
    δ = subpixel(algo, r, Imax, maxr)
    shift = Tuple(Imax - oneunit(Imax))
    hs = size(sig1) ./ 2
    @. shift - hs + δ, maxr
end

displacement(apod::AbstractApodizationFunction, sig1, sig2) = displacement(apod(sig1), apod(sig2))

displacement(algo::AbstractSubPixelAlgorithm, apod::AbstractApodizationFunction, sig1, sig2) = 
    displacement(algo, apod(sig1), apod(sig2))

#=
function local_displacement(sig1, sig2, I, winsize, apod)
    Δ = CartesianIndex(winsize .÷ 2)
    s1 = apod(sig1[I - Δ:I + Δ - one(I)])
    s2 = apod(sig2[I - Δ:I + Δ - one(I)])
    displacement(s1, s2)
end
=#
end
