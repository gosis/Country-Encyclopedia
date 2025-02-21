//
//  KeyValueCacheActor.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 21/02/2025.
//

actor KeyValueCacheActor<T> {
    private var storage = [String: T]()
    
    var count: Int { storage.count }
    
    init(storage: [String : T] = [String: T]()) {
        self.storage = storage
    }
    
    func getValue(for key: String) -> T? {
        return storage[key]
    }

    func setValue(_ value: T, for key: String) {
        storage[key] = value
    }
}

extension KeyValueCacheActor where T == Set<String> {
    func appendToSet(_ value: String, for key: String) {
        var existingSet = storage[key] ?? Set<String>()
        existingSet.insert(value)
        storage[key] = existingSet
    }
}

