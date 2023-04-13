use bevy::prelude::*;

use lib::config;

fn main() {
    let mut app = App::new();

    app.add_plugins(
        DefaultPlugins
            .set(get_window_plugin())
            // Use nearest filtering so our pixel art renders clear
            .set(ImagePlugin::default_nearest()),
    );

    lib::parallax::init(&mut app);

    app.run();
}

fn get_window_plugin() -> WindowPlugin {
    let primary_window = Window {
        title: config::APP_NAME.to_string(),
        resolution: config::get_window_resolution(),
        resizable: true,
        ..Default::default()
    };
    WindowPlugin {
        primary_window: Some(primary_window),
        ..default()
    }
}
