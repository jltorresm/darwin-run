APP_NAME := darwin-run
RUN_FLAGS := --features bevy/dynamic_linking
SERVE_PORT := 8000

watch:
	cargo watch -x run $(RUN_FLAGS)

run:
	cargo run $(RUN_FLAGS)

build-wasm:
	cargo build --release --target wasm32-unknown-unknown
	wasm-bindgen --out-name $(APP_NAME) \
		--out-dir dist \
		--target web target/wasm32-unknown-unknown/release/$(APP_NAME).wasm
	cp -r ./assets dist/

serve-docker:
	docker build -t $(APP_NAME) .
	docker run --rm -p $(SERVE_PORT):80 $(APP_NAME)

serve: build-wasm
	cd dist && php -S 0.0.0.0:$(SERVE_PORT)
