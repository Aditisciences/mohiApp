//
//  APIRequestParam.swift
//

import Foundation
import ObjectMapper

class APIRequestParam {
    
    class Login: Mappable {
        
        private var phoneNumberOrEmail:String?
        private var password:String?
        //private var deviceToken:String?
        
        init(phoneNumber:String?, password:String?) {
            self.phoneNumberOrEmail = phoneNumber
            self.password = password
            //self.deviceToken = deviceToken
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            phoneNumberOrEmail  <- map["email"]
            password            <- map["password"]
            //deviceToken         <- map["device_token"]
        }
    }
    
    class Mobile: Mappable {
        
        private var phoneNumber:String?
        
        init(phoneNumber:String?) {
            self.phoneNumber = phoneNumber
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            phoneNumber     <- map["phone_number"]
        }
    }
    
    class RegistrationOLD: Mappable {
        private var name:String?
        private var mobile_number:String?
        private var email:String?
        private var password:String?
        
        private var deviceToken:String?
        
        init(name:String?, mobile_number:String?, email:String?, password:String?, deviceToken:String?) {
            self.name = name
            self.mobile_number = mobile_number
            self.email = email
            self.password = password
            
            //            self.deviceToken = deviceToken
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            name            <- map["name"]
            mobile_number   <- map["mobile_number"]
            email           <- map["email"]
            password        <- map["password"]
            //            deviceToken     <- map["device_token"]
        }
    }
    
    class Registration: Mappable {
        private var firstname:String?
        private var lastname:String?
        private var mob_number:String?
        private var email:String?
        private var password:String?
        private var cntry_code:String?

        //private var deviceToken:String?
        init(firstname:String?, lastname:String?, email:String?, password:String?, cntry_code:String?, mob_number:String?) {
            
            self.firstname = firstname
            self.lastname = lastname
            self.email = email
            self.password = password
            self.cntry_code = cntry_code
            self.mob_number = mob_number
        }
        
        
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            firstname       <- map["firstname"]
            lastname        <- map["lastname"]
            mob_number      <- map["mob_number"]
            email           <- map["email"]
            password        <- map["password"]
            cntry_code      <- map["cntry_code"]
            //            deviceToken     <- map["device_token"]
        }
    }
    
    class Logout: Mappable {
        private var user_id:String?
        
        init(user_id:String?) {
            self.user_id = user_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id  <- map["user_id"]
        }
    }
    
    class Profile: Mappable {
        private var userId:String?
        private var token:String?
        
        init(userId:String?, token:String?) {
            self.userId = userId
            self.token = token
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            userId <- map["user_id"]
            token <- map["token"]
        }
    }
    
    class UploadProfile: Mappable {
        var user_id:String?
        var token:String?
        var name:String?
        var phone:String?
        
        
        init(user_id:String?, token:String?, name:String?, phone:String?) {
            self.user_id = user_id
            self.token = token
            self.name = name
            self.phone = phone
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id         <- map["user_id"]
            token           <- map["token"]
            name            <- map["name"]
            phone           <- map["mobile_number"]
        }
    }
    
    class ResetPassword: Mappable {
        private var oldpassword:String?
        private var newpassword:String?
        
        init(oldpassword:String?, newpassword:String?) {
            self.oldpassword = oldpassword
            self.newpassword = newpassword
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            oldpassword <- map["old_password"]
            newpassword <- map["new_password"]
        }
    }
    
    class ForgotPassword: Mappable {
        private var emailOrphoneNumber:String?
        init(email:String?) {
            self.emailOrphoneNumber = email
        }
        required init?(map: Map) {

        }
        //Map Auth Request Parameters
        func mapping(map: Map) {
            emailOrphoneNumber  <- map["email"]
        }
    }
    
    class OtpVerify: Mappable {
        private var phoneNumber:String?
        private var otp:String?
        
        init(phoneNumber:String?, otp:String?) {
            self.phoneNumber = phoneNumber
            self.otp = otp
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            phoneNumber     <- map["phone_number"]
            otp             <- map["otp"]
        }
    }
    
    class FeaturedProduct: Mappable {
        
        private var limit:String?
        private var page:String?
        private var deviceToken:String?
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(limit:String?, page:String?,user_id:String?,token:String?,width:String?,height:String?) {
            self.limit = limit
            self.page = page
            self.user_id = user_id
            self.token =  token
            self.width =  width
            self.height =  height
            //  self.deviceToken = deviceToken
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            limit       <- map["limit"]
            page        <- map["page"]
            token       <- map["token"]
            user_id     <- map["user_id"]
            width       <- map["width"]
            height      <- map["height"]
            //  deviceToken     <- map["device_token"]
        }
    }
    
    
    class Product: Mappable {
        
        private var limit:String?
        private var page:String?
        private var cat_id:String?
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        private var type:String?
        private var search:String?
        private var sort:NSNumber?
        
        init(limit:String?, page:String?, cat_id:String?,token:String?,user_id:String?,width:String?,height:String?, type:String?, sort:NSNumber?, search:String? = "") {
            self.limit = limit
            self.page = page
            self.cat_id = cat_id
            self.user_id = user_id
            self.token = token
            self.width = width
            self.height = height
            self.type = type
            self.search = search
            self.sort = sort
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            limit   <- map["limit"]
            page    <- map["page"]
            cat_id  <- map["cat_id"]
            user_id <- map["user_id"]
            token   <- map["token"]
            width   <- map["width"]
            height  <- map["height"]
            type    <- map["type"]
            search  <- map["search"]
            sort    <- map["sort"]
        }
    }
    
    class ProductDetail: Mappable {
        
        private var product_id:String?
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(product_id:String?,user_id:String,token:String?,width:String?,height:String?) {
            self.product_id = product_id
            self.user_id = user_id
            self.token =  token
            self.width =  width
            self.height =  height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            product_id  <- map["product_id"]
            user_id     <- map["user_id"]
            token       <- map["token"]
            width       <- map["width"]
            height      <- map["height"]
        }
    }
    
    class Categories: Mappable {
        
        private var limit:String?
        private var page:String?
        private var deviceToken:String?
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(limit:String?, page:String?,user_id:String,token:String?,width:String?,height:String?) {
            self.limit = limit
            self.page = page
            self.user_id = user_id
            self.token = token
            self.width = width
            self.height = height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            limit       <- map["limit"]
            page        <- map["page"]
            user_id     <- map["user_id"]
            token       <- map["token"]
            width       <- map["width"]
            height      <- map["height"]
        }
    }
    
    class Review: Mappable {
        
        private var product_id:String?
        private var review:String?
        private var rating:String?
        private var name:String?
        private var user_id:String?
        private var token:String?
        
        init(product_id:String?, review:String?,user_id:String,token:String?,name:String?,rating:String?) {
            self.product_id = product_id
            self.review = review
            self.name = name
            self.rating = rating
            self.user_id = user_id
            self.token = token
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            product_id  <- map["product_id"]
            review      <- map["review"]
            rating      <- map["rating"]
            name        <- map["name"]
            user_id     <- map["user_id"]
            token       <- map["token"]
        }
    }
    
    class AddToWish: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var product_id:String?
        
        init(user_id:String?, token:String?,product_id:String?) {
            self.user_id = user_id
            self.token = token
            self.product_id = product_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            product_id  <- map["product_id"]
        }
    }
    
    class RemoveFromWish: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var product_id:String?
        
        init(user_id:String?, token:String?,product_id:String?) {
            self.user_id = user_id
            self.token = token
            self.product_id = product_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            product_id  <- map["product_id"]
        }
    }
    
    class Deals: Mappable {
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(user_id:String?, token:String?,width:String?, height:String?) {
            self.user_id = user_id
            self.token = token
            self.width = width
            self.height = height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            width   <- map["width"]
            height  <- map["height"]
        }
    }
    
    class WishList: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(user_id:String?, token:String?, width:String?, height:String?) {
            self.user_id = user_id
            self.token = token
            self.width = width
            self.height = height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            width       <- map["width"]
            height      <- map["height"]
        }
    }
    
    class AddToCart: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var product_id:String?
        private var qty:String?
        private var quote_id:String?
        private var buy_status:String?
        
        
        init(user_id:String?, token:String?,product_id:String?,qty:String?,quote_id:String?, buy_status:String?) {
            self.user_id = user_id
            self.token = token
            self.product_id = product_id
            self.qty = qty
            self.quote_id = quote_id
            self.buy_status = buy_status
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            product_id  <- map["product_id"]
            qty         <- map["qty"]
            quote_id    <- map["quote_id"]
            buy_status  <- map["buy_status"]
        }
    }
    
    class RemoveFromAddToCart: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var product_id:String?
        private var quote_id:String?
        
        init(user_id:String?, token:String?,product_id:String?,quote_id:String?) {
            self.user_id = user_id
            self.token = token
            self.product_id = product_id
            self.quote_id = quote_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            product_id  <- map["product_id"]
            quote_id    <- map["quote_id"]
        }
    }
    
    class AddToCartList: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(user_id:String?, token:String?,width:String?,height:String? ){
            self.user_id = user_id
            self.token = token
            self.width = width
            self.height = height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            width       <- map["width"]
            height      <- map["height"]
        }
    }
    
    class PlaceOrder: Mappable {
        
        var order_data:OrderData?
        init(order_data:OrderData){
            self.order_data = order_data
        }
        required init?(map: Map) {
            
        }
        //Map Auth Request Parameters
        func mapping(map: Map) {
            order_data           <- map["order_data"]
        }

        class OrderData: Mappable{
            var currency_id:String?
            var quote_id:String?
            var user_id:String?
            var token:String?
            var address_id:String?
            var payment_method:String?
            var items:[ItemsData]?
            
            init(currency_id:String,quote_id:String,user_id:String,token:String,address_id:String?,items:[ItemsData], payment_method:String?) {
                self.currency_id = currency_id
                self.quote_id = quote_id
                self.user_id = user_id
                self.token = token
                self.address_id = address_id
                self.items = items
                self.payment_method = payment_method
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                user_id         <- map["user_id"]
                token           <- map["token"]
                currency_id     <- map["currency_id"]
                quote_id        <- map["quote_id"]
                address_id      <- map["address_id"]
                items           <- map["items"]
                payment_method  <- map["payment_method"]
            }
        }
        
        
        class ShippingAddressData: Mappable{
            
            var firstname:String?
            var lastname:String?
            var street:String?
            var city:String?
            var country_id:String?
            var region:String?
            var postcode:String?
            var fax:String?
            var save_in_address_book:String?
            init(firstname:String,lastname:String,street:String,city:String,country_id:String,region:String,postcode:String,fax:String,save_in_address_book:String) {
                
                self.firstname = firstname
                self.lastname = lastname
                self.street = street
                self.city = city
                self.country_id = country_id
                self.region = region
                self.postcode = postcode
                self.fax = fax
                self.save_in_address_book = save_in_address_book
                
            }
            
            required init?(map: Map){
                
            }
            
            func mapping(map: Map){
                firstname               <- map["firstname"]
                lastname                <- map["lastname"]
                street                  <- map["street"]
                city                    <- map["city"]
                country_id              <- map["country_id"]
                region                  <- map["region"]
                postcode                <- map["postcode"]
                fax                     <- map["fax"]
                save_in_address_book    <- map["save_in_address_book"]
            }
        }
        
        class ItemsData: Mappable{
            var product_id:String?
            var qty:String?
            
            init(product_id:String,qty:String) {
                self.product_id = product_id
                self.qty = qty
            }
            required init?(map: Map){
                
            }
            func mapping(map: Map){
                product_id  <- map["product_id"]
                qty         <- map["qty"]
            }
        }
    }
    
    class HomeScreenDetail: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(user_id:String?,token:String?,width:String?,height:String?) {
            self.user_id = user_id
            self.token =  token
            self.width =  width
            self.height =  height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            token       <- map["token"]
            user_id     <- map["user_id"]
            width       <- map["width"]
            height      <- map["height"]
        }
    }
    
    class AddShippingAddress: Mappable {
        
        private var user_id:String?
        private var token:String?
        private var name:String?
        private var country:String?
        private var city:String?
        private var postcode:String?
        private var mobile:String?
        private var state:String?
        private var address_id:String?
        private var landmark:String?
        private var flat_no:String?
        private var street:String?
        
        
        init(user_id:String?,token:String?,name:String?, country:String?, city:String?, postcode:String?, mobile:String?, state:String?, street:String?, landmark:String?, flat_no:String?, address_id:String?) {
            self.user_id = user_id
            self.token =  token
            self.name = name
            self.country = country
            self.city = city
            self.postcode = postcode
            self.mobile = mobile
            self.state = state
            self.street = street
            self.address_id = address_id
            self.flat_no = flat_no
            self.landmark = landmark
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            
            user_id     <- map["user_id"]
            token       <- map["token"]
            name        <- map["name"]
            country     <- map["country"]
            city        <- map["city"]
            postcode    <- map["postcode"]
            mobile      <- map["mobile"]
            state       <- map["state"]
            street      <- map["street"]
            landmark    <- map["landmark"]
            flat_no     <- map["flat_no"]
            address_id  <- map["address_id"]
        }
    }
    
    class GetShippingAddress: Mappable {
        private var user_id:String?
        private var token:String?
        
        init(user_id:String?, token:String?) {
            self.user_id = user_id
            self.token = token
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id  <- map["user_id"]
            token   <- map["token"]
        }
    }
    
    class GetOrderHistory: Mappable {
        private var user_id:String?
        private var token:String?
        private var width:String?
        private var height:String?
        
        init(user_id:String?, token:String?, width:String?, height:String?) {
            self.user_id = user_id
            self.token = token
            self.width = width
            self.height = height
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id <- map["user_id"]
            token   <- map["token"]
            width   <- map["width"]
            height  <- map["height"]
        }
    }
    
    class DeleteShippingAddress: Mappable{
        private var user_id:String?
        private var token:String?
        private var address_id:String?
        
        init(user_id:String?, token:String?, address_id:String?) {
            self.user_id = user_id
            self.token = token
            self.address_id = address_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            address_id  <- map["address_id"]
        }
    }
    
    class ViewCartCount: Mappable{
        private var user_id:String?
        private var token:String?
        
        init(user_id:String?, token:String?) {
            self.user_id = user_id
            self.token = token
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
        }
    }
    
    class ChangePassword: Mappable{
        
        private var user_id:String?
        private var token:String?
        private var new_password:String?
        private var old_password:String?
        
        init(user_id:String?, token:String?, new_password:String?, old_password:String?) {
            self.user_id = user_id
            self.token = token
            self.new_password = new_password
            self.old_password = old_password
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id         <- map["user_id"]
            token           <- map["token"]
            new_password    <- map["new_password"]
            old_password    <- map["old_password"]
        }
    }
    
    class UpdateCartQty: Mappable{
        
        private var user_id:String?
        private var token:String?
        private var product_id:String?
        private var qty:String?
        private var quote_id:String?
        
        init(user_id:String?, token:String?, product_id:String?, qty:String?, quote_id:String?) {
            self.user_id = user_id
            self.token = token
            self.product_id = product_id
            self.qty = qty
            self.quote_id = quote_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id         <- map["user_id"]
            token           <- map["token"]
            product_id      <- map["product_id"]
            qty             <- map["qty"]
            quote_id        <- map["quote_id"]
        }
    }
    
    class Banner: Mappable{
        private var height:String?
        private var width:String?
        
        init(height:String?, width:String?) {
            self.height = height
            self.width = width
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            height         <- map["height"]
            width           <- map["width"]
        }
    }
    
    class FilterProduct: Mappable{
        private var user_id:String?
        private var token:String?
        private var cat_id:[String]?
        private var from_price:String?
        private var to_price:String?
        private var availabilty:String?
        private var brand:String? // comma separated list
        private var color:String? // comma separated list
        var limit:NSNumber? // access and update by object
        var page:NSNumber? // access and update by object
        var sort:NSNumber? // access and update by object
        var height:String?
        var width:String?
        
        init(user_id:String?, token:String?, cat_id:[String]?, height:String?, width:String?, from_price:String?, to_price:String?, availabilty:String?,brand:String?,color:String?) {
            self.user_id = user_id
            self.token = token
            self.cat_id = cat_id
            self.height = height
            self.width = width
            self.from_price = from_price
            self.to_price = to_price
            self.availabilty = availabilty
            self.brand = brand
            self.color = color
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id         <- map["user_id"]
            token           <- map["token"]
            height          <- map["height"]
            width           <- map["width"]
            cat_id          <- map["cat_id"]
            from_price      <- map["from_price"]
            to_price        <- map["to_price"]
            availabilty     <- map["availabilty"]
            brand           <- map["brand"]
            color           <- map["color"]
            limit           <- map["limit"]
            page            <- map["page"]
            sort            <- map["sort"]
        }
    }
    
    class CancelOrder: Mappable{
        
        private var user_id:String?
        private var token:String?
        private var order_id:String?
        
        init(user_id:String?, token:String?, order_id:String?) {
            self.user_id = user_id
            self.token = token
            self.order_id = order_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id         <- map["user_id"]
            token           <- map["token"]
            order_id        <- map["order_id"]
        }
    }
    
    class CheckServiceAvailability: Mappable{
        //{ "pincode":"452003", "user_id" : ""}
        private var pincode:String?
        private var user_id:String?
        
        init(pincode:String?, user_id:String?) {
            self.pincode = pincode
            self.user_id = user_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            pincode         <- map["pincode"]
            user_id         <- map["user_id"]
        }
    }
    
    //
    class GetShippingPrice: Mappable{
        
        private var user_id:String?
        private var token:String?
        private var address_id:String?
        private var quote_id:String?
        
        init(user_id:String?, token:String?, address_id:String?, quote_id:String?) {
            self.user_id = user_id
            self.token = token
            self.address_id = address_id
            self.quote_id = quote_id
        }
        
        required init?(map: Map) {
            
        }
        
        //Map Auth Request Parameters
        func mapping(map: Map) {
            user_id     <- map["user_id"]
            token       <- map["token"]
            address_id  <- map["address_id"]
            quote_id    <- map["quote_id"]
        }
    }
}
