import RealmSwift
import Foundation

class QuoteObject: Object{
    @Persisted var text = ""
    @Persisted var date:Date = Date()
    @Persisted var id = UUID().uuidString
    @Persisted var category: String = ""
    
    // Указываем первичный ключ для объекта
    override static func primaryKey() -> String? {
        return "id"
    }
}
 
