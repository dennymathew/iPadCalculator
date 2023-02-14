const {danger, warn} = require('danger')

  
// No PR is too small to include a description of why you made a change
if (danger.github.pr.body.length < 10) {
  warn('Please include a description of your PR changes.');
}


// Check that someone has been assigned to this PR
if (danger.github.pr.assignee === null) {
   warn('Please assign someone to merge this PR, and optionally include people who should review.');
}

slather.configure("Calculator.xcodeproj", "Calculator")
slather.notify_if_coverage_is_less_than(minimum_coverage: 80)
slather.notify_if_modified_file_is_less_than(minimum_coverage: 60)
slather.show_coverage
