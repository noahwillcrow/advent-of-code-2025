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

function part1(input)
    local sum = 50
    local zeroesCounter = 0

    for i = 1, #input do
        local prevSum = sum
        local addend = input[i]
        sum = (sum + addend) % 100
        if sum == 0 then
            zeroesCounter = zeroesCounter + 1
        end
    end

    return zeroesCounter
end

function part2(input)
    local sum = 50
    local zeroesCounter = 0
    for i = 1, #input do
        local prevSum = sum

        local addend = input[i]

        local tempSum = sum + addend

        local hundos = math.floor(math.abs(tempSum) / 100)

        if tempSum < 0 and prevSum > 0 then
            hundos = hundos + 1
        elseif tempSum == 0 then
            hundos = hundos + 1
        end
        
        sum = tempSum % 100

        zeroesCounter = zeroesCounter + hundos

        if (math.abs(addend) > 100) then
            print(prevSum, addend, tempSum, sum, hundos, zeroesCounter)
        end
    end
    return zeroesCounter
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end