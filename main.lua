local day = arg[1]
local shouldUseExample = arg[2] == "example"

local config = require("common/config")
config.isDebugPrintingEnabled = arg[3] == "debug"

local dayDir = string.format("./days/%s", day)
local inputPath = dayDir .. "/input.txt"
local solutionPath = dayDir .. "/solution"

if shouldUseExample then
    inputPath = dayDir .. "/example.txt"
end

local inputContent = ""
local inputFile = io.open(inputPath, "r")

if inputFile then
    inputContent = inputFile:read("*all")
    inputFile:close()
else
    print(string.format("Error: Could not open input file at %s", inputPath))
    os.exit(1)
end

local solutionFunc = require(solutionPath)

if solutionFunc then
    local result = solutionFunc(inputContent)
    print(result)
else
    print(string.format("Error loading solution file at %s: %s", solutionPath, err))
    os.exit(1)
end