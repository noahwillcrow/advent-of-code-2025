local LinkedList = require("common/data-structures/linked-list")

local Queue = {}

function Queue.new()
    return LinkedList.new()
end

function Queue.push(queue, value)
    LinkedList.append(queue, value)
end

function Queue.pop(queue)
    return LinkedList.popHead(queue)
end

local Stack = {}

function Stack.new()
    return LinkedList.new()
end

function Stack.push(stack, value)
    LinkedList.prepend(stack, value)
end

function Stack.pop(stack)
    return LinkedList.popHead(stack)
end

return { Queue = Queue, Stack = Stack }