using PhaseOnlyCorrelation
using ApodizationFunctions
using Test

@testset "PhaseOnlyCorrelation" begin
    # Test with a discrete translation
    Δtrue = (5.0, 8.0)
    img1, img2 = testpair("cameraman.tif", Δtrue)
    Δest, _ = displacement(img1, img2)
    @test all(Δest .== Δtrue)

    # Test with an apodization function
    Δtrue = (15.0, -18.0)
    img1, img2 = testpair("cameraman.tif", Δtrue)
    apod = apodfunc(:hamming, size(img1))
    Δest, _ = displacement(apod, img1, img2)
    @test all(Δest .== Δtrue)

    # Test subpixel Foroosh method
    Δtrue = (5.3, -8.3)
    img1, img2 = testpair("cameraman.tif", Δtrue)
    Δest, _ = displacement(Foroosh(), img1, img2)
    @test all(isapprox.(Δest, Δtrue; atol = 0.2))
    Δest, _ = displacement(Foroosh(), apod, img1, img2)
    @test all(isapprox.(Δest, Δtrue; atol = 0.1))
end
