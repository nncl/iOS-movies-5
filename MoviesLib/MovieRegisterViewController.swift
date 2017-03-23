//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 17/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class MovieRegisterViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    var movie: Movie!
    
    // Somente quando carrega a primeira vez
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Sempre quando a view aparece
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movie != nil {
            tfTitle.text = movie.title
            tfRating.text = "\(movie.rating)"
            tfDuration.text = movie.duration
            tvSummary.text = movie.summary
            
            // Array com as categorias
            if let categories = movie.categories {
                // Forma reduzia da closue
                lbCategories.text = categories.map({($0 as! Category).name!}).joined(separator: ", ")
                
                /*
                categories.map({ (qqCoisa: Any) -> T in
                    return (qqCoisa as !Category).name
                })
                */
            }
            
            btAddUpdate.setTitle("Atualizar", for: .normal)
        }
    }
    
    // Quando formos para a tela de categorias devemos enviar o filme atual
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CategoriesViewController
        if movie == nil {
            movie = Movie(context: context)
        } else {
            vc.movie = movie
        }
    }

    @IBAction func close(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
        
        if movie != nil && movie.title == nil {
            context.delete(movie)
        }
    }
    
    @IBAction func addUpdateMovie(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        movie.title = tfTitle.text!
        movie.rating = Double(tfRating.text!)!
        movie.summary = tvSummary.text
        movie.duration = tfDuration.text
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        close(nil)
    }
    
    @IBAction func addPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar pôster", message: "De onde vc quer escolher seu pôster?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
            // TODO
        }
        
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action: UIAlertAction) in
            // TODO
        }
        
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
