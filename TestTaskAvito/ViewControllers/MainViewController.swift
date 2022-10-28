//
//  ViewController.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import UIKit
import Network

class MainViewController: UIViewController {
    
    private let cellIdentifier = "personCell"
    private var employees = [Employee]()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemGray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkNetworkConnection()
        
        setupViews()
        setConstraints()
        
        getData()
    }
}

//MARK: - UITableViewDelegate && UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeDetailCell
        else { return UITableViewCell() }
        
        let employee = employees[indexPath.row]
        cell.setText(employee: employee)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Private Methods
extension MainViewController {
    
    private func setupViews() {
        title = "Avito"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeDetailCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func getData() {
        NetworkManager.shared.fetchingData { result in
            let sortListEmployees = result.company.employees.sorted { $0.name < $1.name }
            self.employees = sortListEmployees
            
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        NetworkManager.shared.removeCache()
    }
    
    private func checkNetworkConnection() {
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.backgroundColor = .systemGreen
                    self.title = "Connected"
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.navigationBar.backgroundColor = .systemGray6
                    self.title = "Avito"
                }
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.backgroundColor = .systemRed
                    self.title = "Not Connected"
                    self.networkAlert("Предупреждение!", "Нет подключения к сети!", "Проверю")
                }
            }
        }
        
        let queue = DispatchQueue(label: "networking")
        monitor.start(queue: queue)
    }
    
    private func networkAlert(_ title: String, _ message: String, _ buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.backgroundColor = .systemGray6
                self.title = "Avito"
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

