//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

public struct TableViewSettings {
    public var rowHeights: [CGFloat]        = []
    public var headerHeights: [CGFloat]     = []
    public var footerHeights: [CGFloat]     = []
    public var canEditRows: [Bool]          = []
    public var shouldHighlightRows: [Bool]  = []
    
    public init(
        rowHeights: [CGFloat] = [],
        headerHeights: [CGFloat] = [],
        footerHeights: [CGFloat] = [],
        canEditRows: [Bool] = [],
        shouldHighlightRows: [Bool]  = []
    ) {
        self.rowHeights = rowHeights
        self.headerHeights = headerHeights
        self.footerHeights = footerHeights
        self.canEditRows = canEditRows
        self.shouldHighlightRows = shouldHighlightRows
    }
}
