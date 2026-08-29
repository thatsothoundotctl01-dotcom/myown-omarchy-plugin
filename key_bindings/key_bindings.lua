
-- 1. SYSTEM & APPLICATION LAUNCHERS
hl.bind({ "SUPER", "RETURN", "exec", "alacritty" })          -- Terminal
hl.bind({ "SUPER", "SPACE", "exec", "omarchy-menu" })         -- App Launcher
hl.bind({ "SUPER", "E", "exec", "alacritty -e yazi" })        -- Terminal File Manager
hl.bind({ "SUPER_SHIFT", "E", "exec", "thunar" })             -- GUI File Manager

-- 2. WINDOW MANAGEMENT
hl.bind({ "SUPER", "Q", "killactive", "" })                  -- Close Focused Window
hl.bind({ "SUPER", "F", "togglefloating", "" })              -- Toggle Floating Mode
hl.bind({ "SUPER", "M", "fullscreen", "0" })                 -- Toggle Fullscreen
hl.bind({ "SUPER", "L", "exec", "hyprctl dispatch layoutmsg toggle" }) -- Switch Layout

-- 3. WINDOW FOCUS (Vim Motion Keys)
hl.bind({ "SUPER", "H", "movefocus", "l" })                  -- Focus Left
hl.bind({ "SUPER", "J", "movefocus", "d" })                  -- Focus Down
hl.bind({ "SUPER", "K", "movefocus", "u" })                  -- Focus Up
hl.bind({ "SUPER", "L", "movefocus", "r" })                  -- Focus Right

-- 4. WORKSPACE SWITCHING (1 - 5)
for i = 1, 5 do
  hl.bind({ "SUPER", tostring(i), "workspace", tostring(i) })
  hl.bind({ "SUPER_SHIFT", tostring(i), "movetoworkspace", tostring(i) })
end

-- 5. CUSTOM DOCUMENT & MEDIA SHORTCUTS
hl.bind({ "SUPER_SHIFT", "D", "exec", "xdg-open ~/Documents" }) -- Open Documents Folder
hl.bind({ "SUPER_SHIFT", "N", "exec", "alacritty -e nvim ~/Documents/notes.md" }) -- Quick Note 





--Reference File in Terminal 

--cat << 'EOF' > ~/Documents/omarchy_keys.lua
-- Omarchy Quick Keyboard Reference
-- Mod Key = SUPER (Windows Key)

--SUPER + ENTER     -> Open Terminal
--SUPER + Q         -> Close Window
--SUPER + SPACE     -> Application Launcher
--SUPER + L         -> Toggle Window Layout
--SUPER + SHIFT + D -> Open Documents
--EOF


