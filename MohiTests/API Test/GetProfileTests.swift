//
//  GetProfileTests.swift
//  MohiTests
//
//  Created by RajeshYadav on 03/12/17.
//  Copyright © 2017 Consagous. All rights reserved.
//

import XCTest
@testable import Mohi

class GetProfileTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetProfileApi(){
        
        //        Login : s@gmail.com
        //        UserID = 1428
        //        token = ea817b8cf7fc019c52a04b04f288a6c9
        
        let urlExpectation = expectation(description: "POST")
        
        let profileRequestParam = APIRequestParam.Profile(userId: ApplicationPreference.getUserId(), token: ApplicationPreference.getAppToken())
        let getProfile = ProfileRequest(profile: profileRequestParam, onSuccess: {
            response in
            
            print(response.toJSON())
            urlExpectation.fulfill()
            
        }, onError: {
            error in
            print(error.toString())
            XCTFail(error.errorMsg!)
            urlExpectation.fulfill()
        })
        
        BaseApp.sharedInstance.jobManager?.addOperation(getProfile)
        
        waitForExpectations(timeout: 1000, handler: nil)
    }
    
}
