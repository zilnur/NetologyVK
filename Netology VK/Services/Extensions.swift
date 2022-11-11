import Foundation
import UIKit

extension Int {
    
    func toDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM 'в' HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return formatter.string(from: date)
    }
}

extension UIImageView {
    
    func download(from: String) {
        guard let url = URL(string: from) else { return }
        
        if let cache = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cache.data)
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                let cache = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cache, for: URLRequest(url: url))
            }
        }
        session.resume()
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
            
            if let top = top {
                topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            }
            
            if let leading = leading {
                leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
            }
            
            if let bottom = bottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
            }
            
            if let trailing = trailing {
                trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
            }
            
            if size.width != 0 {
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            
            if size.height != 0 {
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
    }
}

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
            let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
            
            let size = self.boundingRect(with: textSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : font],
                                         context: nil)
            return size.height
        }
}

