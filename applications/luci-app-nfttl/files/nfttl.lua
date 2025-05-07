module("luci.controller.nfttl", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/nfttl") then
		return
	end

	entry({"admin", "modem", "nfttl"}, cbi("nfttl"), "TTL Control", 100).dependent = true
end
