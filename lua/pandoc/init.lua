local M = {}

local DefaultConfig = {
	PDF = {
		MarginLeft = "2.5cm",
		MarginRight = "2.5cm",
		MarginTop = "2.5cm",
		MarginBottom = "2.5cm",
	},
}

local function strip_extension(file_name)
	local index_of_dot = string.find(file_name, ".[^.]*$")
	if index_of_dot == nil then
		return file_name
	end
	return string.sub(file_name, 1, index_of_dot - 1)
end

local function render_pdf()
	local buf_name = vim.fn.expand("%:p")
	local buf_minus_ext = strip_extension(buf_name)
	local pandoc_cmd = "pandoc -s "
		.. buf_name
		.. " -o "
		.. buf_minus_ext
		.. ".pdf"
		.. ' -V geometry:"left='
		.. DefaultConfig.PDF.MarginLeft
		.. ",right="
		.. DefaultConfig.PDF.MarginRight
		.. ",top="
		.. DefaultConfig.PDF.MarginTop
		.. ",bottom="
		.. DefaultConfig.PDF.MarginBottom
		.. '"'
	local output = vim.fn.system(pandoc_cmd)
	if output ~= "" then
		print("Error: " .. output)
		return
	end
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
