//
//  ViewController.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let vm = GetViewModel()
    private let imagePicker = UIImagePickerController()
    private var selectID:Int?
    
    lazy var tableViewItems:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var imageBack: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "AmQIrU")
        return image
    }()
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        tableViewItems.delegate = self
        tableViewItems.dataSource = self
        view.addSubview(imageBack)
        view.addSubview(tableViewItems)
        tableViewItems.register(TableViewCellPost.self, forCellReuseIdentifier: "table")
        configLayout()
        configUI()
        fetchData()
        picker()
        
    }
    
    func configUI(){
        tableViewItems.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
    }
    
    func configLayout(){
        NSLayoutConstraint.activate([
            
            tableViewItems.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            tableViewItems.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30),
            tableViewItems.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            tableViewItems.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            
            imageBack.topAnchor.constraint(equalTo: view.topAnchor),
            imageBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func refreshTable(_ sender: Any) {
        vm.fetchData { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableViewItems.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    func picker(){
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func fetchData(){
        vm.fetchData { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableViewItems.contentInset = UIEdgeInsets(top: self.refreshControl.frame.height, left: 0, bottom: 0, right: 0)
                self.tableViewItems.reloadData()
                self.refreshControl.endRefreshing()
                self.tableViewItems.contentInset = .zero
            }
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCellPost {
            
            let originalBackgroundColor = cell.contentView.backgroundColor
            
            UIView.animate(withDuration: 0.2, animations: {
                cell.contentView.backgroundColor = .lightGray
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.contentView.backgroundColor = originalBackgroundColor
                }
            }
        }
        selectID = vm.getCats(index: indexPath.section).id
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Ошибка доступа в info.plist")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewItems.dequeueReusableCell(withIdentifier: "table") as! TableViewCellPost
        
        cell.config(with: vm.getCats(index: indexPath.section))
        
        if indexPath.section % 2 == 0 {
            cell.setupColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.2))
        } else {
            cell.setupColor(color: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 0.2))
        }
       

        return cell
    }
    
    
}

extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        1
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                
                vm.upload(imageData: imageData, id: selectID ?? 0)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
