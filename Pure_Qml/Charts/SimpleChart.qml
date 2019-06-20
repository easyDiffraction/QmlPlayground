import QtCharts 2.3

ChartView {
    antialiasing: true
    
    PieSeries {
        PieSlice { label: "eaten"; value: 94.9 }
        PieSlice { label: "not yet eaten"; value: 5.1 }
    }
}
