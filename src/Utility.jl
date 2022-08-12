# MIT License
# Copyright (c) 2022 Mechanomy LLC
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


"""
Convenience functions not found elsewhere.
"""
module Utility
  using Unitful
  using DocStringExtensions

  """Union type for angular units."""
  Angle{T} = Union{Quantity{T,NoDims,typeof(u"rad")}, Quantity{T,NoDims,typeof(u"°")}} where T #unitfulAngles.jl?

  @derived_dimension Radian dimension(u"rad") #Unitful's rad doesn't have a type name..?


  """
    $TYPEDSIGNATURES
    Given `n` elements in an array, wrap `i` around to 1 if it exceeds `n`.

      Utility.iWrap(1,5) == 1
      Utility.iWrap(5,5) == 5
      Utility.iWrap(6,5) == 1
      Utility.iWrap(-6,5) == -1
  """
  function iWrap(i::Integer, n::Integer)::Integer
    return ((i-1)%n)+1 #(things) to shift for 1-indexed arrays
  end

  """
    $TYPEDSIGNATURES
    Given `n` elements in an array, return the next `i+1` element after `i`, wrapping around 0 if necessary.

      Utility.iNext(1,5) == 2
      Utility.iNext(5,5) == 1
      Utility.iNext(6,2) == 1
      Utility.iNext(-6,5) == 0
  """
  function iNext(i::Integer, n::Integer)::Integer
    return iWrap(i+1,n)
  end

  """
    $TYPEDSIGNATURES
    Returns true if `low` <= `value` <= `high`.
  """
  function within(low::Number, value::Number, high::Number)::Bool
    return low <= value && value <= high
  end


  """
    $TYPEDSIGNATURES
    Returns true if `a` == `b` within `tol`.  Prefer using [Base.isapprox](https://docs.julialang.org/en/v1/base/math/#Base.isapprox)
  """
  function eqTol(a::Number, b::Number, tol=1e-3)::Bool
    return abs(a-b) <= tol
  end

  """
    $TYPEDSIGNATURES
    Returns true if every element `A` and `B` are equal within `tol`.
  """
  function eqTol(A::AbstractMatrix, B::AbstractMatrix, tol=1e-3)::Bool
    ret = true
    for (a,b) in zip(A, B)
      ret &= eqTol(a,b, tol)
    end
    return ret
  end

  """
      eqTol(a::Unitful.Quantity, b::Unitful.Quantity, tol=1e-3)::Bool
    Returns true if `a` == `b` within `tol`.  Prefer using [Base.isapprox](https://docs.julialang.org/en/v1/base/math/#Base.isapprox)
  """
  function eqTol(a::Unitful.Quantity, b::Unitful.Quantity, tol=1e-3)::Bool
    return eqTol( ustrip(unit(a), a), ustrip(unit(a), b), tol )
  end

  """
    stringTable(strings::Vector{String}, lengthEach::Integer=3, separator::String="")::String
    Regularizes the `strings` vector by truncating each string to `lengthEach` then concatenating into one string, separated by `separator`.

      Utility.stringTable(["abc","defghi","jk","lmnopq"], 4, "|") == " abc|defg|  jk|lmno"
      Utility.stringTable(["abcdef","ghi","jkl","mnopq"], 4, "|") == "abcd| ghi| jkl|mnop"
  """
  function stringTable(strings::Vector{String}, lengthEach::Integer=3, separator::String="")::String
    ret = ""
    for str in strings
      if length(str) < lengthEach
        ret = string(ret, " "^(lengthEach-length(str)), str)
      else
        ret = string(ret, str[1:min(lengthEach, length(str))])
      end
      if str != last(strings)
        ret = string(ret, separator)
      end
    end
    return ret
  end

  """
      chirpLinear(start::Unitful.Frequency, stop::Unitful.Frequency, duration::Unitful.Time, amplitude::Number, offset::Number=0, phase=0u"°", ts::Unitful.Time = 1e-3u"s", timeStart::Unitful.Time=0u"s")
    Creates a chirp signal from `start` to `stop` frequencies over `duration` time on timestep `ts` with `amplitude` about `offset`, shifted by `phase` and `timeStart`
  """
  function chirpLinear(start::Unitful.Frequency, stop::Unitful.Frequency, duration::Unitful.Time, amplitude::Number, offset::Number=0, phase=0u"°", ts::Unitful.Time = 1e-3u"s", timeStart::Unitful.Time=0u"s")
    chirpRate = (stop-start)/duration
    t = 0u"s":ts:duration
    f = zeros(length(t))u"Hz"
    y = zeros(length(t))
    for it in 1:length(t)
      f[it] = start + (chirpRate * t[it])
      intf = start*(t[it]-timeStart) + 0.5 * chirpRate * (t[it]-timeStart)^2 # === intf = der(f)
      y[it] = offset + amplitude * sin(phase + 2*pi*intf)
    end
    return (t,f,y)
  end
end



