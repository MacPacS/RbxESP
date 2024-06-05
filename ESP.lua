print("███╗░░░███╗░█████╗░░█████╗░██████╗░░█████╗░░█████╗░░██████╗██╗░░░░░██╗░░░██╗░█████╗░")
print("████╗░████║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░░░░██║░░░██║██╔══██╗")
print("██╔████╔██║███████║██║░░╚═╝██████╔╝███████║██║░░╚═╝╚█████╗░██║░░░░░██║░░░██║███████║")
print('██║╚██╔╝██║██╔══██║██║░░██╗██╔═══╝░██╔══██║██║░░██╗░╚═══██╗██║░░░░░██║░░░██║██╔══██║')
print("██║░╚═╝░██║██║░░██║╚█████╔╝██║░░░░░██║░░██║╚█████╔╝██████╔╝███████╗╚██████╔╝██║░░██║")
print("╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚═╝░░╚═╝░╚════╝░╚═════╝░╚══════╝░╚═════╝░╚═╝░░╚═╝")
print("                      GitHub: https://github.com/MacPacS/RbxESP")
print("------------------------------------------------------------------------------------------")
print()
print("                                   Client Status: ✅")
print()
print("------------------------------------------------------------------------------------------")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")

-- Function to get highlight color based on team
local function getTeamColor(team)
    if team then
        return team.TeamColor.Color
    else
        return Color3.fromRGB(255, 255, 255) -- Default color (white) if no team
    end
end

-- Function to highlight a character
local function highlightCharacter(character, team)
    -- Check if the character already has a highlight
    if character:FindFirstChildOfClass("Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = getTeamColor(team)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0) -- Black outline for contrast
    highlight.Parent = character
end

-- Function to handle new player added
local function onPlayerAdded(player)
    local function onCharacterAdded(character)
        highlightCharacter(character, player.Team)
    end

    -- Highlight the character if it already exists
    if player.Character then
        onCharacterAdded(player.Character)
    end

    -- Highlight the character when it's added
    player.CharacterAdded:Connect(onCharacterAdded)

    -- Update highlight color if the player's team changes
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if player.Character then
            -- Remove existing highlight
            local existingHighlight = player.Character:FindFirstChildOfClass("Highlight")
            if existingHighlight then
                existingHighlight:Destroy()
            end
            -- Add new highlight with updated team color
            highlightCharacter(player.Character, player.Team)
        end
    end)
end

-- Connect the player added event
Players.PlayerAdded:Connect(onPlayerAdded)

-- Highlight characters of existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Update highlights every frame to handle character changes
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if not highlight then
                highlightCharacter(player.Character, player.Team)
            end
        end
    end
end)
