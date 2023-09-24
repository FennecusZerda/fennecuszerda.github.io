source:
	@mkdir -p swift

build: source
	find ./swift -name "*.swift" -maxdepth 1 | xargs swiftc -o main

run: build
	./main

clean:
	rm -r ./main ./build