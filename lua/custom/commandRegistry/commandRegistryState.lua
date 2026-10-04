local commandRegistryState = {}

commandRegistryState.commands = {}
commandRegistryState.project = nil

commandRegistryState.mode = "normal"
commandRegistryState.panelBuf = nil
commandRegistryState.panelWin = nil
commandRegistryState.sourceBuf = nil
commandRegistryState.sourceWin = nil

return commandRegistryState
