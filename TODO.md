## @TODO

### Prod / Staging

- Move .env file contents to either
  - docker-compose secrets or
  - CircleCI encrypt/decrypt
- Review IAM roles/permissions ([See here](https://docs.docker.com/cloud/ecs-integration/#iam-roles))
- ~~Improve health check setup -- ought to be ensuring PHP-FPM is working, not just nginx~~**Done**
- [Staging] Set up e-mail catcher ([Mailtrap](https://mailtrap.io)? or do we already have something?)
- [Prod] Need cluster / load balancer ARNs to complete config

### Development

- Improve sample dataset
- Flesh out the documentation (@see README)
- May want an e-mail catcher here too

### General
- Explicitly define machine-image version in pipeline -- see CircleCI announcement [here](https://circleci.com/blog/ubuntu-14-16-image-deprecation/?mkt_tok=NDg1LVpNSC02MjYAAAGDLWN3QKPJpJaRMPa_b3Wb4U_VWoGwKy7Dk-uMXVgzs_adS1CQIxzOavu_VAxNhg3MwqCbiCm2UNBc4sMgWM1Zh-mtndvhLFkLYJYy2y31xtWw2w)

----

### Big picture questions

- When to set up Production cluster, load balancer etc.?
- Are we changing Staging to the staging-w4-api subdomain soon? now? (Is that what we're going with? not sure I remember.)
- Database questions
  - Use read-replication from an admin/internal DB to the w4-api DB? -- what about inserts from POST/PUT? -- master/master replication?
  - How to admin the Staging DB -- snapshot of Prod? -- are there staged DB changes we want to replicate in Prod? -- per-table replication?
