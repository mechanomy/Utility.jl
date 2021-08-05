

module Utility

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



end



