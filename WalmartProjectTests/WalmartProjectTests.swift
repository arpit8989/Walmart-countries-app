//
//  WalmartProjectTests.swift
//  WalmartProjectTests
//
//  Created by Arpit Mallick on 3/14/25.
//

import XCTest
@testable import WalmartProject

final class WalmartProjectTests: XCTestCase {
    
    var viewModel: CountryViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CountryViewModel(apiService: MockApiManager())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchCountries_Success() async {
        let expectation = expectation(description: "Fetch countries from mock API")
        
        viewModel.onDataUpdated = {
            if !self.viewModel.countries.isEmpty { // Ensures it's only fulfilled when data is received
                expectation.fulfill()
            }
        }
        
        viewModel.fetchCountries()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.countries.count, 249)
        XCTAssertEqual(viewModel.countries.first?.name, "Afghanistan")
        XCTAssertEqual(viewModel.countries.first?.capital, "Kabul")
        
        // Test a country in between (e.g., "India")
        if let india = viewModel.countries.first(where: { $0.name == "India" }) {
            XCTAssertEqual(india.capital, "New Delhi")
            XCTAssertEqual(india.code, "IN")
            XCTAssertEqual(india.region, "AS")
        } else {
            XCTFail("India not found in fetched countries")
        }
        
        // Test a different country (e.g., "United States")
        if let usa = viewModel.countries.first(where: { $0.name == "United States of America" }) {
            XCTAssertEqual(usa.capital, "Washington, D.C.")
            XCTAssertEqual(usa.code, "US")
            XCTAssertEqual(usa.region, "NA")
        } else {
            XCTFail("United States not found in fetched countries")
        }
    }
    
    // Test Invalid Response Error
    func testFetchCountries_InvalidResponse() async {
        viewModel = CountryViewModel(apiService: MockApiManager(errorType: .invalidResponse))
        
        let expectation = expectation(description: "Handle invalid response error")
        
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }
        
        viewModel.fetchCountries()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertTrue(viewModel.countries.isEmpty)
    }
    
    // Test Bad URL Error
    func testFetchCountries_BadUrl() async {
        viewModel = CountryViewModel(apiService: MockApiManager(errorType: .badUrl))
        
        let expectation = expectation(description: "Handle bad URL error")
        
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }
        
        viewModel.fetchCountries()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertTrue(viewModel.countries.isEmpty)
    }
    
    // Test JSON Parsing Error
    func testFetchCountries_ParsingError() async {
        viewModel = CountryViewModel(apiService: MockApiManager(errorType: .parsingError))
        
        let expectation = expectation(description: "Handle JSON parsing error")
        
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }
        
        viewModel.fetchCountries()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertTrue(viewModel.countries.isEmpty)
    }
}
