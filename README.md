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

# CLI Examples

### Linting Script
 - `-t` takes a single argument of "jinja", "salt", or "yaml"
 - `-s` takes a single argument of "merge" or "all"
   - `merge` will only test the .sls files modified in the merge/pull request
   - `all` will test all .sls files within the repository
```bash
# Lint only the .sls files included in a merge request with salt-lint
linting -t salt -s merge

# Lint all .sls files in the repository with yamllint
linting -t yaml -s all
```
### Deploy Script (Triggers gitfs updates via the Salt API)
The deploy script requires the setup of the Salt API to allow access to the following runner
modules
  - fileserver.update
  - git_pillar.update
```bash
# Update the Salt Fileserver (salt-run fileserver.update) via API
deploy -u "$saltapi_user" -p "$saltapi_pass" -e "$saltapi_eauth" -s "$saltapi_server" -t states

# Update Salt Pillar (salt-run git_pillar.update) via API
deploy -u "$saltapi_user" -p "$saltapi_pass" -e "$saltapi_eauth" -s "$saltapi_server" -t pillar
```

# Example CI/CD Configurations
Example configurations for Gitlab CI/CD, Github Actions and yamllint/salt-lint configs can be found in the `example-configs` directory.

# Todo
- Add functions to linting and deploy scripts
- Add a note to the docs about yaml linting intentionally adding comments in front of jinja lines
