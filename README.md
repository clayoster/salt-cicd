# Salt CICD

***(The true source for this repository is located [here](https://github.com/clayoster/salt-cicd))***

This is collection of tools for running CI/CD jobs to test and deploy Salt states and pillar files.

Container images are based on Alpine Linux and include the following tools:

- A deploy script for triggering fileserver updates via the Salt API
- A linting script that leverages these projects to check for problems in sls files
  - [j2lint](https://github.com/aristanetworks/j2lint)
  - [yamllint](https://github.com/adrienverge/yamllint)
  - [salt-lint](https://github.com/warpnet/salt-lint)

Currently, this container is designed to be used with Gitlab CI/CD running on merge requests. The linting script specifically targets the files that have changed in the merge request and only tests them. 

In the future I'm planning to add an argument that will allow a choice between testing the files changed in the current branch or all of the files matching '*.sls' in the entire repository being tested. This will make the project a little more useful for projects hosted on Github.

# Todo
- Improve arguments and input validation for deploy and linting scripts
- Add documentation for how to actually use the scripts included in the container
- Add choice between linting just the changed files in the current branch or all sls files in the repository
- Add example gitlab-ci.yml file (and Github Actions?)
- Add suggsted yamllint and salt-lint dotfiles
