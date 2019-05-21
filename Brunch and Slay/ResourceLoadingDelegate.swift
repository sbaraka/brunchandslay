//
//  ResourceLoadingDelegate.swift
//  Brunch and Slay
//
//  Created by Noah on 5/20/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation
import AVKit

class ResourceLoadingDelegate:NSObject, AVAssetResourceLoaderDelegate
{
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel authenticationChallenge: URLAuthenticationChallenge)
    {
        print("\nchallenge\n")
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        print("\nloading request\n")
    }
}
