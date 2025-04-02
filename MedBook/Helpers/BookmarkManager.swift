import CoreData

final class BookmarkManager: ObservableObject {
    static let shared = BookmarkManager()
    private let coreDataManager = CoreDataManager.shared
    
    private init() {}
    
    func isBookmarked(_ book: Book) -> Bool {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.key)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking bookmark status: \(error)")
            return false
        }
    }
    
    func fetchBookmarks() -> [BookmarkEntity] {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching bookmarks: \(error)")
            return []
        }
    }
    
    func toggleBookmark(for book: Book) {
        if isBookmarked(book) {
            removeBookmark(book)
        } else {
            bookmarkBook(book)
        }
        objectWillChange.send()
    }
    
    func updateBook(_ book: Book, description: String) {
        let context = coreDataManager.context
        
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.key)
        
        do {
            let books = try context.fetch(fetchRequest)
            books[0].setValue(description, forKey: "desc")
            coreDataManager.saveContext()
        } catch {
            print("Error removing bookmark: \(error)")
        }
    }
    
    func fetchBook(key: String) -> Book? {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", key)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results[0].toBook()
        } catch {
            print("Error removing bookmark: \(error)")
        }
        
        return nil
    }
    
    private func bookmarkBook(_ book: Book) {
        guard !isBookmarked(book) else { return }
        
        let context = coreDataManager.context
        let bookmarkEntity = BookmarkEntity(context: context)
        bookmarkEntity.id = book.key
        bookmarkEntity.title = book.title
        bookmarkEntity.author = book.authorName?.first
        bookmarkEntity.coverId = Int64(book.coverI ?? 0)
        bookmarkEntity.rating = book.ratingsAverage ?? 0
        bookmarkEntity.hits = Int64(book.ratingsCount ?? 0)
        bookmarkEntity.yearPublished = Int16(book.firstPublishYear ?? 0)
        bookmarkEntity.dateAdded = Date()
        
        coreDataManager.saveContext()
    }
    
    private func removeBookmark(_ book: Book) {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.key)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            coreDataManager.saveContext()
        } catch {
            print("Error removing bookmark: \(error)")
        }
    }
} 
