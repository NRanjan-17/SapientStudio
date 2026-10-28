// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (C) 2026 OpenHorizon Labs Pvt Ltd — Sapient Studio: AGPL-3.0-only OR commercial (see LICENSE, NOTICE)

import SwiftUI

/// Benchmark and Compare: on wide screens, setup in a column on the left
/// and progress and results on the right, so a run's numbers are visible
/// while it goes; one form otherwise (iPhone, iPad portrait in a narrow
/// window). On a half-folded iPhone Duo, setup and results take a side of
/// the fold each. Both closures supply form sections.
struct SetupResultsLayout<Setup: View, Results: View>: View {
    @ViewBuilder let setup: () -> Setup
    @ViewBuilder let results: () -> Results
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .regular {
            // The system's arrangement: two equal halves, side by side when
            // wide, stacked when tall, one each side of a fold.
            ArrangementView {
                setupForm
            } secondary: {
                resultsForm
            }
            .arrangementViewStyle(.split)
            // The forms' own colour behind the gap at the fold.
            .background(Color(.systemGroupedBackground))
        } else {
            Form {
                setup()
                results()
            }
            .scrollDismissesKeyboard(.interactively)
            .readableContentWidth(720)
        }
    }

    // The arrangement puts the halves edge to edge; a margin on each
    // inner edge leaves a gap between their cards. The outer edges keep the
    // system's margins, which stay clear of the side bar.
    private var setupForm: some View {
        Form { setup() }
            .scrollDismissesKeyboard(.interactively)
            .contentMargins(.trailing, 16, for: .scrollContent)
    }

    private var resultsForm: some View {
        Form { results() }
            .scrollDismissesKeyboard(.interactively)
            .contentMargins(.leading, 16, for: .scrollContent)
            .readableContentWidth(820)
    }
}
