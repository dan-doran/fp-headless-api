#!/usr/bin/env node

import 'source-map-support/register'
import * as cdk from 'aws-cdk-lib'
import { FilmpacWpStack } from '../lib/filmpac-wp-stack'

const app = new cdk.App()
new FilmpacWpStack(app, 'FilmpacWp', {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
  /* For more information, see https://docs.aws.amazon.com/cdk/latest/guide/environments.html */
})
