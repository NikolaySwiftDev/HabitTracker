

import SwiftUI

struct HabitListCell: View {
    
    @State var title: String
    
    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Image(uiImage: .checkmark)
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                
                Text(title)
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                Spacer()
                Circle()
                    .fill(.clear)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .frame(width: 25, height: 25)
            }
            .padding(12)
            
            .background(.gray.opacity(0.2))
            .cornerRadius(20)
            
        }
    }
}
