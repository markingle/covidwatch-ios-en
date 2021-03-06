//
//  Created by Zsombor Szabo on 10/05/2020.
//  
//

import SwiftUI

struct ReportingStep3: View {

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {

            VStack(spacing: 0) {

                Spacer(minLength: .headerHeight)

                Text("REPORTING_FINISH_TITLE")
                    .modifier(StandardTitleTextViewModifier())
                    .padding(.horizontal, 2 * .standardSpacing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                Group {

                    Spacer().frame(height: 2 * .standardSpacing)

                    Text("REPORTING_FINISH_SUBTITLE_MESSAGE")
                        .font(.custom("Montserrat-Regular", size: 16))
                        .foregroundColor(Color("Text Color"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 2 * .standardSpacing)

                    Spacer().frame(height: 2 * .standardSpacing)

                    Text("REPORTING_FINISH_MESSAGE_1")
                        .font(.custom("Montserrat-Semibold", size: 16))
                        .foregroundColor(Color("Text Color"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 2 * .standardSpacing)

                    Spacer().frame(height: .standardSpacing)

                    Text("REPORTING_FINISH_MESSAGE_2")
                        .font(.custom("Montserrat-Regular", size: 14))
                        .foregroundColor(Color("Text Color"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 2 * .standardSpacing)

                    Spacer().frame(height: .standardSpacing)

                    Text("REPORTING_FINISH_MESSAGE_3")
                        .font(.custom("Montserrat-Regular", size: 14))
                        .foregroundColor(Color("Text Color"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 2 * .standardSpacing)
                }

                Button(action: {
                    ApplicationController.shared.handleTapShareApp()
                }) {
                    Text("SHARE_THE_APP").modifier(SmallCallToAction())
                }
                .padding(.top, 2 * .standardSpacing)
                .padding(.horizontal, 2 * .standardSpacing)

                Image("Family Earth")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .top)
                    .padding(.top, 2 * .standardSpacing)
                    .padding(.bottom, 2 * .standardSpacing)

                Image("Powered By CW for ADHS Grey")
                    .accessibility(label: Text("POWERED_BY_CW_IMAGE_ACCESSIBILITY_LABEL"))
                    .padding(.top, 2 * .standardSpacing)
                    .padding(.bottom, .standardSpacing)
            }
        }
    }
}

struct ReportingFinish_Previews: PreviewProvider {
    static var previews: some View {
        ReportingStep3()
    }
}
