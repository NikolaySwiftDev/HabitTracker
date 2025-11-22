

import SwiftUI

struct NavigationBar: View {
    
    @State var addAction: ()->()
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.clear)
            
            Spacer()
            
            Text("Schedule")
                .font(.fontSystem(size: 30, weight: .bold))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)

            Spacer()
            Button {
                addAction()
            } label: {
                Image.init(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationBar(addAction: {})
}
