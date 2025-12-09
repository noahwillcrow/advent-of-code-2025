local print = require("common/print-if-enabled")

function parseInput(inputStr)
    return inputStr
end

--[==[
actually parsed input shape:
{
    addingColumns: { { number } }
    multiplyingColumns: { { number} }
}
]==]
function runCoreCompute(input)
    local result = 0
    
    for i = 1, #input.addingColumns do
        local colNums = input.addingColumns[i]
        local colVal = 0
        for j = 1, #colNums do
            colVal = colVal + colNums[j]
        end
        result = result + colVal
    end
    
    for i = 1, #input.multiplyingColumns do
        local colNums = input.multiplyingColumns[i]
        local colVal = 1
        for j = 1, #colNums do
            colVal = colVal * colNums[j]
        end
        result = result + colVal
    end

    return result
end

function parseInputPart1(inputStr)
    local result = {
        addingColumns = {},
        multiplyingColumns = {}
    }

    local columnNumbers = {}

    for line in inputStr:gmatch("([^\n]+)\n?") do
        local i = 1
        for substr in line:gmatch("%S+") do
            if substr == "+" or substr == "*" then
                if substr == "+" then
                    table.insert(result.addingColumns, columnNumbers[i])
                else
                    table.insert(result.multiplyingColumns, columnNumbers[i])
                end
            else
                local num = tonumber(substr)
                local numbersForColumn = columnNumbers[i]
                if not numbersForColumn then
                    columnNumbers[i] = {}
                    numbersForColumn = columnNumbers[i]
                end

                table.insert(numbersForColumn, num)
            end

            i = i + 1
        end
    end

    return result
end

function part1(input)
    input = parseInputPart1(input)
    return runCoreCompute(input)
end

function parseInputPart2(inputStr)
    local result = {
        addingColumns = {},
        multiplyingColumns = {}
    }

    local lines = {}
    for line in inputStr:gmatch("([^\n]+)\n?") do
        table.insert(lines, line)
    end

    local numLines = #lines

    local operatorsLine = lines[numLines]
    local infoByColumnIndex = {}
    for i = 1, #operatorsLine do
        local char = operatorsLine:sub(i, i)
        if char == "+" or char == "*" then
            table.insert(infoByColumnIndex, {
                operatorType = char,
                startIndexInLines = i
            })
        end
    end

    local numColumns = #infoByColumnIndex

    for col = 1, numColumns do
        local columnInfo = infoByColumnIndex[col]
        local startCharIndex = columnInfo.startIndexInLines
        local lastCharIndex = math.huge
        if col < numColumns then
            lastCharIndex = infoByColumnIndex[col + 1].startIndexInLines - 1
        end

        local numsByRelativeStringIndex = {}
        local relativeStringIndexesWithNumber = {}

        for row = 1, numLines - 1 do
            local line = lines[row]
            for strIndex = startCharIndex, math.min(lastCharIndex, #line) do
                local i = strIndex - startCharIndex + 1
                local char = line:sub(strIndex, strIndex)
                if char == " " then
                    -- pass
                else
                    local digit = tonumber(char)
                    local currentNumber = numsByRelativeStringIndex[i]
                    if currentNumber == nil then
                        table.insert(relativeStringIndexesWithNumber, i)
                        currentNumber = 0
                    end

                    local updatedNumber = currentNumber * 10 + digit
                    numsByRelativeStringIndex[i] = updatedNumber
                end
            end
        end

        local columnNumbers = {}
        table.sort(relativeStringIndexesWithNumber)
        for i, j in ipairs(relativeStringIndexesWithNumber) do
            columnNumbers[i] = numsByRelativeStringIndex[j]
        end

        print(table.concat(columnNumbers, " " .. columnInfo.operatorType .. " "))
        
        if columnInfo.operatorType == "+" then
            table.insert(result.addingColumns, columnNumbers)
        else
            table.insert(result.multiplyingColumns, columnNumbers)
        end
    end

    return result
end

function part2(input)
    input = parseInputPart2(input)
    return runCoreCompute(input)
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end