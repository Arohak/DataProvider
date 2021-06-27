//
//  Created by Ara Hakobyan on 7/13/20.
//  Copyright © 2020 Marktguru. All rights reserved.
//

import UIKit

public class GenericCollectionView
<
    Cell: BaseCollectionViewCell<Model>, Model,
    Header: BaseCollectionReusableView<HeaderModel>, HeaderModel,
    Footer: BaseCollectionReusableView<FooterModel>, FooterModel
>
: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public var didSelectHeader: Completion<HeaderModel>?
    public var didResetHeader: Completion<HeaderModel>?
    public var didSelectFooter: Completion<FooterModel>?
    public var didSelect: Completion<Model>?
    public var cellForItem: Completion<(index: Int, cell: Cell)>?
    public var insetForSectionAt: ((Int) -> (UIEdgeInsets))?
    public var willDisplay: Completion<Cell?>?
    public var didEndDisplaying: Completion<Cell?>?
    public var didScroll: Completion<UIScrollView>?
    public var didEndDragging: Completion<UIScrollView>?

    public var sections: [[Model]] = []
    public var headerModels: [HeaderModel] = []
    public var footerModels: [FooterModel] = []
    public var settings: GenericCollectionViewSettings!
    
    public init(scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        super.init(frame: .zero, collectionViewLayout: layout)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dataSource = self
        delegate = self

        registerCell(Cell.self)
        registerHeader(Header.self)
        registerFooter(Footer.self)
    }
    
    public func config(with settings: GenericCollectionViewSettings) {
        self.settings = settings
    }
    
    public func configData(
        settings: GenericCollectionViewSettings,
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
        updateHeader(with: headerModels)
        updateFooter(with: footerModels)
        reloadData()
    }

    public func updateHeader(with headerModels: [HeaderModel]) {
        self.headerModels = headerModels
    }

    public func updateFooter(with footerModels: [FooterModel]) {
        self.footerModels = footerModels
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = sections[section]
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath) as Cell
        let items = sections[indexPath.section]
        cell.model = items[indexPath.row]
        cell.index = indexPath.row
        cellForItem?((indexPath.row, cell))
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return settings.itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = sections[safe: indexPath.section],
              let model = items[safe: indexPath.row] else { return }
        didSelect?(model)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueHeaderView(indexPath) as Header
            view.model = headerModels[safe: indexPath.section]
            view.action = didSelectHeader
            return view
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueFooterView(indexPath) as Footer
            view.model = footerModels[safe: indexPath.section]
            view.action = didSelectFooter
            return view
        default:
            return UICollectionReusableView()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return settings.inset
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return settings.itemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return settings.lineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return settings.headerSizes[safe: section] ?? .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return settings.footerSizes[safe: section] ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay?(cell as? Cell)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplaying?(cell as? Cell)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?(scrollView)
    }
}

public class GenericCollectionViewWithoutHeaderFooter<Cell: BaseCollectionViewCell<Model>, Model>: GenericCollectionView<Cell, Model, BaseCollectionReusableView<Any>, Any, BaseCollectionReusableView<Any>, Any> { }

public class GenericCollectionViewWithoutFooter<Cell: BaseCollectionViewCell<Model>, Model, Header: BaseCollectionReusableView<HeaderModel>, HeaderModel>: GenericCollectionView<Cell, Model, Header, HeaderModel, BaseCollectionReusableView<Any>, Any> { }

public class GenericCollectionViewWithoutHeader<Cell: BaseCollectionViewCell<Model>, Model, Footer: BaseCollectionReusableView<FooterModel>, FooterModel>: GenericCollectionView<Cell, Model, BaseCollectionReusableView<Any>, Any, Footer, FooterModel> { }
