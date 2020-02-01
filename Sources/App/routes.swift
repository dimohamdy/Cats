import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return temp()
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

func temp() -> String{
    let directory = DirectoryConfig.detect()
    let configDir = "Sources/App/Assets"
    
    do {
        let fileURL = URL(fileURLWithPath: directory.workDir)
            .appendingPathComponent(configDir, isDirectory: true)
            .appendingPathComponent("cats.json", isDirectory: false)
        let text2 = try String(contentsOf: fileURL, encoding: .utf8)
        return text2
    } catch {
        print(error)
        return "Error"
    }
    
}
