//
//  ItemCell.swift
//  DreamList
//
//  Created by Robert Block on 12/3/16.
//  Copyright © 2016 globile. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDetail: UILabel!

    func configureCell(item: Item) {
        itemTitle.text = item.title
        itemDetail.text = item.detail
        itemPrice.text = "$\(item.price)"
        itemImage.image = item.toImage?.image as? UIImage
    }

}
