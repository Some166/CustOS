-- custOS startup entry point
local ok, err = pcall(function()
    shell.run("/boot/boot.lua")
end)

if not ok then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.red)
    term.clear()
    term.setCursorPos(1, 1)
    print("custOS startup failure")
    print("")
    print(tostring(err))
    print("")
    print("Check /boot/boot.lua and the installation.")
end
