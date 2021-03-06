//
//  CookieParser.swift
//  Noze.io / Macro
//
//  Created by Helge Heß on 6/16/16.
//  Copyright © 2016-2020 ZeeZide GmbH. All rights reserved.
//

import enum  MacroCore.process
import class http.IncomingMessage

/// After running the `cookieParser` middleware you can access the cookies
/// via `request.cookies` (a [String:String]).
///
/// Example:
///
///     app.use(cookieParser())
///     app.get("/cookies") { req, res, _ in
///       res.json(req.cookies)
///     }
///
public func cookieParser() -> Middleware {
  return { req, res, next in
    if req.extra[requestKey] == nil {
      let cookies = Cookies(req, res)
      req.extra[requestKey] = cookies.cookies // grab all
    }
    next()
  }
}

// MARK: - IncomingMessage extension

private let requestKey = "macro.connect.cookie-parser"

public extension IncomingMessage {
  
  /// Returns the cookies embedded in the request. Note: Make sure to invoke
  /// the `cookieParser` middleware first, so that this property is actually
  /// filled.
  var cookies : [ String : String ] {
    get {
      // This concept is a little weird as so many thinks in Node. Why not just
      // parse the cookies on-demand?
      guard let cookiesKeyValue = extra[requestKey] else {
        process.emitWarning(
          "attempt to access `cookies` of request, " +
          "but cookieParser middleware wasn't invoked")
        
        // be smart
        let cookies = Cookies(self)
        extra[requestKey] = cookies.cookies // grab all
        return cookies.cookies
      }
      
      guard let cookies = cookiesKeyValue as? [ String : String ] else {
        process.emitWarning("Unexpected value in request cookies key: " +
                            "\(requestKey): \(cookiesKeyValue)")
        return [:]
      }
      
      return cookies
    }
  }
}
