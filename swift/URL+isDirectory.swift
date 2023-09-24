import Foundation

extension URL {
    var isDirectory: Bool {
       (try! resourceValues(forKeys: [.isDirectoryKey])).isDirectory == true
    }
}