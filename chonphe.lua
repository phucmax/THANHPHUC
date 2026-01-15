-- AUTO SELECT TEAM (Blox Fruits)

getgenv().team = "Marines" 
-- đổi thành "Pirates" nếu muốn

repeat wait() until game:IsLoaded() 
    and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- Chỉ chạy khi đang ở màn hình chọn phe
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        task.wait()
        local Remotes = game.ReplicatedStorage:WaitForChild("Remotes")
        Remotes.CommF_:InvokeServer("SetTeam", getgenv().team)
        task.wait(3)
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end
