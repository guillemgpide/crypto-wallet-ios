//
//  CryptoRow.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 1/27/25.
//

import UIKit

class CryptoRow: UITableViewCell {
    
    @IBOutlet weak var cryptoIcon: UIImageView!
    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var cryptoValue: UILabel!
    @IBOutlet weak var cryptoLastMovemenet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cryptoIcon.contentMode = .scaleAspectFit
                
        // Añadir restricciones para limitar el tamaño máximo
        cryptoIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cryptoIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 50),  // Anchura máxima
            cryptoIcon.heightAnchor.constraint(lessThanOrEqualToConstant: 50)  // Altura máxima
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
