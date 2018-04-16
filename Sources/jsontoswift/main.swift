/*
** This project is licensed under the GNU GENERAL PUBLIC LICENSE Version 3
** Project made by barre_k 2019 EPITECH LYON
*/


import Foundation
typealias JSONValue = Any
typealias JSONAray = [Any]
typealias JSONElement = [String: JSONValue]
typealias Item = (key: String, value: Any)
typealias ValDef = (name: String, type: String, initValue:Any, value:Any)


extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension Array {
    func getIndexOf(_ value: Any) -> Int {
        var index: Int = 0
        for item in self
        {
            if "\(item)" == "\(value)"{
                break
            }
            index += 1
        }
        return index
    }
}

struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func append(_ item: Element) {
        self.push(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
    var count: Int {
        return items.count
    }
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
    var isNotEmpty: Bool{
        return !items.isEmpty
    }
    var lastIndex: Int{
        return items.count - 1
    }
}

class SwiftStuctDef {
    var values = Stack<ValDef>()
    private var strucDef: String
    private var structname: String?
    
    required init(_ name: String? = nil)
    {
        self.structname = name ?? "JsonObject"
        self.strucDef = "struct \(name ?? "JsonObject") {\n"
    }

    var getJsonInit: String{
        var initStruct: String = "\n    init(json jsonValues: [String: Any]){\n"
        for i in 0..<values.count {
            if type(of: values[i].initValue) == JSONElement.self
            {
                initStruct += "\tself.\(values[i].name) = Struct\(values[i].name.firstUppercased)(json: jsonValues[\"\(values[i].name)\"] as! [String: Any])\n" 
            }
            else{
                initStruct += "\tself.\(values[i].name) = jsonValues[\"\(values[i].name)\"] as? \(type(of: values[i].initValue))\n" 
            }
        }
        initStruct += "    }\n\n"
        return initStruct
    }

    var getInit: String{
        var initStruct: String = "\n    init("
        for i in 0..<values.count - 1 {
            initStruct += "\(values[i].name): \(values[i].type) =  \(values[i].value),\n    " 
        }
        initStruct += "\(values[values.lastIndex].name): \(values[values.lastIndex].type) =  \(values[values.lastIndex].value)){\n"
        for i in 0..<values.count {
            initStruct += "\tself.\(values[i].name) = \(values[i].name)\n" 
        }
        initStruct += "    }\n"
        return initStruct
    }

    var toString: String{
        var value: ValDef
        let initStruct: String = getJsonInit + getInit
        while values.isNotEmpty {
            value = values.pop()
            strucDef += "    var \(value.name): \(value.type)\n"
        }
        strucDef += "\(initStruct)\n}\n\n"
        return strucDef
    }
}

func analyseArray(_ items: JSONAray, _ stackStruct: inout Stack<SwiftStuctDef>, _ structName: String? = nil)
{
    for item in items
    {
        let runtype = type(of: item)
        if runtype == JSONElement.self {
            analyse(item as! JSONElement, &stackStruct, "Struct"+structName!.firstUppercased+"\(items.getIndexOf(item))")
        }
        else if runtype == JSONAray.self {
            analyseArray(item as! JSONAray, &stackStruct)
        }
    }
}

func analyse(_ items: JSONElement, _ stackStruct: inout Stack<SwiftStuctDef>, _ structName: String? = nil)
{
    let actualStruct = SwiftStuctDef(structName)

    for item in items
    {
        switch item.value {
            case let val as JSONAray:
                actualStruct.values.push((item.key, "\(type(of: val))?", item.value, "nil"))
                analyseArray(val, &stackStruct, item.key)
            case let val as JSONElement:
                actualStruct.values.push((item.key, "Struct"+item.key.firstUppercased+"?", item.value, "Struct"+item.key.firstUppercased+"()"))
                analyse(val, &stackStruct, "Struct"+item.key.firstUppercased)
            case _ as NSNull:
                actualStruct.values.push((item.key, "Any?", "", "nil"))
            case _ as String:
                actualStruct.values.push((item.key, "\(type(of: item.value))?", item.value, "\"\(item.value)\""))
            default:
                actualStruct.values.push((item.key, "\(type(of: item.value))?", item.value, item.value))
        }
    }
    stackStruct.push(actualStruct)
}

// I will not explain all function because i don't care
// You can use this for personal project
// But don't use for profesional project because is just school project
func run(_ jsonValues: JSONElement) {
    var allStructs = Stack<SwiftStuctDef>()
    analyse(jsonValues, &allStructs)
    for i in 0..<allStructs.count {
        print(allStructs[i].toString)
        print("\n")
    }
}


// how to use
// cat Sources/jsontoswift/data.json | swift run jsontoswift > class.swift
var jsonFile: String = ""
while let thing = readLine() {jsonFile += thing + " "}
let jsonData = jsonFile.data(using: .utf8)
let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
if let jsonValues = json as? JSONElement {
    run(jsonValues)
}
else
{
    print("Json error")
}

