import Foundation
import RegexBuilder

public struct Component {
	let key: String
	let contents: String
	
	init(key: String) throws {
		self.key = key
		self.contents = try String(contentsOf: componentsDir.appending(component: key + ".html"))
	}

	func findAndReplace(in string: inout String, pageName: String) throws {
		let regex = Regex {
			"{{\(key)"
			Optionally {
				Capture {
					One(".")
					ZeroOrMore {
						CharacterClass(
							.anyOf("./"),
							.word
						)
					}
				}
			}
			"}}"
		}
		.anchorsMatchLineEndings()

		if key == "images" && FileManager.default.fileExists(atPath: imageDir.appending(component: pageName).path) {
			for match in string.matches(of: regex).reversed() {
				let args = match.output.1?.split(separator: ".") ?? []
				let argString = (args.isEmpty ? "" : "/") + args.joined(separator: "/")
				let sourcePath = imageDir.appending(path: pageName + argString)

				let imagePaths = try FileManager
					.default
					.contentsOfDirectory(at: sourcePath, includingPropertiesForKeys: nil)
					.filter { !$0.isDirectory }

				let images = contents.replace(
					key: "images", 
					with: imagePaths.map { imageString(for: $0) }.joined()
				)
				string.replaceSubrange(match.range, with: images)
			}
		} else if key == "image" && FileManager.default.fileExists(atPath: imageDir.appending(component: pageName).path) {
			for match in string.matches(of: regex).reversed() {
				let imageName = match.output.1?.trimmingPrefix(".") ?? ""
				let imagePath = imageDir.appending(path: pageName + "/" + imageName)
				let image = imageString(for: imagePath, active: true)
				string.replaceSubrange(match.range, with: image)
			}
		} else {
			string.replaceInSelf(key: self.key, with: self.contents)
		}
	}

	private func imageString(for path: URL, active: Bool = false) -> String {
		"""
		<img class="image" src="./img/\(path.lastPathComponent)" fetchpriority="high" data-active="\(active ? "true" : "false")" />
		""" 
	}
}