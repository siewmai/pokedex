//
//  Pokemon.swift
//  pokedex
//
//  Created by Siew Mai Chan on 12/11/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _width: String!
    private var _attack: String!
    private var _nextEvoText: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
    }
}
