extension String {
	func replace(key: String, with: String) -> String {
		self.replacingOccurrences(of: "{{" + key + "}}", with: with)
	}

	func replace(key: Keys, with: String) -> String {
		self.replacingOccurrences(of: "{{" + key.rawValue + "}}", with: with)
	}

	mutating func replaceInSelf(key: String, with: String) {
		self.replace("{{" + key + "}}", with: with)
	}

	mutating func replaceInSelf(key: Keys, with: String) {
		self.replace("{{" + key.rawValue + "}}", with: with)
	}
}