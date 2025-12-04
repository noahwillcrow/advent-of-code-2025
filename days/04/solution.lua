function parseInput(inputStr)
    local result = {}

    for line in inputStr:gmatch("([^\n]+)\n?") do
        local lineChars = {}
        for i = 1, #line do
            local char = line:sub(i, i)
            table.insert(lineChars, char)
        end
        table.insert(result, lineChars)
    end

    return result
end

local function doesInputCharMatch(input, targetChar, row, col, numRows, numCols)
    if row < 1 or row > numRows or col < 1 or col > numCols then
        return false
    end

    return input[row][col] == targetChar
end

local neighborPositionDeltas = {
    { -1, -1 }, { -1, 0 }, { -1, 1 },
    {  0, -1 }, --[[core]] {  0, 1 },
    {  1, -1 }, {  1, 0 }, {  1, 1 },
}
local numberOfNeighborPositions = #neighborPositionDeltas
local function countSurroundingCharMatches(input, targetChar, centerRow, centerCol, numRows, numCols)
    local count = 0

    for i = 1, numberOfNeighborPositions do
        local delta = neighborPositionDeltas[i]
        if doesInputCharMatch(input, targetChar, centerRow + delta[1], centerCol + delta[2], numRows, numCols) then
            count = count + 1
        end
    end
    
    return count
end

local function findWellSurroundedTargetCharPositions(input, targetChar, exlusiveMaxTargetCharsSurrounding)
    local numRows = #input
    local numCols = #input[1]

    local result = {}
    for row = 1, numRows do
        for col = 1, numCols do
            if doesInputCharMatch(input, targetChar, row, col, numRows, numCols) then
                local numSurroundingCharMatches = countSurroundingCharMatches(input, targetChar, row, col, numRows, numCols)
                if numSurroundingCharMatches < exlusiveMaxTargetCharsSurrounding then
                    table.insert(result, {row, col})
                end
            end
        end
    end
    
    return result
end

function deepCopy(tbl)
    local newTable = {}
    for k,v in pairs(tbl) do
        if type(v) == "table" then
            newTable[k] = deepCopy(v)
        else
            newTable[k] = v
        end
    end
    return newTable
end

function part1(input)
    local targetChar = "@"
    local wellSurroundedTargetCharPositions = findWellSurroundedTargetCharPositions(input, targetChar, 4)
    return #wellSurroundedTargetCharPositions
end

function part2(input)
    local targetChar = "@"
    local emptiedChar = "x"
    local totalRemoved = 0

    local currentInput = input
    
    local wellSurroundedTargetCharPositions = {}
    repeat
        currentInput = deepCopy(currentInput)
        for i = 1, #wellSurroundedTargetCharPositions do
            pos = wellSurroundedTargetCharPositions[i]
            currentInput[pos[1]][pos[2]] = emptiedChar
            totalRemoved = totalRemoved + 1
        end

        wellSurroundedTargetCharPositions = findWellSurroundedTargetCharPositions(currentInput, targetChar, 4)
    until #wellSurroundedTargetCharPositions == 0
        
    return totalRemoved
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end