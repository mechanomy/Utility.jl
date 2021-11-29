

module Utility
    using Unitful

    Angle{T} = Union{Quantity{T,NoDims,typeof(u"rad")}, Quantity{T,NoDims,typeof(u"°")}} where T


    """Given <n> elements in an array, wraps <i> around if it exceeds <n>"""
    function iWrap(i::Integer, n::Integer)::Integer
        return ((i-1)%n)+1 #(things) to shift for 1-indexed arrays
    end

    """Given <n> elements in an array, return the next <i+1> element after <i>, wrapping if necessary"""
    function iNext(i::Integer, n::Integer)::Integer
        return iWrap(i+1,n)
    end

    """Returns true if <low> <= <value> <= <high>"""
    function within(low::Number, value::Number, high::Number)::Bool
        return low <= value && value <= high
    end

    """Returns true if <low> <= <value> <= <high>"""
    function eqTol(a::Number, b::Number, tol=1e-3)::Bool
        return abs(a-b) <= tol
    end
    """Returns true if <low> <= <value> <= <high>"""
    function eqTol(a::Unitful.Quantity, b::Unitful.Quantity, tol=1e-3)::Bool
        return eqTol( ustrip(unit(a), a), ustrip(unit(a), b), tol )
    end

    """Regularizes the <strings> vector, truncating to <lengthEach>, separated by <separator>"""
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

    """Creates a chirp signal from <start> to <stop> frequencies over <duration> time on timestep <ts> with <amplitude> about <offset>, shifted by <phase> and <timeStart>"""
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



