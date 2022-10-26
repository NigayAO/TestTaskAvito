//
//  ViewController.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let cellIdentifier = "personCell"
    private var employees = [Employee]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        
        getData()
    }
    
    private func setupViews() {
        title = "Avito"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeDetailCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func getData() {
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(let company):
                self.employees = company.company.employees
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: -
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeDetailCell else { return UITableViewCell() }
        let employee = employees[indexPath.row]
        cell.setText(employee: employee)
//        var content = cell.defaultContentConfiguration()
//        content.text = employee.name
//        content.secondaryText = employee.phoneNumber
//        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
