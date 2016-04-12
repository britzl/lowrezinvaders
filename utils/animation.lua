local M = {}

local ANIMATION_DONE = hash("animation_done")

local callbacks = {}

function M.play(sprite_url, animation_id, on_animation_done)
	assert(sprite_url, "You must provide a sprite url")
	assert(animation_id, "You must provide an animation id")
	if on_animation_done then
		callbacks[tostring(sprite_url)] = on_animation_done
	end
	msg.post(sprite_url, "play_animation", { id = animation_id })
end

function M.on_message(message_id, message, sender)
	if message_id == ANIMATION_DONE then
		local sender_string = tostring(sender)
		if callbacks[sender_string] then
			local cb = callbacks[sender_string]
			callbacks[sender_string] = nil
			cb()
		end
	end
end

return M