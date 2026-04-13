//
//  AppErrors.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

enum AppErrors: Error {
    case invalidCredentials
    case networkError
    case unknown
    case invalidURL
    case invalidResponse
    case decodingError
    case databaseSaveFailed
    case databaseFetchFailed
    case databaseDeleteFailed
    
    var message: String {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        case .networkError:
            return AppStrings.Errors.networkError
        case .unknown:
            return AppStrings.Errors.genericTitle
        case .invalidURL:
            return AppStrings.Errors.invalidURL
        case .invalidResponse:
            return AppStrings.Errors.apiError
        case .decodingError:
            return AppStrings.Errors.dataError
        case .databaseSaveFailed:
            return AppStrings.Errors.databaseSaveFailed
        case .databaseFetchFailed:
            return AppStrings.Errors.databaseFetchFailed
        case .databaseDeleteFailed:
            return AppStrings.Errors.databaseDeleteFailed
        }
    }
}
