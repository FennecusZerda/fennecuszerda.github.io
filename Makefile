source:
	@mkdir -p swift

install:
	cd scripts && npm install --save-dev

build: source
	find ./swift -name "*.swift" -maxdepth 1 | xargs xcrun swiftc -o main

run: build
	./main

deploy: run
	zip -r build.zip build

clean:
	rm -r ./main ./build