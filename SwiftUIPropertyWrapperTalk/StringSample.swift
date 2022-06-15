//
//  StringSample.swift
//  SwiftUIPropertyWrapperTalk
//
//  Created by Donny Wals on 14/06/2022.
//

import Foundation

@propertyWrapper
struct StringSample {
    let wrappedValue: String

    var projectedValue: String {
        "Projected: \(wrappedValue)"
    }
}

struct SampleUsage {
    @StringSample var example = "Hello, world"
    
    func printSample() {
        print(example) // "Hello, world"
        print(_example) // StringSample
        print($example) // "Projected: Hello, world"
    }
}
