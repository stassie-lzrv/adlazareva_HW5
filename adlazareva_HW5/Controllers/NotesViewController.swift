//
//  NotesViewController.swift
//  adlazareva_HW5
//
//  Created by Настя Лазарева on 07.12.2022.
//

import Foundation


import UIKit

final class NotesViewController: UIViewController{
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource = [ShortNote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "notes") as? Data {
                    dataSource = try! JSONDecoder().decode([ShortNote].self, from: data)
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func setupView(){
        setupTableView()
        setupNavBar()
    }
    
    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)
        tableView.register(AddNoteCell.self, forCellReuseIdentifier: AddNoteCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.pin(to: self.view)
    }

    
    private func setupNavBar(){
        self.title = "Notes"
        let closeButton = UIButton(type: .close)
       closeButton.addTarget(self, action: #selector(dismissViewController(_:)),
        for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:
        closeButton)
    }
    
    @objc
        private func dismissViewController(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
    
    private func handleDelete(indexPath: IndexPath){
        dataSource.remove(at: indexPath.row)
        tableView.reloadData()
        UserDefaults.standard.removeObject(forKey: "notes")
        let defaults = UserDefaults.standard
                if let encoded = try? JSONEncoder().encode(dataSource) {
                    defaults.set(encoded, forKey: "notes")
                }
    }
}


extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
    indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
    ) { [weak self] (action, view, completion) in
        self?.handleDelete(indexPath: indexPath)
        completion(true)
    }
    deleteAction.image = UIImage(
        systemName: "trash.fill",
        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
    )?.withTintColor(.white)
    deleteAction.backgroundColor = .red
    return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return dataSource.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
UITableViewCell {
        switch indexPath.section {
        case 0:
            if let addNewCell = tableView.dequeueReusableCell(withIdentifier:
AddNoteCell.reuseIdentifier, for: indexPath) as? AddNoteCell {
                addNewCell.delegate = self
                return addNewCell
            }
        default:
            let note = dataSource[indexPath.row]
            if let noteCell = tableView.dequeueReusableCell(withIdentifier:
NoteCell.reuseIdentifier, for: indexPath) as? NoteCell {
                noteCell.configure(note)
                return noteCell
            }
        }
        return UITableViewCell()
    }
}

extension NotesViewController: AddNoteDelegate{
    func newNoteAdded(note : ShortNote){
        dataSource.insert(note, at: 0)
        let defaults = UserDefaults.standard
                if let encoded = try? JSONEncoder().encode(dataSource) {
                    defaults.set(encoded, forKey: "notes")
                }
        tableView.reloadData()
    }
}
