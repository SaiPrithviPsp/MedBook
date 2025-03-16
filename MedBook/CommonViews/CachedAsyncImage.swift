import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var cachedImage: UIImage?
    @State private var isLoading = false
    
    init(url: URL?,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let cachedImage = cachedImage {
                content(Image(uiImage: cachedImage))
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        guard !isLoading, let url = url else { return }
        
        let urlString = url.absoluteString
        
        // Check if image is in cache
        if let cachedImage = ImageCache.shared.get(forKey: urlString) {
            self.cachedImage = cachedImage
            return
        }
        
        // If not in cache, load it
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            isLoading = false
            
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            // Cache the image
            ImageCache.shared.set(image: image, forKey: urlString)
            
            DispatchQueue.main.async {
                self.cachedImage = image
            }
        }.resume()
    }
} 