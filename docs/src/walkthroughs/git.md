# Working with Git

Here, we walk through checking out a separate branch, pushing our work, and merging the work of our collaborators.

We also detail how to add packages to an existing Tonel repo.

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%;"><iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://player.vimeo.com/video/541133065" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe></div>

## Git Commands Mentioned
* `git reset --hard` reset **all** files in the filesystem to the last commit
* `git fetch --all` fetch changes onto our `origin/` branches but do not merge them just yet
* `git push -u origin BRANCH` push a local branch to the remote and remember the `origin BRANCH` as its upstream so that you can leave it out next time

## Adding Your Repo in Squeak
1. Via the commandline, `git clone ` your repo to any folder on your filesystem.
2. When first opening the Git Browser, it will ask you to add a new project. Click yes.
3. Locate the folder that you `git clone`d earlier.

## Recommended Workflow
1. Perform changes in the image
2. Commit using the Git Browser
    * `Ctrl+x` to ignore change for commit
3. `git push` using the CLI or setup credentials in the Git Browser and use the push button
4. To merge other people's work, we have three options:
    1. use the Git Browser's pull button (need to have credentials setup, no conflict resolution)
    2. run `git fetch --all` in the CLI, right click the origin branch and click `merge` (no conflict resolution)
    3. `git pull` in the CLI, then right click new most recent commit and select `checkout` (might result in invalid Smalltalk, is not aware of uncommitted changes in your image)
5. When adding packages, right click the project and click "change tracked packages", add the packages, then make sure to go to settings and re-select the right type of storage format

## Difference to Metacello
Metacello is a dependency manager that will only fetch the most recent version of the packages you want to install. The Git Browser, on the other hand, will clone and manage the entire history of the repository and allow you to create and push new commits.
