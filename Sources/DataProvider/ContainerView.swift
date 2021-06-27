//
//  ContainerView.swift
//  Weather_MVVM
//
//  Created by Ara Hakobyan on 28/04/2019.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

public protocol ContainerView: UIView {
    associatedtype Model
    func update(with model: Model)
}
