# JsonToSwift

A description of this package.

## Getting Started

* This script is Tongji University IOS/Swift project.
* Convert Json Document to Swift Structure.

### Prerequisites

You need to have swift installed on your computer.

* [Swift](https://swift.org/getting-started/#installing-swift) - MacOS & Ubuntu
* [Swift-docker](https://github.com/swiftdocker/docker-swift) - Linux without Ubuntu


## Running
```
cat data.json | swift run jsontoswift > struct.swift
```

```
// create struct with initial values
var obj = JsonObject()

// create struct with json parameter values
let jsonFile: String = "{\"answer\": 42, \"hello\": \"world\"}"
let jsonData = jsonFile.data(using: .utf8)
let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
var objprime = JsonObject(json)

print(obj)
print(objprime)
```


## Authors

* **Barre Kevin** - *Initial work* - [neudinger](https://github.com/neudinger)

## Code Style and Optimisation

I learned SWIFT language and write this project in 2 days.

You can use this for personal project. But don't use for professional project because is just school project.

So may be the code is not awesome but i will never touch this proprietary language again.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE
                       Version 3 - see the [GNU GPL3](LICENSE) file for details

## Epitech Cheater

Please understand the project and the swift language
don't copy - paste foolishly.

Skills & Experiences > School Ranking