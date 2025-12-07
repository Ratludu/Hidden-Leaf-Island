const rl = @import("raylib");

pub const premium_character_path = "/Users/ratludu/Downloads/Sprout Lands - Sprites - premium pack/Characters/Premium Charakter Spritesheet.png";

const state = enum {
    idle,
    hoe,
    walkLeft,
    walkRight,
    walkUp,
    walkDown,
};

const direction = enum {
    left,
    right,
    up,
    down,
};

const animations = enum {
    repeating,
    oneshot,
};

pub const Animation = struct {
    type: animations,
    first: u32,
    last: u32,
    current: u32,

    speed: f32,
    durationLeft: f32,

    pub fn init(animation_type: animations, first: u32, last: u32, current: u32) Animation {
        return Animation{
            .type = animation_type,
            .first = first,
            .last = last,
            .current = current,
            .speed = 0.1,
            .durationLeft = 0.1,
        };
    }

    pub fn animation_frame(self: *Animation, num_frames_per_row: u32, tile_size: f32) rl.Rectangle {
        const x: f32 = @as(f32, @floatFromInt(self.current % num_frames_per_row)) * tile_size;
        const y: f32 = @as(f32, @floatFromInt(self.current / num_frames_per_row)) * tile_size;

        return rl.Rectangle{
            .x = x,
            .y = y,
            .width = tile_size,
            .height = tile_size,
        };
    }

    pub fn animationUpdate(self: *Animation) void {
        const dt: f32 = rl.getFrameTime();
        self.durationLeft -= dt;

        if (self.durationLeft <= 0.0) {
            self.durationLeft = self.speed;
            self.current += 1;

            if (self.current > self.last) {
                switch (self.type) {
                    .repeating => blk: {
                        self.current = self.first;
                        break :blk;
                    },
                    .oneshot => blk: {
                        self.current = self.last;
                        break :blk;
                    },
                }
            }
        }
    }
};

pub const Player = struct {
    sourceRect: rl.Rectangle,
    destRect: rl.Rectangle,
    playerSprite: rl.Texture2D,
    playerState: state,
    playerDirection: direction,
    anim: Animation,
    cam: rl.Camera2D,

    pub fn init(screenWidth: i32, screenHeight: i32) rl.RaylibError!Player {
        const player_sprite = try rl.loadTexture(premium_character_path);
        var source_rect = rl.Rectangle.init(0, 0, 48, 48);
        _ = &source_rect;

        var anim = Animation.init(.repeating, 0, 7, 0);
        _ = &anim;

        var dest_rect = rl.Rectangle.init(@floatFromInt(@divFloor(screenWidth, 2) - 100 / 2), @floatFromInt(@divFloor(screenHeight, 2) - 100 / 2), 100, 100);
        _ = &dest_rect;

        var cam = rl.Camera2D{
            .offset = .{ .x = @as(f32, @floatFromInt(@divFloor(screenWidth, 2))) - dest_rect.width, .y = @as(f32, @floatFromInt(@divFloor(screenHeight, 2))) - dest_rect.height },
            .target = .{ .x = dest_rect.x - dest_rect.width / 2.0, .y = dest_rect.y - dest_rect.height / 2.0 },
            .rotation = 0.0,
            .zoom = 1.0,
        };
        _ = &cam;

        return Player{
            .sourceRect = source_rect,
            .playerSprite = player_sprite,
            .playerState = state.idle,
            .playerDirection = direction.down,
            .anim = anim,
            .destRect = dest_rect,
            .cam = cam,
        };
    }

    pub fn updateCam(self: *Player) void {
        self.cam.target = .{ .x = self.destRect.x - self.destRect.width / 2.0, .y = self.destRect.y - self.destRect.height / 2.0 };
    }

    pub fn update(self: *Player, new_state: state) void {
        if (new_state == self.playerState) {
            return;
        }

        self.playerState = new_state;

        switch (self.playerState) {
            .idle => blk: {
                idleAnimation(self);
                break :blk;
            },
            .hoe => blk: {
                hoe(self);
                break :blk;
            },
            .walkLeft => blk: {
                self.playerDirection = .left;
                walkLeft(self);
                break :blk;
            },
            .walkRight => blk: {
                self.playerDirection = .right;
                walkRight(self);
                break :blk;
            },
            .walkUp => blk: {
                self.playerDirection = .up;
                walkUp(self);
                break :blk;
            },
            .walkDown => blk: {
                self.playerDirection = .down;
                walkDown(self);
                break :blk;
            },
        }
    }

    pub fn animate(self: *Player) void {
        rl.drawTexturePro(self.playerSprite, self.anim.animation_frame(8, 48), self.destRect, .{ .x = 0.0, .y = 0.0 }, 0.0, .white);
    }

    pub fn idleAnimation(self: *Player) void {
        switch (self.playerDirection) {
            .left => blk: {
                const first = 8 * 3;
                var anim = Animation.init(.repeating, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
            .right => blk: {
                const first = 8 * 2;
                var anim = Animation.init(.repeating, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
            .up => blk: {
                const first = 8 * 1;
                var anim = Animation.init(.repeating, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
            .down => blk: {
                var anim = Animation.init(.repeating, 0, 7, 0);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
        }
    }

    pub fn hoe(self: *Player) void {
        switch (self.playerDirection) {
            .left => blk: {
                const first = 8 * 15;
                var anim = Animation.init(.oneshot, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
            .right => blk: {
                const first = 8 * 14;
                var anim = Animation.init(.oneshot, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
            .up => blk: {
                const first = 13 * 8;
                var anim = Animation.init(.oneshot, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
            .down => blk: {
                const first = 12 * 8;
                var anim = Animation.init(.oneshot, first, first + 7, first);
                _ = &anim;
                self.anim = anim;
                break :blk;
            },
        }
    }

    pub fn walkLeft(self: *Player) void {
        const first = 8 * 7;
        var anim = Animation.init(.oneshot, first, first + 7, first);
        _ = &anim;
        self.anim = anim;
    }

    pub fn walkRight(self: *Player) void {
        const first = 8 * 6;
        var anim = Animation.init(.oneshot, first, first + 7, first);
        _ = &anim;
        self.anim = anim;
    }

    pub fn walkUp(self: *Player) void {
        const first = 8 * 9;
        var anim = Animation.init(.oneshot, first, first + 7, first);
        _ = &anim;
        self.anim = anim;
    }

    pub fn walkDown(self: *Player) void {
        const first = 8 * 8;
        var anim = Animation.init(.oneshot, first, first + 7, first);
        _ = &anim;
        self.anim = anim;
    }

    pub fn walkingUpdate(self: *Player) void {
        if (rl.isKeyDown(rl.KeyboardKey.a)) {
            self.update(.walkLeft);
            self.destRect.x -= 2;
            return;
        }

        if (rl.isKeyDown(rl.KeyboardKey.d)) {
            self.update(.walkRight);
            self.destRect.x += 2;
            return;
        }

        if (rl.isKeyDown(rl.KeyboardKey.w)) {
            self.update(.walkUp);
            self.destRect.y -= 2;
            return;
        }
        if (rl.isKeyDown(rl.KeyboardKey.s)) {
            self.update(.walkDown);
            self.destRect.y += 2;
            return;
        }
    }

    pub fn resetToIdle(self: *Player) void {
        if (self.anim.current == self.anim.last and self.anim.type == .oneshot) {
            self.update(.idle);
            return;
        }

        if (!rl.isKeyDown(rl.KeyboardKey.a) and self.playerState == .walkLeft) {
            self.update(.idle);
            return;
        }

        if (!rl.isKeyDown(rl.KeyboardKey.d) and self.playerState == .walkRight) {
            self.update(.idle);
            return;
        }

        if (!rl.isKeyDown(rl.KeyboardKey.s) and self.playerState == .walkDown) {
            self.update(.idle);
            return;
        }

        if (!rl.isKeyDown(rl.KeyboardKey.w) and self.playerState == .walkUp) {
            self.update(.idle);
            return;
        }
    }
};
