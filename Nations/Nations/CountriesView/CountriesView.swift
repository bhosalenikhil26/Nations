//
//  CountriesView.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

struct CountriesView<ViewModel: CountriesViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
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
                    List(Array(searchResults), id: \.self) { country in
                        CountryCell(country: country) {
                            Task {
                                await viewModel.didSelectCountry(country)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Countries")
        }
        .searchable(text: $searchText)
        .onAppear {
            Task {
                await viewModel.viewAppeared()
            }
        }
        .alert("Something went wrong, try again in a moment.", isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.shouldShowCountryDetails) {
            if let detailsViewModel = viewModel.countryDetailsViewModel {
              CountryDetailsView(viewModel: detailsViewModel)
            } else {
                EmptyView()
            }
        }
    }
}

private extension CountriesView {
    var searchResults: [Country] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter { $0.name.common.contains(searchText) }
        }
    }
}

#Preview {
    CountriesView(viewModel: MockCountriesViewModel())
}

final class MockCountriesViewModel: CountriesViewModelProtocol {
    var countries: [Country] = []
    var loadingState: LoadingState = .initial
    var showAlert: Bool = false
    var shouldShowCountryDetails: Bool = false
    var countryDetailsViewModel: CountryDetailsViewModel? = nil

    func viewAppeared() async {}
    func didSelectCountry(_ country: Country) async {}
    func didTapRetry() async {}
}

struct CountryCell: View {
    let country: Country
    var didTapCell: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(country.flag)
            Text(country.name.common)
            Spacer()
        }
        .frame(height: 40)
        .contentShape(Rectangle())
        .onTapGesture {
            didTapCell()
        }
    }
}
