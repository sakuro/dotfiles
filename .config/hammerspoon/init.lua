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

local keyCodeToInputMethod = function(keyCode)
  for code, lang in pairs(bindings) do
    if keyCode == code then
      return inputMethods[lang]
    end
  end
  error('inputMethod unbound')
end

local switchInputMethod = function(inputMethod)
  local currentInputMethod = hs.keycodes.currentMethod()
  if currentInputMethod ~= inputMethod then
    hs.keycodes.setMethod(inputMethod)
  end
end

local isAsModifier = {}

local handleSingleModifier = function(modifier, handler)
  local keyDown = hs.eventtap.event.types.keyDown
  local flagsChanged = hs.eventtap.event.types.flagsChanged

  return hs.eventtap.new({keyDown, flagsChanged}, function(event)
    local eventType = event:getType()
    local isFlag = event:getFlags()[modifier]
    if eventType == keyDown then
      if isFlag then
        isAsModifier[modifier] = true
      end
    elseif eventType == flagsChanged then
      if not isFlag then
        if isAsModifier[modifier] == false then
          local keyCode = event:getKeyCode()
          handler(keyCode)
        end
        isAsModifier[modifier] = false
      end
    end
  end)
end

switchInputMethodByCommandKey = handleSingleModifier('cmd', function(keyCode)
  local success, result = pcall(keyCodeToInputMethod, keyCode)
  if success then
    switchInputMethod(result)
  end
end)

-- Force switching IM to English on activated applications
local activated = hs.application.watcher.activated
switchToEnglishOnActivation = hs.application.watcher.new(function(name, event, app)
  if event == activated then
    switchInputMethod(inputMethods["en"])
  end
end)

-- Toggle Mute
toggleMuteByRightOptionKey = handleSingleModifier('alt', function(keyCode)
  if keyCode == map['rightalt'] then
    local audio = hs.audiodevice.defaultOutputDevice()
    local muted = audio:outputMuted()
    audio:setOutputMuted(not muted)
  end
end)

switchInputMethodByCommandKey:start()
switchToEnglishOnActivation:start()
toggleMuteByRightOptionKey:start()
