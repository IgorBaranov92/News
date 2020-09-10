import Foundation
import SwiftyXMLParser

class NewsParser: NSObject, XMLParserDelegate {
    
    weak var delegate: ParserDelegate?
    
    private var parser: XMLParser?
    private var xmlText = ""
    private var newsData: NewsData?
    private(set) var news = [NewsData]()
    private var last = false
    
    init(data:Data,last:Bool = false) {
        parser = XMLParser(data: data)
        self.last = last
        let str = try! String(contentsOf: URL(string: Sources.sources[0])!)
        let xml = try! XML.parse(str)
        print(xml.rss.channel.item[0].pubDate.text)
        print(xml.rss.channel.item.all!.count)
    }

    func parse() -> [NewsData]  {
        parser?.delegate = self
        parser?.parse()
        return news
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        if elementName == "item" {
            newsData = NewsData()
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case Tags.title:
          //  print(xmlText)
            newsData?.title = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
        case Tags.link:
            newsData?.link = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
        case Tags.author:
            newsData?.author = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
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
