//
//  UrlHandler.swift
//  MovieAppTests
//
//  Created by Nurşah Ari on 23.02.2024.
//

import Foundation
import UIKit

protocol URLHandler {
    func openURL(_ url: URL)
}

class ApplicationURLHandler: URLHandler {
    func openURL(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
