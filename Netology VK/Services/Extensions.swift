import Foundation
import UIKit

extension Int {
    
    //Преобразует в Int в String с указанием даты формата день-месяц "в" часы:минуты
    func toDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM 'в' HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return formatter.string(from: date)
    }
}

extension UIImageView {
    
    //Проверяет кэш на наличие сохраненного изображения и устанавливает в качестве проперти image. В случае отсутствия в кэше, скачивает и сохраняет
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
    
    //Чуть упрощает верстку.
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
            
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
    
    //Возвращет высоту текста.
    func height() -> CGFloat {
            let textSize = CGSize(width: CGFloat(323), height: .greatestFiniteMagnitude)
            
            let size = self.boundingRect(with: textSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : UIFont(name: "Inter-Regular", size: 14)!],
                                         context: nil)
            return size.height
        }
}

