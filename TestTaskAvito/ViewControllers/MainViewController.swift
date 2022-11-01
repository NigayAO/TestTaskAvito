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
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeDetailCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.addSubview(activityIndicator)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullRefreshing), for: .valueChanged)
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
    
    @objc private func pullRefreshing(_ sender: UIRefreshControl) {
        getData()
        sender.endRefreshing()
    }
    
    private func getData() {
        NetworkManager.shared.fetchingData { result in
            switch result {
            case .success(let receivedData):
                self.setValueAfterDownload(receivedData)
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.networkAlert(error.localizedDescription)
                }
            }
        }
    }
    
    private func checkNetworkConnection() {
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.setNotificationForConnection(.systemGreen, "Connected")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.setNotificationForConnection(.systemGray6, "Avito")
                }
            } else {
                DispatchQueue.main.async {
                    self.setNotificationForConnection(.systemRed, "Not Connected")
                    self.networkAlert("Network connection was lost!")
                }
            }
        }
        
        let queue = DispatchQueue(label: "networking")
        monitor.start(queue: queue)
    }
    
    private func setNotificationForConnection(_ color: UIColor, _ withTitle: String) {
        navigationController?.navigationBar.backgroundColor = color
        title = withTitle
    }
    
    private func networkAlert(_ message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.setNotificationForConnection(.systemGray6, "Avito")
            self.activityIndicator.stopAnimating()
        }
        let tryAction = UIAlertAction(title: "Try again?", style: .default) { _ in
            self.getData()
        }
        alert.addAction(okAction)
        alert.addAction(tryAction)
        present(alert, animated: true)
    }
    
    private func setValueAfterDownload(_ data: Avito) {
        let sortListEmployees = data.company.employees.sorted { $0.name < $1.name }
        self.employees = sortListEmployees
        
        self.tableView.reloadData()
    }
}

