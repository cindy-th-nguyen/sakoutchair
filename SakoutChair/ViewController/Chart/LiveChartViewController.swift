//
//  LiveChartViewController.swift
//  SakoutChair
//
//  Created by Oudjama on 16/07/2021.
//

import UIKit
import Charts

class LiveChartViewController: UIViewController {
    
    @IBOutlet weak var liveBarChart: BarChartView!
    @IBOutlet weak var historyLiveChart: LineChartView!
    
    var numbers : [Float] {
        get {
            return SensorDataManager.sharedInstance.data
        }
    }
    
    var sonarTop: [Double] = []
    var sonarMid: [Double] = []
    var sonarBot: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(
        self.updateChart(notification:)), name: Notification.Name("reloadChart"),
        object: nil)
        updateChart(notification: Notification(name: Notification.Name("reloadChart")))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func updateChart(notification: Notification)  {
        DispatchQueue.main.async {
            var barChartEntry1  = [BarChartDataEntry]()
            var barChartEntry2  = [BarChartDataEntry]()
            var barChartEntry3  = [BarChartDataEntry]()
            let numbers = self.numbers
            
            //MARK: - LIVE ONE DATA
            barChartEntry1.append(BarChartDataEntry(x: 0, y: Double(numbers[0])))
            barChartEntry2.append(BarChartDataEntry(x: 1, y: Double(numbers[1])))
            barChartEntry3.append(BarChartDataEntry(x: 2, y: Double(numbers[2])))
            
            let barChartData1 = BarChartDataSet(entries: barChartEntry1, label: "S1")
            barChartData1.colors = [NSUIColor.red]
            let barChartData2 = BarChartDataSet(entries: barChartEntry2, label: "S2")
            barChartData2.colors = [NSUIColor.green]
            let barChartData3 = BarChartDataSet(entries: barChartEntry3, label: "S3")
            barChartData3.colors = [NSUIColor.blue]

            let allBarChartData = BarChartData()
            allBarChartData.addDataSet(barChartData1)
            allBarChartData.addDataSet(barChartData2)
            allBarChartData.addDataSet(barChartData3)
            
            self.liveBarChart.data = allBarChartData
            self.liveBarChart.chartDescription?.text = "Live Chart"
            
            //MARK: - LIVE HISTORY
            
            var lineHistoryChartEntry1  = [ChartDataEntry]()
            var lineHistoryChartEntry2  = [ChartDataEntry]()
            var lineHistoryChartEntry3  = [ChartDataEntry]()
            self.sonarTop.append(Double(numbers[0]))
            self.sonarMid.append(Double(numbers[1]))
            self.sonarBot.append(Double(numbers[2]))
            
            for number in 0..<self.sonarTop.count {
                let value = ChartDataEntry(x: Double(number), y: self.sonarTop[number])
                lineHistoryChartEntry1.append(value)
            }

            for number in 0..<self.sonarMid.count {
                let value = ChartDataEntry(x: Double(number), y: self.sonarMid[number])
                lineHistoryChartEntry2.append(value)
            }

            for number in 0..<self.sonarBot.count {
                let value = ChartDataEntry(x: Double(number), y: self.sonarBot[number])
                lineHistoryChartEntry3.append(value)
            }
            
            let lineHistoryChartData1 = LineChartDataSet(entries: lineHistoryChartEntry1, label: "S1")
            lineHistoryChartData1.drawCirclesEnabled = false
            lineHistoryChartData1.drawValuesEnabled = false
            lineHistoryChartData1.colors = [NSUIColor.red]
            let lineHistoryChartData2 = LineChartDataSet(entries: lineHistoryChartEntry2, label: "S2")
            lineHistoryChartData2.drawCirclesEnabled = false
            lineHistoryChartData2.drawValuesEnabled = false
            lineHistoryChartData2.colors = [NSUIColor.green]
            let lineHistoryChartData3 = LineChartDataSet(entries: lineHistoryChartEntry3, label: "S3")
            lineHistoryChartData3.drawCirclesEnabled = false
            lineHistoryChartData3.drawValuesEnabled = false
            lineHistoryChartData3.colors = [NSUIColor.blue]

            let allHistoryChartData = LineChartData()
            allHistoryChartData.addDataSet(lineHistoryChartData1)
            allHistoryChartData.addDataSet(lineHistoryChartData2)
            allHistoryChartData.addDataSet(lineHistoryChartData3)

            self.historyLiveChart.data = allHistoryChartData
            self.historyLiveChart.chartDescription?.text = "Daily History Chart"
        }
    }
}
