-- Specify inputs methods for en and ja.
--   defaults write org.hammerspoon.Hammerspoon input-methods '{ "en" = "英字　　（ATOK）"; "ja" = "ひらがな（ATOK）"; }'

local alert = function(message, duration)
  hs.alert.closeAll(0.0)
  hs.alert.show(message, {}, duration or 0.5)
end

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
  hs.keycodes.setMethod(inputMethod)
  alert("🖊️" .. inputMethod)
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

switchInputMethodByCommandKey:start()
switchToEnglishOnActivation:start()

-- Audio volume management
math.clamp = function(value, min, max)
  return math.min(math.max(min, value), max)
end

local notifyCurrentAudioStatus = function(device)
  local muted = device:outputMuted()
  local volume = math.floor(device:volume())
  alert((muted or volume <= 0) and "🔇Muted" or "🔈Volume " .. volume .. "%")
end

local changeVolume = function(diff)
  return function()
    local device = hs.audiodevice.defaultOutputDevice()
    local current = device:volume()
    local new = math.clamp(math.floor(current + diff), 0, 100)
    device:setMuted(new <= 0)
    device:setVolume(new)
    notifyCurrentAudioStatus(device)
  end
end

toggleMuteByRightOptionKey = handleSingleModifier('alt', function(keyCode)
  if keyCode == map['rightalt'] then
    local device = hs.audiodevice.defaultOutputDevice()
    device:setOutputMuted(not device:outputMuted())
    notifyCurrentAudioStatus(device)
  end
end)

hs.hotkey.bind({'alt'}, 'Down', changeVolume(-3))
hs.hotkey.bind({'alt'}, 'Up', changeVolume(3))

toggleMuteByRightOptionKey:start()

hs.hotkey.bind({'alt'}, 't', function()
  local time = os.date("%Y-%m-%d %H:%M")
  alert(time, 3)
end)
