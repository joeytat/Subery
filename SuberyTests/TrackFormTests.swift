//
//  TrackFormTests.swift
//  SuberyTests
//
//  Created by yu wang on 2023/12/3.
//

import XCTest
import ComposableArchitecture
@testable import Subery

@MainActor
final class TrackFormTests: XCTestCase {

  func testSetName() async {
    let store = TestStore(
      initialState: TrackFormFeature.State(
        name: "",
        category: "",
        price: "",
        startAtDate: .now,
        endAtDate: .now.nextMonth()
      )
    ) {
      TrackFormFeature()
    }

    await store.send(.set(\.$name, "Copilot")) { state in
      state.name = "Copilot"
    }
  }

}
