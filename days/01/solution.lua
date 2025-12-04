function parseInput(inputStr)
    local result = {}

    for line in inputStr:gmatch("([^\n]+)\n?") do
        local direction = line:sub(1, 1)
        local magnitude = tonumber(line:sub(2, -1))

        if direction == "L" then
            table.insert(result, -1 * magnitude)
        else
            table.insert(result, magnitude)
        end
    end

    return result
end

return function(inputStr)
    local input = parseInput(inputStr)
    local sum = 50
    local zeroesCounter = 0
    for i = 1, #input do
        local prevSum = sum
        local addend = input[i]
        sum = (sum + addend) % 100
        if sum == 0 then
            zeroesCounter = zeroesCounter + 1
        end
        print(prevSum, addend, sum, zeroesCounter)
    end
    return zeroesCounter
end