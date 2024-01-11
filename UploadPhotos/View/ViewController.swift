//
//  ViewController.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import UIKit

class ViewController: UIViewController {
    var isImagePickerPresented = false
    private let viewModel = GetViewModel()
    private let imagePicker = UIImagePickerController()
    private var selectID:Int?
    
    lazy var tableViewItems:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    lazy var imageBack: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "background")
        return image
    }()
    private var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configLayout()
        viewModel.resetPageNum()
        loadData()
    }
    //MARK: - UI SETUP LAYOUT
    func configUI(){
        view.backgroundColor = .white
        tableViewItems.delegate = self
        tableViewItems.dataSource = self
        tableViewItems.register(TableViewCellPost.self, forCellReuseIdentifier: "table")
        tableViewItems.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        view.addSubview(imageBack)
        view.addSubview(tableViewItems)
    }
    func configLayout(){
        NSLayoutConstraint.activate(
            [
                tableViewItems.topAnchor.constraint(equalTo: view.topAnchor,constant: 70),
                tableViewItems.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:0),
                tableViewItems.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
                tableViewItems.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
                
                imageBack.topAnchor.constraint(equalTo: view.topAnchor),
                imageBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                imageBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        )
    }
    @objc func refreshTable(_ sender: Any) {
        viewModel.fetchData { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableViewItems.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    //MARK: - SHOW INDIDCATOR
    func showLoadingIndicator() {
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewItems.bounds.size.width, height: tableViewItems.bounds.size.height))
        loadingView.backgroundColor = .clear
        let loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loadingIndicator.startAnimating()
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.center = loadingView.center
        tableViewItems.backgroundView = loadingView
    }
    //MARK: HIDE INDICATOR
    func hideLoadingIndicator() {
        tableViewItems.backgroundView = nil
    }
    func picker(){
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func loadData() {
           viewModel.fetchData { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(_):
                       self?.tableViewItems.reloadData()
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                   }
               }
           }
       }
    private func highlightCell(_ cell: TableViewCellPost) {
        let originalBackgroundColor = cell.contentView.backgroundColor
        UIView.animate(withDuration: 0.4, animations: {
            cell.contentView.backgroundColor = .lightGray
        }) { _ in
            UIView.animate(withDuration: 0.4) {
                cell.contentView.backgroundColor = originalBackgroundColor
            }
        }
    }
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
//MARK: TABLE VIEW
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCellPost {
            highlightCell(cell)
        }
        selectID = viewModel.getCats(index: indexPath.section).id
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker()
        } else {
            showAlert(with: "Camera is not available.")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex && !viewModel.isLoading && viewModel.hasMoreData {
            loadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewItems.dequeueReusableCell(withIdentifier: "table") as! TableViewCellPost
        cell.config(with: viewModel.getCats(index: indexPath.section))
        if indexPath.section % 2 == 0 {
            cell.setupColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0))
        } else {
            cell.setupColor(color: UIColor(red: 0.94, green: 1, blue: 1, alpha: 0))
        }
        return cell
    }
}
//MARK: - PICKER
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
                viewModel.upload(imageData: imageData, id: selectID ?? 0)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
}
