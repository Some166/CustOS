f directory ~= "" then
        fs.makeDir(directory)
    end

    print("Downloading " .. file)

    local success, err = pcall(function()
        shell.run("wget", base .. file, file)
    end)

    if not success or not fs.exists(file) then
        print("FAILED: " .. file)
        print(err or "Download unsuccessful")
        return
    end
end

print("")
print("CustOS installation complete!")
print("Restart your computer to launch CustOS.")
