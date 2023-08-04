package.path = "./?.raw;" .. package.path

--print(api.luaversion() .. ", plec " .. api.version)

local api = require("src.api") -- everything happen inside this
local session = api.new.session(600,480)


-- print(api.run, session.run, api.legacyrun)
-- api.visualtable(session) -- uncomment this to see how session hierarchy look like

--[[ uncomment this to test encryption
api.encode.save('abc.txt',api.encode.base64Encode(api.stringify(session,4)),0451)
api.file.save.text('changed.txt', api.encode.base64Decode(api.encode.load("abc.txt",0451)))
--]]

while not rl.WindowShouldClose() and not session.temp.quit do
    if rl.IsKeyPressed(rl.KEY_F1) then
        session.console.loop(session)
    end
    session.api.process(session,'',session.pipeline.render)
end

session.temp.exit = nil