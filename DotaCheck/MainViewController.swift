/*
 Resource Links that have guided and tutorial me through the app development:
 https://medium.com/@apmason/uiview-animation-options-9510832eedba,
 https://www.youtube.com/watch?v=q_o1To9QRb0, https://medium.com/@astitv96/passing-data-between-view-controllers-using-delegate-and-protocol-ios-swift-4-beginners-e32828862d3f,
 https://www.youtube.com/watch?v=Pm_AOPvfur8, https://www.youtube.com/watch?v=WK5vrOD1zCQ
, https://www.hackingwithswift.com/example-code/uikit/how-to-swipe-to-delete-uitableviewcells , https://www.youtube.com/watch?v=35mKM4IkHS8 , https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift, https://www.appypie.com/pass-data-between-view-controllers-swift-how-to,
 https://www.hackingwithswift.com/example-code/system/how-to-pass-data-between-two-view-controllers,
 https://www.youtube.com/watch?v=t8sYKkST1gs , https://www.youtube.com/watch?v=FNkS_QIngg8&t=803s,https://www.youtube.com/watch?v=bYcfZdoCRe8&t=621s,https://www.avanderlee.com/swift/json-parsing-decoding/, https://www.youtube.com/watch?v=tdxKIPpPDAI,
 https://www.advancedswift.com/core-data-objects/

 
API : https://api.opendota.com/api/players/{account_id}
 account_id examples: 114645455, 196493835, 292921272, 299068038 and ....
ViewController.swift
DotaCheck
Created by Hui Hong Zheng on 10/31/21.
*/
import UIKit

class ViewController: UIViewController,UISearchBarDelegate,PassTitleName{
    //A label that changeable according to the user
    //Default label is "Enter Dota ID"
    @IBOutlet weak var mainTitle: UILabel!
    
    //Declare an outlet for searchbar enter the userinput
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - UserDefault
    // To persist the previous input ID so that user don't have to re-enter everytime he wants to search same player
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Main Screen"
        //Save the userdefault of the previous input else nothing
        let inputText = UserDefaults.standard.string(forKey: "inputID")
        if inputText != nil {
            searchBar.text = inputText
        }
        else{
            searchBar.text = ""
        }
        //Save the userdefault of the previous title for the main view controller
        let titleRename = UserDefaults.standard.string(forKey: "pageTitle")
        if titleRename != nil {
            self.mainTitle.text = titleRename
        }
        else{
            self.mainTitle.text = "Enter Dota ID"
        }
        
        searchBar.delegate = self
    }
    // Search bar allow user to enter it's input
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UserDefaults.standard.set(searchBar.text,forKey: "inputID")
        let secondviewcontroller = storyboard?.instantiateViewController(withIdentifier: "showDetails") as? secondViewController
        //sending it to second view controller
        secondviewcontroller?.defaultName = "Enter Title Name"
        secondviewcontroller?.delegate = self
        secondviewcontroller?.inputUser = searchBar.text
        navigationController?.pushViewController(secondviewcontroller!, animated: true)
    }
    //delegate function pass from second controller to main to pass changes to title of the main
    func ChangeTitleName(NewTitleName: String) {
        mainTitle.text = NewTitleName
        UserDefaults.standard.set(mainTitle.text,forKey: "pageTitle")
    }
}
