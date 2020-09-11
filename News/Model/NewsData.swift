import Foundation


class NewsData: Comparable {
    
    static func == (lhs: NewsData, rhs: NewsData) -> Bool {
        return lhs.title == rhs.title
    }
    
    static func < (lhs: NewsData, rhs: NewsData) -> Bool {
        return lhs.pubDate > rhs.pubDate
    }
    
    var alreadySeen = false
    var title = ""
    var link = ""
    var author = ""
    var pubDate = Date()
    var description = ""
    var enclosure = ""
    var guid = ""
    var category = ""
    var imageURL = ""
    var favorite = false
    
}
