const SERVER_URL = 'http://localhost:8080';

function renderEpsChart(epsData) {
    if (!epsData) return null;

    const actual = [];
    const estimate = [];
    const categories = [];

    epsData.slice().reverse().forEach(item => {
        categories.push(`${item.period}<br>Surprise: ${item.surprise}`);
        actual.push([item.actual]);
        estimate.push([item.estimate]);
    });

    const chartOptions = {
        chart: {
            type: 'line',
            backgroundColor: 'rgba(211, 211, 211, 0.1)'
        },
        rangeSelector: {
            enabled: false
        },
        scrollbar: {
            enabled: false
        },
        navigator: {
            enabled: false
        },
        title: {
            text: 'Historical EPS Surprises'
        },
        xAxis: {
            categories: categories
        },
        yAxis: {
            title: {
                text: 'Quarterly EPS'
            },
            opposite: false
        },
        plotOptions: {
            line: {
                marker: {
                    enabled: true,
                    radius: 4
                }
            }
        },
        legend: {
            enabled: true
        },
        tooltip: {
            shared: true,
            formatter: function () {
                return '<b>' + this.x + '</b><br/>' +
                    this.points.map(point => {
                        return point.series.name + ': ' + point.y;
                    }).join('<br/>');
            }
        },
        series: [{
            name: 'Actual',
            data: actual,
        }, {
            name: 'Estimate',
            data: estimate
        }]
    };
    
    const container = document.getElementById('chart');
    Highcharts.chart(container, chartOptions);
}

function fetchEpsDataAndRenderChart(ticker) {
    fetch(`${SERVER_URL}/eps?stock_ticker=${ticker}`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Failed to fetch EPS data. Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
                console.log(data);
            renderEpsChart(data);
        })
        .catch(error => {
            console.error('Error fetching EPS data:', error);
        });
}
