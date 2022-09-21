//
//  MessageViewCell.swift
//  RabbitMQIOS
//
//  Created by Mac Mini 2021_1 on 21/09/2022.
//

import Foundation
import UIKit

class MessageViewCell : UITableViewCell {
    
    let name:UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.clipsToBounds = true
        name.layer.cornerRadius = 20
        name.backgroundColor = .systemGray5
        name.textAlignment = .center
        name.textColor = .black
        name.font = .systemFont(ofSize: 25)
        return name
    }()
    
    let message = UILabel()
    
    var id : String? {
        didSet {
            self.name.text = id
        }
    }
    
    var mess : String? {
        didSet {
            self.message.text = mess
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name.text = ""
        self.message.text = ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.message.translatesAutoresizingMaskIntoConstraints = false
        self.message.clipsToBounds = true
        self.message.textAlignment = .left
        self.message.textColor = .black
        self.message.font = .systemFont(ofSize: 15)

        let contraints1 = [
            self.message.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.message.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -60),
            self.message.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.message.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(contraints1)
        
        let contraints = [
            self.name.leadingAnchor.constraint(equalTo: self.message.trailingAnchor, constant: 10),
            self.name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.name.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.name.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(contraints)
        
#if TEST
        self.message.backgroundColor = .black
        self.name.backgroundColor = .black
#endif
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.name)
        self.contentView.addSubview(self.message)
    }
    
}
