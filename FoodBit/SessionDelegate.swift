//
//  SessionDelegate.swift
//  FoodBit
//
//  Created by Ameya Singh on 3/26/17.
//  Copyright © 2017 Ameya Singh. All rights reserved.
//

//import Foundation
//
//typealias CompletionHandler = () -> Void
//
//class MySessionDelegate : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate, URLSessionStreamDelegate {
//    var completionHandlers: [String: CompletionHandler] = [:]
//}
//
//// Creating session configurations
//let defaultConfiguration = URLSessionConfiguration.default
//let ephemeralConfiguration = URLSessionConfiguration.ephemeral
//let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.foodbit.networking.background")
//
//// Configuring caching behavior for the default session
//let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
//let cacheURL = try! cachesDirectoryURL.appendingPathComponent("MyCache")
//var diskPath = cacheURL.path
//
//
//let cache = URLCache(memoryCapacity:16384, diskCapacity: 268435456, diskPath: diskPath)
//defaultConfiguration.urlCache = cache
//defaultConfiguration.requestCachePolicy = .useProtocolCachePolicy
//// Creating sessions
//let delegate = MySessionDelegate()
//let operationQueue = OperationQueue.main
//
//let defaultSession = URLSession(configuration: defaultConfiguration, delegate: delegate, delegateQueue: operationQueue)
//let ephemeralSession = URLSession(configuration: ephemeralConfiguration, delegate: delegate, delegateQueue: operationQueue)
//let backgroundSession = URLSession(configuration: backgroundConfiguration, delegate: delegate, delegateQueue: operationQueue)
//
//ephemeralConfiguration.allowsCellularAccess = false
//let ephemeralSessionWiFiOnly = URLSession(configuration: ephemeralConfiguration, delegate: delegate, delegateQueue: operationQueue)
