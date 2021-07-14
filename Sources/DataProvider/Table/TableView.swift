//
//  Created by Ara Hakobyan on 06.03.21.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

public class TableViewWithoutHeaderFooter
<
    Cell: TableViewCell<View>, View
>
: TableView<Cell, View, TableViewHeaderFooterView<Any>, Any, TableViewHeaderFooterView<Any>, Any> { }

public class TableViewWithoutFooter
<
    Cell: TableViewCell<View>, View,
    Header: TableViewHeaderFooterView<HeaderModel>, HeaderModel
>
: TableView<Cell, View, Header, HeaderModel, TableViewHeaderFooterView<Any>, Any> { }

public class TableViewWithoutHeader
<
    Cell: TableViewCell<View>, View,
    Footer: TableViewHeaderFooterView<FooterModel>, FooterModel
>
: TableView<Cell, View, TableViewHeaderFooterView<Any>, Any, Footer, FooterModel> { }

public class TableView
<
    Cell: TableViewCell<View>, View,
    Header: TableViewHeaderFooterView<HeaderModel>, HeaderModel,
    Footer: TableViewHeaderFooterView<FooterModel>, FooterModel
>
: UITableView, UITableViewDataSource, UITableViewDelegate {
    public typealias Model = Cell.Model
    
    public var didSelectHeader: Completion<HeaderModel>?
    public var didResetHeader: Completion<HeaderModel>?
    public var didSelectFooter: Completion<FooterModel>?
    public var didSelect: Completion<Model>?
    public var didDeselect: Completion<Model>?
    public var cellForItem: Completion<(index: Int, cell: Cell)>?
    public var willDisplay: Completion<Cell?>?
    public var didEndDisplaying: Completion<Cell?>?
    public var didEditing: Completion<(UITableViewCell.EditingStyle, IndexPath?)>?
    public var willBeginEditing: Completion<IndexPath?>?
    public var didEndEditing: Completion<IndexPath?>?
    public var didScroll: Completion<UIScrollView>?
    public var didEndDragging: Completion<UIScrollView>?
    public var sections: [[Model]] = []
    public var headerModels: [HeaderModel] = []
    public var footerModels: [FooterModel] = []
    public var settings: TableViewSettings
    
    public init(settings: TableViewSettings = .init(), style: UITableView.Style = .plain) {
        self.settings = settings
        super.init(frame: .zero, style: style)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dataSource = self
        delegate = self

        registerCell(Cell.self)
        registerHeaderFooter(Header.self)
        registerHeaderFooter(Footer.self)
    }
    
    public func config(with settings: TableViewSettings) {
        self.settings = settings
    }
    
    public func configData(
        settings: TableViewSettings,
        sections: [[Model]],
        headerModels: [HeaderModel] = [],
        footerModels: [FooterModel] = [],
        didSelectHeader: Completion<HeaderModel>? = nil,
        didSelectFooter: Completion<FooterModel>? = nil,
        didSelect: Completion<Model>? = nil,
        cellForItem: Completion<(index: Int, cell: Cell)>? = nil,
        willDisplay: Completion<Cell?>? = nil,
        didEndDisplaying: Completion<Cell?>? = nil,
        
        didScroll: Completion<UIScrollView>? = nil,
        didEndDragging: Completion<UIScrollView>? = nil
    ) {
        self.settings = settings
        self.didSelectHeader = didSelectHeader
        self.didSelectFooter = didSelectFooter
        self.didSelect = didSelect
        self.cellForItem = cellForItem
        self.willDisplay = willDisplay
        self.didEndDisplaying = didEndDisplaying
        self.didScroll = didScroll
        self.didEndDragging = didEndDragging
        
        updateData(with: sections, headerModels: headerModels, footerModels: footerModels)
        reloadData()
    }
    
    public func updateData(with sections: [[Model]],
                           headerModels: [HeaderModel] = [],
                           footerModels: [FooterModel] = []) {
        self.sections = sections
        self.headerModels = headerModels
        self.footerModels = footerModels
        reloadData()
    }
    
    public override func numberOfRows(inSection section: Int) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath) as Cell
        let items = sections[indexPath.section]
        cell.model = items[indexPath.row]
        cell.index = indexPath.row
        cellForItem?((indexPath.row, cell))
        return cell
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = settings.rowHeights[safe: indexPath.section]
        return height ?? UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = sections[safe: indexPath.section]?[safe: indexPath.row] else { return }
        didSelect?(model)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let model = sections[safe: indexPath.section]?[safe: indexPath.row] else { return }
        didDeselect?(model)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay?(cell as? Cell)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplaying?(cell as? Cell)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = headerModels[safe: section] else { return nil }
        let view = tableView.dequeueReusableHeaderFooter() as Header
        view.model = model
        view.action = didSelectHeader
        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let model = footerModels[safe: section] else { return nil }
        let view = tableView.dequeueReusableHeaderFooter() as Footer
        view.model = model
        view.action = didSelectFooter
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = settings.headerHeights[safe: section] ?? 0
        return height
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = settings.footerHeights[safe: section] ?? 0
        return height
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        didEditing?((editingStyle, indexPath))
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditing?(indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        didEndEditing?(indexPath)
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let canEditRow = settings.canEditRows[safe: indexPath.section] ?? false
        return canEditRow
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let canEditRow = settings.canEditRows[safe: indexPath.section] ?? false
        return canEditRow
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?(scrollView)
    }
}
