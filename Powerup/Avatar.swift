/** This struct is a data model for avatar features (customizables). */

struct Avatar {
    var id: Int
    
    // Required accessories.
    var face: Accessory
    var eyes: Accessory
    var hair: Accessory
    var clothes: Accessory
    
    // Optional accessories (Should be bought at the store).
    var necklace: Accessory?
    var glasses: Accessory?
    var handbag: Accessory?
    var hat: Accessory?

    init(avatarID: Int, face: Accessory, eyes: Accessory, hair: Accessory, clothes: Accessory, necklace: Accessory?, glasses: Accessory?, handbag: Accessory?, hat: Accessory?) {
        self.id = avatarID
        
        self.face = face
        self.eyes = eyes
        self.hair = hair
        self.clothes = clothes
        
        self.necklace = necklace
        self.glasses = glasses
        self.handbag = handbag
        self.hat = hat
    }
    
    init() {
        self.id = DatabaseAccessor.sharedInstance.avatarID
        
        self.face = Accessory(type: .face)
        self.eyes = Accessory(type: .eyes)
        self.hair = Accessory(type: .hair)
        self.clothes = Accessory(type: .clothes)
        
        self.necklace = nil
        self.glasses = nil
        self.handbag = nil
        self.hat = nil
    }
}
