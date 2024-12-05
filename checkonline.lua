-- Credit to notShiroo for the original code

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

getgenv().StopUpdate = false

-- Function to create the GUI element
local function createStatusGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StatusDisplay"
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 60)  -- Adjusted the frame size to better fit the logo and text together
    -- Adjust position to be closer to the edges (increased negative values)
    Frame.Position = UDim2.new(1, -210, 1, -80)  -- Closer to the right and bottom edges of the screen
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 40, 0, 40)  -- The logo size remains unchanged
    Logo.Position = UDim2.new(0, 30, 0.5, -20)  -- Adjusted the position of the logo
    Logo.Image = "rbxassetid://75549568108414"  -- Replace with your logo's asset ID
    Logo.BackgroundTransparency = 1
    Logo.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 140, 0, 20)  -- Adjusted the title size
    Title.Position = UDim2.new(0, 60, 0, 10)  -- Moved the title closer to the logo
    Title.Text = "Reconnect"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 140, 0, 20)  -- Adjusted the status size
    Status.Position = UDim2.new(0, 60, 0, 30)  -- Position below the title
    Status.Text = "Success"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.TextScaled = true
    Status.Font = Enum.Font.SourceSans
    Status.BackgroundTransparency = 1
    Status.Parent = Frame

    -- Automatically remove the GUI after 5 seconds
    task.delay(5, function()
        ScreenGui:Destroy()
    end)
end

-- Error handling for connection errors
GuiService.ErrorMessageChanged:Connect(function()
    local Code = GuiService:GetErrorCode().Value
    if Code >= Enum.ConnectionError.DisconnectErrors.Value then
        getgenv().StopUpdate = true
    end
end)

repeat wait() until game.JobId ~= nil

-- Executor status logging
local function writeExecutorStatus(status)
    local username = Players.LocalPlayer.Name
    local timestamp = os.time()
    local statusData = {
        status = status,
        timestamp = timestamp
    }

    local jsonData = HttpService:JSONEncode(statusData)

    pcall(function()
        -- Ensure the folder 'Reconnect' exists in the file system
        local folderPath = "Reconnect"
        if not isfolder(folderPath) then
            makefolder(folderPath)
        end

        -- Save the JSON data in the "Reconnect" folder
        writefile(folderPath .. "/reconnect_status_" .. username .. ".json", jsonData)
    end)
end

-- Initial setup
createStatusGUI()
writeExecutorStatus("Online")

-- Monitor status updates
while wait(1) do
    if not getgenv().StopUpdate and Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerScripts") then
        writeExecutorStatus("Online")
    end
end
