import Foundation

struct Resource: Codable {
    var title: String
    var category: String
    var link: String
    
    init(title: String, category: String, link: String) {
        self.title = title
        self.category = category
        self.link = link
    }
    
    // Static function to save resources (similar to the `saveCategories` function)
    static func saveResources(_ resources: [Resource]) {
        let propertyListEncoder = PropertyListEncoder()
        
        do {
            // Encode the array of resources
            let encodedResources = try propertyListEncoder.encode(resources)
            
            // Write to the archive URL (create a custom file path for storing resources)
            try encodedResources.write(to: Resource.archiveURL, options: .noFileProtection)
        } catch {
            print("Error encoding and saving resources: \(error)")
        }
    }
    
    // Static function to load resources from file
    static func loadResources() -> [Resource]? {
        let propertyListDecoder = PropertyListDecoder()
        
        do {
            // Decode the data from the archive URL
            let data = try Data(contentsOf: Resource.archiveURL)
            let decodedResources = try propertyListDecoder.decode([Resource].self, from: data)
            return decodedResources
        } catch {
            print("Error loading resources: \(error)")
            
            // If loading fails, return sample data
            return createSampleData()
        }
    }
    
    // Function to create sample data if loading fails
    static func createSampleData() -> [Resource] {
        return [
            Resource(title: "How to prepare for an interview", category: "video", link: "http://example.com/interview-prep"),
            Resource(title: "Technical Skills Guide", category: "article", link: "http://example.com/tech-skills"),
            Resource(title: "Best Programming Practices", category: "book", link: "http://example.com/best-practices"),
            Resource(title: "Mastering Swift", category: "video", link: "http://example.com/mastering-swift"),
            Resource(title: "Effective Time Management", category: "article", link: "http://example.com/time-management")
        ]
    }
    
    // Define the archive URL for saving/loading the resources (using the documents directory)
    static var archiveURL: URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("resources.plist")
    }
}
