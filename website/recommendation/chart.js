const SERVER_URL = 'http://localhost:8080';
//const SERVER_URL = 'https://express-backend-stock-app.uw.r.appspot.com';

function renderRecommendationChart(recommendationData) {
    if (!recommendationData) return;

    const analysisData = {
        'Strong Buy': [],
        'Buy': [],
        'Hold': [],
        'Sell': [],
        'Strong Sell': []
    };

    recommendationData.slice().reverse().forEach(item => {
        Object.keys(analysisData).forEach(key => {
            var parsedKey = key.replace(/\s+/g, '').replace(/^./, key[0].toLowerCase());
            analysisData[key].push([new Date(item.period).getTime(), item[parsedKey]]);
        });
    });

    const chartOptions = {
        chart: {
            type: 'column',
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
            text: 'Recommendation Trends'
        },
        xAxis: {
            type: 'datetime',
            labels: {
                formatter: function() {
                    return Highcharts.dateFormat('%Y-%m', this.value);
                }
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: '# Analysis'
            },
            opposite: false
        },
        tooltip: {
            pointFormat: '{series.name}: {point.y}<br/>',
            shared: true
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    inside: true,
                    color: 'black',
                    style: {
                        textOutline: '1px contrast'
                    }
                }
            }
        },
        legend: {
            enabled: true
        },
        series: [{
            name: 'Strong Buy',
            data: analysisData['Strong Buy'],
            color: '#177b3f'
        }, {
            name: 'Buy',
            data: analysisData['Buy'],
            color: '#21c15e'
        }, {
            name: 'Hold',
            data: analysisData['Hold'],
            color: '#c2951f'
        }, {
            name: 'Sell',
            data: analysisData['Sell'],
            color: '#f06161'
        }, {
            name: 'Strong Sell',
            data: analysisData['Strong Sell'],
            color: '#8d3939'
        }]
    };

    const container = document.getElementById('recommendation-chart');
    Highcharts.chart(container, chartOptions);
}

function fetchRecommendationDataAndRenderChart(ticker) {
    fetch(`${SERVER_URL}/recommendation?stock_ticker=${ticker}`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Failed to fetch recommendation data. Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            renderRecommendationChart(data);
            console.log("Finished!")
            return true;
        })
        .catch(error => {
            console.error('Error fetching recommendation data:', error);
            return false;
        });
}
