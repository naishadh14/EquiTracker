//
//  HourlyChart.swift
//  Stock
//
//  Created by Naishadh Vora on 28/04/24.
//

import UIKit
import WebKit
import SwiftUI

struct HourlyChartView: UIViewRepresentable {
    
    let ticker: String
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let ticker: String
        init(ticker: String) {
            self.ticker = ticker
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = "fetchHourlyChartData('\(ticker)')"
            webView.evaluateJavaScript(script, completionHandler: { result, error in
                if let error = error {
                    print("Error calling JavaScript: \(error)")
                } else {
                    print("JavaScript function executed with result: \(String(describing: result))")
                }
            })
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "website/hourly") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(ticker: ticker)
    }
}

struct HistoricalChartView: UIViewRepresentable {
    
    let ticker: String
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let ticker: String
        init(ticker: String) {
            self.ticker = ticker
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = "fetchDailyChartData('\(ticker)')"
            webView.evaluateJavaScript(script, completionHandler: { result, error in
                if let error = error {
                    print("Error calling JavaScript: \(error)")
                } else {
                    print("JavaScript function executed with result: \(String(describing: result))")
                }
            })
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "website/historical") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(ticker: ticker)
    }
}

struct RecommendationChartView: UIViewRepresentable {
    
    let ticker: String
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let ticker: String
        init(ticker: String) {
            self.ticker = ticker
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = "fetchRecommendationDataAndRenderChart('\(ticker)')"
            webView.evaluateJavaScript(script, completionHandler: { result, error in
                if let error = error {
                    print("Error calling JavaScript: \(error)")
                } else {
                    print("JavaScript function executed with result: \(String(describing: result))")
                }
            })
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "website/recommendation") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(ticker: ticker)
    }
}

struct EpsChartView: UIViewRepresentable {
    
    let ticker: String
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let ticker: String
        init(ticker: String) {
            self.ticker = ticker
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = "fetchEpsDataAndRenderChart('\(ticker)')"
            webView.evaluateJavaScript(script, completionHandler: { result, error in
                if let error = error {
                    print("Error calling JavaScript: \(error)")
                } else {
                    print("JavaScript function executed with result: \(String(describing: result))")
                }
            })
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "website/eps") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(ticker: ticker)
    }
}
