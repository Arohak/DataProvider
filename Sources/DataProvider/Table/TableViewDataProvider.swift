//
//  Created by Ara Hakobyan on 06.03.21.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

public class TableViewDataProvider
<
    Cell: TableViewCell<View>, View
>
: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    public var didSelect: Completion<View.Model>?
    private var settings: TableViewSettings!
    private weak var tableView: UITableView!
    private var models = [View.Model]()

    init(settings: TableViewSettings = .init(), tableView: UITableView) {
        super.init()
        self.settings = settings
        self.tableView = tableView
        config()
    }
    
    private func config() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(Cell.self)
    }
    
    public func update(with models: [View.Model]) {
        self.models = models
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath) as Cell
        let model = models[indexPath.row]
        cell.model = model
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        didSelect?(model)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settings.rowHeights[safe: indexPath.section] ?? UITableView.automaticDimension
    }
}
