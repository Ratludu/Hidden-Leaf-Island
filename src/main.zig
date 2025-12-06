const std = @import("std");
const Hidden_Leaf_Island = @import("Hidden_Leaf_Island");
const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 640;
    const screenHeight = 360;

    rl.initWindow(screenWidth, screenHeight, "Hidden Leaf Island");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    const sprite = try rl.loadTexture("/home/ratludu/assets/Sprout Lands - Sprites - premium pack/Characters/Basic Charakter Actions.png");
    defer rl.unloadTexture(sprite);

    const sourceRect = rl.Rectangle{
        .x = 0.0,
        .y = 0.0,
        .width = 32.0,
        .height = 32.0,
    };

    const destRect = rl.Rectangle{
        .x = screenWidth / 2 - 32,
        .y = screenHeight / 2 - 32,
        .width = 64.0,
        .height = 64.0,
    };

    const positiion = rl.Vector2{
        .x = destRect.width + destRect.width / 2,
        .y = destRect.height + destRect.width / 2,
    };

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.drawTexturePro(sprite, sourceRect, destRect, positiion, 0.0, .white);

        rl.clearBackground(.white);

        rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
        //----------------------------------------------------------------------------------
    }
}
