//
//  CountriesView.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

struct CountriesView<ViewModel: CountriesViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        List(Array(viewModel.countriesWithFlag.enumerated()), id: \.offset) { index, country in
            CountryCell(country: country) {
                viewModel.didSelectCountry(at: index)
            }
        }
        .padding()
        .onAppear(perform: {
            Task {
                await viewModel.viewAppeared()
            }
        })
    }
}

#Preview {
    CountriesView(viewModel: MockCountriesViewModel())
}

final class MockCountriesViewModel: CountriesViewModelProtocol {
    var countriesWithFlag: [CountryWithFlag] = []

    func viewAppeared() async {}
    func didSelectCountry(at index: Int) {}
}

struct CountryCell: View {
    let country: CountryWithFlag
    var didTapCell: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(country.flag)
            Text(country.name)
            Spacer()
        }
        .onTapGesture {
            didTapCell()
        }
    }
}
