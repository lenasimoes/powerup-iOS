import UIKit

class ShopViewController: UIViewController {

    // MARK: Properties
    // The indices of exhibition accessories.
    var exhibitionBagIndex = 0
    var exhibitionGlassesIndex = 0
    var exhibitionHatIndex = 0
    var exhibitionNecklaceIndex = 0
    var exhibitionHairIndex = 0
    var exhibitionClothesIndex = 0
    
    // The displayed avatar.
    var avatar = DatabaseAccessor.sharedInstance.getAvatar()
    
    // Array of accessories.
    var handbags = DatabaseAccessor.sharedInstance.getAccessoryArray(accessoryType: .handbag)
    var glasses = DatabaseAccessor.sharedInstance.getAccessoryArray(accessoryType: .glasses)
    var hats = DatabaseAccessor.sharedInstance.getAccessoryArray(accessoryType: .hat)
    var necklaces = DatabaseAccessor.sharedInstance.getAccessoryArray(accessoryType: .necklace)
    var hairs = DatabaseAccessor.sharedInstance.getAccessoryArray(accessoryType: .hair)
    var clothes = DatabaseAccessor.sharedInstance.getAccessoryArray(accessoryType: .clothes)
    
    // MARK: Views
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var handbagPaidLabel: UILabel!
    @IBOutlet weak var glassesPaidLabel: UILabel!
    @IBOutlet weak var hatPaidLabel: UILabel!
    @IBOutlet weak var necklacePaidLabel: UILabel!
    @IBOutlet weak var hairPaidLabel: UILabel!
    @IBOutlet weak var clothesPaidLabel: UILabel!
    
    @IBOutlet weak var exhibitionHandbag: UIImageView!
    @IBOutlet weak var exhibitionGlasses: UIImageView!
    @IBOutlet weak var exhibitionHat: UIImageView!
    @IBOutlet weak var exhibitionNecklace: UIImageView!
    @IBOutlet weak var exhibitionHair: UIImageView!
    @IBOutlet weak var exhibitionClothes: UIImageView!
    
    @IBOutlet weak var handbagPriceLabel: UILabel!
    @IBOutlet weak var hatPriceLabel: UILabel!
    @IBOutlet weak var glassesPriceLabel: UILabel!
    @IBOutlet weak var necklacePriceLabel: UILabel!
    @IBOutlet weak var hairPriceLabel: UILabel!
    @IBOutlet weak var clothesPriceLabel: UILabel!
    
    @IBOutlet weak var avatarEyesView: UIImageView!
    @IBOutlet weak var avatarHairView: UIImageView!
    @IBOutlet weak var avatarFaceView: UIImageView!
    @IBOutlet weak var avatarClothesView: UIImageView!
    @IBOutlet weak var avatarHandbagView: UIImageView!
    @IBOutlet weak var avatarGlassesView: UIImageView!
    @IBOutlet weak var avatarHatView: UIImageView!
    @IBOutlet weak var avatarNecklaceView: UIImageView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Karma points
        let score = DatabaseAccessor.sharedInstance.getScore()
        pointsLabel.text = String(score.karmaPoints)
        
        // Configure Image Views of Avatar Accessories.
        avatarClothesView.image = avatar.clothes.image
        avatarFaceView.image = avatar.face.image
        avatarEyesView.image = avatar.eyes.image
        avatarHairView.image = avatar.hair.image
        avatarHandbagView.image = avatar.handbag?.image
        avatarGlassesView.image = avatar.glasses?.image
        avatarNecklaceView.image = avatar.necklace?.image
        avatarHatView.image = avatar.hat?.image
        
        // Configure exhibition image and paid label.
        updateHandbagExhibition()
        updateHatExhibition()
        updateGlassesExhibition()
        updateNecklaceExhibition()
        updateHairExhibition()
        updateClothesExhibition()
    }
    
    func updateHandbagExhibition() {
        let handbag = handbags[exhibitionBagIndex]
        exhibitionHandbag.image = handbag.image
        handbagPaidLabel.isHidden = !handbag.purchased
        handbagPriceLabel.text = "\(handbag.points)$"
    }
    
    func updateGlassesExhibition() {
        let glass = glasses[exhibitionGlassesIndex]
        exhibitionGlasses.image = glass.image
        glassesPaidLabel.isHidden = !glass.purchased
        glassesPriceLabel.text = "\(glass.points)$"
    }
    
    func updateHatExhibition() {
        let hat = hats[exhibitionHatIndex]
        exhibitionHat.image = hat.image
        hatPaidLabel.isHidden = !hat.purchased
        hatPriceLabel.text = "\(hat.points)$"
    }
    
    func updateNecklaceExhibition() {
        let necklace = necklaces[exhibitionNecklaceIndex]
        exhibitionNecklace.image = necklace.image
        necklacePaidLabel.isHidden = !necklace.purchased
        necklacePriceLabel.text = "\(necklace.points)$"
    }
    
    func updateHairExhibition() {
        let hair = hairs[exhibitionHairIndex]
        exhibitionHair.image = hair.image
        hairPaidLabel.isHidden = !hair.purchased
        hairPriceLabel.text = "\(hair.points)$"
    }
    
    func updateClothesExhibition() {
        let cloth = clothes[exhibitionClothesIndex]
        exhibitionClothes.image = cloth.image
        clothesPaidLabel.isHidden = !cloth.purchased
        clothesPriceLabel.text = "\(cloth.points)$"
    }
    
    func reducePointsAndSaveBoughtToDatabase(accessory: Accessory) {
        let newScore = DatabaseAccessor.sharedInstance.getScore() - Score(karmaPoints: accessory.points)
        
        // Update points label.
        pointsLabel.text = String(newScore.karmaPoints)
        
        // Reduce points.
        guard DatabaseAccessor.sharedInstance.saveScore(score: newScore) else {
            print("Error reducing points.")
            return
        }
        
        // Set as purchased.
        guard DatabaseAccessor.sharedInstance.boughtAccessory(accessory: accessory) else {
            print("Error buying accessory.")
            return
        }
    }
    
    func haveEnoughPointsToBuy(accessoryPrice: Int) -> Bool {
        
        // Show alert dialog if players are trying to buy items they can't afford.
        if DatabaseAccessor.sharedInstance.getScore().karmaPoints < accessoryPrice {
            let alertDialog = UIAlertController(title: "Oops!", message: "You don't have enough points to buy that!", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Alright", style: .default))
            self.present(alertDialog, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }

    // MARK: Actions
    // Handbag
    @IBAction func handbagLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = handbags.count
        exhibitionBagIndex = (exhibitionBagIndex + totalCount - 1) % totalCount
        
        updateHandbagExhibition()
    }
    
    @IBAction func handbagRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = handbags.count
        exhibitionBagIndex = (exhibitionBagIndex + 1) % totalCount
        
        updateHandbagExhibition()
    }
    
    @IBAction func handbagBuyButtonTouched(_ sender: UIButton) {
        
        // Already bought.
        if handbags[exhibitionBagIndex].purchased {
            
            // Update avatar
            avatar.handbag = handbags[exhibitionBagIndex]
            avatarHandbagView.image = avatar.handbag!.image
            
        } else if haveEnoughPointsToBuy(accessoryPrice: handbags[exhibitionBagIndex].points) {
            
            // Set as paid
            handbags[exhibitionBagIndex].purchased = true
            handbagPaidLabel.isHidden = false
            
            // Record "purchased" in database.
            reducePointsAndSaveBoughtToDatabase(accessory: handbags[exhibitionBagIndex])
            
            // Update avatar
            avatar.handbag = handbags[exhibitionBagIndex]
            avatarHandbagView.image = avatar.handbag!.image
        }
    }
    
    // Glasses
    @IBAction func glassesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glasses.count
        exhibitionGlassesIndex = (exhibitionGlassesIndex + totalCount - 1) % totalCount
        
        updateGlassesExhibition()
    }
    
    @IBAction func glassesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glasses.count
        exhibitionGlassesIndex = (exhibitionGlassesIndex + 1) % totalCount
        
        updateGlassesExhibition()
    }
    
    @IBAction func glassesBuyButtonTouched(_ sender: UIButton) {
        
        // Already bought.
        if glasses[exhibitionGlassesIndex].purchased {
            
            // Update avatar
            avatar.glasses = glasses[exhibitionGlassesIndex]
            avatarGlassesView.image = avatar.glasses!.image
            
        } else if haveEnoughPointsToBuy(accessoryPrice: glasses[exhibitionGlassesIndex].points) {
            // Set as paid
            glasses[exhibitionGlassesIndex].purchased = true
            glassesPaidLabel.isHidden = false
            
            // Save "purchased" to database.
            reducePointsAndSaveBoughtToDatabase(accessory: glasses[exhibitionGlassesIndex])
            
            // Update avatar
            avatar.glasses = glasses[exhibitionGlassesIndex]
            avatarGlassesView.image = avatar.glasses!.image
        }
    }
    
    // Hat
    @IBAction func hatLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hats.count
        exhibitionHatIndex = (exhibitionHatIndex + totalCount - 1) % totalCount
        
        updateHatExhibition()
    }
    
    @IBAction func hatRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hats.count
        exhibitionHatIndex = (exhibitionHatIndex + 1) % totalCount
        
        updateHatExhibition()
    }
    
    @IBAction func hatBuyButtonTouched(_ sender: UIButton) {
        
        // Already bought.
        if hats[exhibitionHatIndex].purchased {
            
            // Update avatar
            avatar.hat = hats[exhibitionHatIndex]
            avatarHatView.image = avatar.hat!.image
            
        } else if haveEnoughPointsToBuy(accessoryPrice: hats[exhibitionHatIndex].points) {
            
            // Set as paid
            hats[exhibitionHatIndex].purchased = true
            hatPaidLabel.isHidden = false
            
            // Save "purchased" to database.
            reducePointsAndSaveBoughtToDatabase(accessory: hats[exhibitionHatIndex])
            
            // Update avatar
            avatar.hat = hats[exhibitionHatIndex]
            avatarHatView.image = avatar.hat!.image
        }
        
    }
    
    // Necklace
    @IBAction func necklaceLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaces.count
        exhibitionNecklaceIndex = (exhibitionNecklaceIndex + totalCount - 1) % totalCount
        
        updateNecklaceExhibition()
    }
    
    @IBAction func necklaceRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaces.count
        exhibitionNecklaceIndex = (exhibitionNecklaceIndex + 1) % totalCount
        
        updateNecklaceExhibition()
    }
    
    @IBAction func necklaceBuyButtonTouched(_ sender: UIButton) {
        
        // Already bought.
        if necklaces[exhibitionNecklaceIndex].purchased {
            
            // Update avatar
            avatar.necklace = necklaces[exhibitionNecklaceIndex]
            avatarNecklaceView.image = avatar.necklace!.image
            
        } else if haveEnoughPointsToBuy(accessoryPrice: necklaces[exhibitionNecklaceIndex].points) {
            
            // Set as paid
            necklaces[exhibitionNecklaceIndex].purchased = true
            necklacePaidLabel.isHidden = false
            
            // Save "purchased" to database.
            reducePointsAndSaveBoughtToDatabase(accessory: necklaces[exhibitionNecklaceIndex])
            
            // Update avatar
            avatar.necklace = necklaces[exhibitionNecklaceIndex]
            avatarNecklaceView.image = avatar.necklace!.image
        }
        
    }
    
    // Hair
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairs.count
        exhibitionHairIndex = (exhibitionHairIndex + totalCount - 1) % totalCount
        
        updateHairExhibition()
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairs.count
        exhibitionHairIndex = (exhibitionHairIndex + 1) % totalCount
        
        updateHairExhibition()
    }
    
    @IBAction func hairBuyButtonTouched(_ sender: UIButton) {
        
        // Already bought.
        if hairs[exhibitionHairIndex].purchased {
            
            // Update avatar
            avatar.hair = hairs[exhibitionHairIndex]
            avatarHairView.image = avatar.hair.image
            
        } else if haveEnoughPointsToBuy(accessoryPrice: hairs[exhibitionHairIndex].points) {
            
            // Set as paid
            hairs[exhibitionHairIndex].purchased = true
            hairPaidLabel.isHidden = false
            
            // Set "purchased" to database.
            reducePointsAndSaveBoughtToDatabase(accessory: hairs[exhibitionHairIndex])
            
            // Update avatar
            avatar.hair = hairs[exhibitionHairIndex]
            avatarHairView.image = avatar.hair.image
        }
        
    }
    
    // Clothes
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothes.count
        exhibitionClothesIndex = (exhibitionClothesIndex + totalCount - 1) % totalCount
        
        updateClothesExhibition()
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothes.count
        exhibitionClothesIndex = (exhibitionClothesIndex + 1) % totalCount
        
        updateClothesExhibition()
    }
    
    @IBAction func clothesBuyButtonTouched(_ sender: UIButton) {
        
        // Already bought.
        if clothes[exhibitionClothesIndex].purchased {
            
            // Update avatar
            avatar.clothes = clothes[exhibitionClothesIndex]
            avatarClothesView.image = avatar.clothes.image
            
        } else if haveEnoughPointsToBuy(accessoryPrice: clothes[exhibitionClothesIndex].points) {
            // Set as paid
            clothes[exhibitionClothesIndex].purchased = true
            clothesPaidLabel.isHidden = false
            
            // Set "purchased" to database.
            reducePointsAndSaveBoughtToDatabase(accessory: clothes[exhibitionClothesIndex])
            
            // Update avatar
            avatar.clothes = clothes[exhibitionClothesIndex]
            avatarClothesView.image = avatar.clothes.image
        }
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save configuration to database.
        guard DatabaseAccessor.sharedInstance.saveAvatar(avatar) else {
            let failedAlert = UIAlertController(title: "Oops!", message: "Error saving your purchase, please try again!", preferredStyle: .alert)
            failedAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(failedAlert, animated: true, completion: nil)
            
            return
        }
        
        //Dismiss this VC
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        // Quit without saving
        self.dismiss(animated: true, completion: nil)
    }
}
