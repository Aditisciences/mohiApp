//
//  HomeScreenModel.swift
//  Mohi
//
//  Created by Consagous on 24/11/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import Foundation

class HomeScreenModel: NSObject {
    var title:String?
    var isProduct:Bool?
    var type:String?
    var productList:[APIResponseParam.HomeScreenDetail.HomeScreenDetailData]?
}
