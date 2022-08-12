# MIT License
# Copyright (c) 2022 Mechanomy LLC
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using Test
using Unitful
using StaticArrays #for defined-length arrays: SVector{3,T}

using Utility

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
  @test Utility.iNext(-6,5) == 0 
end



function eqTolMatrices()
  A = rand(3,4)/3;
  # println(typeof(A))
  B = A .+ 1e-2;
  return !Utility.eqTol(A,B, 1e-3)
end

"""Compares StaticArrays.SMatrix to LinearAlgebra.Matrix, both of which <: AbstractMatrix"""
function eqTolMatricesMixed()
  A = SMatrix{2,3}([1 2.1 3.2; 4.3 5.4 6.5])
  B = Matrix([1 2.1 3.2; 4.3 5.4 6.5])
  return Utility.eqTol(A,B, 1e-9)
end

function eqTolMatricesUnitful()
  A = rand(3,4)u"mm";
  B = A .+ 1e-4u"mm";
  return Utility.eqTol(A,B, 1e-3)
end
@testset "test set bools" begin
  @test Utility.eqTol(1,2) == false
  @test eqTolMatrices()
  @test eqTolMatricesMixed()
  @test eqTolMatricesUnitful()
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

@testset "Utility.eqTol" begin
  @test Utility.eqTol( 25.4u"mm", 1u"inch" )
  @test_throws Unitful.DimensionError Utility.eqTol( 25.4u"mm", 1u"°" )
end

