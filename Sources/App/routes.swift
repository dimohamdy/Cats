import Vapor

enum EnhanceLevel: Int,CaseIterable {
    case level1 = 1
    case level2
    case level3
    case level4
    case level5

}
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    //EnhanceLevel.allCases.compactMap

    router.get("stream") { req -> HTTPResponse in
        
        let directory = DirectoryConfig.detect()
        let configDir = "Sources/App/Assets"

        let fileURL = URL(fileURLWithPath: directory.workDir)
            .appendingPathComponent(configDir, isDirectory: true)
            .appendingPathComponent("cats1.json", isDirectory: false)
        
        return try req.fileio().chunkedResponse(file: fileURL.relativePath, for: req.http)
    }
    
    router.get("level", Int.parameter) { req -> String in
        let level = try req.parameters.next(Int.self)
        if let level = EnhanceLevel(rawValue: level) {
            return getData(for:  level)

        } else {
            return "Levels from 1 ... 5"
        }
    }
    

}


//typealias Path = String
//typealias Content = String

//lazy var files:[Path:Content] =
func getData(for level:EnhanceLevel) -> String{
    let directory = DirectoryConfig.detect()
    let configDir = "Sources/App/Assets"
    
    do {
        let fileURL = URL(fileURLWithPath: directory.workDir)
            .appendingPathComponent(configDir, isDirectory: true)
            .appendingPathComponent("cats\(level.rawValue).json", isDirectory: false)
        let text2 = try String(contentsOf: fileURL, encoding: .utf8)
        return text2
    } catch {
        print(error)
        return "Error"
    }
    
}
