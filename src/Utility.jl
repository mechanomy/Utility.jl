

module Utility
    using Unitful

    function iWrap(i::Integer, n::Integer)
        return ((i-1)%n)+1 #(things) to shift for 1-indexed arrays
    end

    function iNext(i::Integer, n::Integer)
        return iWrap(i+1,n)
    end

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



