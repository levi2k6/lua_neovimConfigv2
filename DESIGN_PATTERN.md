# DESIGN PATTERN

## Folder structure
In the lua folder there are 2 folders named:

### custom folder
- customer/ is where the custom overrides and custom plugins are added.

### plugin folder
plugin/ is where the third party plugins are added.

#### folder plugin
- Create a folder if the plugin cannot be represented in to a single lua file, or it will cause a visual clutter in both file and folder. Look at the folder lsp/ in plugin/ folder as an example, as you can see in the folder each language lsp are represented as a single file in the lsp/ folder. The code would look clutter if all of the language lsp are in a single lsp lua file, and the plugin/ folder would look clutter if all of the lsp language represented as lua files are in the plugin/ folder. That is why you add a new folder to isolate related plugins. 

### init.lua plugin connection 
- Both of the folders (custom/ and plugin/) have their own init.lua file. It is where the their plugins are defined to be initialized later. Then the two init.lua files are required in the main init.lua file so that all of the plugins of both custom/ and plugin/ will be initialized the moment the systems starts.  

init.lua: 
    require("custom.init")
    require("plugin.init")




 
