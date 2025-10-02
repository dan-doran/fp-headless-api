## FILMPAC W4 API Service

#### About
@todo
#### Links
@todo

----

### Getting Started with Development
#### Requirements
Be sure you have installed and configured both [Docker Engine](https://docs.docker.com/get-docker/)
and [Docker Compose](https://docs.docker.com/compose/install/). Docker Desktop must be up and running on your Mac.

_Recommended:_ [CircleCI CLI](https://circleci.com/docs/2.0/local-cli/#install-with-homebrew-macos)

#### Installation
From within the root directory (which this README is in), run `docker-compose up -d`.

Note that the MariaDB database is at **10.5** to match AWS RDS. Importing the data is a work in progress, so if you find it does not meet your needs then import your own data manually.

#### Plugin & Theme Repos
Each FILMPAC plugin and theme has its own GitHub repository, listed below. When you are developing, remember to use git _within_ the plugin or theme directory itself. You can use `git init` and `git add remote origin {repo URL}` to get started.

> It is important to understand that plugin and theme repos are _not_ a part of the **filmpac-w4-api** repo. They are merely included as development Docker volumes for your convenience. For more, see the sidebar at _Deployment: Staging_ below.

See the README in each repo for details about its development.

- [filmpac-w4-theme](https://github.com/FILMPAC/filmpac-w4-theme)  
- [filmpac-data-extensions](https://github.com/FILMPAC/filmpac-data-extensions)  
- [filmpac-rest-api-extensions](https://github.com/FILMPAC/filmpac-rest-api-extensions)  
(Plugin _filmpac-download-tracker_ is deprecated.)

#### Tests
Integration tests can be run manually from the FILMPAC Dev Team workspace in Postman. Locate the W4 Endpoints Get-Only Tests collection, hover to see the `...`, and click Run Collection. (Some other collections also have tests that you may find useful although they are not run in the pipeline at this time.)

> Alternatively, import the files from the `.circleci/integration-tests` directory into your own Postman workspace, or use them with the [Newman CLI](https://learning.postman.com/docs/running-collections/using-newman-cli/command-line-integration-with-newman/#:~:text=Newman%20is%20a%20command%2Dline,directly%20from%20the%20command%20line.&text=Newman%20maintains%20feature%20parity%20with,the%20collection%20runner%20in%20Postman.).

Integration tests are written in JavaScript using libraries available in Postman. For more, see the [documentation](https://learning.postman.com/docs/writing-scripts/test-scripts/).

----

### Deployment
#### Architecture Overview
    +----------+                                +-------------+                              +-------------------+
    | Project  |  . . . . . . . . . . . . . .   | Cluster     |    . . . . . . .             | LoadBalancer      |
    +-+--------+                                +-------------+                              +-------------------+
    |
    |    +----------+                         +-------------++-------------------+         +-------------------+
    +----+ Service  |   . . . . . . . . . .   | Service     || TaskDefinition    |         | TargetGroup       |
    |    +--+-------+                         +-------------++-------------------+-+       +-------------------+
    |       |                                                  | TaskRole          |
    |       |                                                  +-------------------+-+
    |       |  x-aws-role, x-aws-policies     . . . . . . . .    | TaskExecutionRole |
    |       |                                                    +-------------------+
    |       |  +---------+
    |       +--+ Deploy  |
    |       |  +---------+                    +-------------------+
    |       |  x-aws-autoscaling  . . . . . . | ScalableTarget    |
    |       |                                 +-------------------+---+
    |       |                                     | ScalingPolicy     |
    |       |                                     +-------------------+-+
    |       |                                       | AutoScalingRole   |
    |       |                                       +-------------------+
    |       |
    |       |  +---------+                    +-------------+                              +-------------------+
    |       +--+ Ports   |   . . . . . . .    | IngressRule +-----+                        | Listener          |
    |       |  +---------+                    +-------------+     |                        +-------------------+
    |       |                                                     |
    |       |  +---------+                    +---------------+ +------------------+
    |       +--+ Secrets |   . . . . . . .    | InitContainer | |TaskExecutionRole |
    |       |  +---------+                    +---------------+ +------------+-----+
    |       |                                                     |          |
    |       |  +---------+                                        |          |
    |       +--+ Volumes |                                        |          |
    |       |  +---------+                                        |          |
    |       |                                                     |          |
    |       |  +---------------+                                  |          |         +-------------------+
    |       +--+ DeviceRequest |  . . . . . . . . . . . . .  . .  | . . . .  | . . .   | CapacityProvider  |
    |          +---------------+                                  |          |         +-------------------+--------+
    |                                                             |          |                | AutoscalingGroup    |
    |   +------------+                        +---------------+   |          |                +---------------------+
    +---+ Networks   |   . . . . . . . . .    | SecurityGroup +---+          |                | LaunchConfiguration |
    |   +------------+                        +---------------+              |                +---------------------+
    |                                                                        |
    |   +------------+                        +---------------+              |
    +---+ Secret     |   . . . . . . . . .    | Secret        +--------------+
        +------------+                        +---------------+
@todo aws cdk etc.
#### Staging
Deployment to the Staging cluster runs automatically when branches in this repo (the base repo, **filmpac-w4-api**) are merged to the `staging` branch.

> Note that the plugin and theme repos do not have pipelines at this time. If you are deploying new plugin or theme code, here are the steps:
> 1. Push your changes to the repo of the plugin or theme you are working on
> 2. Merge your update branch into `staging`
> 3. Alert a repo administrator to merge `staging` into the protected `master` branch
> 4. Return to this project and either
>   - Push code (to the base repo, **filmpac-w4-api**), and merge to trigger the pipeline
>   - Manually trigger the pipeline from the CircleCI UI or
>   - Use the CircleCI CLI

The deploy pipeline to Staging is configured to be verbose. Detailed information about the container, the environment, and the build process is sent to STDOUT. Similarly, the Staging instance itself is configured to log a variety of application debugging information to CloudWatch (see _Logs_ below).

#### Production
@todo

### W4 API Maintenance
@todo

#### WP CLI
@todo

#### Caches
@todo

#### Logs
@todo

#### Refreshing RDS Databases
@todo





























































&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
<div align="center" style="color: dimgrey;"><sup><sub><em>"In your face, Trellis."</em></sub></sup></div>
