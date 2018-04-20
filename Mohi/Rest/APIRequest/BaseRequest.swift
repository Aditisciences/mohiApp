//
//  BaseRequest.swift
//

import Foundation
import MobileCoreServices

enum CommonServerError:Int{
    case VERSIONUPDATE = 460
    case TOKEN_EXPIRE = 461
}

enum MethodType:Int{
    case POST
    case GET
    case POSTMULTIFORM
}

struct UploadImageData{
    var imageData:Data?
    var imageName:String?
    var imageKeyName:String?
}

class BaseRequest<T:APIResponseParam.BaseResponse>: Operation {
    
    var methodType:MethodType = .GET
    var postData:Data?
    var urlString:String?
    var header:[String:String]?
    
    var formDataParameter:[String:Any]?
    var uploadImageList:[UploadImageData]?
    internal let kDriverMarkDefaultTimerInterval = 10
    
    fileprivate var serverRequest:URLRequest?
    
    override func main() {
         
        switch methodType {
        case .POST:
            serverRequest = sendPostRequest()
            break
        case .GET:
            serverRequest = sendGetRequest()
            break
        case .POSTMULTIFORM:
            serverRequest = sendPostMultiFormRequest()
            break
        }
        
        if serverRequest != nil {
            let session = URLSession.shared
            
            //TODO: update session default timeout of API
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 100.0
            sessionConfig.timeoutIntervalForResource = 190.0
            //            session.configuration = sessionConfig
            
            session.dataTask(with: serverRequest!) {data, response, error in
                
                if error != nil {
                    print(error!.localizedDescription)
                    // Parse error
                    let responseError = error! as NSError
                    var errorModel:ErrorModel?
                    
                    if(self.IsCodeInNetworkError(responseError.code)){
                        errorModel = ErrorModel(errorCode: "\(responseError.code)", errorMsg: BaseApp.sharedInstance.getMessageForCode("no_internet_message", fileName: "Strings")!)
                    }else{
                        errorModel = ErrorModel(errorCode: "\(responseError.code)", errorMsg: responseError.localizedDescription)
                    }
                    
                    self.onError(errorModel!)
                    
                    return
                }
                
                do {
                    let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                     print("JSONRESPONSE===>>#@#@#@#%@",jsonResult ?? "")
                    //guard (jsonResult?.value(forKey: "status") as! NSString).intValue < 0 else {
                    if (jsonResult?.value(forKey: "status") as? NSNumber)?.intValue == 0
                    {
                        let errorView:APIResponseParam.Error? = APIResponseParam.Error().getModelObjectFromServerResponse(jsonResponse: jsonResult! as AnyObject)
                        if(errorView != nil && errorView?.message != nil){
                            if(errorView?.error != nil && errorView?.error?.intValue == CommonServerError.VERSIONUPDATE.rawValue){
                                ApplicationPreference.clearAllData()
                                BaseApp.sharedInstance.showVersionUpdateAvailableAlertController()
                            } else if(errorView?.error != nil && errorView?.error?.intValue == CommonServerError.TOKEN_EXPIRE.rawValue){
                                ApplicationPreference.clearAllData()
                                BaseApp.sharedInstance.showTokenExpireAlertController(errorView)
                            }else{
                                var errorModel:ErrorModel?
                                errorModel = ErrorModel(errorCode: "", errorMsg: (errorView?.message)!)
                                self.onError(errorModel!)
                            }
                        }else{
                            self.onSuccess(nil)
                            self.onSuccess(responseList: response.debugDescription)
                        }
                        return
                    }
                else {
                        AppConstant.kLogString(jsonResult ?? "")
                       
                        
                        let reqResponse = T().getModelObjectFromServerResponse(jsonResponse: jsonResult! as AnyObject)
                        
                        //&& reqResponse?.status?.intValue == APIConfigConstants.kResponseStatusOK
                        if(reqResponse != nil ){
                            self.onSuccess(reqResponse as? T)
                        }else{
                            let errorView:APIResponseParam.Error? = APIResponseParam.Error().getModelObjectFromServerResponse(jsonResponse: jsonResult! as AnyObject)
                            if(errorView != nil && errorView?.message != nil){
                                var errorModel:ErrorModel?
                                errorModel = ErrorModel(errorCode: "", errorMsg: (errorView?.message)!)
                                self.onError(errorModel!)
                            }else{
                                self.onSuccess(nil)
                                self.onSuccess(responseList: response.debugDescription)
                            }
                        }
                        return
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    
                    let errorStr = String(data: data!, encoding: String.Encoding.utf8)
                    let errorModel = ErrorModel(errorCode: "", errorMsg: errorStr!)
                    self.onError(errorModel)
                }
                }.resume()
        }
    }
    
    func onSuccess(_ response:T?){}
    
    func onSuccess(responseList:String){}
    
    func onError(_ response:ErrorModel) {}
}

// POST/GET request with URLRequest
extension BaseRequest{
    
    fileprivate func sendPostRequest() -> URLRequest? {
        
        var request = URLRequest(url: URL(string: urlString!)!)
        
        request.allHTTPHeaderFields = header
        
        request.httpMethod = "POST"
        
        request.httpBody = postData
        
        return request
    }
    
    fileprivate func sendGetRequest() -> URLRequest?{
        var request = URLRequest(url: URL(string: urlString!)!)
        
        request.allHTTPHeaderFields = header
        
        request.httpMethod = "GET"
        
        return request
    }
    
    fileprivate func sendPostMultiFormRequest() -> URLRequest?{
        
        do{
            let request = try createRequest(urlStr: urlString!)
            return request
        } catch {
            print(error.localizedDescription)
        }
        
        
        return nil
    }
}

// Upload multi-form data
extension BaseRequest{
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    func createRequest(urlStr:String) throws -> URLRequest {
        let boundary = generateBoundaryString()
        
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        for (key, value) in header! {
            request.setValue(value, forHTTPHeaderField:key)
        }
        
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try createBody(with: formDataParameter, imageUploadList: uploadImageList, boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBody(with parameters: [String: Any]?, imageUploadList: [UploadImageData]?, boundary: String) throws -> Data {
        let body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        if(imageUploadList != nil){
            let mimetype = "image/png"
            for uploadImageData in imageUploadList!{
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data;name=\"\(uploadImageData.imageKeyName!)\";\r\nfilename=\"\(uploadImageData.imageName!)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(uploadImageData.imageData!)
                body.appendString("\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


extension BaseRequest{
    //MARK:- check network releated error
    func IsCodeInNetworkError(_ code:Int)-> Bool{
        var isFound = false
        switch code {
        case Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorTimedOut.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorCancelled.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorBadServerResponse.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorUserAuthenticationRequired.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorUserCancelledAuthentication.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfurlErrorDataNotAllowed.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfErrorHTTPAuthenticationTypeUnsupported.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfErrorHTTPBadCredentials.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfErrorHTTPConnectionLost.rawValue):
            isFound = true
            break
        case Int(CFNetworkErrors.cfErrorHTTPBadURL.rawValue):
            isFound = true
            break
        case Int(EPERM):        //       1      / Operation not permitted
            isFound = true
            break
        case Int(ENOENT):       //       2      / No such file or directory
            isFound = true
            break
        case Int(ESRCH):        //       3      / No such process
            isFound = true
            break
        case Int(EINTR):        //       4      / Interrupted system call
            isFound = true
            break
        case Int(EIO):          //       5      / Input/output error
            isFound = true
            break
        case Int(ENXIO):        //       6      / Device not configured /
            isFound = true
            break
        case Int(E2BIG):        //       7      / Argument list too long /
            isFound = true
            break
        case Int(ENOEXEC):      //      8       / Exec format error /
            isFound = true
            break
        case Int(EBADF):        //      9       /Bad file descriptor
            isFound = true
            break
        case Int(ECHILD):       //      10      / No child processes /
            isFound = true
            break
        case Int(EDEADLK):      //      11      / Resource deadlock avoided // 11 was EAGAIN /
            isFound = true
            break
        case Int(ENOMEM):       //      12      / Cannot allocate memory /
            isFound = true
            break
        case Int(EACCES):       //      13      / Permission denied /
            isFound = true
            break
        case Int(EFAULT):       //      14      / Bad address #H
            isFound = true
            break
        default:
            isFound = false
            break
        }
        return isFound
    }
}
