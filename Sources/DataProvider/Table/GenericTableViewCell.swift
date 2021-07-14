//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

public class GenericTableViewCell<View: ContainerView>: TableViewCell<View.Model> {
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
    
    public override var model: View.Model! {
        didSet {
            view.update(with: model)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initialize() { /* Override point */ }
}
