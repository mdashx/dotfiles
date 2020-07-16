# https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches#10312587

git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done



# Clean up old branches:
# https://railsware.com/blog/git-housekeeping-tutorial-clean-up-outdated-branches-in-local-and-remote-repositories/
