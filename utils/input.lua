local M = {}

local action_map = {}

local ACTION_ID_UNNAMED = hash("unnamed")

function M.acquire()
	msg.post(".", "acquire_input_focus")
	action_map = {}
end

function M.release()
	msg.post(".", "release_input_focus")
	action_map = {}
end

function M.is_pressed(action_id)
	action_id = type(action_id) == "string" and hash(action_id) or action_id
	return action_map[hash_to_hex(action_id)]
end

function M.update(action_id, action)
	if action_id ~= ACTION_ID_UNNAMED then
		action_id = type(action_id) == "string" and hash(action_id) or action_id
		if action.pressed then
			action_map[hash_to_hex(action_id)] = true
		elseif action.released then
			action_map[hash_to_hex(action_id)] = false
		end
	end
end

return M