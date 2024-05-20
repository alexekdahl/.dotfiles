return {
	"crispgm/nvim-go",
	opts = {
		-- notify: use nvim-notify
		notify = false,
		auto_format = false,
		auto_lint = false,
		test_flags = { "-v", "-count=1" },
		test_timeout = "30s",
		test_env = {},
		-- show test result with popup window
		test_popup = true,
		test_popup_auto_leave = true,
		test_popup_width = 80,
		test_popup_height = 10,
		-- test open
		test_open_cmd = "edit",
		-- struct tags
		tags_name = "json",
		tags_options = { "json=omitempty" },
		tags_transform = "snakecase",
		tags_flags = { "-skip-unexported" },
		-- quick type
		quick_type_flags = { "--just-types" },
	},
}
