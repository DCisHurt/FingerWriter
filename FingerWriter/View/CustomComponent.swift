import Controls
import SwiftUI

/// slider component style of app
struct mySlider: View {
    @Binding var position: Float
    var title: String

    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: UIScreen.main.bounds.height * 0.018))
                .foregroundColor(Color("myPrimary"))
                .frame(width: UIScreen.main.bounds.height * 0.06)
            
            Ribbon(position: $position)
                .backgroundColor(.gray.opacity(0.7))
                .foregroundColor(Color("mySecondary"))
                .cornerRadius(80)
                .indicatorWidth(UIScreen.main.bounds.width * 0.08)
                .frame(height: UIScreen.main.bounds.height * 0.025)

            Text(String(Int(position*100)))
                .font(.system(size: UIScreen.main.bounds.height * 0.018))
                .foregroundColor(Color("myPrimary"))
                .frame(width: UIScreen.main.bounds.height * 0.04)
        }
        .padding(.vertical, UIScreen.main.bounds.height * 0.005)
        .frame(height: UIScreen.main.bounds.height * 0.05)
        .frame(width: UIScreen.main.bounds.width * 0.95)
    }
}

/// selector component style of app
struct mySelector: View {
    @Binding var index: Int
    var title: String
    var labels: [String]
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: UIScreen.main.bounds.height * 0.018))
                .foregroundColor(Color("myPrimary"))
                .frame(width: UIScreen.main.bounds.height * 0.06)
            
            IndexedSlider(index: $index, labels: labels)
                .backgroundColor(Color("myPrimary").opacity(0.3))
                .foregroundColor(.white.opacity(0.7))
                .cornerRadius(10)
                .frame(height: UIScreen.main.bounds.height * 0.035)
            
            Spacer()
        }
        .padding(.vertical, UIScreen.main.bounds.height * 0.005)
        .frame(height: UIScreen.main.bounds.height * 0.05)
        .frame(width: UIScreen.main.bounds.width * 0.95)
    }
}

/// subtitle style of setting view
struct mySubtitle: View {
    var text: String
    
    var body: some View {
        HStack{
            Rectangle()
                .padding(.horizontal)
                .frame(height:  UIScreen.main.bounds.height * 0.003)
                .foregroundColor(Color("myPrimary"))
            Text(text)
                .font(.system(size: UIScreen.main.bounds.height * 0.03))
                .foregroundColor(Color("myPrimary"))
            Rectangle()
                .padding(.horizontal)
                .frame(height:  UIScreen.main.bounds.height * 0.003)
                .foregroundColor(Color("myPrimary"))
        }
        .padding(.vertical, UIScreen.main.bounds.height * 0.005)
        .frame(height: UIScreen.main.bounds.height * 0.06)
    }
}

/// text style of manual title
struct ManualTitle: View {
    var title: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .fontWeight(.bold)
                .font(.subheadline)
            
            Rectangle()
                .frame(height: 2.0)
                .background(Color("myOutline"))
        }
        .padding(.top)
        .foregroundColor(Color("myPrimary"))
    }
}

/// text style of manual text
struct ManualText: View {
    var text: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(text)
                .font(.callout)
        }
        .padding(.bottom)
        .foregroundColor(Color("myPrimary"))
    }
}
