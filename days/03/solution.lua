--[==[
My basic idea for part 1 is to use a list of pointers (), starting at indexes 1 and 2
for i = 1, #digitLists do
    pointers = { ... }
    for k = 0, numPointers do
        pointers[k] = k
    end

    run a for loop from j = numPointers + 1 to j = #digits;
        run another for loop from k = math.max(1, #digits - j) to k = numPointers
            if value at list[j] > value at list[pointers[k]] then
                for l = 0, l < numPointers do
                    pointers[k + l] = j + l
                end
            end
        end
    end
end
]==]


function parseInput(inputStr)
    local result = {}

    for line in inputStr:gmatch("([^\n]+)\n?") do
        local lineDigits = {}
        for i = 1, #line do
            local digitStr = line:sub(i, i)
            table.insert(lineDigits, tonumber(digitStr))
        end
        table.insert(result, lineDigits)
    end

    return result
end

function part1(input)
    input = { numPointers = 2, digitLists = input }

    local result = 0

    for i = 1, #input.digitLists do
        local digits = input.digitLists[i]
        local numDigits = #digits

        local pointers = {}
        for pointerIndex = 1, input.numPointers do
            pointers[pointerIndex] = pointerIndex
        end

        for digitIndex = 2, numDigits do
            local numDigitsLeft = numDigits - digitIndex + 1
            local minPointerIndex = input.numPointers - numDigitsLeft + 1
            for pointerIndex = math.max(1, minPointerIndex), input.numPointers do
                if digits[digitIndex] > digits[pointers[pointerIndex]] then
                    for j = 0, input.numPointers do
                        pointers[pointerIndex + j] = digitIndex + j
                    end

                    break
                end
            end
        end

        local value = 0
        for pointerIndex = 1, input.numPointers do
            local digitPlace = input.numPointers - pointerIndex
            value = value + (math.pow(10, digitPlace) * digits[pointers[pointerIndex]])
        end

        result = result + value
    end

    return result
end

function part2(input)
    return ""
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end
