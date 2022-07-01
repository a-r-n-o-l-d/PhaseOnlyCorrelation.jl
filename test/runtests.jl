using PhaseOnlyCorrelation
using ApodizationFunctions
using Images
using Interpolations
using CoordinateTransformations
using TestImages
using Test

@testset "PhaseOnlyCorrelation" begin
    # Test with a discrete translation
    Δtrue = (5.0, 8.0)
    img1 = testimage("cameraman.tif")
    t = Translation(Δtrue...)
    img2 = warp(img1, Translation(Δtrue...), indices_spatial(img1); method = Linear(), fillvalue = 0)
    Δest, _ = displacement(img1, img2)
    @test all(Δest .== Δtrue)

    # Test with an apodization function
    apod = apodfunc(:hamming, size(img1))
    Δest, _ = displacement(apod, img1, img2)
    @test all(Δest .== Δtrue)

    # Test subpixel Foroosh method
    Δtrue = (5.2, 8.3)
    img2 = warp(img1, Translation(Δtrue...), indices_spatial(img1); method = Linear(), fillvalue = 0)
    Δest, _ = displacement(Foroosh(), img1, img2)
    @test all(isapprox.(Δest, Δtrue; atol = 0.2))
    Δest, _ = displacement(Foroosh(), apod, img1, img2)
    @test all(isapprox.(Δest, Δtrue; atol = 0.1))
end
