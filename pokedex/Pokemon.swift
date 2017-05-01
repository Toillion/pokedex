//
//  Pokemon.swift
//  pokedex
//
//  Created by Paul Toillion on 4/30/17.
//  Copyright © 2017 Toillion. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    
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
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        
    }
    
}
