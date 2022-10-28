//
//  EmployeeDetailCell.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import UIKit

class EmployeeDetailCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name: "
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone: "
        label.font = UIFont.systemFont(ofSize: 24, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.text = "Skills: "
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 24, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private methods
extension EmployeeDetailCell {
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(skillsLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            phoneLabel.heightAnchor.constraint(equalToConstant: 25),
            
            skillsLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            skillsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            skillsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            skillsLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setText(employee: Employee) {
        nameLabel.text = "Name: \(employee.name)"
        phoneLabel.text = "Phone: \(employee.phoneNumber)"
        skillsLabel.text = "Skills: \(employee.skills.joined(separator: ", "))"
    }
}

