const std = @import("std");
const Hidden_Leaf_Island = @import("Hidden_Leaf_Island");
const rl = @import("raylib");
const Entities = @import("entities/player.zig");
const Map = @import("maps/basemap.zig");

fn toggleFullScreen(windowWidth: i32, windowHeight: i32) void {
    if (!rl.isWindowFullscreen()) {
        const monitor = rl.getCurrentMonitor();
        rl.setWindowSize(rl.getMonitorWidth(monitor), rl.getMonitorHeight(monitor));
        rl.toggleFullscreen();
    } else {
        rl.toggleFullscreen();
        rl.setWindowSize(windowWidth, windowHeight);
    }
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 640;
    const screenHeight = 360;

    rl.initWindow(screenWidth, screenHeight, "Hidden Leaf Island");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    var player = try Entities.Player.init(screenWidth, screenHeight);
    defer rl.unloadTexture(player.playerSprite);

    var basemap = try Map.BaseMap.init();
    defer rl.unloadTexture(basemap.grass);
    defer rl.unloadTexture(basemap.soil);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Full screen toggle
        if (rl.isKeyDown(rl.KeyboardKey.left_super) and rl.isKeyPressed(rl.KeyboardKey.f)) {
            toggleFullScreen(screenWidth, screenHeight);
        }
        // Update

        player.resetToIdle();

        if (rl.isKeyDown(rl.KeyboardKey.e)) {
            player.update(.hoe);
        }
        player.walkingUpdate();
        player.updateCam();

        player.anim.animationUpdate();
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.beginMode2D(player.cam);
        defer rl.endMode2D();

        basemap.draw();

        player.animate();

        rl.clearBackground(.white);

        //----------------------------------------------------------------------------------
    }
}
