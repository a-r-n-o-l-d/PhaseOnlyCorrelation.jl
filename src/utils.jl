function testpair(imtest, Δ)
    img1 = testimage(imtest)
    img2 = warp(img1, Translation(Δ...), indices_spatial(img1); method = Linear(), fillvalue = 0)
    img1, img2
end
