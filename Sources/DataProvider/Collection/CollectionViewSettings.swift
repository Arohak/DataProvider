//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

public struct CollectionViewSettings {
    public var headerSizes: [CGSize]    = []
    public var footerSizes: [CGSize]    = []
    public var itemSize: CGSize         = .zero
    public var inset: UIEdgeInsets      = .zero
    public var itemSpacing: CGFloat     = 0
    public var lineSpacing: CGFloat     = 0
    
    public init(
        headerSizes: [CGSize] = [],
        footerSizes: [CGSize] = [],
        itemSize: CGSize = .zero,
        inset: UIEdgeInsets = .zero,
        itemSpacing: CGFloat = 0,
        lineSpacing: CGFloat = 0
    ) {
        self.headerSizes = headerSizes
        self.footerSizes = footerSizes
        self.itemSize = itemSize
        self.inset = inset
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
    }
}
