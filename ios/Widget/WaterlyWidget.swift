//
//  WaterlyWidget.swift
//  WaterlyWidget
//
//  iOS Widget Extension - Small & Medium Widgets
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), progress: 0.6, totalAmount: 1500, targetAmount: 2500, unitLabel: "ml")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), progress: 0.6, totalAmount: 1500, targetAmount: 2500, unitLabel: "ml")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Her saat güncelle
        for hourOffset in 0..<24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                progress: 0.6, // TODO: App Group'dan veri çek
                totalAmount: 1500,
                targetAmount: 2500,
                unitLabel: "ml"
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let progress: Double
    let totalAmount: Int
    let targetAmount: Int
    let unitLabel: String
}

struct WaterlyWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Today")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(entry.progress * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(entry.totalAmount) / \(entry.targetAmount)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .padding()
    }
}

struct MediumWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Progress")
                    .font(.headline)
                
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.2), lineWidth: 10)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: entry.progress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 100)
                    
                    Text("\(Int(entry.progress * 100))%")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                VStack(alignment: .trailing) {
                    Text("\(entry.totalAmount)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("of \(entry.targetAmount) \(entry.unitLabel)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    // Quick add action - URL scheme ile uygulamayı aç
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("+250ml")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

@main
struct WaterlyWidget: Widget {
    let kind: String = "WaterlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WaterlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Waterly")
        .description("Track your daily water intake")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WaterlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        WaterlyWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            progress: 0.6,
            totalAmount: 1500,
            targetAmount: 2500,
            unitLabel: "ml"
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WaterlyWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            progress: 0.6,
            totalAmount: 1500,
            targetAmount: 2500,
            unitLabel: "ml"
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

