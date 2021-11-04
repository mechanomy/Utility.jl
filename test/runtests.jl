
using Test
using Unitful

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

@testset "test stringTable" begin
  @test Utility.stringTable(["abc","defghi","jk","lmnopq"], 4, "|") == " abc|defg|  jk|lmno"
  @test Utility.stringTable(["abcdef","ghi","jkl","mnopq"], 4, "|") == "abcd| ghi| jkl|mnop"
end


function chirpLinear_amplitudeUnits() #what needs to be tested?
  fstart = 1u"Hz"
  fstop = 10u"Hz"
  amp = 2
  t,f,y = Utility.chirpLinear(fstart,fstop, 11u"s", amp)
  return f[1] == fstart && f[end] == fstop
  # plot(ustrip(chirp[1]), ustrip(chirp[2]))
end

@testset "test chirpLinear" begin
  @test chirpLinear_amplitudeUnits()
end