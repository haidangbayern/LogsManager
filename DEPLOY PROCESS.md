- Change version in podspec
- Run `podUpdate.command`
- Assure all dependencies are also added to Carthage project
- Run `carthageUpdate.command`
- Run `checkBuild.command`
- Update CHANGELOG.md
- Update README.md with new version if needed
- Push changes in git
- Add git tag
- Run `podPush.command`