import Foundation
import RegexBuilder

enum Keys: String {
	case css
	case js
	case body
}

func cleanCreateDir(_ path: URL) throws {
	if FileManager.default.fileExists(atPath: path.path) {
		try FileManager.default.removeItem(at: path)
	}
	try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
}

// Constants
let baseDir = URL(filePath: "./")
let pagesDir = URL(filePath: "./pages/")
let cssDir = URL(filePath: "./index.scss")
let jsDir = URL(filePath: "./index.js")
let componentsDir = URL(filePath: "./components/")
let imageDir = URL(filePath: "./images/")
let faviconDir = URL(filePath: "./favicon/")

let outputDir = URL(filePath: "./build/")
let cssOutDir = URL(filePath: "./build/css/")
let jsOutDir = URL(filePath: "./build/js/")
let imageOutDir = URL(filePath: "./build/img/")
let faviconOutDir = URL(filePath: "./build/favicon/")

let htmlMinifyPath = "./scripts/node_modules/html-minifier/cli.js"
let htmlMinifyFlags = "--collapse-whitespace --remove-comments --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype"

// MAIN

do {
	for argument in CommandLine.arguments.dropFirst() {
		switch argument {
			case "-clean":
				if FileManager.default.fileExists(atPath: outputDir.path) {
					try FileManager.default.removeItem(at: outputDir)
				}
				exit(0)
			default:
				print("Unknown argument found, \(argument)")
				exit(1)
		}
	}

	// Clean & Setup output directories	
	try cleanCreateDir(outputDir)

	print("Setup output dir")

	// Get base HTML contents
	var baseHTML = try String(contentsOf: URL(filePath: "./base.html"))
	let baseJS = try String(contentsOf: jsDir)

	// Setup CSS & JS Output Dirs
	try cleanCreateDir(cssOutDir)
	try cleanCreateDir(jsOutDir)
	try cleanCreateDir(imageOutDir)

	// Copy JS into output
	try baseJS.write(to: jsOutDir.appending(component: "index-tmp.js"), atomically: true, encoding: .utf8)

	print("Copied JS")

	// Generate CSS from SCSS file
	let cssExecOutput = try exec("node ./scripts/node_modules/.bin/sass --no-source-map \(cssDir.path) \(cssOutDir.path + "/index-tmp.css")")
	if cssExecOutput.count > 0 {
		print(cssExecOutput)
	}

	print("Generated CSS From SCSS")

	try exec([
		"node",
		"./scripts/node_modules/.bin/minify",
		cssOutDir.path + "/index-tmp.css",
		">", 
		cssOutDir.path + "/index.css"
	].joined(separator: " "))
	try FileManager.default.removeItem(atPath: cssOutDir.path + "/index-tmp.css")

	print("Minified CSS")

	try exec([
		"node",
		"./scripts/node_modules/.bin/minify",
		jsOutDir.appending(component: "index-tmp.js").path,
		">", 
		jsOutDir.appending(component: "index.js").path
	].joined(separator: " "))
	try FileManager.default.removeItem(at: jsOutDir.appending(component: "index-tmp.js"))
	
	print("Minified JS")

	// Add CSS & JS Paths to base HTML
	baseHTML = baseHTML.replace(key: .css, with: "./css/index.css")
	baseHTML = baseHTML.replace(key: .js, with: "./js/index.js")

	print("Copying Images")
	for directory in try FileManager.default.subpathsOfDirectory(atPath: imageDir.path())
	where !imageDir.appending(path: directory).isDirectory {
		let path = imageDir.appending(path: directory)
		if !FileManager.default.fileExists(atPath: imageOutDir.appending(component: path.lastPathComponent).path) {
			try FileManager.default.copyItem(at: path, to: imageOutDir.appending(component: path.lastPathComponent))
		}
	}

	print("Copying Favicon")
	try FileManager.default.copyItem(at: faviconDir, to: faviconOutDir)

	print("Generating Pages")

	// Get all components
	let components: [Component] = try FileManager
		.default
		.contentsOfDirectory(at: componentsDir, includingPropertiesForKeys: nil)
		.map { $0.deletingPathExtension() }
		.compactMap { $0.pathComponents.last }
		.compactMap { try? Component(key: $0) }

	for page in try FileManager.default.contentsOfDirectory(at: pagesDir, includingPropertiesForKeys: nil) {
		var pageContents = try String(contentsOf: page)
		pageContents = "<div class=\"page-content\">" + pageContents + "</div>"
		var pageHTML = baseHTML.replace(key: .body, with: pageContents)

		for component in components {
			try component.findAndReplace(in: &pageHTML, pageName: page.deletingPathExtension().lastPathComponent)
		}

		// Replace all images

		var pagePath = page.pathComponents
		for component in baseDir.pathComponents {
			if pagePath[0] == component {
				pagePath.removeFirst()
			}
		}
		pagePath.removeFirst()
		let outURL = outputDir.appending(component: pagePath.joined(separator: "/"))
		let tmpOutURL = outURL.deletingPathExtension().appendingPathExtension("-tmp.html")
		try pageHTML.write(
			to: tmpOutURL,
			atomically: true,
			encoding: .utf8
		)

		// Minify the page
		let minifyOut = try exec([
			"node",
			"./scripts/node_modules/.bin/minify",
			tmpOutURL.path,
			">", 
			outURL.path
		].joined(separator: " "))
		if minifyOut.count > 0 {
			print(minifyOut)
		}

		try FileManager.default.removeItem(atPath: tmpOutURL.path)
		
		print("\tFinished", pagePath.joined(separator: "/"))
	}

	print("Done")
} catch {
	print("Error")
	print(error)
	exit(1)
}

