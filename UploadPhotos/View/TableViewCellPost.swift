//
//  TableViewCellPost.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import UIKit

class TableViewCellPost: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        configLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    lazy var imageViewGet: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var labelID: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        
        return label
    }()
    
    func config(with model:Model){
        imageViewGet.load(urlString: model.image ?? "23")
        labelID.text = "ID : \(model.id)"
        labelName.text = "Name : \(model.name)"
    }
    
    func setupUI(){
        self.addSubview(imageViewGet)
        self.addSubview(labelID)
        self.addSubview(labelName)
        
    }
    
    func setupColor(color: UIColor) {
        self.backgroundColor = color
    }
        
    func configLayout(){
        NSLayoutConstraint.activate([
            
            imageViewGet.topAnchor.constraint(equalTo: self.topAnchor,constant: 35),
            imageViewGet.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16),
            imageViewGet.widthAnchor.constraint(equalToConstant: 150),
            imageViewGet.heightAnchor.constraint(equalToConstant: 100),
            
            labelID.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            labelID.leadingAnchor.constraint(equalTo: labelName.trailingAnchor,constant: 5),
            labelID.widthAnchor.constraint(equalToConstant: 80),
            labelID.heightAnchor.constraint(equalToConstant: 16),
            
            labelName.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            labelName.widthAnchor.constraint(equalToConstant: 160),
            labelName.heightAnchor.constraint(equalToConstant: 16),
            
        ])
    }
}
