//
//  AAOptionsComposer.swift
//  AAInfographicsDemo
//
//  Created by AnAn on 2019/8/31.
//  Copyright Â© 2019 An An. All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 *  ð ð ð ð  âââ   WARM TIPS!!!   âââ ð ð ð ð
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit-Swift/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/7842508/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */

import UIKit

public class AAOptionsConstructor {
    
    public static func configureChartOptions(
        _ aaChartModel: AAChartModel
        ) -> AAOptions {
        let aaChart = AAChart()
            .type(aaChartModel.chartType!) //ç»å¾ç±»å
            .inverted(aaChartModel.inverted) //è®¾ç½®æ¯å¦åè½¬åæ è½´ï¼ä½¿Xè½´åç´ï¼Yè½´æ°´å¹³ã å¦æå¼ä¸º trueï¼å x è½´é»è®¤æ¯ åç½® çã å¦æå¾è¡¨ä¸­åºç°æ¡å½¢å¾ç³»åï¼åä¼èªå¨åè½¬
            .backgroundColor(aaChartModel.backgroundColor) //è®¾ç½®å¾è¡¨çèæ¯è²(åå«éæåº¦çè®¾ç½®)
            .pinchType(aaChartModel.zoomType?.rawValue) //è®¾ç½®æå¿ç¼©æ¾æ¹å
            .panning(true) //è®¾ç½®æå¿ç¼©æ¾åæ¯å¦å¯å¹³ç§»
            .polar(aaChartModel.polar) //æ¯å¦æåå¾è¡¨(å¼å¯æåæ æ¨¡å¼)
            .marginLeft(aaChartModel.marginLeft) //å¾è¡¨å·¦è¾¹è·
            .marginRight(aaChartModel.marginRight) //å¾è¡¨å³è¾¹è·
        
        let aaTitle = AATitle()
            .text(aaChartModel.title) //æ é¢ææ¬åå®¹
            .style(AAStyle()
                .color(aaChartModel.titleFontColor) //Title font color
                .fontSize(aaChartModel.titleFontSize!) //Title font size
                .fontWeight(aaChartModel.titleFontWeight) //Title font weight
        )
        
        let aaSubtitle = AASubtitle()
            .text(aaChartModel.subtitle) //å¯æ é¢åå®¹
            .align(aaChartModel.subtitleAlign) //å¾è¡¨å¯æ é¢ææ¬æ°´å¹³å¯¹é½æ¹å¼ãå¯éçå¼æ âleftâï¼âcenterâåârightâã é»è®¤æ¯ï¼center.
            .style(AAStyle()
                .color(aaChartModel.subtitleFontColor) //Subtitle font color
                .fontSize(aaChartModel.subtitleFontSize!) //Subtitle font size
                .fontWeight(aaChartModel.subtitleFontWeight) //Subtitle font weight
        )
        
        let aaTooltip = AATooltip()
            .enabled(aaChartModel.tooltipEnabled) //å¯ç¨æµ®å¨æç¤ºæ¡
            .shared(true) //å¤ç»æ°æ®å±äº«ä¸ä¸ªæµ®å¨æç¤ºæ¡
            .crosshairs(true) //å¯ç¨åæçº¿
            .valueSuffix(aaChartModel.tooltipValueSuffix) //æµ®å¨æç¤ºæ¡çåä½åç§°åç¼
        
        let aaPlotOptions = AAPlotOptions()
            .series(AASeries()
                .stacking(aaChartModel.stacking) //è®¾ç½®æ¯å¦ç¾åæ¯å å æ¾ç¤ºå¾å½¢
        )
        
        if (aaChartModel.animationType != .linear) {
            aaPlotOptions
                .series?.animation(AAAnimation()
                    .easing(aaChartModel.animationType)
                    .duration(aaChartModel.animationDuration)
            )
        }
        
        configurePlotOptionsMarkerStyle(aaChartModel, aaPlotOptions)
        configurePlotOptionsDataLabels(aaPlotOptions, aaChartModel)
        
        let aaLegend = AALegend()
            .enabled(aaChartModel.legendEnabled) //æ¯å¦æ¾ç¤º legend
            .itemStyle(AAItemStyle()
                .color(aaChartModel.axesTextColor ?? "#000000")
        ) //é»è®¤å¾ä¾çæå­é¢è²åXè½´æå­é¢è²ä¸æ ·
        
        let aaOptions = AAOptions()
            .chart(aaChart)
            .title(aaTitle)
            .subtitle(aaSubtitle)
            .tooltip(aaTooltip)
            .plotOptions(aaPlotOptions)
            .legend(aaLegend)
            .series(aaChartModel.series)
            .colors(aaChartModel.colorsTheme) //è®¾ç½®é¢è²ä¸»é¢
            .touchEventEnabled(aaChartModel.touchEventEnabled) //æ¯å¦æ¯æç¹å»äºä»¶
        
        configureAxisContentAndStyle(aaOptions, aaChartModel)
        
        return aaOptions
    }
    
    private static func configurePlotOptionsMarkerStyle(
        _ aaChartModel: AAChartModel,
        _ aaPlotOptions: AAPlotOptions
        ) {
        let chartType = aaChartModel.chartType!
        
        //æ°æ®ç¹æ è®°ç¸å³éç½®ï¼åªæçº¿æ§å¾(æçº¿å¾ãæ²çº¿å¾ãæçº¿åºåå¡«åå¾ãæ²çº¿åºåå¡«åå¾ãæ£ç¹å¾ãæçº¿èå´å¡«åå¾ãæ²çº¿èå´å¡«åå¾ãå¤è¾¹å½¢å¾)æææ°æ®ç¹æ è®°
        if     chartType == .area
            || chartType == .areaspline
            || chartType == .line
            || chartType == .spline
            || chartType == .scatter
            || chartType == .arearange
            || chartType == .areasplinerange
            || chartType == .polygon {
            let aaMarker = AAMarker()
                .radius(aaChartModel.markerRadius) //æ²çº¿è¿æ¥ç¹åå¾ï¼é»è®¤æ¯4
                .symbol(aaChartModel.markerSymbol?.rawValue) //æ²çº¿ç¹ç±»åï¼"circle", "square", "diamond", "triangle","triangle-down"ï¼é»è®¤æ¯"circle"
            if (aaChartModel.markerSymbolStyle == .innerBlank) {
                aaMarker
                    .fillColor("#ffffff") //ç¹çå¡«åè²(ç¨æ¥è®¾ç½®æçº¿è¿æ¥ç¹çå¡«åè²)
                    .lineWidth(2.0) //å¤æ²¿çº¿çå®½åº¦(ç¨æ¥è®¾ç½®æçº¿è¿æ¥ç¹çè½®å»æè¾¹çå®½åº¦)
                    .lineColor("") //å¤æ²¿çº¿çé¢è²(ç¨æ¥è®¾ç½®æçº¿è¿æ¥ç¹çè½®å»æè¾¹é¢è²ï¼å½å¼ä¸ºç©ºå­ç¬¦ä¸²æ¶ï¼é»è®¤åæ°æ®ç¹ææ°æ®åçé¢è²)
            } else if (aaChartModel.markerSymbolStyle == .borderBlank) {
                aaMarker
                    .lineWidth(2.0)
                    .lineColor(aaChartModel.backgroundColor)
            }
            let aaSeries = aaPlotOptions.series
            aaSeries?.marker(aaMarker)
        }
    }
    

    private static  func configurePlotOptionsDataLabels(
        _ aaPlotOptions: AAPlotOptions,
        _ aaChartModel: AAChartModel
        ) {
        let chartType = aaChartModel.chartType!
        
        var aaDataLabels = AADataLabels()
        .enabled(aaChartModel.dataLabelsEnabled)
        if (aaChartModel.dataLabelsEnabled == true) {
            aaDataLabels = aaDataLabels
                .style(AAStyle()
                    .color(aaChartModel.dataLabelsFontColor)
                    .fontSize(aaChartModel.dataLabelsFontSize!)
                    .fontWeight(aaChartModel.dataLabelsFontWeight)
            )
        }
        
        switch chartType {
        case .column:
            let aaColumn = AAColumn()
                .borderWidth(0)
                .borderRadius(aaChartModel.borderRadius)
                .dataLabels(aaDataLabels)
            if (aaChartModel.polar == true) {
                aaColumn.pointPadding(0)
                    .groupPadding(0.005)
            }
            aaPlotOptions.column(aaColumn)
        case .bar:
            let aaBar = AABar()
                .borderWidth(0)
                .borderRadius(aaChartModel.borderRadius)
                .dataLabels(aaDataLabels)
            if (aaChartModel.polar == true) {
                aaBar.pointPadding(0)
                    .groupPadding(0.005)
            }
            aaPlotOptions.bar(aaBar)
        case .area:
            aaPlotOptions.area(AAArea().dataLabels(aaDataLabels))
        case .areaspline:
            aaPlotOptions.areaspline(AAAreaspline().dataLabels(aaDataLabels))
        case .line:
            aaPlotOptions.line(AALine().dataLabels(aaDataLabels))
        case .spline:
            aaPlotOptions.spline(AASpline().dataLabels(aaDataLabels))
        case .pie:
            let aaPie = AAPie()
                .allowPointSelect(true)
                .cursor("pointer")
                .showInLegend(true)
            if (aaChartModel.dataLabelsEnabled == true) {
                aaDataLabels.format("<b>{point.name}</b>: {point.percentage:.1f} %")
            }
            aaPlotOptions.pie(aaPie.dataLabels(aaDataLabels))
        case .columnrange:
            aaPlotOptions.columnrange(AAColumnrange()
                .dataLabels(aaDataLabels)
                .borderRadius(0)
                .borderWidth(0))
        case .arearange:
            aaPlotOptions.arearange(AAArearange().dataLabels(aaDataLabels))
        default: break
        }
    }
    
    private static func configureAxisContentAndStyle(
        _ aaOptions: AAOptions,
        _ aaChartModel: AAChartModel
        ) {
        let chartType = aaChartModel.chartType
        //x è½´å Y è½´çç¸å³éç½®,æå½¢å¾ãéå­å¡å¾ãæ¼æå¾ å ä»ªè¡¨ãè¡¨çå¾åä¸éè¦è®¾ç½® X è½´å Y è½´çç¸å³åå®¹
        if (    chartType == .column
             || chartType == .bar
             || chartType == .area
             || chartType == .areaspline
             || chartType == .line
             || chartType == .spline
             || chartType == .scatter
             || chartType == .bubble
             || chartType == .columnrange
             || chartType == .arearange
             || chartType == .areasplinerange
             || chartType == .boxplot
             || chartType == .waterfall
             || chartType == .polygon
             || chartType == .gauge) {
            
            if chartType != .gauge {
                  let aaXAxisLabelsEnabled = aaChartModel.xAxisLabelsEnabled
                  let aaXAxisLabels = AALabels()
                      .enabled(aaXAxisLabelsEnabled) //è®¾ç½® x è½´æ¯å¦æ¾ç¤ºæå­
                  if aaXAxisLabelsEnabled == true {
                      aaXAxisLabels.style(
                          AAStyle()
                          .color(aaChartModel.axesTextColor)
                      )
                  }
                  
                  let aaXAxis = AAXAxis()
                      .labels(aaXAxisLabels)
                      .reversed(aaChartModel.xAxisReversed)
                      .gridLineWidth(aaChartModel.xAxisGridLineWidth) //xè½´ç½æ ¼çº¿å®½åº¦
                      .categories(aaChartModel.categories)
                      .visible(aaChartModel.xAxisVisible) //xè½´æ¯å¦å¯è§
                      .tickInterval(aaChartModel.xAxisTickInterval) //xè½´åæ ç¹é´éæ°
                  
                   aaOptions.xAxis(aaXAxis)
              }
            
            let aaYAxisLabelsEnabled = aaChartModel.yAxisLabelsEnabled
            let aaYAxisLabels = AALabels()
                .enabled(aaChartModel.yAxisLabelsEnabled)
            if aaYAxisLabelsEnabled == true {
                aaYAxisLabels.style(
                    AAStyle()
                    .color(aaChartModel.axesTextColor)
                )
            }
            
            let aaYAxis = AAYAxis()
                .labels(aaYAxisLabels) //è®¾ç½® y è½´æå­
                .min(aaChartModel.yAxisMin) //è®¾ç½® y è½´æå°å¼,æå°å¼ç­äºé¶å°±ä¸è½æ¾ç¤ºè´å¼äº
                .max(aaChartModel.yAxisMax) //yè½´æå¤§å¼
                .allowDecimals(aaChartModel.yAxisAllowDecimals) //æ¯å¦åè®¸æ¾ç¤ºå°æ°
                .reversed(aaChartModel.yAxisReversed)
                .gridLineWidth(aaChartModel.yAxisGridLineWidth) //yè½´ç½æ ¼çº¿å®½åº¦
                .lineWidth(aaChartModel.yAxisLineWidth) //è®¾ç½® yè½´è½´çº¿çå®½åº¦,ä¸º0å³æ¯éè yè½´è½´çº¿
                .visible(aaChartModel.yAxisVisible)
                .title(AATitle()
                    .text(aaChartModel.yAxisTitle) //y è½´æ é¢
                    .style(AAStyle()
                        .color(aaChartModel.axesTextColor)
                    ))
            
            aaOptions.yAxis(aaYAxis)
        }
    }
    
}
