local M = {}

M.shouldDisable = function(current_dir)
	local disabled_folders = vim.env.DISABLED_COPILOT or ""

	for folder in string.gmatch(disabled_folders, "([^,]+)") do
		-- Normalize paths to ensure consistent comparison
		local normalized_folder = string.gsub(folder, "/$", "")
		local normalized_current_dir = string.gsub(current_dir, "/$", "")

		-- Check if the current directory path contains the disabled folder path
		if string.find(normalized_current_dir, normalized_folder, 1, true) then
			return false
		end
	end
	return true
end

return M
