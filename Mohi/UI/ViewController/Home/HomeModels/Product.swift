//
//  Product.swift
//
//  Created by Sandeep Kumar  on 17/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class Product: NSObject, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let productId = "product_id"
    static let isAddToCart = "is_add_to_cart"
    static let image = "image"
    static let isWishlist = "is_wishlist"
    static let productSpecialPrice = "product_special_price"
    static let productName = "product_name"
    static let productPrice = "product_price"
  }

  // MARK: Properties
  public var productId: Int?
  public var isAddToCart: Int?
  public var image: String?
  public var isWishlist: Int?
  public var productSpecialPrice: Int?
  public var productName: String?
  public var productPrice: Int?

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
    productId <- map[SerializationKeys.productId]
    isAddToCart <- map[SerializationKeys.isAddToCart]
    image <- map[SerializationKeys.image]
    isWishlist <- map[SerializationKeys.isWishlist]
    productSpecialPrice <- map[SerializationKeys.productSpecialPrice]
    productName <- map[SerializationKeys.productName]
    productPrice <- map[SerializationKeys.productPrice]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = productId { dictionary[SerializationKeys.productId] = value }
    if let value = isAddToCart { dictionary[SerializationKeys.isAddToCart] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = isWishlist { dictionary[SerializationKeys.isWishlist] = value }
    if let value = productSpecialPrice { dictionary[SerializationKeys.productSpecialPrice] = value }
    if let value = productName { dictionary[SerializationKeys.productName] = value }
    if let value = productPrice { dictionary[SerializationKeys.productPrice] = value }
    return dictionary
  }

}
