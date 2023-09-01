//
//  RideType.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/08.
//

enum RideType: Int, CaseIterable, Identifiable {
    case uberX
    case uberB
    case uberXL
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
            
        case .uberX:
            return "UberX"
        case .uberB:
            return "UberBlack"
        case .uberXL:
            return "UberXL"
        }
    }
    
    var imageName: String {
        switch self {
            
        case .uberX:
            return "uber-x"
        case .uberB:
            return "uber-black"
        case .uberXL:
            return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
            
        case .uberX:
            return 500
        case .uberB:
            return 2000
        case .uberXL:
            return 1000
        }
    }
    
    func computePrice(for distance: Double) -> Double {
        let mileDistance = distance/1600
        
        switch self {
            
        case .uberX:
            return mileDistance * 100 + baseFare
        case .uberB:
            return mileDistance * 250 + baseFare
        case .uberXL:
            return mileDistance * 150 + baseFare
        }
    }
}

