//
//  SliderDetailView.swift
//  AirAP
//
//  Created by neon443 on 06/11/2025.
//

import SwiftUI

struct SliderDetailView: View {
	@Binding var value: CGFloat
	@State var valueUnit: String
	@State var range: ClosedRange<CGFloat>
	@State var defaultValue: CGFloat
	@State var step: CGFloat
	@State var dp: Int
	@State var multiplyUIValueBy: CGFloat = 1
	@State var title: String
	@State var minLabel: String = ""
	@State var maxLabel: String = ""
	@Binding var disabled: Bool
	
    var body: some View {
		VStack(alignment: .center) {
			HStack {
				Text(title)
					.bold()
				Spacer()
				Text(String(format: "%.\(dp)f", value*multiplyUIValueBy)+valueUnit)
					.modifier(contentTransitionIfAv())
					.animation(.interactiveSpring, value: value)
					.modifier(monospacedIfAv())
				Button("", systemImage: "arrow.uturn.backward") {
					withAnimation { value = defaultValue }
				}
				.disabled(value == defaultValue || disabled)
				.buttonStyle(.plain)
				.padding(.horizontal, 5)
				.padding(.trailing, -10)
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

@available(iOS 17, *)
#Preview {
	@Previewable @State var value: CGFloat = 0.5
	List {
		SliderDetailView(
			value: $value,
			valueUnit: "x",
			range: 0...1,
			defaultValue: 1,
			step: 0.1,
			dp: 2,
			title: "Title",
			disabled: .constant(false)
		)
	}
}
