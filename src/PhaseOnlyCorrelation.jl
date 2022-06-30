module PhaseOnlyCorrelation

export poc, displacement, local_displacement

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
    maxr, I = findmax(r)
    Δ = ntuple(i -> _delta(r, I, maxr, i), ndims(sig1))
    J = Tuple(I - one(I))
    hs = size(sig1) ./ 2
    @. J - hs + Δ, maxr
end

displacement(sig1, sig2, apod) = displacement(apod(sig1), apod(sig2))

function local_displacement(sig1, sig2, I, winsize, apod)
    Δ = CartesianIndex(winsize .÷ 2)
    s1 = apod(sig1[I - Δ:I + Δ - one(I)])
    s2 = apod(sig2[I - Δ:I + Δ - one(I)])
    displacement(s1, s2)
end

function _delta(r1, r2, maxr)
    if r1 > r2
        δ = - r1 / (r1 + maxr)
    elseif r2 > r1
        δ = r2 / (r2 + maxr)
    else
        δ = 0.0
    end
    δ
end

function _delta(r, I, maxr, dims)
    O = CartesianIndex(ntuple(i -> i == dims ? 1 : 0, ndims(r)))
    J = I - O
    K = I + O
    if !checkbounds(Bool, r, J) || !checkbounds(Bool, r, K)
        δ = 0.0 # edge, NaN  
    else
        δ = _delta(r[J], r[K], maxr)
    end
    δ
end

end
