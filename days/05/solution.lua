--[==[
IDEA:
- use a sorted list of ranges, sorted by range start? no that won't work... at least not with a binary search...
- okay actually going to use this interval tree
]==]

--[[
input shape:
{
    intervalTreeRoot: IntervalTreeNode,
    numbers: { number }
}
]]

local print = require("common/print-if-enabled")
local IntervalTree = require("common/data-structures/interval-tree")

function parseInput(inputStr)
    local result = {
        intervalTreeRoot = nil,
        numbers = {}
    }

    local isIntervalTreeInProgress = true
    for line in inputStr:gmatch("([^\n]+)\n?") do
        print(line)
        if isIntervalTreeInProgress then
            local left, right = line:match("([^-]+)-([^-]+)")
            if not left or not right then
                print("interval tree is done")
                isIntervalTreeInProgress = false
            else
                print("adding interval to tree")
                local interval = { tonumber(left), tonumber(right) }
                result.intervalTreeRoot = IntervalTree.insert(result.intervalTreeRoot, interval)
            end
        end
        
        if not isIntervalTreeInProgress then
            print("adding number")
            table.insert(result.numbers, tonumber(line))
        end
    end

    return result
end

function part1(input)
    local counter = 0

    for i = 1, #input.numbers do
        local number = input.numbers[i]
        if IntervalTree.doesOverlapWithAnyInterval(input.intervalTreeRoot, number) then
            counter = counter + 1
        end
    end

    return counter
end

function part2(input)
    -- this will give me an array of the intervals in ascending order of their min value
    local intervalsOrdered = IntervalTree.toOrderedList(input.intervalTreeRoot)

    local count = 0

    local highestIntegerSoFar = -math.huge
    for i = 1, #intervalsOrdered do
        local interval = intervalsOrdered[i]

        if interval[2] > highestIntegerSoFar then
            local numberOfNewAvailableIntegers = interval[2] - math.max(highestIntegerSoFar + 1, interval[1]) + 1
            print(interval[1], interval[2], highestIntegerSoFar, math.max(highestIntegerSoFar, interval[1]), numberOfNewAvailableIntegers)
            if numberOfNewAvailableIntegers > 0 then
                count = count + numberOfNewAvailableIntegers
            end

            highestIntegerSoFar = interval[2]
        end
    end

    return count
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end