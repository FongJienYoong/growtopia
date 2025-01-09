-- Define the list of item IDs to be trashed
local trashItemIDs = {914, 916, 918, 920, 924}
local maxInventoryCapacity = 200 -- Set the max amount that will trigger trashing the item

-- Function to check if an item is in the trash list
function isTrashItem(itemID)
    for _, trashID in ipairs(trashItemIDs) do
        if itemID == trashID then
            return true
        end
    end
    return false
end

-- Function to trash an item (without dropping it visually)
function trashItem(item)
    LogToConsole("Attempting to trash item: " .. item.id .. " with amount: " .. item.amount)
    
    -- Send the packet to trash the item
    SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|" .. item.id .. "|\ncount|" .. item.amount)
    
    -- Log to confirm action
    LogToConsole("Trashed item: " .. item.id .. " (" .. item.amount .. " items)")
end

-- Function to handle trash items when inventory reaches max capacity
function handleTrashItems()
    local inventory = GetInventory()

    -- Check if inventory retrieval is successful
    if inventory == nil then
        LogToConsole("Error: Could not retrieve inventory.")
        return
    end

    -- Loop through inventory and trash items if their amount reaches max capacity
    for _, item in pairs(inventory) do
        if isTrashItem(item.id) then
            if item.amount >= maxInventoryCapacity then
                trashItem(item)  -- Trashing the item if it reaches the capacity
            end
        end
    end
end

-- Main loop: Continuously check and trash items when needed
while true do
    -- Handle trash items if the inventory has any reaching the max capacity
    handleTrashItems()

    -- Sleep to prevent flooding the server with too many requests at once
    Sleep(1000)  -- You can adjust the sleep delay here (in milliseconds)
end
