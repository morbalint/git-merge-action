# git-merge-action
git merge and push branches

## Inputs

### `target`

**Required** Target branch of the merge operation, 'ours'.

### `source`

**Optional** *(default: `${GITHUB_REF##*/}`)* Source branch to merge into the target branch, 'theirs'. Defaults to the branch this action is running on. 

### `user_email`

**Optional** *(default: `git-merge-action@github.com`)* The `git config user.email` for the merge commit.

### `user_name`

**Optional** *(default: `git merge action`)* The `git config user.name` for the merge commit.

### `dry-run`

**Optional** *(default: `false`)* Execute a dry run. All steps are executed, but no updates are pushed.

## Example workflow

```yml
name: Merge release branch into dev

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
          target: "dev"
          dry-run: true
```

## Testing

### Locally

Change the GITHUB_REPOSITORY to your fork
Generate a developer token with repo scope and substitute it with the stars in the command below.

Run this command with parameters relevant to your change:

```shell
docker run --rm -e "INPUT_SOURCE=dev" -e "INPUT_TARGET=test/dev-clone" -e "INPUT_DRY_RUN=true" -e "GITHUB_SERVER_URL=https://github.com" -e "GITHUB_REPOSITORY=morbalint/git-merge-action"  -e "GITHUB_TOKEN=******" --workdir=/src -v "$(pwd):/src"  $(docker build -q .)
```

### Using workflows

The `test.yml` runs the following scenarios:
- `simple-merge`: Dry run of merging branches with two changes made to different files
- `mirror-dev`: Fast forward merge with actual push to detect pushing issues. 

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
