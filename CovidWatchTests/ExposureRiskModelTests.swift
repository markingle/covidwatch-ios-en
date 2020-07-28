//
//  Created by Zsombor Szabo on 08/06/2020.
//  
//

import XCTest
@testable import CovidWatch
import ExposureNotification

class ExposureRiskModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAZExposureRiskModel() {
        let model = AZExposureRiskModel()
        let message = "Computed risk score does not match expected risk score"

        // ## Single exposure info tests ##

        // Scenario: "Sufficiently risky individual, 30 minutes close contact"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [30.0 * 60.0, 0.0, 0.0],
                transmissionRiskLevel: 4
            ),
            1, // Expected
            message
        )

        // Scenario: "Sufficiently risky individual, 30 minutes at med. attenuation"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 30.0 * 60.0, 0.0],
                transmissionRiskLevel: 4
            ),
            0, // Expected
            message
        )

        // Scenario: "Sufficiently risky individual, 5 minutes close contact"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [5.0 * 60.0, 0.0, 0.0],
                transmissionRiskLevel: 4
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual, 30 minutes at med. attenuation"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 30.0 * 60.0, 0.0],
                transmissionRiskLevel: 6
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual, 5 minutes close contact"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [5.0 * 60.0, 0.0, 0.0],
                transmissionRiskLevel: 6
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual, 5 minutes at med attenuation"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 5.0 * 60.0, 0.0],
                transmissionRiskLevel: 6
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual, 30 minutes at long distance"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 0.0, 30.0 * 60.0],
                transmissionRiskLevel: 6
            ),
            0, // Expected
            message
        )

        // Scenario: "Asymptomatic shedder at peak risk, 30 min at med. attenuation"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 30.0 * 60.0, 0.0],
                transmissionRiskLevel: 3
            ),
            0, // Expected
            message
        )

        // Scenario: "Low shedder, 30 min at medium attenuation"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 30.0 * 60.0, 0.0],
                transmissionRiskLevel: 2
            ),
            0, // Expected
            message
        )

        // Scenario: "Low shedder, 5 min at med. attenuation"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 5.0 * 60.0, 0.0],
                transmissionRiskLevel: 2
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual, 30 min in each bucket"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [30.0 * 60.0, 30.0 * 60.0, 30.0 * 60.0],
                transmissionRiskLevel: 6
            ),
            5, // Expected
            message
        )

        // Scenario: "Highest risk individual, 30 min in each bucket"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [30.0 * 60.0, 30.0 * 60.0, 30.0 * 60.0],
                transmissionRiskLevel: 1
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual 15 minutes close contact"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [15.0 * 60.0, 0.0, 0.0],
                transmissionRiskLevel: 6
            ),
            1, // Expected
            message
        )

        // Scenario: "Lowest risk individual 15 minutes close contact"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [15.0 * 60.0, 0.0, 0.0],
                transmissionRiskLevel: 1
            ),
            0, // Expected
            message
        )

        // Scenario: "Highest risk individual 15 minutes long distance"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 0.0, 15.0 * 60.0],
                transmissionRiskLevel: 6
            ),
            0, // Expected
            message
        )

        // Scenario: "Lowest risk individual 15 minutes long distance"
        XCTAssertEqual(
            model.computeRiskScore(
                forAttenuationDurations: [0.0, 0.0, 15.0 * 60.0],
                transmissionRiskLevel: 1
            ),
            0, // Expected
            message
        )

        // ## Date risk level tests ##

        // Current date
        let day0 = Date()
        let day2 = Calendar.current.date(byAdding: .day, value: 2, to: day0)!
        let day3 = Calendar.current.date(byAdding: .day, value: 3, to: day0)!
        let day4 = Calendar.current.date(byAdding: .day, value: 4, to: day0)!
        let day18 = Calendar.current.date(byAdding: .day, value: 18, to: day0)!

        var exposures = [
            ENExposureInfo(
                attenuationDurations: [5 * 60.0, 10 * 60.0, 5 * 60.0],
                attenuationValue: 0,
                date: day0,
                duration: 0,
                totalRiskScore: 0,
                transmissionRiskLevel: 6
            ),
            ENExposureInfo(
                attenuationDurations: [10 * 60.0, 0.0, 0.0],
                attenuationValue: 0,
                date: day3,
                duration: 0,
                totalRiskScore: 0,
                transmissionRiskLevel: 6
            )
        ]

        XCTAssertEqual(
            model.computeRiskLevelValue(forExposureInfos: exposures, computeDate: day2),
            0.689657, // Expected
            accuracy: 0.0001,
            message
        )
        XCTAssertEqual(
            model.computeRiskLevelValue(forExposureInfos: exposures, computeDate: day3),
            1.395461, // Expected
            accuracy: 0.0001,
            message
        )
        XCTAssertEqual(
            model.computeRiskLevelValue(forExposureInfos: exposures, computeDate: day18),
            0.436539, // Expected
            accuracy: 0.0001,
            message
        )

        exposures = [
            ENExposureInfo(
                attenuationDurations: [0.0, 0.0, 25 * 60.0],
                attenuationValue: 0,
                date: day3,
                duration: 0,
                totalRiskScore: 0,
                transmissionRiskLevel: 6
            ),
            ENExposureInfo(
                attenuationDurations: [5 * 60.0, 20 * 60.0, 5 * 60.0],
                attenuationValue: 0,
                date: day3,
                duration: 0,
                totalRiskScore: 0,
                transmissionRiskLevel: 6
            ),
            ENExposureInfo(
                attenuationDurations: [5 * 60.0, 0.0, 0.0],
                attenuationValue: 0,
                date: day3,
                duration: 0,
                totalRiskScore: 0,
                transmissionRiskLevel: 6
            )
        ]

        XCTAssertEqual(
            model.computeRiskLevelValue(forExposureInfos: exposures, computeDate: day2),
            0.0, // Expected
            accuracy: 0.0001,
            message
        )
        XCTAssertEqual(
            model.computeRiskLevelValue(forExposureInfos: exposures, computeDate: day4),
            1.527189, // Expected
            accuracy: 0.0001,
            message
        )
        XCTAssertEqual(
            model.computeRiskLevelValue(forExposureInfos: exposures, computeDate: day18),
            0.520678, // Expected
            accuracy: 0.0001,
            message
        )

        // ## Tranmission risk level tests ##

        let key = ENTemporaryExposureKey()
        key.keyData = Data(base64Encoded: "z2Cx9hdz2SlxZ8GEgqTYpA==")!
        key.rollingPeriod = 144

        key.rollingStartNumber = day0.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil ),
            6 // Expected
        )

        key.rollingStartNumber = day2.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            6 // Expected
        )

        key.rollingStartNumber = day3.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            5 // Expected
        )

        key.rollingStartNumber = day18.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            0 // Expected
        )

        let day2Ago = Calendar.current.date(byAdding: .day, value: -2, to: day0)!
        let day3Ago = Calendar.current.date(byAdding: .day, value: -3, to: day0)!
        let day4Ago = Calendar.current.date(byAdding: .day, value: -4, to: day0)!
        let day18Ago = Calendar.current.date(byAdding: .day, value: -18, to: day0)!

        key.rollingStartNumber = day2Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            5 // Expected
        )

        key.rollingStartNumber = day3Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            3 // Expected
        )

        key.rollingStartNumber = day4Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            2 // Expected
        )

        key.rollingStartNumber = day18Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: Date().intervalNumber.date, testDate: nil, possibleInfectionDate: nil),
            0 // Expected
        )

        key.rollingStartNumber = day0.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: Date().intervalNumber.date, possibleInfectionDate: nil ),
            3 // Expected
        )

        key.rollingStartNumber = day2Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: Date().intervalNumber.date, possibleInfectionDate: nil),
            2 // Expected
        )

        key.rollingStartNumber = day3Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: Date().intervalNumber.date, possibleInfectionDate: nil),
            2 // Expected
        )

        key.rollingStartNumber = day18Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: Date().intervalNumber.date, possibleInfectionDate: nil),
            0 // Expected
        )

        key.rollingStartNumber = day0.intervalNumber
        XCTAssertEqual(
          model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: day0, possibleInfectionDate: day3Ago ),
          3 // Expected
        )

        key.rollingStartNumber = day0.intervalNumber
        XCTAssertEqual(
          model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: day2, possibleInfectionDate: day4Ago),
          2 // Expected
        )

        key.rollingStartNumber = day0.intervalNumber
        XCTAssertEqual(
          model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: day3, possibleInfectionDate: day18Ago),
          2 // Expected
        )

        key.rollingStartNumber = day0.intervalNumber
        XCTAssertEqual(
          model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: day18Ago, possibleInfectionDate: nil),
          0 // Expected
        )

        key.rollingStartNumber = day3Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: day0, possibleInfectionDate: day4Ago ),
            0 // Expected
        )

        key.rollingStartNumber = day3Ago.intervalNumber
        XCTAssertEqual(
            model.computeTransmissionRiskLevel(forTemporaryExposureKey: key, symptomsStartDate: nil, testDate: day0, possibleInfectionDate: day3Ago ),
            0 // Expected
        )

    }

}
