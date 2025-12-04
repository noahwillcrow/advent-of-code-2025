local config = require("common/config")

return function(...)
    if not config.isDebugPrintingEnabled then return end

    print(...)
end