//
//  AppDIContainer.swift
//  MoneyMind
//
//  Created by Павел on 26.05.2025.
//

import Swinject

final class AppDIContainer {
    let assembler: Assembler
    
    init(assemblies: [Assembly]) {
        self.assembler = Assembler(assemblies)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = assembler.resolver.resolve(type) else {
            fatalError("Failed to resolve \(type)")
        }
        return resolved
    }
    
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        guard let resolved = assembler.resolver.resolve(type, argument: argument) else {
            fatalError("Failed to resolve \(type) with argument \(argument)")
        }
        return resolved
    }
}

extension Resolver {
    func safeResolve<T>(_ type: T.Type) -> T {
        guard let resolved = resolve(type) else {
            fatalError("Failed to resolve \(String(describing: type))")
        }
        return resolved
    }
    
    func safeResolve<T, Arg>(_ type: T.Type, argument: Arg.Type) -> T {
        guard let resolved = resolve(type, argument: argument) else {
            fatalError("Failed to resolve \(String(describing: type)) with argument \(argument)")
        }
        return resolved
    }
}
