import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct SharedUserDefault<T> {
    let suite: String
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults(suiteName: suite)?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults(suiteName: suite)?.set(newValue, forKey: key)
        }
    }
}

enum Defaults {}
