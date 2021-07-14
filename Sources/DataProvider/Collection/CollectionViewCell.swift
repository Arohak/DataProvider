//
//  Created by Ara Hakobyan on 27.06.21.
//

import UIKit

open class CollectionViewCell<View: ContainerView>: UICollectionViewCell {
    public typealias Model = View.Model

    public var index: Int!
    public var action: Completion<Model>?
    public var model: Model! {
        didSet {
            view.update(with: model)
        }
    }
    
    public lazy var view: View = {
        let view = View()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initialize() { /* Override point */ }
}
