//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import SWXMLHash
import Foundation
import Alamofire

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
        let xmlWithNamespace = """
        <root xmlns:h=\"http://www.w3.org/TR/html4/\"
        xmlns:f=\"http://www.w3schools.com/furniture\">
          <h:table>
            <h:tr>
              <h:td>Apples</h:td>
              <h:td>Bananas</h:td>
            </h:tr>
          </h:table>
          <f:table>
            <f:name>African Coffee Table</f:name>
            <f:width></f:width>
            <f:length></f:length>
          </f:table>
        </root>
        """
        //parse local data
        let xml = SWXMLHash.parse(xmlWithNamespace)
        // one root element
        let count = xml.all.count
        var totalElements = 0.01
        var leafElements = 0.01
        print(count)
        // "Apples"
        print(xml["root"]["h:table"]["h:tr"]["h:td"][0].element!.text)
        // enumerate all child elements (procedurally)
        func enumerate(indexer: XMLIndexer, level: Int) {
            
            for child in indexer.children {
                let name = child.element!.name
                let children = child.element!.children
                let isEmpty = child.element!.children.isEmpty
                let countRatio :Double = Double((leafElements/totalElements))
                print (countRatio)
                label.text = "Total/leaf elements = \(countRatio)"
                if isEmpty == true {
                    leafElements += 1
                    
                } else {
                }
                print("\(level) \(name) \(children.count) \(isEmpty)")
                totalElements += 1
                enumerate(indexer: child, level: level + 1)
            }
            
            print("LEAF elements \(leafElements)")
            print("Total elements \(totalElements)")
            

           
            
        }
        
        enumerate(indexer: xml, level: 0)
        // enumerate all child elements (functionally)
        func reduceName(names: String, elem: XMLIndexer) -> String {
            return names + elem.element!.name + elem.children.reduce(", ", reduceName)
        }
        
        // print(count)
        
        //parse data drom w3schools server
        // AF.request
        AF.request("https://www.w3schools.com/xml/cd_catalog.xml").response { response in
            
            if let data = response.data {
                print(SWXMLHash.parse(data))
                
                let xml = SWXMLHash.parse(data)
                let news = xml["CATALOG"]["CD"][0].element?.text
                print(news!)
            }
        }
        
        
    }
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
#warning (" start playground ")
