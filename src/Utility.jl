

module Utility

    function iWrap(i::Integer, n::Integer)
        return ((i-1)%n)+1 #(things) to shift for 1-indexed arrays
    end

    function iNext(i::Integer, n::Integer)
        return iWrap(i+1,n)
    end

end



