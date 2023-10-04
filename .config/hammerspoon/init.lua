-- Make sure to change the location of init.lua
-- $ defaults write org.hammerspoon.Hammerspoon MJConfigFile ~/.config/hammerspoon/init.lua

local map = hs.keycodes.map
local bindings = {
  -- Swith IM to English via Left ⌘
  ["en"] = map['cmd'],
  -- Switch IM to Japanese via Right ⌘
  ["ja"] = map['rightcmd']
}

local inputMethods = {
  ["en"] = "英字　　（ATOK）",
  ["ja"] = "ひらがな（ATOK）"
}

local isCmdAsModifier = false

local trySwitchInputMethod = function(keyCode)
  local currentInputMethod = hs.keycodes.currentMethod()
  for lang, code in pairs(bindings) do
    inputMethod = inputMethods[lang]
    if keyCode == code and currentInputMethod ~= inputMethod then
      hs.keycodes.setMethod(inputMethod)
      break
    end
  end
end

local keyDown = hs.eventtap.event.types.keyDown
local flagsChanged = hs.eventtap.event.types.flagsChanged

-- Switch IM via Left ⌘ (to English) and Right ⌘ (to Japanese)
hs.eventtap.new({keyDown, flagsChanged}, function(event)
  local eventType = event:getType()
  local isCmdFlag = event:getFlags()['cmd']

  if eventType == keyDown then
    if isCmdFlag then
      isCmdAsModifier = true
    end
  elseif eventType == flagsChanged then
    if not isCmdFlag then
      if isCmdAsModifier == false then
        trySwitchInputMethod(event:getKeyCode())
      end
      isCmdAsModifier = false
    end
  end
end):start()

local activated = hs.application.watcher.activated

-- Force switching IM to English on activated applications
hs.application.watcher.new(function(name, event, app)
  if event == activated then
    hs.keycodes.setMethod(inputMethods["en"])
  end
end):start()
