//
//  Pokemon.swift
//  pokedex
//
//  Created by Paul Toillion on 4/30/17.
//  Copyright © 2017 Toillion. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
   
    
    
    var name: String {
        get{
            return  _name
        }
    }
    
    var pokedexId: Int {
        get{
            return _pokedexId
        }
    }
    
    
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
            return _nextEvolutionTxt
    }
    
    var attack: String{
        
        return _attack ?? ""
    }
    
    var weight: String{
        
        return _weight ?? ""
    }
    
    var height: String{
        return _height ?? ""
    }
    
    var defense: String{
        return _defense ?? ""
    }
    
    var type: String{
        return _type ?? ""
    }
    
    var description: String{
        return _description ?? ""
    }
    
    var nextEvolutionName: String{
        return _nextEvolutionName ?? ""
    }
    
    var nextEvolutionId: String{
        return _nextEvolutionId ?? ""
    }
    
    var nextEvolutionLvl: String{
        return _nextEvolutionLvl ?? ""
    }
    
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetails(completed: @escaping downloadComplete){
        
        // Get request from the pokemon URL
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            //Get all the JSON results and save in a dictionary
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                
                //Parse the data
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0{
                    
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in  1..<types.count{
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>], descArr.count > 0{
                    
                    if let url = descArr[0]["resource_uri"]{
                        
                        let descURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String{
                                    
                                    let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")

                                    self._description = newDesc
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0 {
                    if let nextevo = evolutions[0]["to"] as? String{
                        
                        if nextevo.range(of: "mega") == nil{
                            self._nextEvolutionName = nextevo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"]{
                                    
                                    if let level = lvlExist as? Int {
                                        self._nextEvolutionLvl = "\(level)"
                                    }
                                    
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                            }
                        }
                    }
                    
                    
                }
                
//                print(self._weight)
//                print(self._defense)
//                print(self._attack)
//                print(self._height)
//                print (self._type)
//                print(self._nextEvolutionName)
//                print(self._nextEvolutionLvl)
//                print(self._nextEvolutionId)
            }
            completed()
        }
        
    }
    
}
