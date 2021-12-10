//
//  secondViewController.swift
//  DotaCheck
//
//  Created by Hui Hong Zheng on 11/7/21.

import UIKit
import CoreData


//information that are being fetched out from the API URL
struct dota_main:Decodable{
    let rank_tier : Int?
    let leaderboard_rank: Int?
    let solo_competitive_rank: Int?
    let profile: profile_list
    
    struct profile_list: Decodable{
        let account_id: Int
        let personaname: String?
        let avatarfull: String
        let name: String?
    }
}

// MARK: - delegate protocol
//A protocol that passes the data to main controller to change the display title
protocol PassTitleName{
    // a function that takes in string
    func ChangeTitleName(NewTitleName:String)
}

//A class for secondviewcontroller on the screen
class secondViewController: UIViewController{
    
    //outlet for tableview on second screen for protocel cells
    @IBOutlet var tableView: UITableView!
    
    
    //outlet allow user to change the main screen title
    @IBOutlet weak var titleText: UITextField!
    
    //pass from mainViewController onto the defaultname into the textfield
    var defaultName = ""
    //delelgate
    var delegate: PassTitleName? = nil
    
    //outlet type(label) display the Dota ID (account ID)
    @IBOutlet weak var account_ID: UILabel!
    
    var informationHolder = [Any]() //an array holds onto the items of the fetched API Call
    
    var inputUser: String? //a nonconstant variable from user input search bar
    
    var player_id = ""
    //passing the the setter_ID into player id and over the action button
    var setter_ID = ""{
        didSet{
            player_id = setter_ID
        }
    }
    //Initalize new game_player from setter_Name
    var game_player = ""
    var setter_Name = ""{
        didSet{
            game_player = setter_Name
        }
    }
    
    //Take image from assets and return the image
    var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: .zero)
        backgroundImage.image = UIImage(named: "waterClear")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Player Information"
        
        titleText.text = defaultName
        //display the label on the second screen display
        account_ID.text = inputUser
        
        //chapter 33
        let nib = UINib(nibName: "SubImageView", bundle: nil)
        //Register in the Sub Image cell with it's identifier to link to the class
        tableView.register(nib, forCellReuseIdentifier: SubImageView.identifier)
        APIResponse {
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        //Insert the view with index of 0
        view.insertSubview(backgroundImage, at:0)
        //Create the screen constraint to fill across all devices from the image
        NSLayoutConstraint.activate([backgroundImage.topAnchor.constraint(equalTo: view.topAnchor), backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        )
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //a delegate of sending information back into the main controller
    //passes on the input textfield to change the main title
    @IBAction func sendTitleName(_ sender: Any) {
        let titleName = String(titleText.text!)
        self.delegate?.ChangeTitleName(NewTitleName: titleName)
        navigationController?.popViewController(animated: true)
    }
    
    /*An action button uses core data to save the information for game_ID(Account ID/ Player ID) and player name
     It would be added into the favorite list tap bar
    */
    @IBAction func likeButton(_ sender: Any) {
        //uses from FavoriteTableController declaration manageObjectContext
        //Save the object with it's attributes into core data
        // MARK: - CoreData Save
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: manageObjectContext)
        let newFavorite = Favorite(entity: entity!, insertInto: manageObjectContext)
        newFavorite.game_ID = player_id
        newFavorite.game_name = game_player
        do{
            try manageObjectContext.save()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "favorite") as! FavoriteTableController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        catch{
            print("The context can't be saved error")
        }
    }
    /*
        An Api response from the user input for dota ID
     It will append the informations that the app will be used
     */
    func APIResponse(completed: @escaping () ->()) {
        // MARK: - URLSession take a parameter by User's input
        //Take one parameter from user manipulate data
        let URL_infor = DotaRequest(player_ID: inputUser!)

        //Fetch the api using one input parameter from user
        let task = URLSession.shared.dataTask(with: URL_infor.resourceURL) {(data, response , error) in
            if error == nil {
                do{
                    
                    let dataInfor = try JSONDecoder().decode(dota_main.self, from: data!)
                    self.setter_ID = String(dataInfor.profile.account_id)
                    /*
                     Insert all those information into an informationholder array
                     Default is nil because the item is empty
                     */
                    self.informationHolder.append(dataInfor.profile.avatarfull)
                    
                    if dataInfor.profile.personaname != nil {
                    let game_name = "game name: \(dataInfor.profile.personaname!)"
                        self.informationHolder.append(game_name)} else{ self.informationHolder.append("game name: nil")
                    }
                    if dataInfor.profile.name != nil {
                        self.setter_Name = dataInfor.profile.name!
                        let person_name = "person name:  \(dataInfor.profile.name!)"
                        self.informationHolder.append(person_name)
                    }
                    else
                    {   self.setter_Name = "nil"
                        self.informationHolder.append("person name: nil")
                        
                    }
                    if dataInfor.leaderboard_rank != nil {
                        let leader_rank = "leaderboard_rank:  \(dataInfor.leaderboard_rank!)"
                        self.informationHolder.append(leader_rank)} else{ self.informationHolder.append("leader_rank: nil")
                        }
                    if dataInfor.rank_tier != nil {
                        let rank_tier = "rank_tier:  \(dataInfor.rank_tier!)"
                        self.informationHolder.append(rank_tier)} else{ self.informationHolder.append("rank_iter: nil")
                        }
                    if dataInfor.solo_competitive_rank != nil {
                        let solo_competitive_rank = "solo_competitive_rank:  \(dataInfor.solo_competitive_rank!)"
                        self.informationHolder.append(solo_competitive_rank)} else{ self.informationHolder.append("solo_competitive_rank: nil")
                        }
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print("Error: The API can't be fetched")
                }
            }
        }
        task.resume()
    }
}

extension secondViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
}

extension secondViewController: UITableViewDataSource{
    
    //return the number of items in the informationHolder for numberofRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.informationHolder.count
    }
    
    //display the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row  == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubImageView.identifier, for: indexPath) as! SubImageView
            cell.configure(urlString: informationHolder[indexPath.row] as! String)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(informationHolder[indexPath.row])"
        return cell
    }
    // MARK: - UIVew Animation
    /*
     animation that bounce the cells from right side of the screen to it's position on the cell
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width,y:cell.contentView.frame.height)
        UIView.animate(withDuration: 1,delay: 0.7 * Double(indexPath.row),usingSpringWithDamping: 0.4,initialSpringVelocity: 0.2,options: .transitionFlipFromLeft, animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
        })
    }
}

