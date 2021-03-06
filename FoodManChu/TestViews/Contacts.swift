import SwiftUI
import UIKit

struct Table: View {
    var rawData = [
        "XYZ Fried Rice",
        "Beef with Broccoli",
        "General Tso's Chicken",
        "Garlic Chicken"
    ]
    
    @State private var wordGroups = ["g": ["General Tso\'s Chicken", "Garlic Chicken"], "b": ["Beef with Broccoli"], "x": ["XYZ Fried Rice"]]
    
    var body: some View {
        Form {
            ForEach(Array(wordGroups.keys).sorted(), id: \.self) { i in
                Section(header: Text(i)) {
                    ForEach(wordGroups[i]!, id: \.self) { food in
                        NavigationLink(destination: Text("Hello")) {
                            Text(food)
                        }
                    }
                }
            }
        }
    }
    
    func getAllFirstLetterGroups() -> [String: [String]] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var sameStartingLetterDict = [String: [String]]()
        
        for letter in alphabet {
            for data in rawData {
                if let firstLetter = data.first {
                    if firstLetter.lowercased() == String(letter) {
                        let key = String(letter)
                
                        if sameStartingLetterDict[key] != nil {
                            sameStartingLetterDict[key]?.append(data)
                        } else {
                            sameStartingLetterDict[key] = [data]
                        }
                    }
                }
            }
        }
        
        print("Dictionary: \(sameStartingLetterDict)")
        print("Keys: \(sameStartingLetterDict.keys)")

        return sameStartingLetterDict
    }
}


struct Table_previews: PreviewProvider {
    static var previews: some View {
        Table()
    }
}



//
//struct TableView: UIViewRepresentable {
//    @Binding var letterGrouping: [String: [String]]
//
//    func makeUIView(context: Context) -> UITableView {
//        let tableView =  UITableView(frame: .zero, style: .plain)
//        tableView.delegate = context.coordinator
//        tableView.dataSource  = context.coordinator
//        return tableView
//    }
//
//    func updateUIView(_ uiView: UITableView, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    final class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
//        var parent: TableView
//
//        init(parent: TableView) {
//            self.parent = parent
//        }
//
//        func numberOfSections(in tableView: UITableView) -> Int {
//            return parent.letterGrouping.keys.count
//        }
//
//        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return Array(parent.letterGrouping.keys).sorted()[section].uppercased()
//        }
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            let sortedKeys = Array(parent.letterGrouping.keys).sorted()
//            let key = sortedKeys[section]
//            return parent.letterGrouping[key]!.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cellId = "cellIdentifier"
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .default, reuseIdentifier: cellId)
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        }
//
////        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
////            return ["a"]
////        }
//    }
//}
