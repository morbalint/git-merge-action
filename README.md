# git-merge-action

Merge the `source` branch into the `target` branch and push the merge commit on the `target` branch.

* Only works on the current repository. 
* Completely self contained, no checkout needed. Doesn't touch the files on the runner.

## Inputs

### `target`

**Required** Target branch of the merge operation, 'ours'.

### `source`

**Optional** *(default: `${GITHUB_REF##*/}`)* Source branch to merge into the target branch, 'theirs'. Defaults to the branch this action is running on. 

### `strategy_options`

**Optional** *(default: empty)* Comma separated list of options for the `ort` [merge strategy](https://git-scm.com/docs/merge-strategies).  

### `user_email`

**Optional** *(default: `git-merge-action@github.com`)* The `git config user.email` for the merge commit.

### `user_name`

**Optional** *(default: `git merge action`)* The `git config user.name` for the merge commit.

### `dry-run`

**Optional** *(default: `false`)* Execute a dry run. All steps are executed, but no updates are pushed.

### `token`

**Optional** *(default: `${{ github.token }}` )* Personal access token (PAT) used to access the repository. The PAT is stored on a remove-after-run docker container.

## Example workflow

```yml
name: Merge any release branch into dev

on: 
  push:
    branches:
      - 'releases/**'

jobs:
  merge:
    runs-on: ubuntu-latest
    steps:
      - uses: morbalint/git-merge-action@v1
        with:
          target: 'dev'
          strategy_options: 'ours'
```

## Testing

### Locally

Please Generate a [Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with repo scope.

#### Manual testing

1. Substitute the PAT with the stars in the command below.
2. Change the GITHUB_REPOSITORY variable to your fork.
3. Run this command with parameters relevant to your change, from the repo root directory:

```shell
docker run --rm -e "INPUT_SOURCE=dev" -e "INPUT_TARGET=test/dev-clone" -e "INPUT_DRY_RUN=true"  -e "INPUT_TOKEN=******" -e "GITHUB_SERVER_URL=https://github.com" -e "GITHUB_REPOSITORY=morbalint/git-merge-action" --workdir=/src -v "$(pwd):/src"  $(docker build -q .)
```

#### Automatic test suite

1. Install [BATS](https://github.com/bats-core/bats-core/wiki/Install)
2. export your PAT as the GITHUB_TOKEN environmental variable with 
    ```shell 
    export GITHUB_TOKEN=******`
    ```
3. Run the tests from the repo root:
    ```shell
    ./tests.bats
    ```

### Using workflows

The `test.yml` runs the following scenarios:
- `simple-merge`: Dry run of merging branches with two changes made to different files
- `mirror-dev`: Fast forward merge with actual push to detect pushing issues. 
- `merge-conflict`: Merge conflict resolution using ours strategy option

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
