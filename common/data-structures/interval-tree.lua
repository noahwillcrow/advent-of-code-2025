--[[
Node structure: Pair<int, int> interval, int max, Node left, Node right
]]

local QS = require("common/data-structures/queue-stack")
local Stack = QS.Stack

local IntervalTree = {}

function IntervalTree.insert(rootNode, interval)
    if rootNode == nil then return { interval = interval, max = interval[2] } end

    if rootNode.max < interval[2] then
        rootNode.max = interval[2]
    end

    -- this interval's low is lower than the root's low
    if interval[1] < rootNode.interval[1] then
        rootNode.left = IntervalTree.insert(rootNode.left, interval)
    else
        rootNode.right = IntervalTree.insert(rootNode.right, interval)
    end

    return rootNode
end

function IntervalTree.doesOverlapWithAnyInterval(rootNode, value)
    if rootNode == nil then return false end

    if rootNode.interval[1] <= value and value <= rootNode.interval[2] then return true end

    if rootNode.left and rootNode.left.max >= value then
        return IntervalTree.doesOverlapWithAnyInterval(rootNode.left, value)
    elseif rootNode.right then
        return IntervalTree.doesOverlapWithAnyInterval(rootNode.right, value)
    else
        return false
    end
end

function IntervalTree.toOrderedList(rootNode)
    if rootNode == nil then return {} end

    local orderedList = {}

    local function processNode(node)
        if node == nil then return end

        processNode(node.left)

        table.insert(orderedList, node.interval)

        processNode(node.right)
    end
    processNode(rootNode)

    return orderedList
end

return IntervalTree