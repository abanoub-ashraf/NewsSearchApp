import Foundation

/// this is a class not struct cause we gonna need to change some stuff on it
/// it's a reference type
class NewsCellViewModel {
    
    let title: String
    let subTitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subTitle: String, imageURL: URL?) {
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
    }
    
}
