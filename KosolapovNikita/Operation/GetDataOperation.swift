//
//  GetDataOperation.swift
//  KosolapovNikita
//
//  Created by Nikita on 01.08.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import Alamofire

class GetDataOperation: AsyncOperation {
    
    var data: Data?
    private var request: DataRequest
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
}
