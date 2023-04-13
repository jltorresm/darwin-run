use bevy::window::WindowResolution;

pub const APP_NAME: &str = "Darwin Run";
pub const WIN_WIDTH: f32 = 1280.0;
pub const WIN_HEIGHT: f32 = 720.0;

#[must_use]
pub fn get_window_resolution() -> WindowResolution {
    (WIN_WIDTH, WIN_HEIGHT).into()
}
