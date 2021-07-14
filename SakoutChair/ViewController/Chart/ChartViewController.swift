//
//  ChartViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 14/07/2021.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var numbers: [Int] = [1,1,2,3,6,2,4]
    var userSensorsDataArray: [String: Payload] = [:]
    let authManager = FirebaseAuthManager()
    var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        updateChart()
    }
    
    func configureComponents() {
        self.headerView.backgroundColor = UIColor.CustomColor.customBeige
        self.dateLabel.text = date
    }
    
    func updateChart() {
        var sonarTop: [Float] = []
        var sonarMid: [Float] = []
        var sonarBot: [Float] = []
        let sensorsArray = userSensorsDataArray.compactMap { $0.value }
        for s in sensorsArray {
            print("🐭😊 \(s.sonar)")
            sonarTop.append(s.sonar[0])
            sonarMid.append(s.sonar[1])
            sonarBot.append(s.sonar[2])
        }
        
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var lineChartEntry3 = [ChartDataEntry]()
        let data = LineChartData()
        
        lineChartView.chartDescription?.text = date
        
        for number in 0..<sonarTop.count {
            let value = ChartDataEntry(x: Double(number), y: Double(sonarTop[number]))
            lineChartEntry1.append(value)
        }
        
        for number in 0..<sonarMid.count {
            let value = ChartDataEntry(x: Double(number), y: Double(sonarMid[number]))
            lineChartEntry2.append(value)
        }
        
        for number in 0..<sonarBot.count {
            let value = ChartDataEntry(x: Double(number), y: Double(sonarBot[number]))
            lineChartEntry3.append(value)
        }
        
        let lineSonar1 = LineChartDataSet(entries: lineChartEntry1, label: "Sonar Top")
        let lineSonar2 = LineChartDataSet(entries: lineChartEntry2, label: "Sonar Mid")
        let lineSonar3 = LineChartDataSet(entries: lineChartEntry3, label: "Sonar Bot")
        
        lineSonar1.colors = [NSUIColor.blue]
        lineSonar2.colors = [NSUIColor.red]
        lineSonar3.colors = [NSUIColor.green]
        
        data.addDataSet(lineSonar1)
        data.addDataSet(lineSonar2)
        data.addDataSet(lineSonar3)
        lineChartView.data = data
    }
}
