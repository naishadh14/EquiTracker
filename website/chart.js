const SERVER_URL = 'http://localhost:8080';
//const SERVER_URL = 'https://express-backend-stock-app.uw.r.appspot.com';

async function fetchDailyChartData(ticker) {
    // Calculate from and to dates
    const now = new Date();
    const fromTimestamp = Math.floor(now.getTime() / 1000) - (2 * 365 * 24 * 60 * 60);
    const toTimestamp = Math.floor(now.getTime() / 1000);

    try {
        // Fetch data from the API
        const response = await fetch(`${SERVER_URL}/dailyChart?stock_ticker=${ticker}&from=${formatDateWithTimestamp(fromTimestamp)}&to=${formatDateWithTimestamp(toTimestamp)}`);
        
        // Check if the response is successful
        if (response.ok) {
            // Convert response to JSON
            const data = await response.json();
            renderDailyChart(ticker, data);
        } else {
            // Throw an error if response is not ok
            throw new Error('Failed to fetch data');
        }
    } catch (error) {
        // Handle errors
        console.error('Error fetching chart data:', error);
        throw error;
    }
}

async function fetchHourlyChartData(ticker) {
    const now = new Date();
    const to = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 2);
    const from = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 3);

    try {
        const response = await axios.get(`${SERVER_URL}/hourlyChart`, {
            params: {
                stock_ticker: ticker,
                from: formatDate(from),
                to: formatDate(to)
            }
        });
        renderChart(ticker, response.data);
        return true;
    } catch (error) {
        console.error('Error fetching hourly chart data:', error);
        renderErrorMessage();
        return false;
    }
}

function formatDateWithTimestamp(timestamp) {
    const date = new Date(timestamp * 1000);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

function formatDate(date) {
    const d = new Date(date);
    const month = `${d.getMonth() + 1}`.padStart(2, '0');
    const day = `${d.getDate()}`.padStart(2, '0');
    return `${d.getFullYear()}-${month}-${day}`;
}

function renderDailyChart(ticker, chartData) {
    const ohlc = [];
    const volume = [];
    const groupingUnits = [
        ['week', [1]],
        ['month', [1, 2, 3, 4, 6]]
    ];

    chartData.results.forEach(item => {
        ohlc.push([item.t, item.o, item.h, item.l, item.c]);
        volume.push([item.t, item.v]);
    });

    const chartOptions = {
        chart: {
            height: 500,
            backgroundColor: 'rgba(211, 211, 211, 0.1)'
        },
        title: {
            text: ticker + ' Historical'
        },
        subtitle: {
            text: 'With SMA and Volume by Price technical indicators'
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: [{
            opposite: true,
            startOnTick: false,
            endOnTick: false,
            labels: {
                align: 'left',
                x: 3
            },
            title: {
                text: 'OHLC'
            },
            height: '60%',
            resize: {
                enabled: true
            },
            lineWidth: 2,
        }, {
            opposite: true,
            labels: {
                align: 'left',
                x: 3
            },
            title: {
                text: 'Volume'
            },
            top: '65%',
            height: '35%',
            offset: 0,
            lineWidth: 2,
        }],
        tooltip: {
            split: true
        },
        plotOptions: {
            series: {
                dataGrouping: {
                    units: groupingUnits
                }
            },
            rangeSelector: {
                verticalAlign: 'left',
            },
            sma: {
                smoothing: true
            }
        },
        legend: {
            enabled: false
        },
        series: [{
            type: 'candlestick',
            name: 'OHLC',
            id: 'ohlc',
            zIndex: 2,
            data: ohlc
        }, {
            type: 'column',
            name: 'Volume',
            id: 'volume',
            data: volume,
            yAxis: 1
        }, {
            type: 'vbp',
            linkedTo: 'ohlc',
            params: {
                volumeSeriesID: 'volume'
            },
            dataLabels: {
                enabled: false
            },
            zoneLines: {
                enabled: false
            }
        }, {
            type: 'sma',
            linkedTo: 'ohlc',
            zIndex: 1,
            marker: {
                enabled: false
            }
        }]
    };

    // Render the chart
    Highcharts.chart('historicalChartContainer', chartOptions);
}

function renderChart(ticker, chartData) {
    if (!chartData || !chartData.results) {
        renderErrorMessage();
        return;
    }

    const color = chartData.positive ? 'green' : 'red';

    Highcharts.chart('chartContainer', {
        chart: {
            type: 'line',
            backgroundColor: '#ffffff',
            style: {
                fontFamily: 'Arial, sans-serif'
            }
        },
        title: {
            text: `${ticker} Hourly Price Variation`
        },
        legend: {
            enabled: false
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: {
                hour: '%H:%M'
            },
            visible: true
        },
        yAxis: {
            title: {
                text: null
            },
            opposite: true,
            tickAmount: 4
        },
        plotOptions: {
            series: {
                marker: {
                    enabled: false
                },
                smooth: true
            }
        },
        series: [{
            name: 'Stock Price',
            color: color,
            data: chartData.results.map(result => [result.t, result.c])
        }],
        credits: {
            enabled: false
        }
    });
}

function renderErrorMessage() {
    const container = document.getElementById('chartContainer');
    container.innerHTML = '<p style="text-align:center; padding-top: 50px;">Hourly chart data not available!</p>';
}
