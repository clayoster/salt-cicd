# Salt CICD

***(The true source for this repository is located [here](https://github.com/clayoster/salt-cicd))***

This is collection of tools for linting [Salt](https://github.com/saltstack/salt) states and pillar files and triggering GitFS updates via the Salt API. It is intended to be used as the container image in relevant CI/CD workflows.

Container images are based on Alpine Linux and include the following tools:

- A deploy script for triggering fileserver updates via the Salt API
- A linting script that leverages these projects to check for problems in sls files
  - [j2lint](https://github.com/aristanetworks/j2lint)
  - [yamllint](https://github.com/adrienverge/yamllint)
  - [salt-lint](https://github.com/warpnet/salt-lint)

# CLI Examples

### Linting Script

Script Arguments:
 - `-f` takes a single argument of a path to a .sls file (only used with a linting scope of "single")
 - `-t` takes a single argument of "jinja", "salt", or "yaml"
 - `-s` takes a single argument of "merge", "single" or "all"
   - `merge` will only test the .sls files modified in the merge/pull request
   - `single` will test a single file (supplied by the -f option)
   - `all` will test all .sls files within the repository

Examples:
```bash
# Lint only the .sls files included in a merge request with salt-lint
linting -t salt -s merge

# Lint all .sls files in the repository with yamllint
linting -t yaml -s all
```
Considerations:
- It is suggested to run each linting type in a separate CI/CD job for several reasons:
  - This makes it easier to find what type of code fixes are needed
  - It allows for parallel execution of linting jobs to speed up workflows
  - YAML linting will introduce comment characters in front of jinja templating lines in the sls files being evaluated so it is best to keep it in a separate job. This is necessary as yamllint will throw errors about the templating lines. Comment characters are used instead of deleting the lines to preserve the line numbers of the code. 

### Deploy Script (Triggers gitfs updates via the Salt API)
The deploy script requires the setup of the Salt API to allow access to the following runner
modules
  - fileserver.update
  - git_pillar.update

Examples:
```bash
# Update the Salt Fileserver (salt-run fileserver.update) via API
deploy -u "$saltapi_user" -p "$saltapi_pass" -e "$saltapi_eauth" -s "$saltapi_server" -t states

# Update Salt Pillar (salt-run git_pillar.update) via API
deploy -u "$saltapi_user" -p "$saltapi_pass" -e "$saltapi_eauth" -s "$saltapi_server" -t pillar
```

# Example CI/CD Configurations
Example configurations for Gitlab CI/CD, Github Actions and yamllint/salt-lint configs can be found in the `example-configs` directory.

I have primarily used this project to only lint the files that are included in merge or pull requests. However, it can certainly be set up to evaluate all sls files in a repository upon any commit to the repository.
