-- Specify inputs methods for en and ja.
--   defaults write org.hammerspoon.Hammerspoon input-methods '{ "en" = "英字　　（ATOK）"; "ja" = "ひらがな（ATOK）"; }'

local map = hs.keycodes.map
local bindings = {
  -- Left ⌘ switches IM to English
  [map["cmd"]] = "en",
  -- Right ⌘ switches IM to Japanese
  [map["rightcmd"]] = "ja"
}

local inputMethods = hs.settings.get("input-methods")
local isCmdAsModifier = false

local switchInputMethod = function(keyCode)
  local currentInputMethod = hs.keycodes.currentMethod()
  for code, lang in pairs(bindings) do
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
switchInputMethodByCommandKey = hs.eventtap.new({keyDown, flagsChanged}, function(event)
  local eventType = event:getType()
  local isCmdFlag = event:getFlags()['cmd']
  if eventType == keyDown then
    if isCmdFlag then
      isCmdAsModifier = true
    end
  elseif eventType == flagsChanged then
    if not isCmdFlag then
      if isCmdAsModifier == false then
        switchInputMethod(event:getKeyCode())
      end
      isCmdAsModifier = false
    end
  end
end)

-- Force switching IM to English on activated applications
local activated = hs.application.watcher.activated

switchToEnglishOnActivation = hs.application.watcher.new(function(name, event, app)
  if event == activated then
      hs.keycodes.setMethod(inputMethods["en"])
  end
end)

switchInputMethodByCommandKey:start()
switchToEnglishOnActivation:start()