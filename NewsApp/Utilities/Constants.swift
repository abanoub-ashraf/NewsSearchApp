import Foundation
import UIKit

struct Constants {
    
    // MARK: - API URLs -
    
    static let topHeadlinesURL = URL(
        string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=\(Config.apiKey)"
    )
    
    static let searchURL = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=\(Config.apiKey)&q="

    // MARK: - TableViewCells -
    
    static let NewsCellIdentifer = "NewsCell"
    
    // MARK: - Images -
    
    static let placeholderImage = UIImage(named: "placeholder")
    static let stringImage = "https://user-images.githubusercontent.com/10991489/119644867-b0888c80-be1d-11eb-9959-d615b8ee3fbd.jpeg"
    
}


