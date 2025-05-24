return {
	"mfussenegger/nvim-jdtls",
	config = function()
		local jdtls = require("jdtls")
		local map = require("utils").namespaced_keymap("Java")

		map("n", "<leader>jc", jdtls.test_class, "Test Class")
		map("n", "<leader>jm", jdtls.test_nearest_method, "Test Nearest Method")
		map("n", "<leader>jp", jdtls.pick_test, "Pick Test")
	end,
}
