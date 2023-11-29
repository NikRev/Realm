import RealmSwift
import Foundation

class CategoryObject: Object {
    @Persisted var name: String = ""
    let quotes = List<QuoteObject>()

    override static func primaryKey() -> String? {
        return "name"
    }
}
