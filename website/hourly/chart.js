const SERVER_URL = 'http://localhost:8080';
//const SERVER_URL = 'https://express-backend-stock-app.uw.r.appspot.com';

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
