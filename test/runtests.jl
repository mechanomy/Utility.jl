
using Test

include("../src/Utility.jl")

@testset "test Utility.iWrap" begin
  @test Utility.iWrap(1,5) == 1
  @test Utility.iWrap(5,5) == 5
  @test Utility.iWrap(6,5) == 1
  @test Utility.iWrap(-6,5) == -1 #literally true, but may want to handle differently
  @test_throws MethodError Utility.iWrap(6.3,5)
end
@testset "test Utility.iNext" begin
  @test Utility.iNext(1,5) == 2
  @test Utility.iNext(5,5) == 1
  @test Utility.iNext(6,2) == 1
  @test Utility.iNext(-6,5) == 0 #literally true, but may want to handle differently
end