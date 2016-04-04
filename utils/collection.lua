local M = {}

local PROXY_LOADED = hash("proxy_loaded")
local PROXY_UNLOADED = hash("proxy_unloaded")

local on_loaded_callbacks = {}
local on_unloaded_callbacks = {}

local function ensure_hash(url)
	return type(url) == "string" and hash(url) or url
end

function M.load(collection_url, on_loaded)
	assert(collection_url, "You must provide a collection url to load")
	on_loaded_callbacks[tostring(collection_url)] = on_loaded
	msg.post(collection_url, "load")
end

function M.unload(collection_url)
	msg.post(collection_url, "unload")
end

function M.on_message(message_id, message, sender)
	if message_id == PROXY_LOADED then
		msg.post(sender, "enable")
		local sender_string = tostring(sender)
		if on_loaded_callbacks[sender_string] then
			on_loaded_callbacks[sender_string]()
			on_loaded_callbacks[sender_string] = nil
		end
	end
end

return M