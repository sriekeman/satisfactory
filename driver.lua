local path = "https://raw.githubusercontent.com/sriekeman/satisfactory/main/content"
local script = "BLAHBLAHBLAH.lua"

-- get internet card
local card = computer.getPCIDevices(findClass("FINInternetCard"))[1]

-- get library from internet
local req = card:request(path .. "/" .. script, "GET", "")
local _, libdata = req:await()

-- save library to filesystem
filesystem.initFileSystem("/dev")
filesystem.makeFileSystem("tmpfs", "tmp")
filesystem.mount("/dev/tmp","/")
local file = filesystem.open(script, "w")
file:write(libdata)
file:close()

-- load the library from the file system and use it
local localScript = filesystem.doFile(script)
