//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

open class TableViewCell<View: ContainerView>: UITableViewCell {
    public typealias Model = View.Model
    
    var index: Int!
    var action: Completion<Model>?
    var model: Model! {
        didSet { view.update(with: model) }
    }
    
    public lazy var view: View = {
        let view = View()
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initialize() { /* Override point */ }
}
