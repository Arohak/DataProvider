//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

public class BaseCollectionViewCell<Model>: UICollectionViewCell {
    var index: Int!
    var model: Model!
    var action: Completion<Model>?
}

public class BaseCollectionReusableView<Model>: UICollectionReusableView {
    var model: Model!
    var action: Completion<Model>?
}
