//
//  ExtensionNSString.swift
//  Flum
//
//  Created by RajeshYadav on 21/12/16.
//  Copyright © 2016 47billion. All rights reserved.
//

import Foundation

extension String {
    /**
     *  @return A copy of the receiver with all leading and trailing whitespace removed.
     */
    func msg_stringByTrimingWhitespace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
