//
//  Pokemon.swift
//  pokedex
//
//  Created by Siew Mai Chan on 12/11/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _pokemonUrl: String!
    
    private var _height: String!
    private var _weight: String!
    private var _defense: String!
    private var _attack: String!
    private var _type: String!
    private var _description: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var defense: String {
        return _defense
    }
    
    var attack: String {
        return _attack
    }
    
    var type: String {
        return _type
    }
    
    var description: String {
        return _description
    }
    
    var nextEvoName: String {
        return _nextEvoName
    }
    
    var nextEvoId: String {
        return _nextEvoId
    }
    
    var nextEvoLevel: String {
        return _nextEvoLevel
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        _height = ""
        _weight = ""
        _defense = ""
        _attack = ""
        _type = ""
        _description = ""
        _nextEvoName = ""
        _nextEvoId = ""
        _nextEvoLevel = ""
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
                
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    for var i=1; i < types.count; i++ {
                        if let name = types[i]["name"] {
                            self._type! += "/\(name.capitalizedString)"
                        }
                    }
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>] where descriptions.count > 0 {
                    if let resource_uri = descriptions[0]["resource_uri"] {
                        
                        let url = NSURL(string: "\(URL_BASE)\(resource_uri)")!
                        
                        Alamofire.request(.GET, url).responseJSON { response in
                            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = dict["description"] as? String {
                                    self._description = description
                                }
                            }
                            
                            completed()
                        }
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Exclude any mega evolution, we are not handling it for now
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let str = uri.stringByReplacingOccurrencesOfString("\(URL_POKEMON)", withString: "")
                                self._nextEvoId = str.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvoName = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvoLevel = "\(level)"
                                }                            }
                        }
                    }
                    
                }                
            }
        }
    }
}
