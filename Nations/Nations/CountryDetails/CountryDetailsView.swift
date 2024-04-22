//
//  CountryDetailsView.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-21.
//

import SwiftUI

struct CountryDetailsView<ViewModel: CountryDetailsViewModelProtocol>: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            closeButton
            flagView
            VStack(alignment: .leading) {
                Text(viewModel.countryOfficialName)
                    .font(.title)
                    .padding(.bottom, 5)
                
                HStack {
                    Text("Capital: \(viewModel.capital)")
                        .font(.subheadline)
                    Spacer()
                    Text(viewModel.region)
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Divider()


                Text("About \(viewModel.countryCommonName)")
                    .font(.title2)
                    .padding(.bottom, 5)

                Text("Country code: \(viewModel.countryCode)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding()
            Spacer()
        }
        .onAppear {
            Task {
                await viewModel.viewAppeared()
            }
        }
    }
}

extension CountryDetailsView {
    var closeButton: some View {
        HStack {
            Spacer()
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(.close)
            }
        }
        .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 24))
    }

    var flagView: some View {
        viewModel.image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CountryDetailsView(viewModel: MockCountryDetailsViewModel())
}

private final class MockCountryDetailsViewModel: CountryDetailsViewModelProtocol {
    var capital: String = ""
    var countryOfficialName: String = ""
    var image: Image? = nil
    var region: String = ""
    var countryCode: String = ""
    var countryCommonName: String = ""

    func viewAppeared() async {}
}
