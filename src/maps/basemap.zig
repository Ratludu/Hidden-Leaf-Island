const rl = @import("raylib");
const data = @import("data.zig");

pub const grass_tiles = "/users/ratludu/Downloads/Sprout Lands - Sprites - premium pack/Tilesets/ground tiles/New tiles/Grass_tiles_v2.png";
pub const soil_tiles = "/users/ratludu/Downloads/Sprout Lands - Sprites - premium pack/Tilesets/ground tiles/New tiles/Soil_Ground_HiIls_Tiles.png";

pub const BaseMap = struct {
    sourceRectange: rl.Rectangle,
    destRectange: rl.Rectangle,
    grass: rl.Texture2D,
    soil: rl.Texture2D,
    map: [30 * 30]u32,

    pub fn init() !BaseMap {
        const grass = try rl.loadTexture(grass_tiles);
        const soil = try rl.loadTexture(soil_tiles);
        var source_rect = rl.Rectangle.init(0, 16 * 6, 16, 16);
        _ = &source_rect;
        var dest_rectangle = rl.Rectangle.init(0, 0, 32, 32);
        _ = &dest_rectangle;

        return BaseMap{
            .sourceRectange = source_rect,
            .destRectange = dest_rectangle,
            .grass = grass,
            .soil = soil,
            .map = data.test_map,
        };
    }
    pub fn draw(self: *BaseMap) void {
        for (self.map, 0..) |tile, i| {
            const new_i: i32 = @intCast(i);
            self.destRectange.x = self.destRectange.width * @as(f32, @floatFromInt(@mod(new_i, 30)));
            self.destRectange.y = self.destRectange.height * @as(f32, @floatFromInt(@divFloor(new_i, 30)));
            if (tile == 67) {
                rl.drawTexturePro(self.grass, self.sourceRectange, self.destRectange, rl.Vector2{ .x = self.destRectange.width, .y = self.destRectange.height }, 0.0, .white);
            } else {
                rl.drawTexturePro(self.soil, self.sourceRectange, self.destRectange, rl.Vector2{ .x = self.destRectange.width, .y = self.destRectange.height }, 0.0, .white);
            }
        }
    }
};
