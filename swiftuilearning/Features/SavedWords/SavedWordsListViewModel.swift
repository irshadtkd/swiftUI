//
//  SavedWordsListViewModel.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 28/01/26.
//

import SwiftUI
import SwiftData

final class SavedWordsListViewModel: ObservableObject {
    @Published var items: [WordOfTheDay] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMore = true
    
    private let pageSize = 20
    private var currentOffset = 0
    
    func loadFirstPage(context: ModelContext) {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentOffset = 0
        hasMore = true
        items = []
        loadPage(context: context)
    }
    
    func loadNextPage(context: ModelContext) {
        guard hasMore, !isLoading else { return }
        loadPage(context: context)
    }
    
    func retry(context: ModelContext) {
        errorMessage = nil
        loadFirstPage(context: context)
    }
    
    private func loadPage(context: ModelContext) {
        isLoading = true
        do {
            let page = try WordDatabaseService.shared.fetchSavedWords(
                offset: currentOffset,
                limit: pageSize,
                context: context
            )
            if currentOffset == 0 {
                items = page
            } else {
                items.append(contentsOf: page)
            }
            currentOffset += page.count
            hasMore = page.count >= pageSize
        } catch let appError as AppErrors {
            errorMessage = appError.message
            if currentOffset == 0 {
                items = []
            }
        } catch {
            errorMessage = AppStrings.Errors.databaseFetchFailed
            if currentOffset == 0 {
                items = []
            }
        }
        isLoading = false
    }
}
