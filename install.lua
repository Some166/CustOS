local base = "https://raw.githubusercontent.com/Some166/CustOS/main/"

local files = {
    "startup.lua",
    "client-test.lua",
    "main.lua",
    "kernel.lua",
    "network.lua"
}

print("=== CustOS Installer ===")
print("Installing CustOS...")

for _, file in ipairs(files) do
    local directory = fs.getDir(file)

    if directory ~= "" then
        fs.makeDir(directory)
    end

    print("Downloading " .. file)

    local url = base .. file
    local response = http.get(url)

    if not response then
        print("FAILED: " .. file)
        return
    end

    local content = response.readAll()
    response.close()

    local output = fs.open(file, "w")
    output.write(content)
    output.close()
end

print("")
print("CustOS installation complete!")
print("Restart your computer to launch CustOS.")
