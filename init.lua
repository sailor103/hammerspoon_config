hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", function()
        hs.reload()
    end)
end

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

-- Define default Spoons which will be loaded later
if not hspoon_list then
    hspoon_list = {
			"KSheet", 
            "BingDaily",
            "ClipboardTool",
            "HSearch",
            "Seal",
			"WinWin",
			"MouseFollowsFocus",
		}
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon Search
if spoon.HSearch then
    hsearch_keys = hsearch_keys or {{"cmd", "shift", "ctrl"}, "G"}
    if string.len(hsearch_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsearch_keys[1], hsearch_keys[2], 'Launch Hammerspoon Search', function()
            spoon.HSearch:toggleShow()
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon API manual: Open Hammerspoon manual in default browser
hsman_keys = hsman_keys or {{"cmd", "shift", "ctrl"}, "H"}
if string.len(hsman_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsman_keys[1], hsman_keys[2], "Read Hammerspoon Manual", function()
        hs.doc.hsdocs.forceExternalBrowser(true)
        hs.doc.hsdocs.moduleEntitiesInSidebar(true)
        hs.doc.hsdocs.help()
    end)
end

----------------------------------------------------------------------------------------------------
-- Register lock screen
hslock_keys = hslock_keys or {"alt", "L"}
if string.len(hslock_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "Lock Screen", function()
        hs.caffeinate.lockScreen()
    end)
end

----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'return', 'Deactivate resizeM', function()
        spoon.ModalMgr:deactivate({"resizeM"})
    end)
    cmodal:bind('', 'escape', 'Deactivate resizeM', function()
        spoon.ModalMgr:deactivate({"resizeM"})
    end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
        spoon.ModalMgr:toggleCheatsheet()
    end)
    cmodal:bind('', 'A', 'Move Leftward', function()
        spoon.WinWin:stepMove("left")
    end, nil, function()
        spoon.WinWin:stepMove("left")
    end)
    cmodal:bind('', 'D', 'Move Rightward', function()
        spoon.WinWin:stepMove("right")
    end, nil, function()
        spoon.WinWin:stepMove("right")
    end)
    cmodal:bind('', 'W', 'Move Upward', function()
        spoon.WinWin:stepMove("up")
    end, nil, function()
        spoon.WinWin:stepMove("up")
    end)
    cmodal:bind('', 'S', 'Move Downward', function()
        spoon.WinWin:stepMove("down")
    end, nil, function()
        spoon.WinWin:stepMove("down")
    end)
    cmodal:bind('', 'H', 'Lefthalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfleft")
    end)
    cmodal:bind('', 'L', 'Righthalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfright")
    end)
    cmodal:bind('', 'K', 'Uphalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfup")
    end)
    cmodal:bind('', 'J', 'Downhalf of Screen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfdown")
    end)
    cmodal:bind('', 'Y', 'NorthWest Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNW")
    end)
    cmodal:bind('', 'O', 'NorthEast Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNE")
    end)
    cmodal:bind('', 'U', 'SouthWest Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSW")
    end)
    cmodal:bind('', 'I', 'SouthEast Corner', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSE")
    end)
    cmodal:bind('', 'F', 'Fullscreen', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("fullscreen")
    end)
    cmodal:bind('', 'C', 'Center Window', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("center")
    end)
    cmodal:bind('', '=', 'Stretch Outward', function()
        spoon.WinWin:moveAndResize("expand")
    end, nil, function()
        spoon.WinWin:moveAndResize("expand")
    end)
    cmodal:bind('', '-', 'Shrink Inward', function()
        spoon.WinWin:moveAndResize("shrink")
    end, nil, function()
        spoon.WinWin:moveAndResize("shrink")
    end)
    cmodal:bind('shift', 'H', 'Move Leftward', function()
        spoon.WinWin:stepResize("left")
    end, nil, function()
        spoon.WinWin:stepResize("left")
    end)
    cmodal:bind('shift', 'L', 'Move Rightward', function()
        spoon.WinWin:stepResize("right")
    end, nil, function()
        spoon.WinWin:stepResize("right")
    end)
    cmodal:bind('shift', 'K', 'Move Upward', function()
        spoon.WinWin:stepResize("up")
    end, nil, function()
        spoon.WinWin:stepResize("up")
    end)
    cmodal:bind('shift', 'J', 'Move Downward', function()
        spoon.WinWin:stepResize("down")
    end, nil, function()
        spoon.WinWin:stepResize("down")
    end)
    cmodal:bind('', 'left', 'Move to Left Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("left")
    end)
    cmodal:bind('', 'right', 'Move to Right Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("right")
    end)
    cmodal:bind('', 'up', 'Move to Above Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("up")
    end)
    cmodal:bind('', 'down', 'Move to Below Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("down")
    end)
    cmodal:bind('', 'space', 'Move to Next Monitor', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("next")
    end)
    cmodal:bind('', '[', 'Undo Window Manipulation', function()
        spoon.WinWin:undo()
    end)
    cmodal:bind('', ']', 'Redo Window Manipulation', function()
        spoon.WinWin:redo()
    end)
    cmodal:bind('', '`', 'Center Cursor', function()
        spoon.WinWin:centerCursor()
    end)

    -- Register resizeM with modal supervisor
    hsresizeM_keys = hsresizeM_keys or {"alt", "R"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter resizeM Environment", function()
            -- Deactivate some modal environments or not before activating a new one
            spoon.ModalMgr:deactivateAll()
            -- Show an status indicator so we know we're in some modal environment now
            spoon.ModalMgr:activate({"resizeM"}, "#DA282A")
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- cheatsheetM modal environment (Because KSheet Spoon is NOT loaded, cheatsheetM will NOT be activated)
if spoon.KSheet then
    spoon.ModalMgr:new("cheatsheetM")
    local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
    cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)

    -- Register cheatsheetM with modal supervisor
    hscheats_keys = hscheats_keys or {{"cmd", "shift", "ctrl"}, "C"}
    if string.len(hscheats_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "Enter cheatsheetM Environment", function()
            spoon.KSheet:show()
            spoon.ModalMgr:deactivateAll()
            spoon.ModalMgr:activate({"cheatsheetM"})
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- Seal 替换Alfred
if spoon.Seal then
    seal_keys = seal_keys or {{"cmd"}, "Space"}
    spoon.Seal:bindHotkeys({ show = seal_keys })
    -- spoon.Seal:loadPlugins({ "apps", "calc", "pasteboard", "filesearch", "useractions" })
    spoon.Seal:loadPlugins({ "apps", "calc", "filesearch", "useractions", "vscode" })
    spoon.Seal.plugins.useractions.actions = {
      ["Open Multiple Wechat"] = {
         keyword = "wc",
         fn = function(str) 
            hs.execute("nohup /Applications/WeChat.app/Contents/MacOS/WeChat > /dev/null 2>&1 &")
         end,
      },
      ["Quick Slug"] = {
         keyword = "sg",
         fn = function(str) 
            local slug = string.gsub(string.gsub(str,"[^ A-Za-z]",""),"[ ]+","-")
            slug = string.gsub(slug,",","")
            slug = string.lower(slug)
            hs.pasteboard.setContents(slug)
         end,
      }
    }
    -- spoon.Seal.plugins.pasteboard.historySize=72
    spoon.Seal:start()
end

----------------------------------------------------------------------------------------------------
-- clipboard history
if spoon.ClipboardTool then
    clipboard_keys = clipboard_keys or {{"cmd", "alt"}, "C"}
    spoon.ClipboardTool:bindHotkeys({ show_clipboard = clipboard_keys })
    spoon.ClipboardTool.paste_on_select = true
    spoon.ClipboardTool.show_copied_alert = false
    spoon.ClipboardTool.show_in_menubar = false
    spoon.ClipboardTool.max_entry_size = 40960
    spoon.ClipboardTool.hist_size = 120
    spoon.ClipboardTool.max_size = true
    spoon.ClipboardTool:start()
end

----------------------------------------------------------------------------------------------------
-- automouse
if spoon.MouseFollowsFocus then
	spoon.MouseFollowsFocus:configure({})
	spoon.MouseFollowsFocus:start()
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon console
hsconsole_keys = hsconsole_keys or {{"cmd", "shift", "ctrl"}, "Z"}
if string.len(hsconsole_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "Toggle Hammerspoon Console", function()
        hs.toggleConsole()
    end)
end

----------------------------------------------------------------------------------------------------
-- GIS Job KeyWords
gis_job_keys = gis_job_keys or {{"cmd", "alt", "ctrl"}, "C"}
if string.len(gis_job_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(gis_job_keys[1], gis_job_keys[2], "GIS Jobs Keywords", function()
        hs.pasteboard.setContents('地理 测绘 遥感 规划 土地 空间信息')
    end)
end


----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
