module PhaseOnlyCorrelation

#=
Note :
Package ApodizationFunctions is reexporting to avoid "ERROR: can not merge projects",
this error is due to the add of ApodizationFunctions to ./test/Project.toml.
Test-specific dependencies should be avoided ?
https://github.com/JuliaLang/Pkg.jl/issues/1585
https://github.com/JuliaLang/Pkg.jl/issues/1714
=#

#using Reexport
#@reexport using ApodizationFunctions
using ApodizationFunctions: AbstractApodizationFunction
using FFTW
using Images
using Interpolations
using CoordinateTransformations
using TestImages

export testpair, poc, displacement, None, Foroosh

include("utils.jl")
include("subpixel_algorithms.jl")

"""
    poc(sig1, sig2)

Return
"""
function poc(sig1, sig2)
    c = fft(sig2) .* conj.(fft(sig1))
    real.(ifftshift(ifft(c ./ abs.(c))))
end

poc(sig1::Array{T}, sig2::Array{T}) where {T<:AbstractGray} = poc(channelview(sig1), channelview(sig2))

#=function displacement(sig1, sig2, subpix::None)
    r = poc(sig1, sig2)
    maxr, Imax = findmax(r)
    shift = Tuple(Imax - oneunit(Imax))
    hs = size(sig1) ./ 2
    @. shift - hs, maxr
end=#

#displacement(sig1, sig2, subpix::None) = 

function displacement(sig1, sig2, subpix::AbstractSubPixelAlgorithm = None())
    r = poc(sig1, sig2)
    maxr, Imax = findmax(r)
    δ = subpixel(subpix, r, Imax, maxr)
    shift = Tuple(Imax - oneunit(Imax))
    hs = size(sig1) ./ 2
    @. shift - hs + δ, maxr
end

#displacement(apod::AbstractApodizationFunction, sig1, sig2) = displacement(apod(sig1), apod(sig2))

displacement(sig1, sig2, apod::AbstractApodizationFunction, subpix::AbstractSubPixelAlgorithm = None()) = 
    displacement(apod(sig1), apod(sig2), subpix)

end
