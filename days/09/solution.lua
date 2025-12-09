local Heap = require("common/data-structures/heap")

local print = require("common/print-if-enabled")

--[[
    output shape: { { number, number } }
]]
function parseInput(inputStr)
    local result = {}

    for line in inputStr:gmatch("([^\n]+)\n?") do
        local coors = {}
        for numStr in line:gmatch("([^,]+)") do
            table.insert(coors, 1, tonumber(numStr) + 1)
        end
        table.insert(result, coors)
    end

    return result
end

--[[
heap object shape:
{
    area: number,
    coordinateIndexes: { number, number }
}
]]

local function customHeapCompare(a, b)
    return a.area > b.area
end

local function buildHeap(coordinatesArray)
    local heap = {}

    local numberOfCoordinates = #coordinatesArray
    for i = 1, numberOfCoordinates do
        local a = coordinatesArray[i]

        for j = i + 1, numberOfCoordinates do
            local b = coordinatesArray[j]

            local area = (math.abs(a[1]-b[1])+1) * (math.abs(a[2]-b[2])+1)
            print("<" .. table.concat(a, ", ") .. ">", "<" .. table.concat(b, ", ") .. ">", (math.abs(a[1]-b[1])+1), (math.abs(a[2]-b[2])+1), area)

            local heapObject = {
                area = area,
                coordinateIndexes = { i, j }
            }
            Heap.push(heap, heapObject, customHeapCompare)
        end
    end

    return heap
end

function part1(input)
    local heap = buildHeap(input)
    return Heap.pop(heap, customHeapCompare).area
end

--[[
returns:
{
    horizontal: { { { number, number }, { number, number } } },
    vertical: { { { number, number }, { number, number } } }
}
]]
local function buildLines(coordinatesArray)
    local lines = {
        horizontal = {},
        vertical = {}
    }

    local numberOfCoordinates = #coordinatesArray
    
    for i = 1, numberOfCoordinates do
        local j = (i % numberOfCoordinates) + 1
        local a = coordinatesArray[i]
        local b = coordinatesArray[j]

        local line = { a, b }

        if a[1] == b[1] then
            -- same row, so it's horizontal
            table.insert(lines.horizontal, line)
        else
            table.insert(lines.vertical, line)
        end
    end

    return lines
end

local function isRectangleInPolygon(rectCorners, polygonLines)
    local rectMinCol = rectCorners[1][2]
    local rectMaxCol = rectCorners[3][2]
    local rectMinRow = rectCorners[1][1]
    local rectMaxRow = rectCorners[3][1]

    for i = 1, #polygonLines.horizontal do
        local horizLine = polygonLines.horizontal[i]
        if rectMinRow < horizLine[1][1] and horizLine[1][1] < rectMaxRow then
            local lineMinCol = math.min(horizLine[1][2], horizLine[2][2])
            local lineMaxCol = math.max(horizLine[1][2], horizLine[2][2])

            if lineMaxCol > rectMinCol and lineMinCol < rectMaxCol then
                print("horizontal intersection!", rectMinCol, rectMaxCol, rectMinRow, rectMaxRow, horizLine[1][1], lineMinCol, lineMaxCol)
                return false
            end
        end
    end

    for i = 1, #polygonLines.vertical do
        local vertLine = polygonLines.vertical[i]
        if rectMinCol < vertLine[1][2] and vertLine[1][2] < rectMaxCol then
            local lineMinRow = math.min(vertLine[1][1], vertLine[2][1])
            local lineMaxRow = math.max(vertLine[1][1], vertLine[2][1])

            if lineMaxRow > rectMinRow and lineMinRow < rectMaxRow then
                print("vertical intersection!", rectMinCol, rectMaxCol, rectMinRow, rectMaxRow, vertLine[1][2], lineMinRow, lineMaxRow)
                return false
            end
        end
    end

    return true
end

local function findFirstLegalAreaFromHeap(coordinatesArray, legalPolygonLines, heap)
    for i = 1, #heap do
        local heapElem = Heap.pop(heap, customHeapCompare)
        local i = heapElem.coordinateIndexes[1]
        local j = heapElem.coordinateIndexes[2]

        local a = coordinatesArray[i]
        local b = coordinatesArray[j]

        -- keep in mind coordinates are in { row, col } format
        local topLeft = { math.min(a[1], b[1]), math.min(a[2], b[2]) }
        local topRight = { math.min(a[1], b[1]), math.max(a[2], b[2]) }
        local bottomLeft = { math.max(a[1], b[1]), math.min(a[2], b[2]) }
        local bottomRight = { math.max(a[1], b[1]), math.max(a[2], b[2]) }
        
        local rectCorners = { topLeft, topRight, bottomRight, bottomLeft }
        print("checking for intersections with rectangle:", rectCorners[1][1], rectCorners[1][2], rectCorners[3][1], rectCorners[3][2])

        if isRectangleInPolygon(rectCorners, legalPolygonLines) then
            return heapElem.area
        end
    end
    
    return -1
end

function part2(input)
    print("RUNNING PART2 SOLUTION")

    print("building legal indexes")
    local legalPolygonLines = buildLines(input)

    print("building heap")
    local heap = buildHeap(input)

    print("finding first legal area from heap")
    return findFirstLegalAreaFromHeap(input, legalPolygonLines, heap)
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end

--[[
checking for intersections with rectangle:      4       3       6       10
horizontal intersection!        3       10      4       6       6       3       10
]]