-- return{
-- 	"ellisonleao/gruvbox.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme gruvbox")
-- 	end
-- }

-- return {
--     "folke/tokyonight.nvim",
--     priority = 1000,  -- load before other plugins
--     config = function()
--         require("tokyonight").setup({
--             style = "storm",  -- storm | night | moon | day
--             transparent = false,
--             terminal_colors = true,
--             styles = {
--                 comments = { italic = true },
--                 keywords = { italic = false },
--             },
--         })
--         vim.cmd("colorscheme tokyonight-storm")
--     end,
-- }

-- return {
--     "nyoom-engineering/oxocarbon.nvim",
--     priority = 1000,
--     config = function()
--         vim.cmd("colorscheme oxocarbon")
--     end,
-- }

return {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
        require("onedarkpro").setup({
            styles = {
                comments = "italic",
                keywords = "bold",
            },
        })
        vim.cmd("colorscheme onedark")
    end,
}
