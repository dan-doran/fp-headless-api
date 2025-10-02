import { Stack, StackProps } from 'aws-cdk-lib'
import { Construct } from 'constructs'

import {
  ApplicationLoadBalancedEc2Service,
  ApplicationLoadBalancedServiceRecordType,
} from 'aws-cdk-lib/aws-ecs-patterns'
import { Certificate } from 'aws-cdk-lib/aws-certificatemanager'
import { Cluster, ContainerImage } from 'aws-cdk-lib/aws-ecs'
import { Repository } from 'aws-cdk-lib/aws-ecr'
import { HostedZone } from 'aws-cdk-lib/aws-route53'
import { InstanceClass, InstanceSize, InstanceType } from 'aws-cdk-lib/aws-ec2'

export class FilmpacWpStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props)

    const prefix = (process.env.STAGING) ? 'staging-' : ''
    const suffix = (process.env.STAGING) ? '-staging' : ''

    const cluster = new Cluster(this, 'WpCluster')
    cluster.addCapacity('t2-medium', {
      instanceType: InstanceType.of(InstanceClass.T2, InstanceSize.MEDIUM),
    })

    new ApplicationLoadBalancedEc2Service(this, 'WpService', {
      certificate: Certificate.fromCertificateArn(
        this,
        '*.filmpac.com',
        'arn:aws:acm:us-west-2:961248697194:certificate/58e0b602-3d63-40e4-bdbc-59ac6b65d41e'
      ),
      circuitBreaker: { rollback: true },
      cluster,
      desiredCount: 2,
      domainName: `${prefix}wp.filmpac.com`,
      domainZone: HostedZone.fromHostedZoneId(this, 'filmpac.com', 'Z2DCY1W4WKEVFA'),
      enableECSManagedTags: true,
      memoryLimitMiB: 2048,
      memoryReservationMiB: 1024,
      recordType: ApplicationLoadBalancedServiceRecordType.NONE,
      redirectHTTP: true,
      taskImageOptions: {
        image: ContainerImage.fromEcrRepository(Repository.fromRepositoryName(
          this,
          'WpImage',
          `com-filmpac-wp${suffix}`
        )),
        containerName: `com-filmpac-wp${suffix}`,
        containerPort: 8080,
        dockerLabels: { 'com.filmpac.wp.version': process.env.VERSION ?? 'beta' },
      },
    })
  }
}
