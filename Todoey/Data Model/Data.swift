//
//  Data.swift
//  Todoey
//
//  Created by Geetesh Vaigankar on 03/07/19.
//  Copyright © 2019 RubikEdge. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
