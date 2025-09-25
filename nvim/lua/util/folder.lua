local M = {}

M.should_disable = function(current_dir, disabled_folders)
	disabled_folders = disabled_folders or ""
	for folder in string.gmatch(disabled_folders, "([^,]+)") do
		-- Check if the current directory path contains the disabled folder path
		if string.find(current_dir, folder, 1, true) then
			return true
		end
	end
	return false
end

return M
