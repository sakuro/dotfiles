local simpleCmd = false
local map = hs.keycodes.map

local function kanaSwitchEvent(event)
    local code = event:getKeyCode()
    local flags = event:getFlags()
    if event:getType() == hs.eventtap.event.types.keyDown then
        if flags['cmd'] then
            simpleCmd = true
        end
    elseif event:getType() == hs.eventtap.event.types.flagsChanged then
        if not flags['cmd'] then
            if simpleCmd == false then
                if code == map['cmd'] then
                    hs.keycodes.setMethod('英字　　（ATOK）')
                elseif code == map['rightcmd'] then
                    hs.keycodes.setMethod('ひらがな（ATOK）')
                end
            end
            simpleCmd = false
        end
    end
end

kanaSwitcher = hs.eventtap.new(
  {hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged},
  kanaSwitchEvent
)
kanaSwitcher:start()
