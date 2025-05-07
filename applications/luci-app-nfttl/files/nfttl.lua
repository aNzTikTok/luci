------------------------------------------------------
-- Copyright (C) 2025 DOTYCAT support@dotycat.com   --
-- This file is licensed under the MIT License.     --
------------------------------------------------------

module("luci.controller.nfttl", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/nfttl") then
		return
	end

	entry({"admin", "modem", "nfttl"}, cbi("nfttl"), "TTL Control", 100).dependent = true
end
