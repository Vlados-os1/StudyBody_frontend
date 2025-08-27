//
//  TagsView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct TagsView: View {
    let tags: [String]
    let maxDisplayTags: Int
    
    init(tags: [String], maxDisplayTags: Int = 5) {
        self.tags = tags.map { $0.trimmed }.filter { !$0.isEmpty }
        self.maxDisplayTags = maxDisplayTags
    }
    
    var displayTags: [String] {
        Array(tags.prefix(maxDisplayTags))
    }
    
    var hasMoreTags: Bool {
        tags.count > maxDisplayTags
    }
    
    var body: some View {
        if !tags.isEmpty {
            FlowLayout(spacing: Constants.UI.smallSpacing) {
                ForEach(displayTags, id: \.self) { tag in
                    TagChip(text: tag)
                }
                
                if hasMoreTags {
                    TagChip(text: "+\(tags.count - maxDisplayTags)")
                        .foregroundColor(Constants.Colors.textTertiary)
                }
            }
        }
    }
}

struct TagChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(Constants.Fonts.caption)
            .foregroundColor(Constants.Colors.primaryBlue)
            .padding(.horizontal, Constants.UI.smallPadding)
            .padding(.vertical, 4)
            .background(Constants.Colors.primaryBlue.opacity(0.1))
            .cornerRadius(8)
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        var currentPosition = CGPoint.zero
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0
        let containerWidth = proposal.width ?? .infinity
        
        for size in sizes {
            if currentPosition.x + size.width > containerWidth && currentPosition.x > 0 {
                // Move to next line
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }
            
            result.append(currentPosition)
            currentPosition.x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            maxX = max(maxX, currentPosition.x - spacing)
        }
        
        return (result, CGSize(width: maxX, height: currentPosition.y + lineHeight))
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        TagsView(tags: ["iOS", "Swift", "SwiftUI", "Backend", "Python"])
        
        TagsView(tags: ["iOS", "Swift", "SwiftUI", "Backend", "Python", "FastAPI", "PostgreSQL", "Docker"])
        
        TagsView(tags: ["Single Tag"])
    }
    .padding()
}
