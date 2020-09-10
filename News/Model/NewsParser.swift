import Foundation

class NewsParser: NSObject, XMLParserDelegate {
    
    weak var delegate: ParserDelegate?
    
    private var parser: XMLParser?
    private var xmlText = ""
    private var newsData: NewsData?
    private(set) var channel: Channel?
    
    private(set) var news = [NewsData]()
    private var last = false
    
    init(data:Data,last:Bool = false) {
        parser = XMLParser(data: data)
    }

    func parse() -> [NewsData]  {
        parser?.delegate = self
        parser?.parse()
        return news
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        switch elementName {
        case Tags.item:
            newsData = NewsData()
        case Tags.channel:
            channel = Channel()
        case "enclosure":
            if let imageLink = attributeDict["url"] {
                newsData?.imageLink = imageLink
            }
        default:break
        }
        
    }
    var elements = NSMutableDictionary()
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case Tags.title:
            newsData?.title = xmlText
            if channel?.title == nil { channel?.title = xmlText }
            newsData?.author = channel?.title ?? ""
        case Tags.link:
            newsData?.link = xmlText
        case Tags.description:
            newsData?.description = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
        case Tags.item:
            if let newsData = newsData {
                news.append(newsData)
            }
        case Tags.rss:
               // news = news.sorted()
                delegate?.finishParsing()
        default:break
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
    

}

protocol ParserDelegate: class {
    func finishParsing()
}
