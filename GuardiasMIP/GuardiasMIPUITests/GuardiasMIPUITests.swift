//
//  GuardiasMIPUITests.swift
//  GuardiasMIPUITests
//
//  Created by Ernesto Sánchez Kuri on 26/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import XCTest

class GuardiasMIPUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.buttons["Crear Nuevo Rol"].tap()
        
        let nombreDeGuardiaEjATextField = app.textFields["Nombre de Guardia (ej: A)"]
        nombreDeGuardiaEjATextField.tap()
        app.textFields["Nombre de Guardia (ej: A)"]
        
        let button = app.otherElements.containingType(.NavigationBar, identifier:"Determina guardias").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Button).elementBoundByIndex(0)
        button.tap()
        nombreDeGuardiaEjATextField.tap()
        app.textFields["Nombre de Guardia (ej: A)"]
        button.tap()
        app.typeText("c")
        nombreDeGuardiaEjATextField.tap()
        nombreDeGuardiaEjATextField.tap()
        app.textFields["Nombre de Guardia (ej: A)"]
        button.tap()
        app.navigationBars["Determina guardias"].buttons["Siguiente"].tap()
        
        let element = app.otherElements.containingType(.NavigationBar, identifier:"Fechas").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.Button).matchingIdentifier("Seleccionar Fecha").elementBoundByIndex(0).tap()
        
        let elegirButton = app.toolbars.buttons["Elegir"]
        elegirButton.tap()
        element.childrenMatchingType(.Button).matchingIdentifier("Seleccionar Fecha").elementBoundByIndex(1).tap()
        app.datePickers.pickerWheels["2016"].tap()
        elegirButton.tap()
        app.navigationBars["Fechas"].buttons["Siguiente"].tap()
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(40).staticTexts["22"].tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.swipeUp()
        
        let guardiasNavigationBar = app.navigationBars["Guardias"]
        guardiasNavigationBar.buttons["Hoy"].tap()
        guardiasNavigationBar.buttons["?"].tap()
        
        let okButton = app.alerts["Calendario de Guardias"].collectionViews.buttons["Ok"]
        okButton.tap()
        okButton.tap()
        guardiasNavigationBar.buttons["Cancelar"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
