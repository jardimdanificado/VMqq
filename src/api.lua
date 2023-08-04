--[[ nix packages in order to make plec + raylib run in replit
    { pkgs }: {
	deps = [
        pkgs.luajit
        pkgs.luajitPackages.luarocks
        pkgs.lua
        pkgs.sumneko-lua-language-server
		pkgs.clang_12
	    pkgs.ccls
	    pkgs.gcc
	    pkgs.glibc
	    pkgs.mesa
		pkgs.xorg.libX11
		pkgs.libGL
		pkgs.libGLU
		pkgs.glfw
		pkgs.xorg.libXcursor
		pkgs.xorg.libXrandr
		pkgs.xorg.libXinerama
		pkgs.xorg.libXi
		pkgs.xorg.libXext
	];
}
]]

local api = require('src.util')

api.formatcmd = function(command)
    command = command:gsub("%s+", " ")
    command = command:gsub('; ', ';')
    command = command:gsub(' ;', ';')
    command = command:gsub(';\n', ';')
    command = command:gsub('\n;', ';')
    
    return api.string.split(command, ';')
end

api.getlink =  function(str,linksymbol)
    local pattern = linksymbol .. "(%w+)"
    local match = string.match(str, pattern)
    local result = string.gsub(str, pattern, "", 1)
    return (linksymbol .. match), result
end

api.process = function(session, cmd, pipeline)
    local result
    pipeline = pipeline or session.pipeline.main
    for i = 1, #pipeline do
        if session.temp["break"]then
            session.temp['break'] = nil
            break
        end
        if not session.temp.skip then
            result = pipeline[i].func(session,result or cmd) 
            if result then
                cmd = result
            end
        else
            session.temp.skip = nil
        end
    end
    return result
end

api.pipeadd = function(session,name,position,newid,custompipeline) 
    local wlist = session.pipeline[custompipeline or 'main']
    print(session.pipes[name],name)
    local pipe = 
    {
        id = '',
        func = session.pipes[name or ''] or ''
    }

    if type(name) == 'function' then
        pipe.func = name
        name = session.api.id()
    end

    if type(position) == "string" then
        newid = position
        position = #wlist+1 
    elseif not position then
        position = #wlist+1 
    end
    
    pipe.id = newid or name
    table.insert(wlist,position,pipe)
    return pipe
end

api.getline = function()
    io.write("> ")
    local str = io.read()
    return str
end

api.run = function(session, command)
    command = command or api.getline()
    local result = ''
    for i, cmd in ipairs(api.formatcmd(command)) do
        local split = api.string.split(cmd, " ")
        local args = {}
        for i = 2, #split, 1 do
            table.insert(args,split[i])
        end
        result = (session.cmd[split[1]] or session.cmd['--'])(session,args,cmd) or cmd
    end
    return result
end

api.new = 
{
    scene = function(session,_type)
        _type = _type or '3d'
        local _3d = _type == '3d' and true or false
        local scene =  
        {
            type = _type,
            text = {},
            image = {},
            model = _3d and {} or nil,
            cube = _3d and {} or nil,
            backgroundcolor = rl.LIGHTGRAY,
            camera = rl.new("Camera", {
                position = rl.new("Vector3", 0, 10, 10),
                target = rl.new("Vector3", 0, 0, 0),
                up = rl.new("Vector3", 0, 1, 0),
                fovy = 45,
                type = rl.CAMERA_PERSPECTIVE
            }),
        }
        table.insert(session.scenes,scene)
        return scene
    end,
    text = function(session,text,px,py,color,size)
        local text = {file=text,position={x=px or 0,y=py or 0},color = color or rl.BLACK, size or 20}
        table.insert(session.scene.text,text)
        return text
    end
}

api.set = 
{
    scene = function(session,index)
        session.scene = session.scenes[index]
    end
}

api.consolemode = function(session)
    local quit = false
    session.cmd.back = function()
        quit = true
    end
    session.cmd.exit = function()
        session.temp.quit = true
        quit = true
    end
    session.scene._text = session.scene.text
    session.scene.text = session.scene.consoletext or {}
    local txtsize = 20
    local lastline = (session.window.height - txtsize)
    local juststarted = true
    local text = api.new.text(session,'',txtsize/1.8 , lastline)
    local logs = {api.new.text(session,'console mode activated.',0,(session.window.height - (txtsize)*2))}
    local barra = api.new.text(session,">", txtsize/7, lastline)
    while not quit do
        if rl.IsKeyPressed(rl.KEY_ENTER) then
            session:run(text.file)
            for k, txt in ipairs(logs) do
                
                if txt.position.y - txtsize <= 0 then
                    txt.file = ''
                else
                    
                    txt.position.y = txt.position.y - txtsize
                    
                end

            end
            table.insert(logs,api.new.text(session,'', 0, text.position.y - txtsize))
            logs[#logs].file = text.file
            text.file = ''
            
        elseif rl.IsKeyPressed(rl.KEY_BACKSPACE) then 
            text.file = string.sub(text.file,1,#text.file-1)
        elseif rl.IsKeyPressed(rl.KEY_F1) then 
            if not juststarted then
                quit = true
            else
                juststarted = false
            end
            
        elseif rl.GetKeyPressed() > 0 and not rl.IsKeyPressed(rl.KEY_F1) then
            text.file = text.file .. string.char(rl.GetCharPressed())
        end
        session.api.process(session,'',session.pipeline.render)
    end
    for k, v in pairs(session.scene.text) do
        if v.file == '>' then
            session.scene.text[k] = nil
        end
    end
    session.scene.text = session.scene._text
    session.scene._text = nil
end

api.startup = function(session)
    for i, v in ipairs(arg or {}) do
        if api.string.includes(v,'-gl') then
            api.gl = api.string.replace(v,'-gl','')
        end
    end
    if not rl then 
        gl = api.gl
        rl = require "lib.raylib"
        gl = nil
    end
end

api.version = '0.0.1'

api.gl = '21'

api.new.session = function(width,height,title,flags)
    --[[
        FLAG_VSYNC_HINT, 
        FLAG_FULLSCREEN_MODE, 
        FLAG_WINDOW_RESIZABLE, 
        FLAG_WINDOW_UNDECORATED, 
        FLAG_WINDOW_HIDDEN, 
        FLAG_WINDOW_MINIMIZED, 
        FLAG_WINDOW_MAXIMIZED, 
        FLAG_WINDOW_UNFOCUSED, 
        FLAG_WINDOW_TOPMOST, 
        FLAG_WINDOW_ALWAYS_RUN, 
        FLAG_WINDOW_TRANSPARENT, 
        FLAG_WINDOW_HIGHDPI, 
        FLAG_WINDOW_MOUSE_PASSTHROUGH, 
        FLAG_BORDERLESS_WINDOWED_MODE, 
        FLAG_MSAA_4X_HINT, 
        FLAG_INTERLACED_HINT
    ]]
    flags = flags or {}
    local session =
    {
        pipes = require 'src.pipes',
        pipeadd= api.pipeadd,
        pipeline = 
        {
            main={}
        },
        process = api.process,
        run = api.run,
        api = api,
        console = 
        {
            logs = {},
            active = false
        },
        window = 
        {
            width = 320,
            height = 240,
            title = ('maqquina' .. api.version)
        },
        scenes = {},
        scene = {},
        data = {},
        temp = {},
        cmd = 
        {
            ['--'] = function() end
        }
    }

    session:pipeadd('close','_close')
    session:pipeadd('startdraw','_startdraw')
    session:pipeadd('clearbg','_clearbg')
    session:pipeadd('start3d','_start3d')
    session:pipeadd('drawcube','_drawcube')
    session:pipeadd('end3d','_end3d')
    session:pipeadd('drawtxt','_drawtxt')
    session:pipeadd('enddraw','_enddraw')

    session.pipeline.render = session.pipeline.main
    session.pipeline.main = {}
    
    api.startup(session)
    session.scene = api.new.scene(session,'3d')
    for i, v in ipairs(flags) do
        rl.SetFlag(v)
    end

    session.window.width = width or session.window.width
    session.window.height = height or session.window.height
    session.window.title = title or session.window.title
    rl.InitWindow(session.window.width, session.window.height, session.window.title)
    return session
end

return api