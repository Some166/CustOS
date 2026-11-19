-- custOS central server entry point
-- Version 0.1.0

local Kernel = require("server.kernel")

local ok, err = pcall(function()
    Kernel.boot()
end)

if not ok then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.red)
    term.clear()
    term.setCursorPos(1, 1)
    print("custOS SERVER FAILURE")
    print("--------------------")
    print(tostring(err))
    print("")
    print("The server stopped. Check the error above.")
end
