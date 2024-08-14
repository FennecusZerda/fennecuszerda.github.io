source:
	@mkdir -p swift

install:
	./install.sh

build: source
	find ./swift -name "*.swift" -maxdepth 1 | xargs xcrun swiftc -o main

run: build
	./main

deploy: run
	zip -r build.zip build

clean:
	rm -rf ./main ./build ./bulma ./scripts/node_modules