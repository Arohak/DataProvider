//
//  Created by Ara Hakobyan on 06.03.21.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

open class TableViewCell<Model>: UITableViewCell {
    var index: Int!
    var model: Model!
    var action: Completion<Model>?
}

