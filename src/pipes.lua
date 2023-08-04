local pipes = {render={}}

pipes.close = function(session)
    if rl.WindowShouldClose() then
        rl.CloseWindow()
        session.temp.exit = true
    end
end

pipes.startdraw = function()
    rl.BeginDrawing()
end

pipes.start3d = function(session)
    rl.BeginMode3D(session.scene.camera)
end

pipes.clearbg = function(session)
    rl.ClearBackground(session.scene.backgroundcolor)
end

pipes.end3d = function()
    rl.EndMode3D()
end

pipes.drawtxt = function(session)
    for i, text in ipairs(session.scene.text) do
        rl.DrawText(text.file, text.position.x, text.position.y, text.size or session.defaults.text.size, text.color or session.scene.color.text)
    end
end

pipes.drawcube = function(session)
    for i, cube in ipairs(session.scene.cube) do
        if cube.render then
            rl.DrawCubeV(cube.position, cube.size, cube.color or rl.RED)
        end
        if cube.wired then
            rl.DrawCubeWiresV(cube.position, cube.size, session.defaults.color)
        end
    end
end

pipes.fpscounter = function(session)
    rl.DrawFPS(1,1)
end

pipes.enddraw = function()
    rl.EndDrawing()
end

return pipes