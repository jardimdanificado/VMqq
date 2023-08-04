local console = {}
console.logs = {}
console.virgin = true 

console.key = {
    [0] = "KEY_NULL",
    [39] = "KEY_APOSTROPHE",
    [44] = "KEY_COMMA",
    [45] = "KEY_MINUS",
    [46] = "KEY_PERIOD",
    [47] = "KEY_SLASH",
    [48] = "KEY_ZERO",
    [49] = "KEY_ONE",
    [50] = "KEY_TWO",
    [51] = "KEY_THREE",
    [52] = "KEY_FOUR",
    [53] = "KEY_FIVE",
    [54] = "KEY_SIX",
    [55] = "KEY_SEVEN",
    [56] = "KEY_EIGHT",
    [57] = "KEY_NINE",
    [59] = "KEY_SEMICOLON",
    [61] = "KEY_EQUAL",
    [65] = "KEY_A",
    [66] = "KEY_B",
    [67] = "KEY_C",
    [68] = "KEY_D",
    [69] = "KEY_E",
    [70] = "KEY_F",
    [71] = "KEY_G",
    [72] = "KEY_H",
    [73] = "KEY_I",
    [74] = "KEY_J",
    [75] = "KEY_K",
    [76] = "KEY_L",
    [77] = "KEY_M",
    [78] = "KEY_N",
    [79] = "KEY_O",
    [80] = "KEY_P",
    [81] = "KEY_Q",
    [82] = "KEY_R",
    [83] = "KEY_S",
    [84] = "KEY_T",
    [85] = "KEY_U",
    [86] = "KEY_V",
    [87] = "KEY_W",
    [88] = "KEY_X",
    [89] = "KEY_Y",
    [90] = "KEY_Z",
    [91] = "KEY_LEFT_BRACKET",
    [92] = "KEY_BACKSLASH",
    [93] = "KEY_RIGHT_BRACKET",
    [96] = "KEY_GRAVE",
    [32] = "KEY_SPACE",
    [256] = "KEY_ESCAPE",
    [257] = "KEY_ENTER",
    [258] = "KEY_TAB",
    [259] = "KEY_BACKSPACE",
    [260] = "KEY_INSERT",
    [261] = "KEY_DELETE",
    [262] = "KEY_RIGHT",
    [263] = "KEY_LEFT",
    [264] = "KEY_DOWN",
    [265] = "KEY_UP",
    [266] = "KEY_PAGE_UP",
    [267] = "KEY_PAGE_DOWN",
    [268] = "KEY_HOME",
    [269] = "KEY_END",
    [280] = "KEY_CAPS_LOCK",
    [281] = "KEY_SCROLL_LOCK",
    [282] = "KEY_NUM_LOCK",
    [283] = "KEY_PRINT_SCREEN",
    [284] = "KEY_PAUSE",
    [290] = "KEY_F1",
    [291] = "KEY_F2",
    [292] = "KEY_F3",
    [293] = "KEY_F4",
    [294] = "KEY_F5",
    [295] = "KEY_F6",
    [296] = "KEY_F7",
    [297] = "KEY_F8",
    [298] = "KEY_F9",
    [299] = "KEY_F10",
    [300] = "KEY_F11",
    [301] = "KEY_F12",
    [340] = "KEY_LEFT_SHIFT",
    [341] = "KEY_LEFT_CONTROL",
    [342] = "KEY_LEFT_ALT",
    [343] = "KEY_LEFT_SUPER",
    [344] = "KEY_RIGHT_SHIFT",
    [345] = "KEY_RIGHT_CONTROL",
    [346] = "KEY_RIGHT_ALT",
    [347] = "KEY_RIGHT_SUPER",
    [348] = "KEY_KB_MENU",
    [320] = "KEY_KP_0",
    [321] = "KEY_KP_1",
    [322] = "KEY_KP_2",
    [323] = "KEY_KP_3",
    [324] = "KEY_KP_4",
    [325] = "KEY_KP_5",
    [326] = "KEY_KP_6",
    [327] = "KEY_KP_7",
    [328] = "KEY_KP_8",
    [329] = "KEY_KP_9",
    [330] = "KEY_KP_DECIMAL",
    [331] = "KEY_KP_DIVIDE",
    [332] = "KEY_KP_MULTIPLY",
    [333] = "KEY_KP_SUBTRACT",
    [334] = "KEY_KP_ADD",
    [335] = "KEY_KP_ENTER",
    [336] = "KEY_KP_EQUAL"
}

console.loop = function(session)
    local quit = false
    session.cmd.back = function()
        quit = true
    end
    session.cmd.exit = function()
        session.temp.quit = true
        quit = true
    end
    
    session.scene._text = session.scene.text
    session.scene.text = console.logs or session.scene.text
    local lastline = (session.window.height - session.defaults.text.size)
    if console.virgin then
        session.scene.text = console.logs
        session.api.new.text(session,'console mode activated.',0,(session.window.height - (session.defaults.text.size)*2))
        console.barra = session.api.new.text(session,">", session.defaults.text.size/7, lastline+0)
        console.buffer = session.api.new.text(session,'',session.defaults.text.size/1.5 , lastline+0)
        session.api.table.move(console.logs,session.api.table.find(console.logs,console.barra),1)
        console.virgin = false
    end
    local clock = math.floor(os.clock()*50)
    local lastclock = math.floor(os.clock()*50)
    local juststarted = true
    local lastconsolekey
    local spamtime = 20
    local history_index = #console.logs-1
    while not quit do
        session.api.table.move(console.logs,session.api.table.find(console.logs,console.buffer),#console.logs)
        lastclock = math.floor(os.clock()*50)
        local keypress = rl.GetKeyPressed()
        local charpress = rl.GetCharPressed()
        if rl.IsKeyPressed(rl.KEY_ENTER) and lastclock ~= clock and console.buffer.file ~= '' then
            session:run(console.buffer.file)
            for k, txt in pairs(console.logs) do
                if txt ~= console.barra and txt ~= console.buffer then
                    if txt.position.y - session.defaults.text.size <= 0 then
                        txt.file = ''
                    else
                        txt.position.y = txt.position.y - session.defaults.text.size
                    end
                end
            end
            session.api.new.text(session,console.buffer.file, 0, console.buffer.position.y - session.defaults.text.size)
            console.buffer.file = ''
            clock = math.floor(os.clock()*50)
            spamtime = 20
            history_index = #console.logs
        elseif rl.IsKeyPressed(rl.KEY_BACKSPACE) and clock ~= lastclock then 
            console.buffer.file = string.sub(console.buffer.file,1,#console.buffer.file-1)
            spamtime = 20
            clock = math.floor(os.clock()*50)
        elseif rl.IsKeyDown(rl.KEY_BACKSPACE) and lastclock > clock+spamtime then
            spamtime = 2
            console.buffer.file = string.sub(console.buffer.file,1,#console.buffer.file-1)
            clock = math.floor(os.clock()*50)
        
        elseif keypress > 0 and (keypress < 256 or keypress > 348) and clock ~= lastclock then
            console.buffer.file = console.buffer.file .. string.char(charpress)
            spamtime = 20
            lastconsolekey = keypress
            clock = math.floor(os.clock()*50)
        elseif rl.IsKeyPressed(rl.KEY_F1) and clock ~= lastclock then 
            quit = true
        elseif history_index > 2 and rl.IsKeyPressed(rl.KEY_UP) and lastclock > clock+spamtime then
            console.buffer.file = console.logs[history_index].file
            spamtime = 20
            history_index = history_index - 1
            while console.buffer.file == '' do
                console.buffer.file = console.logs[history_index].file
                history_index = history_index - 1
            end
            clock = math.floor(os.clock()*50)
        elseif history_index > 2 and rl.IsKeyDown(rl.KEY_UP) and lastclock > clock+spamtime then
            spamtime = 2
            console.buffer.file = console.logs[history_index].file
            history_index = history_index - 1
            while console.buffer.file == '' do
                console.buffer.file = console.logs[history_index].file
                history_index = history_index - 1
            end
            clock = math.floor(os.clock()*50)
        elseif history_index < #console.logs and rl.IsKeyPressed(rl.KEY_DOWN) and lastclock > clock+spamtime then
            console.buffer.file = console.logs[history_index].file
            spamtime = 20
            history_index = history_index + 1
            while console.buffer.file == '' do
                console.buffer.file = console.logs[history_index].file
                history_index = history_index + 1
            end
            clock = math.floor(os.clock()*50)
        elseif history_index < #console.logs and rl.IsKeyDown(rl.KEY_DOWN) and lastclock > clock+spamtime then
            spamtime = 2
            console.buffer.file = console.logs[history_index].file
            history_index = history_index + 1
            while console.buffer.file == '' do
                console.buffer.file = console.logs[history_index].file
                history_index = history_index +1
            end
            clock = math.floor(os.clock()*50)
        elseif lastconsolekey and rl.IsKeyDown(lastconsolekey) and lastclock > clock+spamtime then
            spamtime = 2
            console.buffer.file = console.buffer.file .. string.lower(string.char(lastconsolekey))
            clock = math.floor(os.clock()*50)
        elseif lastconsolekey and rl.IsKeyReleased(lastconsolekey) then
            spamtime = 20
        end
        --print(keypress)
        session.api.process(session,'',session.pipeline.render)
    end
    session.scene.text = session.scene._text
    session.scene._text = nil
end

return console