local print = require("common/print-if-enabled")

function parseInput(inputStr)
    local result = {}

    for rangeStr in inputStr:gmatch("([^,]+)") do
        local left, right = rangeStr:match("([^-]+)-([^-]+)")
        table.insert(result, {tonumber(left), tonumber(right)})
    end

    return result
end

function part1(input)
    local result = 0

    for i = 1, #input do
        local prevResult = result

        local range = input[i]
        local min = range[1]
        local max = range[2]

        local minOrderOfMagnitude = math.floor(math.log(min, 10))
        local maxOrderOfMagnitude = math.floor(math.log(max, 10))

        for order = minOrderOfMagnitude, maxOrderOfMagnitude do
            if order % 2 == 1 then
                local halfOrderBase = math.pow(10, math.floor(order / 2))

                local repeatPiece = halfOrderBase
                while repeatPiece < halfOrderBase * 10 do
                    local fullRepeatedNumber = repeatPiece * halfOrderBase * 10 + repeatPiece

                    if fullRepeatedNumber > max then break end
                    
                    if fullRepeatedNumber >= min then
                        result = result + fullRepeatedNumber
                    end

                    repeatPiece = repeatPiece + 1
                end
            end
        end
    end

    return result
end

function part2(input)
    local result = 0
    local found = {} -- Needed because 111111 fits both "1 repeated" and "11 repeated"

    for i = 1, #input do
        local range = input[i]
        local min = range[1]
        local max = range[2]

        local minOrderOfMagnitude = math.floor(math.log(min, 10))
        local maxOrderOfMagnitude = math.floor(math.log(max, 10))

        for order = minOrderOfMagnitude, maxOrderOfMagnitude do
            local totalDigits = order + 1

            for repeatPieceLength = 1, math.floor(totalDigits / 2) do
                if totalDigits % repeatPieceLength == 0 then
                    
                    local repeatPieceBase = math.pow(10, repeatPieceLength)
                    local numRepetitions = totalDigits / repeatPieceLength

                    local repeatPiece = math.pow(10, repeatPieceLength - 1)
                    while repeatPiece < repeatPieceBase do
                        
                        local fullRepeatedNumber = 0
                        for r = 1, numRepetitions do
                            fullRepeatedNumber = fullRepeatedNumber * repeatPieceBase + repeatPiece
                        end

                        if fullRepeatedNumber > max then break end
                        
                        if fullRepeatedNumber >= min then
                            if not found[fullRepeatedNumber] then
                                result = result + fullRepeatedNumber
                                found[fullRepeatedNumber] = true
                            end
                        end

                        repeatPiece = repeatPiece + 1
                    end
                end
            end
        end
    end

    return result
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end