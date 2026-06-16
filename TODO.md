# TODO - Update “Day 365” plan ending semantics

- [ ] Implement day-365 semantics across plan generation and UI
  - [ ] Update PlanGenerationScreen to treat the “365” option as an end-of-year/day-of-year target (not fixed 365 reading entries)
  - [ ] Update AppState.generatePlan bibleInYear path to remove hardcoded `365` for generatedPlanConfig/config length, and derive plan length from end-at-day-of-year-365 target
  - [ ] Update BiblePlanScreen day-label logic to stop gating on `config.length == 365`, and instead compute label consistently using plan start date + day index
- [ ] Run `flutter analyze`
- [ ] Build/run and spot-check:
  - [ ] Start-new plan from a mid-year date: ensure it ends at day 365 and UI labels align
  - [ ] Continue mode: ensure UI label numbering and schedule length align with end-at-day-365

