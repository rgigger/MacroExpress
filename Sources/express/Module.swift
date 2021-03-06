//
//  Module.swift
//  Noze.io / Macro
//
//  Created by Helge Heß on 4/3/16.
//  Copyright © 2016-2020 ZeeZide GmbH. All rights reserved.
//

import MacroCore
@_exported import connect
@_exported import class http.IncomingMessage
@_exported import class http.ServerResponse

public enum ExpressModule {}

public extension ExpressModule {
  
  @inlinable
  static func express(invokingSourceFilePath: StaticString = #file,
                      middleware: Middleware...) -> Express
  {
    let app = Express(invokingSourceFilePath: invokingSourceFilePath)
    middleware.forEach { app.use($0) }
    return app
  }
}

@inlinable
public func express(invokingSourceFilePath: StaticString = #file,
                    middleware: Middleware...) -> Express
{
  let app = Express(invokingSourceFilePath: invokingSourceFilePath)
  middleware.forEach { app.use($0) }
  return app
}
