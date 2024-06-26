local GitStuff = {}

function GitStuff.getAll()
    local commitID = io.popen("git rev-parse HEAD"):read("*all")
    local branch = io.popen("git rev-parse --abbrev-ref HEAD"):read("*all")
    local status = io.popen("git status --porcelain"):read("*all")

    VERSION.meta.commitID = string.sub(commitID, 1, 6)
    VERSION.meta.branch = branch

    io.printf("{brightYellow}[CommitID] : " .. commitID .. "{reset}")
    io.printf("{brightMagenta}[Branch] : " .. branch .. "{reset}")
    io.printf("{cyan}[Status] : " .. (status == "" and "Everything clear :3" or status) .. "{reset}\n")
end

return GitStuff