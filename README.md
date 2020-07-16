# sensuctl-action
Repository for sensuctl github action

### Introduction
This github action will allow you to perform sensuctl actions such as prune and create to help you manage Sensu resources
using github actions.

### Inputs
#### sensu_backend_url: 
Required: the Sensu backend url
#### sensu_user:
Required: the Sensu user to authenticate as  
#### sensu_password: 
Required: the password for the Sensu user
#### sensu_command: 
Required: the sensuctl subcommand to run Ex: `check list --namespace qa`
#### configure_args: 
Optional: additional arguments to pass to sensuctl configure
#### sensu_ca: 
Optional: custom CA certificate if needed.


### Example Configuration

```

name: sensuctl example

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "check_list"
  check_list:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - name: Checkout
      uses: actions/checkout@v2

    - name: Sensuctl Check List
      uses: jspaleta/sensuctl-action@0.0.1
      id: sensuctl
      with:
        sensu_backend_url: ${{ secrets.SENSU_BACKEND_URL }}
        sensu_user: ${{ secrets.SENSU_USER }}
        sensu_password: ${{ secrets.SENSU_PASSWORD }} 
        sensu_command: check list --namespace ${{ secrets.SENSU_NAMESPACE }}



