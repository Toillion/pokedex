//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Paul Toillion on 5/1/17.
//  Copyright © 2017 Toillion. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var PokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()


        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = img
        currentEvoImg.image = img
        PokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails {
            //Whatever we write here will only be called when the network call is complete
            
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == ""{
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }
        else{
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            evoLbl.text = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLvl)"
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }

}
