<!-- Note which issues are linked to this pull request (PR) -->
<!-- If this PR is enough to close them you can write something like "Closes #10 and closes #12" -->
Closes #
<!-- If you just want to reference them without closing them, you can add something like "References #10" -->
References #

<!--Structure this Pull Request how you think is best, but here is a suggestion:-->

<!-- Add a short description of the PR here - what you have changed and why -->

## Proposed Changes
<!-- List major changes here, so that the reviewers can have a bit more context -->
<!-- If you want reviewers to test your code, give direction on how to do that -->
  -
  -
  -

## Checklist for the author of this PR:
<!-- You're invited to open a draft PR so people can see what you are working on sooner -->
- [ ] [if package files were edited] I have run these checks locally:
  - `devtools::document()` to generates the `.Rd` files from any updated roxygen comments.
  - `codemetar::write_codemeta()` to ensures the metadata file is up to date.
  - `styler::style_pkg()` to ensure consistent code styling that match the guidelines.
  - `devtools::check()` for a comprehensive package check. I have resolved any warnings or errors, or written them here in the PR, for discussion.
- [ ] The code base and the documentation files match (they both reflect any recent changes). 
- [ ] The title of this PR is clear and self-explantory.
- [ ] I have added any appropriate labels to this PR.
- [ ] This PR is now ready for review (and I have removed the draft PR status). 
