-- custOS bootloader
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)

local function centre(y, text, colour)
    local w, h = term.getSize()
    term.setCursorPos(math.max(1, math.floor((w - #text) / 2) + 1), y)
    if colour then term.setTextColor(colour) end
    write(text)
    term.setTextColor(colors.white)
end

local w, h = term.getSize()
local title = "custOS"
centre(math.max(2, math.floor(h / 2) - 1), title, colors.lime)
centre(math.max(3, math.floor(h / 2) + 1), "Starting system...", colors.lightGray)
sleep(0.7)

local ok, result = pcall(function()
    local Kernel = require("kernel.kernel")
    local kernel = Kernel.new()
    kernel:boot()
end)

if not ok then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.red)
    term.clear()
    term.setCursorPos(1, 1)
    print("custOS could not start")
    print("")
    print(tostring(result))
    print("")
    print("Press any key to return to the shell.")
    os.pullEvent("key")
end
