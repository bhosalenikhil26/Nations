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
        ZStack {
            switch viewModel.loadingState {
            case .initial:
                Button("Load Countries") {
                    Task {
                        await viewModel.didTapRetry()
                    }
                }
            case .loading:
                ActivityIndicator()
            case .loaded:
                List(Array(viewModel.countriesWithFlag.enumerated()), id: \.offset) { index, country in
                    CountryCell(country: country) {
                        viewModel.didSelectCountry(at: index)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await viewModel.viewAppeared()
            }
        }
        .alert("Something went wrong, try again in a moment.", isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {}
        }
    }
}

#Preview {
    CountriesView(viewModel: MockCountriesViewModel())
}

final class MockCountriesViewModel: CountriesViewModelProtocol {
    var countriesWithFlag: [CountryWithFlag] = []
    var loadingState: LoadingState = .initial
    var showAlert: Bool = false

    func viewAppeared() async {}
    func didSelectCountry(at index: Int) {}
    func didTapRetry() async {}
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
