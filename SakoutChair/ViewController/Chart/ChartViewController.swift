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
    
    var userSensorsDataArray: [String: Payload] = [:]
    let authManager = FirebaseAuthManager()
    var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        updateChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureComponents() {
        self.headerView.backgroundColor = UIColor.CustomColor.customBeige
        self.dateLabel.text = date
    }
    
    func updateChart() {
        let sorted = orderSensorsByHour2()
        print(sorted)
        
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var lineChartEntry3 = [ChartDataEntry]()
        let data = LineChartData()
        
        lineChartView.chartDescription?.text = date
        
        var i: Int = 0
        while i < (sorted[0] as AnyObject).count {
            lineChartEntry1.append(
                ChartDataEntry(x: Double(sorted[3][i]), y: Double(sorted[0][i]))
            )
            lineChartEntry2.append(
                ChartDataEntry(x: Double(sorted[3][i]), y: Double(sorted[1][i]))
            )
            lineChartEntry3.append(
                ChartDataEntry(x: Double(sorted[3][i]), y: Double(sorted[2][i]))
            )
            i += 1
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
    
    func orderSensorsByHour2() -> [[Float]] {
        var refomatted : [String: [Float]] = ["":[]]
        let hoursArray = Dictionary(grouping: userSensorsDataArray, by: { $0.key.split(separator: ":").first! }).compactMap { $0.key }.sorted()

        for hour in hoursArray {
            var total : [Float] = [0,0,0,0]
            for data in userSensorsDataArray {
                let splitedHour: String = String(data.key.split(separator: ":").first!)
                if hour == splitedHour {

                    total[0] += data.value.sonar[0]
                    total[1] += data.value.sonar[1]
                    total[2] += data.value.sonar[2]
                    total[3] += 1
                    
                    refomatted[String(hour)] = total
                }
            }
        }
        var averageTops: [Float] = []
        var averageMids: [Float] = []
        var averageBots: [Float] = []
        var floatHours: [Float] = []
        
        let keys = refomatted.keys.sorted()
        print(keys)
        
        for key in keys {
            if key.isEmpty { continue }

            print(key)
            let averageTop: Float = (refomatted[key]![0] / refomatted[key]![3])
            let averageMid: Float = (refomatted[key]![1] / refomatted[key]![3])
            let averageBot: Float = (refomatted[key]![2] / refomatted[key]![3])
            
            averageTops.append(averageTop)
            averageMids.append(averageMid)
            averageBots.append(averageBot)
            floatHours.append(Float(key) ?? 0)
        }
        
        return [
            averageTops,
            averageMids,
            averageBots,
            floatHours,
        ]
        
    }
}
