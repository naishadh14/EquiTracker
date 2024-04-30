const SERVER_URL = 'http://localhost:8080';
//const SERVER_URL = 'https://express-backend-stock-app.uw.r.appspot.com';

async function fetchDailyChartData(ticker) {

    const now = new Date();
    const fromTimestamp = Math.floor(now.getTime() / 1000) - (2 * 365 * 24 * 60 * 60);
    const toTimestamp = Math.floor(now.getTime() / 1000);

    try {
        const response = await fetch(`${SERVER_URL}/dailyChart?stock_ticker=${ticker}&from=${formatDateWithTimestamp(fromTimestamp)}&to=${formatDateWithTimestamp(toTimestamp)}`);
        
        if (response.ok) {
            const data = await response.json();
            renderDailyChart(ticker, data);
        } else {
            throw new Error('Failed to fetch data');
        }
    } catch (error) {
        console.error(error.message);
        console.error('Error fetching chart data:', error);
        throw error;
    }
}

function formatDateWithTimestamp(timestamp) {
    return formatDate(new Date(timestamp * 1000));
}

function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
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

    const container = document.getElementById('chartContainer');
    Highcharts.chart(container, chartOptions);
}
