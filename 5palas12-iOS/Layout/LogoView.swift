//
//  LogoView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation
import SwiftUI

struct LogoView:View    {
    var body: some View{
        ZStack{
            Rectangle().fill(Color("FernGreen"))
                .ignoresSafeArea()
            VStack {
                            Spacer()
                            Text("5 pa' las 12")
                                .font(.custom("FascinateInline-Regular", size: 24))
                                .foregroundColor(Color("Timberwolf"))
                                .padding(.bottom,20)
                        }
        }.frame( height:  60)
    }
}

#Preview {
    LogoView()
}
