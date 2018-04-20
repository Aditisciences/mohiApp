//
//  Category.swift
//
//  Created by Sandeep Kumar  on 16/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class Category: NSObject, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let catId = "id"
    static let image = "image"
    static let name = "name"
  }

  // MARK: Properties
  public var catId: String?
  public var image: String?
  public var name: String?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map){

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    catId <- map[SerializationKeys.catId]
    image <- map[SerializationKeys.image]
    name <- map[SerializationKeys.name]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = catId { dictionary[SerializationKeys.catId] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    return dictionary
  }

}
