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
    
    router.get("stream", Int.parameter) { req -> HTTPResponse in
        let level = try req.parameters.next(Int.self)
        if let level = EnhanceLevel(rawValue: level) {
            let fileURL =  getFilePath(for:  level)
            return try req.fileio().chunkedResponse(file: fileURL.relativePath, for: req.http)
        } else {
            var res = HTTPResponse(status: .ok, body: "Levels from 1 ... 5")
            res.contentType = .plainText
            return res
        }
    }
    
    router.get("level", Int.parameter) { req -> String in
        let level = try req.parameters.next(Int.self)
        if let level = EnhanceLevel(rawValue: level) {
            return getData(for: getFilePath(for:  level))
            
        } else {
            return "Levels from 1 ... 5"
        }
    }
    
    
}


//typealias Path = String
//typealias Content = String

//lazy var files:[Path:Content] =
func getFilePath(for level:EnhanceLevel) -> URL{
    let directory = DirectoryConfig.detect()
    let configDir = "Sources/App/Assets"
    
    let fileURL = URL(fileURLWithPath: directory.workDir)
        .appendingPathComponent(configDir, isDirectory: true)
        .appendingPathComponent("cats\(level.rawValue).json", isDirectory: false)
    return fileURL
    
}
func getData(for fileURL:URL) -> String{
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return content
    } catch {
        print(error)
        return "Error"
    }
    
}
