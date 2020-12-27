import UIKit

let imageCache = NSCache<NSString, AnyObject>()
var task: URLSessionTask!

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {
        
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.image = image
                }
            }
        }).resume()
    }
}
