//
//  CategoriesViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 17/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData

enum CategoryAlertType {
    case add
    case edit
}

class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: [Category] = []
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    func loadCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func add(_ sender: UIBarButtonItem) {
        showAlert(type: .add, category: nil)
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // Adicionamos ou editamos a categoria
    // Se adicionamos ainda nao temos uma categoria, por isso cateogira deve ser optional
    func showAlert(type: CategoryAlertType, category: Category?) {
        
        let title = (type == .add) ? "Adicionar" : "Editar"
        
        let alert = UIAlertController(title: "Adicionar Categoria", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome da categoria"
            if let name = category?.name {
                textField.text = name
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            
            let category = category ?? Category(context: self.context)
            category.name = alert.textFields?.first?.text
            
            do {
                try self.context.save()
                self.loadCategories()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


extension CategoriesViewController: UITableViewDelegate {
    
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let category = dataSource[indexPath.row]
        cell.textLabel?.text = category.name
        
        // Vamos mostrar as categorias que estão selecionadas
        
        if let categories = movie.categories {
            if categories.contains(category) {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    // Quando clicarmos em uma linha,
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = dataSource[indexPath.row]
        
        // Pegamos a célula clicada para alterá-la para informar que está selecionada, via accessory type
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            
            // Agora vamos vincular a categoria ao filme
            movie.addToCategories(category)
            
        } else {
            cell.accessoryType = .none
            
            // Desvincular a categoria ao filme
            movie.removeFromCategories(category)
        }
        
        // Remove o cinza default do bg quando selecionamos
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Vamos criar os botões no swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let category = self.dataSource[indexPath.row]
            
            self.context.delete(category)
            try! self.context.save()
            
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            let category = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true) // Voltando com swipe
            self.showAlert(type: .edit, category: category)
        }
        
        editAction.backgroundColor = .blue
        
        return [deleteAction, editAction]
    }
}





