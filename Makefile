TARGET_LINUX=x86_64-unknown-linux-musl
TARGET_DARWIN=x86_64-apple-darwin
RUSTV = 1.43.1
RUST_DOCKER_IMAGE=rust:${RUSTV}

install_windows_on_mac:
	rustup target add x86_64-pc-windows-gnu
	brew install mingw-w64

compile_wasm:
	rustup target add wasm32-unknown-unknown
	cargo build --target wasm32-unknown-unknown

test:
	cargo test	--features==unstable

test_tokio:
	cargo test   --features=tokio2 --no-default-features 


test_asyncstd:
	cargo test --features=asyncstd --no-default-features


install_linux:
	rustup target add x86_64-unknown-linux-musl

# build linux version
build_linux:	install_linux
	cargo build --target ${TARGET_LINUX}


# build windows version
build-windows:
	cargo build --target=x86_64-pc-windows-gnu



cargo_cache_dir:
	mkdir -p .docker-cargo

docker_linux_test:	cargo_cache_dir
	 docker run --rm --volume ${PWD}:/src --workdir /src  \
	 	-e USER -e CARGO_HOME=/src/.docker-cargo \
		-e CARGO_TARGET_DIR=/src/target-docker \
	  	${RUST_DOCKER_IMAGE} cargo test

docker_linux_test_large:	cargo_cache_dir
	 docker run --rm --volume ${PWD}:/src --workdir /src  \
	 	-e USER -e CARGO_HOME=/src/.docker-cargo \
		-e CARGO_TARGET_DIR=/src/target-docker \
	 	--env RUST_LOG=trace \
	  	${RUST_DOCKER_IMAGE} cargo test zero_copy_large_size