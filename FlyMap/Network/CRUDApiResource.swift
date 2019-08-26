//
//  CRUDApiResource.swift
//  FlyMap
//
//  Created by Ivan Babich on 25/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class CRUDApiResource<ResourceModel: Codable> {
    let collectionPath: String
    private let pendingPromise = Promise<ResourceModel>.pending()
    
    required init(collectionPath: String) {
        self.collectionPath = collectionPath
    }
    
    // GET on resource
    final func read(url: URL) -> Promise<ResourceModel> {
        Alamofire.request(url, method: .get).responseJSON {
            guard let data = $0.data else {
                self.pendingPromise.resolver.reject($0.result.error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let tweetRequest = try decoder.decode(ResourceModel.self, from: data)
                self.pendingPromise.resolver.fulfill(tweetRequest)
            } catch let error {
                self.pendingPromise.resolver.reject(error)
            }
        }
        return pendingPromise.promise
    }
}
