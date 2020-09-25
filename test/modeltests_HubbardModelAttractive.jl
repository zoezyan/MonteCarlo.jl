@testset "Hubbard Model Attractive" begin
    # constructors
    m = HubbardModelAttractive(dims=1, L=8);
    @test m.L == 8 && m.dims == 1
    @test typeof(m) == HubbardModelAttractive{Chain}
    d = Dict(:dims=>2,:L=>3)
    m = HubbardModelAttractive(d)
    @test typeof(m) == HubbardModelAttractive{SquareLattice}
    @test m.L == 3 && m.dims == 2

end
