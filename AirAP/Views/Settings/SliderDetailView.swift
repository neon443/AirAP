//
//  SliderDetailView.swift
//  AirAP
//
//  Created by neon443 on 06/11/2025.
//

import SwiftUI

struct SliderDetailView: View {
	@Binding var value: CGFloat
	@State var range: ClosedRange<CGFloat>
	@State var defaultValue: CGFloat
	@State var step: CGFloat
	@State var title: String
	@State var minLabel: String = ""
	@State var maxLabel: String = ""
	@Binding var disabled: Bool
	
    var body: some View {
		VStack(alignment: .center) {
			HStack {
				Text(title)
					.font(.title3)
					.bold()
				Spacer()
				Text("\(value)")
					.modifier(monospacedIfAv())
				if value != defaultValue {
					Button("", systemImage: "arrow.uturn.backward") {
						withAnimation { value = defaultValue }
					}
					.animation(.spring, value: value)
					.transition(.scale)
					.buttonStyle(.plain)
					.padding(.horizontal, 5)
				}
			}
			HStack {
				Text(minLabel)
					.modifier(foregroundColorStyle(.gray))
					.modifier(monospacedIfAv())
				Slider(value: $value, in: range, step: step)
					.disabled(disabled)
				Text(maxLabel)
					.modifier(foregroundColorStyle(.gray))
					.modifier(monospacedIfAv())
			}
		}
    }
}

#Preview {
	SliderDetailView(
		value: .constant(0.5),
		range: 0...1,
		defaultValue: 1,
		step: 0.1,
		title: "Title",
		disabled: .constant(false)
	)
}
