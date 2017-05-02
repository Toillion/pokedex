//
//  ViewController.swift
//  pokedex
//
//  Created by Paul Toillion on 4/30/17.
//  Copyright © 2017 Toillion. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        parsePokemonCSV()
       // initAudio()
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    
    // MARK - parse the csv file to get pokemon information and add to the pokemon array

    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print (rows)
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokemon(name: name, pokedexId: pokeId)
                
                self.pokemon.append(pokemon)
            }
            
        } catch let err as NSError{
            print (err.debugDescription)
        }
        
    }
    
    // MARK - Collection view setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell
        {
            let poke: Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemon: poke)
            return cell
            
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }
        else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "pokemonDetailVC", sender: poke)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pokemonDetailVC"{
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    // MARK - Audio
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError{
            print (err.debugDescription)
        }
    }

    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2
        }
        else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    
    // MARK - searchbar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

