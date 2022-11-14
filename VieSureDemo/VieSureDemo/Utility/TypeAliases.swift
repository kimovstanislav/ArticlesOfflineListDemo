//
//  TypeAliases.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

/**
 `VoidClosure` is a typealias for `() -> Void`, i.e. a closure with no arguments and no return value.
 */
public typealias VoidClosure = () -> Void

/**
 `Completion` provides a simpler syntax for closures with one or more arguments and no return value.

 Example:

     class Example {
       func postMessage(identifier: String, onCompletion: @escaping Completion<String>) { ... }
     }
 */
public typealias Completion<T> = (_ result: T) -> Void

/// Typealias for `Completion<Result<T, U>>`
/// periphery:ignore
public typealias CompletionResult<T, U: Error> = Completion<Result<T, U>>
