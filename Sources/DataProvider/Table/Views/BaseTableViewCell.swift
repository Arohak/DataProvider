//
//  Created by Ara Hakobyan on 06.03.21.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

public class BaseTableViewCell<Model>: UITableViewCell {
    var index: Int!
    var model: Model!
    var action: Completion<Model>?
}

public class BaseTableViewHeaderFooterView<Model>: UITableViewHeaderFooterView {
    var index: Int!
    var model: Model!
    var action: Completion<Model>?
}
