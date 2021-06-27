//  
//  Created by Ara Hakobyan on 28/04/2019.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

public typealias Completion<T> = (T) -> (Void)

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UITableViewCell {
    static let reuseId = String(describing: self)
}

extension UITableViewHeaderFooterView {
    static var reuseId: String = String(describing: self)
}

extension UICollectionReusableView {
    static var reuseId: String = String(describing: self)
}

// MARK: - UITableView
extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell else {
            fatalError("fatal error for cell at \(indexPath)")
        }
        return cell
    }

    func registerHeaderFooter<View: UITableViewHeaderFooterView>(_ viewClass: View.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: View.reuseId)
    }

    func dequeueReusableHeaderFooter<View: UITableViewHeaderFooterView>() -> View {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: View.reuseId) as? View else {
            fatalError("fatal error for HeaderFooter View)")
        }
        return view
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: Cell.reuseId)
    }
    
    func registerHeader<Header: UICollectionReusableView>(_ headerClass: Header.Type) {
        register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId)

    }
    
    func registerFooter<Footer: UICollectionReusableView>(_ footerClass: Footer.Type) {
        register(footerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footer.reuseId)

    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as? Cell else {
            fatalError("fatal error for cell at \(indexPath)")
        }
        return cell
    }
    
    func dequeueHeaderView<Header: UICollectionReusableView>(_ indexPath: IndexPath) -> Header {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId, for: indexPath) as? Header else {
            fatalError("fatal error for header at \(indexPath)")
        }
        return header
    }
    
    func dequeueFooterView<Footer: UICollectionReusableView>(_ indexPath: IndexPath) -> Footer {
        guard let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footer.reuseId, for: indexPath) as? Footer else {
            fatalError("fatal error for header at \(indexPath)")
        }
        return footer
    }
}
