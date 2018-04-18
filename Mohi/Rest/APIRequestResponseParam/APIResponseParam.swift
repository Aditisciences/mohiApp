//
//  APIResponseParam.swift
//  MyPanditJi
//

import Foundation
import ObjectMapper

class APIResponseParam {
    
    class BaseResponse:Mappable{
        var status:String?
        var message:String? // String
        var token:String?
        var error:NSNumber?
        
        required init(){
            
        }
        
        // Convert Json response to class object
        func getModelObjectFromServerResponse(jsonResponse: AnyObject)->BaseResponse?{
            var baseResponse:BaseResponse?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<BaseResponse>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        baseResponse = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                if (tempJsonString?.isEmpty)! { // On Success response is empty
                    baseResponse = BaseResponse()
                }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<BaseResponse>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            baseResponse = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return baseResponse ?? nil
        }
        
        required init?(map: Map){
        }
        
        func mapping(map: Map){
            status      <- map["status"]
            message     <- map["msg"]
            token       <- map["token"]
            error       <- map["error"]
        }
    }
    
    class Error : BaseResponse{
        var code:String?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Error?{
            var error:Error?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Error>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        error = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Error>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            error = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return error ?? nil
        }
        
        func toString()->String{
            return "{code:"+String(describing: code)+"msg: "+message!+"}"
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            code        <- map["error"]
            
        }
    }
    
    class Login : BaseResponse{
        var loginData:LoginData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Login?{
            var login:Login?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Login>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        login = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Login>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            login = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return login ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            loginData        <- map["data"]
        }
        
        // Data in login response
        class LoginData: Mappable{
            var user_id:Int?
            var firstname:String?
            var lastname:String?
            var email:String?
            var user_image:String?
            var token:String?
            var mobile:String?
            var countryCode : String?
            var address:ShippingAddress.ShippingAddressData?
            
            init(){
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->LoginData?{
                var loginData:LoginData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<LoginData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            loginData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<LoginData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                loginData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return loginData ?? nil
            }
            
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                user_id     <- map["user_id"]
                firstname   <- map["firstname"]
                lastname    <- map["lastname"]
                email       <- map["email"]
                user_image  <- map["user_image"]
                token       <- map["token"]
                mobile      <- map["mob_number"]
                address     <- map["address"]
                countryCode <- map["cntry_code"]
            }
        }
    }
    
    class Registration : BaseResponse{
        var registrationData:RegistrationData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Registration?{
            var registration:Registration?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Registration>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Registration>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            registrationData        <- map["data"]
        }
        
        // Data in registration response
        class RegistrationData: Mappable{
            
            var created_by:String?
            var firstName:String?
            var lastName:String?
            var email:String?
            var contact_number:String?
            var personal_number:String?
            var status:String?
            var account_status:String?
            
            var user_id:String?
            var token:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->RegistrationData?{
                var registrationData:RegistrationData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<RegistrationData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            registrationData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<RegistrationData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                registrationData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return registrationData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                
                user_id         <- map["user_id"]
                token           <- map["token"]
                created_by      <- map["created_by"]
                firstName       <- map["firstName"]
                lastName        <- map["lastName"]
                email           <- map["email"]
                contact_number  <- map["contact_number"]
                personal_number <- map["personal_number"]
                status          <- map["status"]
                account_status  <- map["account_status"]
            }
        }
    }
    
    class Product : BaseResponse{
        var productData:[ProductData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Product?{
            var registration:Product?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Product>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Product>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            productData        <- map["data"]
        }
        
        // Data in registration response
        class ProductData: Mappable{
            
            var product_id:String?
            var product_name:String?
            var image:String?
            var product_price:String?
            var is_add_to_cart:String?
            var is_wishlist:String?
            var qty:String?
            var rating:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ProductData?{
                var featuredProductData:ProductData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ProductData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ProductData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                
                product_id         <- map["product_id"]
                product_name       <- map["product_name"]
                image              <- map["image"]
                product_price      <- map["product_price"]
                is_add_to_cart     <- map["is_add_to_cart"]
                is_wishlist        <- map["is_wishlist"]
                rating             <- map["rating"]
                qty                <- map["qty"]
            }
        }
    }
    
    class WishList : BaseResponse{
        var wishListData:[WishListData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->WishList?{
            var registration:WishList?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<WishList>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<WishList>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            wishListData        <- map["data"]
        }
        
        // Data in registration response
        class WishListData: Mappable{
            
            var product_id:String?
            var product_name:String?
            var image:String?
            var product_price:String?
            var is_add_to_cart:String?
            var qty:String?
            var rating:String?
            var category:String?
            var stock:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->WishListData?{
                var featuredProductData:WishListData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<WishListData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<WishListData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                product_id      <- map["product_id"]
                product_name    <- map["product_name"]
                image           <- map["image"]
                product_price   <- map["product_price"]
                is_add_to_cart  <- map["is_add_to_cart"]
                rating          <- map["rating"]
                qty             <- map["qty"]
                category        <- map["category"]
                stock           <- map["stock"]
            }
        }
    }
    
    class AddToCartList : BaseResponse{
        var productData:[AddToCartListData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->AddToCartList?{
            var registration:AddToCartList?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<AddToCartList>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<AddToCartList>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            productData        <- map["data"]
        }
        
        // Data in product Data response
        class AddToCartListData: Mappable{
            var product_id:String?
            var item_id:String?
            var product_name:String?
            var product_price:String?
            var image:String?
            var category:String?
            var is_add_to_cart:String?
            var is_wishlist:String?
            var rating:String?
            var qty:NSNumber = 1 // For cache purpose only
            var qtyTest:String?
            var quote_id:String?
            var stock:NSNumber?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->AddToCartListData?{
                var featuredProductData:AddToCartListData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<AddToCartListData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<AddToCartListData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                product_id      <- map["product_id"]
                product_name    <- map["product_name"]
                image           <- map["image"]
                product_price   <- map["product_price"]
                is_add_to_cart  <- map["is_add_to_cart"]
                is_wishlist     <- map["is_wishlist"]
                rating          <- map["rating"]
                category        <- map["category"]
                item_id         <- map["item_id"]
                qty             <- map["qty"]
                qtyTest         <- map["qty"]
                quote_id        <- map["quote_id"]
                stock           <- map["stock"]
                
            }
        }
    }
    
    
    class Deals : BaseResponse{
        var productData:[DealsData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Deals?{
            var registration:Deals?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Deals>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Deals>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            productData        <- map["data"]
        }
        
        // Data in product Data response
        class DealsData: Mappable{
            
            var product_id:String?
            var product_name:String?
            var image:String?
            var product_price:String?
            var is_add_to_cart:String?
            var is_wishlist:String?
            var rating:String?
            var new_price:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->DealsData?{
                var featuredProductData:DealsData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<DealsData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<DealsData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                
                product_id         <- map["product_id"]
                product_name       <- map["product_name"]
                image              <- map["image"]
                product_price      <- map["product_price"]
                is_add_to_cart     <- map["is_add_to_cart"]
                is_wishlist        <- map["is_wishlist"]
                rating             <- map["rating"]
                new_price          <- map["new_price"]
            }
        }
    }
    
    class ProductDetail : BaseResponse{
        var productDetailData:ProductDetailData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ProductDetail?{
            var registration:ProductDetail?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<ProductDetail>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<ProductDetail>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            productDetailData        <- map["data"]
        }
        
        // Data in product Data response
        class ProductDetailData: Mappable{
            
            var product_id:String?
            var product_name:String?
            var image:String?
            var product_price:String?
            var description:String?
            var productMediaData:[ProductMediaData]?
            var is_add_to_cart:String?
            var is_wishlist:String?
            var rating:String?
            var stock:String?
            var qty:String?
            var pincode:String?
            var pincodeAddress:String?
            var related_products:[HomeScreenDetail.HomeScreenDetailData]?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ProductDetailData?{
                var featuredProductData:ProductDetailData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ProductDetailData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ProductDetailData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                
                product_id          <- map["product_id"]
                product_name        <- map["product_name"]
                image               <- map["image"]
                product_price       <- map["product_price"]
                productMediaData    <- map["media"]
                description         <- map["description"]
                is_add_to_cart      <- map["is_add_to_cart"]
                is_wishlist         <- map["is_wishlist"]
                rating              <- map["rating"]
                stock               <- map["stock"]
                qty                 <- map["qty"]
                related_products    <- map["related_products"]
                pincode             <- map["pincode"]
                pincodeAddress      <- map["pincode_address"]
            }
        }
        
        class ProductMediaData: Mappable {
            var media_id:String?
            var base:String?
            var thumbnail:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ProductMediaData?{
                var featuredProductData:ProductMediaData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ProductMediaData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ProductMediaData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                
                media_id         <- map["media_id"]
                thumbnail        <- map["thumbnail"]
                base             <- map["base"]
            }
        }
    }
    
    class Categories : BaseResponse{
        var categoriesData:[CategoriesData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Categories?{
            var registration:Categories?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Categories>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        registration = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Categories>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            registration = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return registration ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            categoriesData        <- map["data"]
        }
        
        // Data in registration response
        class CategoriesData: Mappable{
            
            var cat_id:String?
            var name:String?
            var image:String?
            
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->CategoriesData?{
                var featuredProductData:CategoriesData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<CategoriesData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            featuredProductData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<CategoriesData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                featuredProductData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return featuredProductData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                cat_id  <- map["cat_id"]
                name    <- map["name"]
                image   <- map["image"]
            }
        }
    }
    
    class Profile : BaseResponse{
        var profileData:ProfileData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Profile?{
            var profile:Profile?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Profile>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        profile = testObject
                    }
                }
            } else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Profile>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            profile = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return profile ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            profileData        <- map["data"]
        }
        
        // Data in profileData response
        class ProfileData: Mappable{
            
            var user_id:String?
            var email:String?
            var name:String?
            var userImage:String?
            var phone:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ProfileData?{
                var profileData:ProfileData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ProfileData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            profileData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ProfileData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                profileData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return profileData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                user_id     <- map["user_id"]
                name        <- map["name"]
                email       <- map["email"]
                userImage   <- map["user_image"]
                phone       <- map["mobile_number"]
            }
        }
    }
    
    class UploadProfile : BaseResponse{
        var data:Profile.ProfileData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->UploadProfile?{
            var uploadProfile:UploadProfile?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<UploadProfile>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        uploadProfile = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<UploadProfile>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            uploadProfile = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return uploadProfile ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            data    <- map["data"]
        }
    }
    
    class Country : BaseResponse{
        var countryDataList:[CountryData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Country?{
            var country:Country?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Country>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        country = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Country>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            country = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return country ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            countryDataList        <- map["data"]
        }
        
        // Data in city response
        class CountryData: Mappable{
            
            var id:String?
            var name:String?
            var dispaly_status:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->CountryData?{
                var countryData:CountryData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<CountryData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            countryData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<CountryData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                countryData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return countryData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                id              <- map["id"]
                name            <- map["name"]
                dispaly_status  <- map["dispaly_status"]
            }
        }
    }
    
    class City : BaseResponse{
        var cityDataList:[CityData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->City?{
            var city:City?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<City>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        city = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<City>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            city = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return city ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            cityDataList        <- map["data"]
        }
        
        // Data in city response
        class CityData: Mappable{
            
            var city_id:String?
            var country_id:String?
            var city_name:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->CityData?{
                var cityData:CityData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<CityData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            cityData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<CityData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                cityData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return cityData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                city_id     <- map["city_id"]
                country_id  <- map["country_id"]
                city_name   <- map["city_name"]
            }
        }
    }
    
    class HomeScreenDetail : BaseResponse{
        //var homeScreenDataList: [[String : [Any]]]?
        var homeScreenDataList: [String : [Any]]?
        var homeScreenForScreen:[HomeScreenModel]?
        var homeData: [String : Any]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->HomeScreenDetail?{
            
            var homeScreenDetail: HomeScreenDetail = HomeScreenDetail()
            
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    
                    homeScreenDetail.homeData = tempDic as! [String : Any]
                    
//                    let mapper = Mapper<HomeScreenDetail>()
//                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
//                        homeScreenDetail = testObject
//                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<HomeScreenDetail>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            homeScreenDetail = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return homeScreenDetail
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            homeScreenDataList        <- map["data"]
        }
        
        // Data in city response
        class HomeScreenDetailData: Mappable{
            
            var product_id:String?
            var product_name:String?
            var image:String?
            var product_price:String?
            var new_price:String?
            var date_from:String?
            var date_to:String?
            var is_wishlist:String?
            var rating:String?
            var is_add_to_cart:String?
            var stock:String?
            var is_product:String?
            var type:String?
            
            init() {
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->HomeScreenDetailData?{
                var homeScreenDetailData:HomeScreenDetailData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<HomeScreenDetailData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            homeScreenDetailData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<HomeScreenDetailData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                homeScreenDetailData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return homeScreenDetailData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                product_id      <- map["product_id"]
                product_name    <- map["product_name"]
                image           <- map["image"]
                product_price   <- map["product_price"]
                new_price       <- map["new_price"]
                date_from       <- map["date_from"]
                date_to         <- map["date_to"]
                is_wishlist     <- map["is_wishlist"]
                rating          <- map["rating"]
                is_add_to_cart  <- map["is_add_to_cart"]
                stock           <- map["stock"]
                is_product      <- map["is_product"]
                type            <- map["type"]
            }
        }
    }
    
    class ColorBrandList : BaseResponse{
        var colorBrandDataList:ColorBrandData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ColorBrandList?{
            var colorBrandList:ColorBrandList?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<ColorBrandList>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        colorBrandList = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<ColorBrandList>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            colorBrandList = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return colorBrandList ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            colorBrandDataList        <- map["data"]
        }
        
        // Data in registration response
        class ColorBrandData: Mappable{
            
            var colorDataList:[ColorData]?
            var brandNameList:[BrandData]?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ColorBrandData?{
                var colorBrandData:ColorBrandData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ColorBrandData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            colorBrandData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ColorBrandData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                colorBrandData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return colorBrandData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                colorDataList   <- map["color"]
                brandNameList   <- map["brands"]
            }
        }
        
        // Data
        class ColorData: Mappable{
            
            var id:String?
            var name:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ColorData?{
                var colorData:ColorData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ColorData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            colorData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ColorData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                colorData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return colorData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                id         <- map["id"]
                name       <- map["name"]
            }
        }
        
        // Data
        class BrandData: Mappable{
            
            var name:String?
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->BrandData?{
                var brandData:BrandData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<BrandData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            brandData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<BrandData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                brandData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return brandData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                name       <- map["name"]
            }
        }
    }
    
    class ShippingAddressList : BaseResponse{
        var shippingAddressDataList:[ShippingAddress.ShippingAddressData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ShippingAddressList?{
            var shippingAddressList:ShippingAddressList?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<ShippingAddressList>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        shippingAddressList = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<ShippingAddressList>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            shippingAddressList = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return shippingAddressList ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            shippingAddressDataList        <- map["data"]
        }
        
        
    }
    
    class ShippingAddress : BaseResponse{
        var shippingAddressData:ShippingAddressData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ShippingAddress?{
            var shippingAddress:ShippingAddress?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<ShippingAddress>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        shippingAddress = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<ShippingAddress>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            shippingAddress = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return shippingAddress ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            shippingAddressData   <- map["data"]
        }
        
        // Data in city response
        class ShippingAddressData: Mappable{
            var address_id:String?
            var name:String?
            var mobile:String?
            var postcode:String?
            var city:String?
            var street:String?
            var state:String?
            var country:String?
            var landmark:String?
            var flat_no:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ShippingAddressData?{
                var shippingAddressData:ShippingAddressData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ShippingAddressData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            shippingAddressData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ShippingAddressData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                shippingAddressData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return shippingAddressData ?? nil
            }
            
            func addressToString() -> String{
                return "\(street ?? ""),\(city ?? ""),\(state ?? ""),\(postcode ?? "")\n\(mobile ?? "")"
            }
            
            func fullAddressToString() -> String {
                return "\(name ?? "")\n\(street ?? ""),\(city ?? ""),\(state ?? ""),\(country ?? ""),\(postcode ?? "")\n\(mobile ?? "")"
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                
                address_id  <- map["address_id"]
                name        <- map["name"]
                mobile      <- map["mobile"]
                postcode    <- map["postcode"]
                city        <- map["city"]
                street      <- map["street"]
                state       <- map["state"]
                landmark    <- map["landmark"]
                flat_no     <- map["flat_no"]
                country     <- map["country"]
            }
        }
    }
    
    class AddToCart : BaseResponse{
        var addToCartData:AddToCartData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->AddToCart?{
            var addToCart:AddToCart?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<AddToCart>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        addToCart = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<AddToCart>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            addToCart = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return addToCart ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            addToCartData   <- map["data"]
        }
        
        // Data in city response
        class AddToCartData: Mappable{
            var quote_id:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->AddToCartData?{
                var addToCartData:AddToCartData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<AddToCartData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            addToCartData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<AddToCartData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                addToCartData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return addToCartData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                quote_id  <- map["quote_id"]
            }
        }
    }
    
    class GetOrderHistory : BaseResponse{
        var getOrderHistoryData:[GetOrderHistoryData]?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->GetOrderHistory?{
            var getOrderHistory:GetOrderHistory?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<GetOrderHistory>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        getOrderHistory = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<GetOrderHistory>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            getOrderHistory = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return getOrderHistory ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            getOrderHistoryData   <- map["data"]
        }
        
        // Data in city response
        class GetOrderHistoryData: Mappable{
            var order_id:String?
            var status:String?
            var customer_id:String?
            var tax_amount:String?
            var subtotal:String?
            var discount_amount:String?
            var grand_total:String?
            var total_qty_ordered:String?
            var payment_method:String?
            var product_id:String?
            var product_name:String?
            var image:String?
            var status_text:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->GetOrderHistoryData?{
                var getOrderHistoryData:GetOrderHistoryData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<GetOrderHistoryData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            getOrderHistoryData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<GetOrderHistoryData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                getOrderHistoryData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return getOrderHistoryData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                order_id            <- map["order_id"]
                status              <- map["status"]
                customer_id         <- map["customer_id"]
                tax_amount          <- map["tax_amount"]
                subtotal            <- map["subtotal"]
                discount_amount     <- map["discount_amount"]
                grand_total         <- map["grand_total"]
                total_qty_ordered   <- map["total_qty_ordered"]
                payment_method      <- map["payment_method"]
                product_id          <- map["product_id"]
                product_name        <- map["product_name"]
                image               <- map["image"]
                status_text         <- map["status_text"]
            }
        }
        
        // Data in city response
        class ItemDetailData: Mappable{
            var product_id:String?
            var product_name:String?
            var image:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ItemDetailData?{
                var itemDetailData:ItemDetailData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ItemDetailData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            itemDetailData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ItemDetailData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                itemDetailData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return itemDetailData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                product_id      <- map["product_id"]
                product_name    <- map["product_name"]
                image           <- map["image"]
            }
        }
    }
    
    class ViewCartCount : BaseResponse{
        var viewCartCountData:ViewCartCountData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ViewCartCount?{
            var viewCartCount:ViewCartCount?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<ViewCartCount>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        viewCartCount = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<ViewCartCount>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            viewCartCount = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return viewCartCount ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            viewCartCountData   <- map["data"]
        }
        
        // Data in city response
        class ViewCartCountData: Mappable{
            var total_product:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->ViewCartCountData?{
                var viewCartCountData:ViewCartCountData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<ViewCartCountData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            viewCartCountData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<ViewCartCountData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                viewCartCountData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return viewCartCountData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                total_product  <- map["total_product"]
            }
        }
    }
    
    class Banner : BaseResponse{
        var bannerData:BannerData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->Banner?{
            var banner:Banner?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<Banner>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        banner = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<Banner>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            banner = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return banner ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            bannerData   <- map["data"]
        }
        
        // Data in city response
        class BannerData: Mappable{
            var imageList:[String]?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->BannerData?{
                var bannerData:BannerData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<BannerData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            bannerData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<BannerData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                bannerData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return bannerData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                imageList  <- map["image"]
            }
        }
    }
    
    class GetFilterListItems : BaseResponse{
        var getFilterListItemsData:GetFilterListItemsData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->GetFilterListItems?{
            var getFilterListItems:GetFilterListItems?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<GetFilterListItems>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        getFilterListItems = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<GetFilterListItems>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            getFilterListItems = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return getFilterListItems ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            getFilterListItemsData   <- map["data"]
        }
        
        // Data in city response
        class GetFilterListItemsData: Mappable{
            var color:[FilterData]?
            var brands:[FilterData]?
            var category:[FilterData]?
            var availabilty:[FilterData]?
            var priceData:PriceData?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->GetFilterListItemsData?{
                var getFilterListItemsData:GetFilterListItemsData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<GetFilterListItemsData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            getFilterListItemsData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<GetFilterListItemsData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                getFilterListItemsData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return getFilterListItemsData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                color       <- map["color"]
                brands      <- map["brands"]
                category    <- map["category"]
                availabilty <- map["availabilty"]
                priceData   <- map["price"]
            }
        }
        
        class FilterData: Mappable{
            var id:String?
            var name:String?
            var code:String?
            var image:String?
            var status:Bool = false
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->FilterData?{
                var filterData:FilterData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<FilterData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            filterData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<FilterData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                filterData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return filterData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                id      <- map["id"]
                name    <- map["name"]
                code    <- map["code"]
                image   <- map["image"]
            }
        }
        
        
        class PriceData: Mappable{
            var high:String?
            var low:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->PriceData?{
                var priceData:PriceData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<PriceData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            priceData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<PriceData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                priceData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return priceData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                high    <- map["high"]
                low     <- map["low"]
            }
        }
    }
    
//    CheckServiceAvailability
    class CheckServiceAvailability : BaseResponse{
        var checkServiceAvailabilityData:CheckServiceAvailabilityData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->CheckServiceAvailability?{
            var checkServiceAvailability:CheckServiceAvailability?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<CheckServiceAvailability>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        checkServiceAvailability = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<CheckServiceAvailability>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            checkServiceAvailability = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return checkServiceAvailability ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            checkServiceAvailabilityData   <- map["data"]
        }
        
        // Data in city response
        class CheckServiceAvailabilityData: Mappable{
            var pincode:String?
            var pincodeAddress:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->CheckServiceAvailabilityData?{
                var checkServiceAvailabilityData:CheckServiceAvailabilityData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<CheckServiceAvailabilityData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            checkServiceAvailabilityData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<CheckServiceAvailabilityData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                checkServiceAvailabilityData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return checkServiceAvailabilityData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                pincode            <- map["pincode"]
                pincodeAddress     <- map["pincode_address"]
            }
        }
    }
    
    class GetShippingPrice : BaseResponse{
        var getShippingPriceData:GetShippingPriceData?
        
        required init(){
            super.init()
        }
        
        // Convert Json response to class object
        override func getModelObjectFromServerResponse(jsonResponse: AnyObject)->GetShippingPrice?{
            var getShippingPrice:GetShippingPrice?
            if jsonResponse is NSDictionary{
                let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                if tempDic != nil{
                    let mapper = Mapper<GetShippingPrice>()
                    if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                        getShippingPrice = testObject
                    }
                }
            }else if jsonResponse is String{
                let tempJsonString = jsonResponse as? String
                let data = tempJsonString?.data(using: String.Encoding.utf8)!
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let mapper = Mapper<GetShippingPrice>()
                        if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                            getShippingPrice = testObject
                        }
                    }
                } catch let error as NSError {
                    AppConstant.klogString(error.localizedDescription)
                }
            }
            return getShippingPrice ?? nil
        }
        
        // MARK:- Mappable delegate method implementation
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map){
            // TODO: Update key-value pair when socket response fetch
            super.mapping(map: map)
            getShippingPriceData   <- map["data"]
        }
        
        // Data in city response
        class GetShippingPriceData: Mappable{
            var amount:String?
            
            init(){
                
            }
            
            // Convert Json response to class object
            func getModelObjectFromServerResponse(jsonResponse: AnyObject)->GetShippingPriceData?{
                var getShippingPriceData:GetShippingPriceData?
                if jsonResponse is NSDictionary{
                    let tempDic:NSDictionary? = (jsonResponse as! NSDictionary)
                    if tempDic != nil{
                        let mapper = Mapper<GetShippingPriceData>()
                        if let testObject = mapper.map(JSON: tempDic as! [String : Any]){
                            getShippingPriceData = testObject
                        }
                    }
                }else if jsonResponse is String{
                    let tempJsonString = jsonResponse as? String
                    let data = tempJsonString?.data(using: String.Encoding.utf8)!
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            let mapper = Mapper<GetShippingPriceData>()
                            if let testObject = mapper.map(JSON: jsonResult as! [String : Any]){
                                getShippingPriceData = testObject
                            }
                        }
                    } catch let error as NSError {
                        AppConstant.klogString(error.localizedDescription)
                    }
                }
                return getShippingPriceData ?? nil
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                amount            <- map["amount"]
            }
        }
    }
}
