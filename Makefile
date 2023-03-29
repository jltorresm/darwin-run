APP_NAME := darwin-run
RUN_FLAGS := --features bevy/dynamic_linking

watch:
	cargo watch -x run $(RUN_FLAGS)

run:
	cargo run $(RUN_FLAGS)

build-wasm:
	cargo build --release --target wasm32-unknown-unknown
	wasm-bindgen --out-name $(APP_NAME) \
		--out-dir dist \
		--target web target/wasm32-unknown-unknown/release/$(APP_NAME).wasm
	cd dist && ln -sf ../assets ./
