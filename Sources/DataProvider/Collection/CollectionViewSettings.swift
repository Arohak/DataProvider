//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

public struct CollectionViewSettings {
    var headerSizes: [CGSize]   = []
    var footerSizes: [CGSize]   = []
    let itemSize: CGSize        = .zero
    var inset: UIEdgeInsets     = .zero
    var itemSpacing: CGFloat    = 0
    var lineSpacing: CGFloat    = 0
    
    public init() {}
}
