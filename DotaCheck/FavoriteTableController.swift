//
//  FavoriteTableController.swift
//  DotaCheck
//
//  Created by Hui Hong Zheng on 12/1/21.
//

import UIKit
import CoreData

//Help to manage objects (delete and save)
var manageObjectContext: NSManagedObjectContext!

// MARK: - Dynamic UITableView
class FavoriteTableController: UITableViewController {
    var loadUpCoreData = true
    //declare object list
    var savedList = [Favorite]()
    
    override func viewDidLoad() {
        // MARK: - CoreData Fetch
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //load up the core data being restored
        if (loadUpCoreData){
            loadUpCoreData = false
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            do {
                savedList = [Favorite]() // Remake the list into an empty list
                let itemList:NSArray = try manageObjectContext.fetch(fetchRequest) as NSArray
                for item in itemList{
                    let favorite = item as! Favorite
                    savedList.append(favorite)
                }
            }
            catch{
                print("Fetch failed")
            }
        }
        super.viewDidLoad()
        //title of the tableviewcontroller
        title = "Favorite List"
    }
    
    // MARK: - Table view data source
    //setting for larger height of the cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedList.count
    }
    
    // display them into table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Favoritecell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCellList", for : indexPath) as! FavoriteViewCell
        let thisfavorite: Favorite!
        thisfavorite = savedList[indexPath.row]
        Favoritecell.player_ID.text = thisfavorite.game_ID
        Favoritecell.dota_Name.text = thisfavorite.game_name
        return Favoritecell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setting that to true again to reload the new data when favorite tap bar is clicked again
        loadUpCoreData = true
        viewDidLoad()
        tableView.reloadData()
    }
    // MARK: - CoreData Delete
    //helps to remove the core data and remove the table cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manageObjectContext.delete(savedList[indexPath.row])
            do {
                try manageObjectContext.save()
                tableView.reloadData()
            }
            catch{
                print("Couldn't saved the deleted ones")
            }
            // Delete the row from the data source
            savedList.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
