# Salt CICD

This is collection of tools for running CI/CD jobs to test and deploy Salt states and pillar files.

Container images are based on Alpine Linux and include the following tools:

- A deploy script for triggering fileserver updates via the Salt API
- A linting script that leverages these projects to check for problems in sls files
  - [j2lint](https://github.com/aristanetworks/j2lint)
  - [yamllint](https://github.com/adrienverge/yamllint)
  - [salt-lint](https://github.com/warpnet/salt-lint)

Currently, this container is designed to be used with Gitlab CI/CD running on merge requests. The linting script specifically targets the files that have changed in the merge request and only tests them. 

In the future I'm planning to add an argument that will allow a choice between testing the files changed in the current branch or all of the files matching '*.sls' in the entire repository being tested. This will make the project a little more useful for projects hosted on Github.
