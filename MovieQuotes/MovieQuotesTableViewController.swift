//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by CSSE Department on 3/29/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import CoreData

class MovieQuotesTableViewController: UITableViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    let noMovieQuotesCellIdentifier = "NoMovieQuotesCell"
    let showDetailSegueIdentifier = "ShowDetailSegue"
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                            target: self,
                                                            action: #selector(showAddDialog))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateMovieQuoteArray()
        tableView.reloadData()
    }

    @objc func showAddDialog() {
        let alertController = UIAlertController(title: "Create a new movie quote",
                                                message: "",
                                                preferredStyle: .alert)
        alertController.addTextField{ (textField) in
            textField.placeholder = "Quote"
        }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Movie Title"
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.cancel,
                                         handler: nil)
        let createQuoteAction = UIAlertAction(title: "Create Quote",
                                         style: UIAlertActionStyle.default) {
                                            (action) in
                                            let quoteTextField = alertController.textFields![0]
                                            let movieTextField = alertController.textFields![1]
                                            print("quoteTextField = \(quoteTextField)")
                                            print("movieTextField = \(movieTextField)")
//                                            let movieQuote = MovieQuote(quote: quoteTextField.text!,
//                                                                        movie: movieTextField.text!)
//                                            self.movieQuotes.insert(movieQuote, at: 0)
                                            let newMovieQuote = MovieQuote(context: self.context)
                                            newMovieQuote.quote = quoteTextField.text!
                                            newMovieQuote.movie = movieTextField.text!
                                            newMovieQuote.created = Date()
                                            self.save()
                                            self.updateMovieQuoteArray()
                                            //self.tableView.reloadData()
                                            if (self.movieQuotes.count == 1) {
                                                self.tableView.reloadData()
                                            }
                                            else {
                                                self.tableView.insertRows(at: [IndexPath(row:0, section: 0)],
                                                                          with: UITableViewRowAnimation.top)
                                            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createQuoteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updateMovieQuoteArray() {
        // Make a fetch request
        // Execute the request in a try/catch block
        let request: NSFetchRequest<MovieQuote> = MovieQuote.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)];
        do {
            movieQuotes = try context.fetch(request)
        } catch {
            fatalError("Unresolved Core Data error \(error)")
        }
    }
    
    // MARK: - Table view data source
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if movieQuotes.count == 0 {
            super.setEditing(false, animated: animated)
        } else {
            super.setEditing(editing, animated: animated)
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(movieQuotes.count, 1)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if movieQuotes.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: noMovieQuotesCellIdentifier, for: indexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
            cell.textLabel?.text = movieQuotes[indexPath.row].quote
            cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
            
        }

        // Configure the cell...
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return movieQuotes.count != 0
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(movieQuotes[indexPath.row])
            save()
            updateMovieQuoteArray()
            // Delete the row from the data source
            // movieQuotes.remove(at: indexPath.row)
            if movieQuotes.count == 0 {
                tableView.reloadData()
                self.setEditing(false, animated: true)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == showDetailSegueIdentifier) {
            if let indexPath = tableView.indexPathForSelectedRow {
               (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
            }
        }
    }
 

}
