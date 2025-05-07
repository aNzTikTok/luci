------------------------------------------------------
-- Copyright (C) 2025 DOTYCAT support@dotycat.com   --
-- This file is licensed under the MIT License.     --
------------------------------------------------------
local uci = require "luci.model.uci".cursor()
local nixio = require "nixio"
local sys = require "luci.sys"

local nft_file = "/etc/nftables.d/10-custom-filter-chains.nft"

m = Map("nfttl", "TTL Control", "Set or disable TTL packet rewriting.")

s = m:section(NamedSection, "main", "settings", "TTL Settings")

-- Mode selection
mode = s:option(ListValue, "mode", "TTL Mode")
mode:value("off", "Off")
mode:value("64", "Set TTL = 64")
mode:value("custom", "Custom TTL")

-- Custom TTL value input
custom = s:option(Value, "custom_value", "Custom TTL")
custom.datatype = "uinteger"
custom.default = "65"
custom:depends("mode", "custom")

-- Button to trigger reboot
reboot_button = s:option(Button, "reboot", "Reboot Router", "Click to reboot the router to apply the changes.")
reboot_button.inputstyle = "apply"  -- Make the button look like a "Save" button
reboot_button.write = function()
    -- Trigger system reboot via Lua
    sys.reboot()
end

-- Handle the form submission to update TTL settings
function m.on_commit(map)
    local mode = uci:get("nfttl", "main", "mode")
    local value = uci:get("nfttl", "main", "custom_value") or "64"
    local ttl = (mode == "custom") and value or mode

    local content = [[
chain mangle_prerouting_ttl64 {
  type filter hook prerouting priority 300; policy accept;
  counter%s
}

chain mangle_postrouting_ttl64 {
  type filter hook postrouting priority 300; policy accept;
  counter%s
}

chain mangle_prerouting_hoplimit64 {
  type filter hook prerouting priority 300; policy accept;
  counter%s
}

chain mangle_postrouting_hoplimit64 {
  type filter hook postrouting priority 300; policy accept;
  counter%s
}
]]

    -- Set lines based on selected mode
    local line = (mode == "off") and "" or (" ip ttl set " .. ttl)
    local hopline = (mode == "off") and "" or (" ip6 hoplimit set " .. ttl)
    local full = content:format(line, line, hopline, hopline)

    -- Write the updated configuration to the file
    local f = nixio.open("/etc/nftables.d/10-custom-filter-chains.nft", "w")
    if f then
        f:write(full)
        f:close()
    end

    -- Show message asking user to reboot
    m.message = "TTL updated. Please reboot your router to apply changes."
end

return m
