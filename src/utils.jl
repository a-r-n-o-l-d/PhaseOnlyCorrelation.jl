function testpair(imtest, Δ)
    img2 = testimage(imtest)
    img1 = warp(img2, Translation(Δ...), indices_spatial(img2); method = Linear(), fillvalue = 0)
    img1, img2
end
