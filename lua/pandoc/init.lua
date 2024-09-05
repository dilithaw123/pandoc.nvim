local M = {}

local function render_pdf()
	local buf_name = vim.fn.expand("%:p")
	local pandoc_cmd = "pandoc -s -o " .. buf_name .. ".pdf " .. buf_name
	vim.fn.system(pandoc_cmd)
	print("PDF generated")
end

local function check_pandoc()
	if vim.fn.executable("pandoc") == 0 then
		print("Pandoc is not installed")
		return false
	end
	return true
end

function M.setup()
	if not check_pandoc() then
		error("Pandoc plugin setup failed: pandoc not installed")
	end
	vim.api.nvim_create_user_command("PandocRenderPDF", render_pdf, {})
end

return M
