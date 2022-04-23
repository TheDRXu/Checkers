//
//  ViewExtension.swift
//  Draughts
//
//  Created by Dwayne Reinaldy on 4/20/22.
//

import Foundation
import SwiftUI

// Modifier for rows in List and Form
extension View {
	func rowStyle(fgColor: Color, rowColor: Color, font: Font, disabled: Bool = false) -> some View {
		self.modifier(Row(fgColor: fgColor, rowColor: rowColor, font: font, disabled: disabled))
	}
}
